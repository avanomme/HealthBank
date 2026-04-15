# backend/tests/mocks/db.py
"""
In-memory database mock for backend tests.

Handles SQL patterns for all endpoint modules:
- Auth / AccountData / Sessions (auth, sessions)
- QuestionBank / QuestionOptions (question_bank)
- Survey / QuestionList (surveys)
- SurveyTemplate / TemplateQuestions (templates)
- SurveyAssignment (assignments)
- Responses (survey delete guard)
"""
import re
import mysql.connector
from datetime import datetime


class FakeCursor:
    # ---- Roles table mock ----
    roles = {
        1: "participant",
        2: "researcher",
        3: "hcp",
        4: "admin"
    }

    # ---- Auth / Account storage (existing) ----
    used_emails = set()
    users = {}       # email -> password_hash
    accounts = {}    # email -> {"account_id": int, "password_hash": str, "must_change_password": bool}
    sessions = {}    # token_hash -> {"account_id": int, "expires_at": datetime}
    next_auth_id = 1
    next_account_id = 1

    # ---- Account Request storage ----
    account_requests = {}  # request_id -> dict
    next_request_id = 1

    # ---- Generic table storage ----
    questions = {}       # question_id -> dict
    options = {}         # option_id -> dict
    surveys = {}         # survey_id -> dict
    question_list = []   # [(survey_id, question_id, is_required)]
    templates = {}       # template_id -> dict
    template_questions = []  # [(template_id, question_id, is_required, display_order)]
    assignments = {}     # assignment_id -> dict
    responses = []       # [(response_id, survey_id, ...)]

    next_question_id = 1
    next_option_id = 1
    next_survey_id = 1
    next_template_id = 1
    next_assignment_id = 1

    def __init__(self, results=None):
        self.results = results or []
        self.rowcount = 0
        self.lastrowid = None
        self._row = None
        self._rows = None
        self._last_password_hash = None

    # ------------------------------------------------------------------
    # execute: route SQL to handlers
    # ------------------------------------------------------------------
    def execute(self, query, params=None):
        q = query.strip()
        qu = q.upper()

        # Reset per-query state
        self._row = None
        self._rows = None


        # ---- Auth / Account / Session handlers (existing) ----
        if "INSERT INTO Auth" in q:
            return self._insert_auth(params)
        if "INSERT INTO AccountData" in q and "FirstName" in q:
            return self._insert_account_data(q, params)
        if "SELECT AccountData.AccountID" in q and "Auth.PasswordHash" in q:
            return self._select_login(params)
        if "INSERT INTO Sessions" in q:
            return self._insert_session(params)
        if "FROM Sessions" in q and "WHERE TokenHash" in q and qu.startswith("SELECT"):
            return self._select_session(params)
        if "DELETE FROM Sessions" in q:
            return self._delete_session(params)
        if "UPDATE Sessions SET ImpersonatedBy" in q:
            self.rowcount = 0
            return
        if "UPDATE Sessions SET ViewingAsUserID" in q:
            self.rowcount = 0
            return
        if "UPDATE Sessions SET IsActive = FALSE" in q:
            self.rowcount = 1
            return
        if "INSERT INTO AccountDeletionRequest" in q:
            self.lastrowid = 1
            self.rowcount = 1
            return
        if "UPDATE Responses SET ParticipantID = NULL" in q:
            return self._anonymise_responses(params)
        if "DELETE FROM ConsentRecord" in q:
            self.rowcount = 0
            return
        if "DELETE FROM Messages WHERE SenderID" in q:
            self.rowcount = 0
            return
        if "UPDATE Survey SET CreatorID = NULL" in q:
            return self._nullify_survey_creator(params)
        if "UPDATE SurveyTemplate SET CreatorID = NULL" in q:
            return self._nullify_template_creator(params)
        if "UPDATE AccountRequest SET ReviewedBy = NULL" in q:
            return self._nullify_account_request_reviewer(params)
        if "DELETE FROM Auth WHERE AuthID" in q:
            return self._delete_auth(params)
        if "DELETE FROM AccountData" in q:
            return self._delete_account_data(params)

        # --- Handle SELECT RoleID FROM Roles WHERE RoleName = %s ---
        if (
            "SELECT RoleID FROM Roles" in q
            and "WHERE RoleName = %s" in q
        ):
            role_name = params[0]
            for rid, rname in self.roles.items():
                if rname == role_name:
                    self._row = (rid,)
                    return
            self._row = None
            return

        # --- Handle SELECT ... FROM AccountData LEFT JOIN Roles ... WHERE AccountID = %s ---
        # Used by sessions.py create_session_for_account:
        #   SELECT a.AccountID, a.FirstName, a.LastName, a.Email, r.RoleName,
        #          a.RoleID, a.ConsentVersion, a.Birthdate, a.Gender
        if (
            "FROM AccountData a" in q
            and "LEFT JOIN Roles r" in q
            and "COUNT(*)" in qu
        ):
            return self._count_users_with_filters(q, params)

        if (
            "FROM AccountData a" in q
            and "LEFT JOIN Roles r" in q
            and "a.IsActive" in q
            and qu.startswith("SELECT")
        ):
            return self._select_users_with_filters(q, params)

        if (
            "FROM AccountData" in q
            and "LEFT JOIN Roles" in q
            and "WHERE a.AccountID = %s" in q.replace("\n", " ")
        ):
            account_id = params[0]
            for email, acct in FakeCursor.accounts.items():
                if acct["account_id"] == account_id:
                    role_id = acct.get("role_id", 1)
                    role_name = {1: "participant", 2: "researcher", 3: "hcp", 4: "admin"}.get(role_id, "participant")
                    self._row = (
                        account_id,              # [0] AccountID
                        acct.get("first_name", "Test"),  # [1] FirstName
                        acct.get("last_name", "User"),   # [2] LastName
                        email,                   # [3] Email
                        role_name,               # [4] RoleName (from Roles JOIN)
                        role_id,                 # [5] RoleID
                        None,                    # [6] ConsentVersion
                        None,                    # [7] Birthdate
                        None,                    # [8] Gender
                    )
                    return
            self._row = None
            return

        # ---- QuestionBank ----
        if "INSERT INTO QuestionBank" in q:
            return self._insert_question(params)
        if "INSERT INTO QuestionOptions" in q:
            return self._insert_option(params)
        if "FROM QuestionOptions" in q and qu.startswith("SELECT"):
            return self._select_options(params)
        if "DELETE FROM QuestionOptions" in q:
            return self._delete_options(params)
        if "DELETE FROM QuestionBank" in q:
            return self._delete_question(params)
        if "UPDATE QuestionBank" in q:
            return self._update_question(q, params)
        # SELECT from QuestionBank (various patterns)
        if "FROM QuestionBank" in q and qu.startswith("SELECT"):
            return self._select_question(q, params)

        # ---- SurveyAssignment (before Survey — "SurveyAssignment" contains "Survey") ----
        if "INSERT INTO SurveyAssignment" in q:
            return self._insert_assignment(params)
        if "DELETE FROM SurveyAssignment" in q:
            return self._delete_assignment(q, params)
        if "UPDATE SurveyAssignment" in q:
            return self._update_assignment(q, params)
        # JOIN: SurveyAssignment + Survey (my assignments)
        if "SurveyAssignment" in q and "JOIN" in qu:
            return self._select_my_assignments(q, params)
        if "FROM SurveyAssignment" in q and qu.startswith("SELECT"):
            return self._select_assignment(q, params)

        # ---- SurveyTemplate (before Survey — "SurveyTemplate" contains "Survey") ----
        if "INSERT INTO SurveyTemplate" in q:
            return self._insert_template(params)
        if "DELETE FROM SurveyTemplate" in q:
            return self._delete_template(params)
        if "UPDATE SurveyTemplate" in q:
            return self._update_template(q, params)
        if "FROM SurveyTemplate" in q and qu.startswith("SELECT"):
            return self._select_template(q, params)

        # ---- TemplateQuestions ----
        if "INSERT INTO TemplateQuestions" in q:
            return self._insert_template_question(params)
        if "DELETE FROM TemplateQuestions" in q:
            return self._delete_template_questions(params)
        if "FROM TemplateQuestions" in q and "COUNT" in qu:
            return self._count_template_questions(params)
        # JOIN: TemplateQuestions + QuestionBank
        if "TemplateQuestions" in q and "QuestionBank" in q and "JOIN" in qu:
            return self._select_template_questions_join(params)
        # Plain SELECT from TemplateQuestions (for duplicate)
        if "FROM TemplateQuestions" in q and qu.startswith("SELECT"):
            return self._select_template_questions(params)

        # ---- QuestionList ----
        if "INSERT INTO QuestionList" in q:
            return self._insert_question_list(params)
        if "DELETE FROM QuestionList" in q:
            return self._delete_question_list(params)
        if "FROM QuestionList" in q and "COUNT" in qu:
            return self._count_question_list(params)
        # JOIN: QuestionList + QuestionBank (survey questions)
        if "QuestionList" in q and "QuestionBank" in q and "JOIN" in qu:
            return self._select_survey_questions(params)

        # ---- Survey (AFTER SurveyAssignment/SurveyTemplate to avoid substring matches) ----
        if "INSERT INTO Survey " in q:
            return self._insert_survey(params)
        if "DELETE FROM Survey " in q:
            return self._delete_survey(params)
        if "UPDATE Survey " in q:
            return self._update_survey(q, params)
        if "FROM Survey " in q and qu.startswith("SELECT") and "JOIN" not in qu:
            return self._select_survey(q, params)

        # ---- Responses (count guard for survey delete) ----
        if "FROM Responses" in q and "COUNT" in qu:
            self._row = (0,)
            return

        # ---- QuestionCategories ----
        if "FROM QuestionCategories" in q:
            # Return distinct non-null categories from questions as (id, key, display_order)
            categories = []
            seen = set()
            for q in FakeCursor.questions.values():
                cat = q.get("Category")
                if cat and cat not in seen:
                    seen.add(cat)
                    categories.append(cat)
            # Simulate DB row tuples: (category_id, category_key, display_order)
            self._rows = [
                (i + 1, cat, i + 1)
                for i, cat in enumerate(sorted(categories))
            ]
            return

        # ---- AccountRequest ----
        if "INSERT INTO AccountRequest" in q:
            return self._insert_account_request(params)
        # SELECT 1 existence check BEFORE general select
        if "SELECT 1 FROM AccountRequest" in q:
            return self._check_pending_request(params)
        if "FROM AccountRequest" in q and "COUNT(*)" in qu:
            return self._count_account_requests(q, params)
        if "FROM AccountRequest" in q and qu.startswith("SELECT"):
            return self._select_account_requests(q, params)
        if "UPDATE AccountRequest" in q:
            return self._update_account_request(q, params)

        # ---- SELECT 1 existence checks ----
        if "SELECT 1 FROM AccountData" in q and "Email" in q:
            return self._check_email_exists(params)

        # ---- Auth UPDATE (change_password with MustChangePassword) ----
        if "UPDATE Auth" in q and "MustChangePassword" in q:
            self.rowcount = 1
            return
        if "UPDATE Auth" in q:
            self.rowcount = 1
            return

        # ---- AccountData SELECT by AccountID ----
        if "SELECT" in qu and "FROM AccountData" in q and "WHERE AccountID" in q:
            return self._select_account_by_id(params)

        # ---- UPDATE AccountData (user fields) ----
        if "UPDATE AccountData" in q:
            # Only update if WHERE AccountID = %s
            match = re.search(r"SET (.+) WHERE AccountID = %s", q, re.IGNORECASE | re.DOTALL)
            if match:
                set_clause = match.group(1)
                columns = [c.strip().split("=")[0].strip() for c in set_clause.split(",")]
                # Last param is the AccountID
                account_id = params[-1]
                # To avoid stale reference after email change, track the key
                for orig_email in list(FakeCursor.accounts.keys()):
                    acct = FakeCursor.accounts[orig_email]
                    if acct["account_id"] == account_id:
                        email = orig_email
                        for i, col in enumerate(columns):
                            value = params[i]
                            if col.lower() == "firstname":
                                acct["first_name"] = value
                            elif col.lower() == "lastname":
                                acct["last_name"] = value
                            elif col.lower() == "email":
                                # Simulate unique email constraint
                                for other_email, other_acct in FakeCursor.accounts.items():
                                    if other_email == value and other_acct["account_id"] != account_id:
                                        # Simulate DB error for duplicate email
                                        raise mysql.connector.IntegrityError("Duplicate entry for email")
                                # Update key in accounts dict
                                if value != email:
                                    FakeCursor.accounts[value] = FakeCursor.accounts.pop(email)
                                    acct = FakeCursor.accounts[value]
                                    email = value
                                acct["email"] = value
                            elif col.lower() == "roleid":
                                # Accept both int and str (role name or id)
                                role_map = {"participant": 1, "researcher": 2, "hcp": 3, "admin": 4}
                                if isinstance(value, str):
                                    # Try to convert to int, else map from name
                                    try:
                                        acct["role_id"] = int(value)
                                    except ValueError:
                                        acct["role_id"] = role_map.get(value, 1)
                                else:
                                    acct["role_id"] = int(value)
                                # Debug print for test troubleshooting
                                print(f"[MOCK DB] Updated role_id for {email} to {acct['role_id']} (input={value})")
                            elif col.lower() == "isactive":
                                acct["is_active"] = value
                        self.rowcount = 1
                        return
                self.rowcount = 0
                return
            # If not a user update, just acknowledge
            self.rowcount = 1
            return

        # ---- SELECT from AccountData + Auth JOIN for change_password ----
        if "FROM AccountData" in q and "JOIN Auth" in q:
            return self._select_auth_for_change_password(params)

    # ------------------------------------------------------------------
    # Auth / Account / Session handlers
    # ------------------------------------------------------------------
    def _insert_auth(self, params):
        self.lastrowid = FakeCursor.next_auth_id
        FakeCursor.next_auth_id += 1
        self._last_password_hash = params[0]
        # Track MustChangePassword if INSERT includes it (e.g., approve flow)
        self._last_must_change = len(params) > 1 if params else False
        self.rowcount = 1

    def _insert_account_data(self, query, params):
        # params: (FirstName, LastName, Email, AuthID) — matches auth.py INSERT
        # RoleID is not in the INSERT; the DB schema default (participant=1) applies.
        first_name = params[0]
        last_name = params[1]
        email = params[2]
        auth_id = params[3]
        role_id = 1   # DB default — participant
        is_active = params[4] if len(params) > 4 else True
        if email in FakeCursor.used_emails:
            raise mysql.connector.IntegrityError(errno=1062, msg="Duplicate entry")
        FakeCursor.used_emails.add(email)
        account_id = FakeCursor.next_account_id
        FakeCursor.next_account_id += 1
        FakeCursor.accounts[email] = {
            "account_id": account_id,
            "password_hash": self._last_password_hash,
            "first_name": first_name,
            "last_name": last_name,
            "email": email,
            "role_id": role_id,
            "auth_id": auth_id,
            "is_active": is_active
        }
        FakeCursor.users[email] = self._last_password_hash
        self.lastrowid = account_id
        self.rowcount = 1

    def _select_login(self, params):
        # Login SQL selects: AccountID, PasswordHash, MustChangePassword, RoleID, Birthdate, Gender,
        #                    IsActive, AuthID, FailedLoginAttempts, LockedUntil
        email = params[0]
        acct = FakeCursor.accounts.get(email)
        if acct:
            self._row = (
                acct["account_id"],
                acct["password_hash"],
                acct.get("must_change_password", False),
                acct.get("role_id", 1),   # RoleID
                None,                      # Birthdate (not stored in mock)
                None,                      # Gender (not stored in mock)
                acct.get("is_active", True),  # IsActive
                acct.get("auth_id", 1),    # AuthID
                0,                         # FailedLoginAttempts
                None,                      # LockedUntil
            )
        else:
            self._row = None

    def _insert_session(self, params):
        account_id = int(params[0])
        token_hash = params[1]
        expires_at = params[3]
        FakeCursor.sessions[token_hash] = {
            "account_id": account_id, "expires_at": expires_at
        }
        self.rowcount = 1

    def _select_session(self, params):
        token_hash = params[0]
        sess = FakeCursor.sessions.get(token_hash)
        if sess is None:
            self._row = None
        else:
            self._row = {
                "SessionID": 1,
                "AccountID": sess["account_id"],
                "ExpiresAt": sess["expires_at"],
            }

    def _delete_session(self, params):
        token_hash = params[0]
        if token_hash in FakeCursor.sessions:
            del FakeCursor.sessions[token_hash]
            self.rowcount = 1
        else:
            self.rowcount = 0

    def _delete_account_data(self, params):
        account_id = int(params[0])
        email_to_delete = None
        for email, acct in FakeCursor.accounts.items():
            if acct["account_id"] == account_id:
                email_to_delete = email
                break
        if email_to_delete is None:
            self.rowcount = 0
        else:
            del FakeCursor.accounts[email_to_delete]
            FakeCursor.used_emails.discard(email_to_delete)
            FakeCursor.users.pop(email_to_delete, None)
            self.rowcount = 1

    def _delete_auth(self, params):
        # Auth row is already logically removed when AccountData is deleted.
        # Just acknowledge — auth_id lookup still succeeds in tests.
        self.rowcount = 1

    def _anonymise_responses(self, params):
        """SET ParticipantID = NULL for responses belonging to a deleted user."""
        account_id = int(params[0])
        updated = 0
        for resp in FakeCursor.responses:
            if isinstance(resp, dict) and resp.get("ParticipantID") == account_id:
                resp["ParticipantID"] = None
                updated += 1
        self.rowcount = updated

    def _nullify_survey_creator(self, params):
        account_id = int(params[0])
        for survey in FakeCursor.surveys.values():
            if survey.get("CreatorID") == account_id:
                survey["CreatorID"] = None
        self.rowcount = 0

    def _nullify_template_creator(self, params):
        account_id = int(params[0])
        for tmpl in FakeCursor.templates.values():
            if tmpl.get("CreatorID") == account_id:
                tmpl["CreatorID"] = None
        self.rowcount = 0

    def _nullify_account_request_reviewer(self, params):
        account_id = int(params[0])
        for req in FakeCursor.account_requests.values():
            if req.get("ReviewedBy") == account_id:
                req["ReviewedBy"] = None
        self.rowcount = 0

    # ------------------------------------------------------------------
    # QuestionBank handlers
    # ------------------------------------------------------------------
    def _insert_question(self, params):
        qid = FakeCursor.next_question_id
        FakeCursor.next_question_id += 1
        now = datetime.now()
        # INSERT INTO QuestionBank (Title, QuestionContent, ResponseType, Category, ScaleMin, ScaleMax)
        # IsRequired was removed from QuestionBank and moved to QuestionList
        FakeCursor.questions[qid] = {
            "QuestionID": qid,
            "Title": params[0],
            "QuestionContent": params[1],
            "ResponseType": params[2],
            "Category": params[3] if len(params) > 3 else None,
            "ScaleMin": params[4] if len(params) > 4 else 1,
            "ScaleMax": params[5] if len(params) > 5 else 10,
            "CreatedAt": now,
            "UpdatedAt": now,
        }
        self.lastrowid = qid
        self.rowcount = 1

    def _insert_option(self, params):
        oid = FakeCursor.next_option_id
        FakeCursor.next_option_id += 1
        # INSERT INTO QuestionOptions (QuestionID, OptionText, DisplayOrder)
        FakeCursor.options[oid] = {
            "OptionID": oid,
            "QuestionID": params[0],
            "OptionText": params[1],
            "DisplayOrder": params[2],
        }
        self.lastrowid = oid
        self.rowcount = 1

    def _select_options(self, params):
        qid = params[0]
        rows = sorted(
            [o for o in FakeCursor.options.values() if o["QuestionID"] == qid],
            key=lambda o: o["DisplayOrder"]
        )
        self._rows = [(o["OptionID"], o["OptionText"], o["DisplayOrder"]) for o in rows]

    def _delete_options(self, params):
        qid = params[0]
        to_del = [oid for oid, o in FakeCursor.options.items() if o["QuestionID"] == qid]
        for oid in to_del:
            del FakeCursor.options[oid]
        self.rowcount = len(to_del)

    def _delete_question(self, params):
        qid = params[0]
        if qid in FakeCursor.questions:
            del FakeCursor.questions[qid]
            # Cascade options
            to_del = [oid for oid, o in FakeCursor.options.items() if o["QuestionID"] == qid]
            for oid in to_del:
                del FakeCursor.options[oid]
            self.rowcount = 1
        else:
            self.rowcount = 0

    def _update_question(self, query, params):
        # Parse SET clause columns
        set_match = re.search(r'SET\s+(.+?)\s+WHERE', query, re.IGNORECASE | re.DOTALL)
        if not set_match:
            return
        set_clause = set_match.group(1)
        columns = [c.strip().split("=")[0].strip() for c in set_clause.split(",")]
        # Last param is the WHERE QuestionID
        qid = params[-1]
        if qid not in FakeCursor.questions:
            self.rowcount = 0
            return
        q = FakeCursor.questions[qid]
        for i, col in enumerate(columns):
            q[col] = params[i]
        q["UpdatedAt"] = datetime.now()
        self.rowcount = 1

    def _select_question(self, query, params):
        # Existence check: SELECT QuestionID FROM QuestionBank WHERE QuestionID = %s
        if "WHERE QuestionID" in query and "Title" not in query:
            qid = params[0] if params else None
            q = FakeCursor.questions.get(qid)
            self._row = (q["QuestionID"],) if q else None
            return
        # Single question with full columns
        if "WHERE QuestionID" in query:
            qid = params[0]
            q = FakeCursor.questions.get(qid)
            if q is None:
                self._row = None
            else:
                if "CreatedAt" in query:
                    self._row = (q["QuestionID"], q["Title"], q["QuestionContent"],
                                 q["ResponseType"], q.get("Category"),
                                 q.get("ScaleMin", 1), q.get("ScaleMax", 10),
                                 q["CreatedAt"], q["UpdatedAt"])
                else:
                    self._row = (q["QuestionID"], q["Title"], q["QuestionContent"],
                                 q["ResponseType"], q.get("Category"),
                                 q.get("ScaleMin", 1), q.get("ScaleMax", 10))
            return
        # List all (with optional filters)
        rows = list(FakeCursor.questions.values())
        if params:
            pi = 0
            if "Category = %s" in query and pi < len(params):
                cat = params[pi]
                pi += 1
                rows = [r for r in rows if r["Category"] == cat]
            if "ResponseType = %s" in query and pi < len(params):
                rt = params[pi]
                pi += 1
                rows = [r for r in rows if r["ResponseType"] == rt]
        self._rows = [
            (r["QuestionID"], r["Title"], r["QuestionContent"],
             r["ResponseType"], r.get("Category"),
             r.get("ScaleMin", 1), r.get("ScaleMax", 10))
            for r in rows
        ]

    # ------------------------------------------------------------------
    # Survey handlers
    # ------------------------------------------------------------------
    def _insert_survey(self, params):
        sid = FakeCursor.next_survey_id
        FakeCursor.next_survey_id += 1
        now = datetime.now()
        pub_status = params[2] if len(params) > 2 else "draft"
        FakeCursor.surveys[sid] = {
            "SurveyID": sid,
            "Title": params[0],
            "Description": params[1] if len(params) > 1 else None,
            "Status": "not-started",
            "PublicationStatus": pub_status,
            "StartDate": params[3] if len(params) > 3 else None,
            "EndDate": params[4] if len(params) > 4 else None,
            "CreatedAt": now,
            "UpdatedAt": now,
        }
        self.lastrowid = sid
        self.rowcount = 1

    def _select_survey(self, query, params):
        if "WHERE SurveyID" in query and params:
            sid = params[0]
            s = FakeCursor.surveys.get(sid)
            if s is None:
                self._row = None
                return
            if "PublicationStatus" in query and "Title" not in query:
                # SELECT SurveyID, PublicationStatus FROM Survey WHERE SurveyID = %s
                self._row = (s["SurveyID"], s["PublicationStatus"])
            elif "Title" not in query:
                # SELECT SurveyID FROM Survey WHERE SurveyID = %s
                self._row = (s["SurveyID"],)
            else:
                self._row = self._survey_full_tuple(s)
            return
        # List surveys (with optional filters)
        rows = list(FakeCursor.surveys.values())
        if params:
            pi = 0
            if "PublicationStatus = %s" in query and pi < len(params):
                ps = params[pi]
                pi += 1
                rows = [r for r in rows if r["PublicationStatus"] == ps]
        # Sort by CreatedAt DESC
        rows.sort(key=lambda r: r["CreatedAt"], reverse=True)
        self._rows = [self._survey_full_tuple(r) for r in rows]

    def _survey_full_tuple(self, s):
        return (s["SurveyID"], s["Title"], s["Description"], s["Status"],
                s["PublicationStatus"], s["StartDate"], s["EndDate"],
                s["CreatedAt"], s["UpdatedAt"])

    def _update_survey(self, query, params):
        set_match = re.search(r'SET\s+(.+?)\s+WHERE', query, re.IGNORECASE | re.DOTALL)
        if not set_match:
            return
        set_clause = set_match.group(1)
        columns = [c.strip().split("=")[0].strip() for c in set_clause.split(",")]
        sid = params[-1]
        s = FakeCursor.surveys.get(sid)
        if not s:
            self.rowcount = 0
            return
        for i, col in enumerate(columns):
            s[col] = params[i]
        s["UpdatedAt"] = datetime.now()
        self.rowcount = 1

    def _delete_survey(self, params):
        sid = params[0]
        if sid in FakeCursor.surveys:
            del FakeCursor.surveys[sid]
            self.rowcount = 1
        else:
            self.rowcount = 0

    # ------------------------------------------------------------------
    # QuestionList handlers
    # ------------------------------------------------------------------
    def _insert_question_list(self, params):
        # params: (survey_id, question_id) or (survey_id, question_id, is_required)
        is_required = params[2] if len(params) > 2 else False
        FakeCursor.question_list.append((params[0], params[1], is_required))
        self.rowcount = 1

    def _delete_question_list(self, params):
        sid = params[0]
        before = len(FakeCursor.question_list)
        FakeCursor.question_list = [(s, q, r) for s, q, r in FakeCursor.question_list if s != sid]
        self.rowcount = before - len(FakeCursor.question_list)

    def _count_question_list(self, params):
        sid = params[0]
        count = sum(1 for s, *_ in FakeCursor.question_list if s == sid)
        self._row = (count,)

    def _select_survey_questions(self, params):
        """JOIN QuestionList + QuestionBank for a survey."""
        sid = params[0]
        linked = [(q, r) for s, q, r in FakeCursor.question_list if s == sid]
        rows = []
        for qid, is_required in linked:
            q = FakeCursor.questions.get(qid)
            if q:
                rows.append((q["QuestionID"], q["Title"], q["QuestionContent"],
                             q["ResponseType"], is_required, q["Category"],
                             q.get("ScaleMin", 1), q.get("ScaleMax", 10)))
        self._rows = rows

    # ------------------------------------------------------------------
    # SurveyTemplate handlers
    # ------------------------------------------------------------------
    def _insert_template(self, params):
        tid = FakeCursor.next_template_id
        FakeCursor.next_template_id += 1
        now = datetime.now()
        FakeCursor.templates[tid] = {
            "TemplateID": tid,
            "Title": params[0],
            "Description": params[1] if len(params) > 1 else None,
            "IsPublic": params[2] if len(params) > 2 else False,
            "CreatedAt": now,
            "UpdatedAt": now,
        }
        self.lastrowid = tid
        self.rowcount = 1

    def _select_template(self, query, params):
        if "WHERE TemplateID" in query and params:
            tid = params[0]
            t = FakeCursor.templates.get(tid)
            if t is None:
                self._row = None
                return
            # Inspect only the SELECT list (not WHERE) to avoid false matches on "TemplateID".
            select_clause = query.split("FROM", 1)[0].upper()

            if all(col in select_clause for col in ["TEMPLATEID", "TITLE", "DESCRIPTION"]) and "ISPUBLIC" not in select_clause:
                # SELECT TemplateID, Title, Description FROM SurveyTemplate WHERE TemplateID = %s
                self._row = (t["TemplateID"], t["Title"], t["Description"])
            elif "TITLE" in select_clause and "DESCRIPTION" in select_clause and "ISPUBLIC" not in select_clause:
                # SELECT Title, Description FROM SurveyTemplate WHERE TemplateID = %s
                self._row = (t["Title"], t["Description"])
            elif "IsPublic" in query and "CreatedAt" in query:
                self._row = (t["TemplateID"], t["Title"], t["Description"],
                             t["IsPublic"], t["CreatedAt"], t["UpdatedAt"])
            elif "Title" not in query:
                self._row = (t["TemplateID"],)
            else:
                self._row = (t["TemplateID"], t["Title"], t["Description"],
                             t["IsPublic"], t["CreatedAt"], t["UpdatedAt"])
            return
        # List templates
        rows = list(FakeCursor.templates.values())
        if params:
            pi = 0
            if "IsPublic = %s" in query and pi < len(params):
                ip = params[pi]
                pi += 1
                rows = [r for r in rows if r["IsPublic"] == ip]
        rows.sort(key=lambda r: r["CreatedAt"], reverse=True)
        self._rows = [(r["TemplateID"], r["Title"], r["Description"],
                        r["IsPublic"], r["CreatedAt"], r["UpdatedAt"]) for r in rows]

    def _update_template(self, query, params):
        set_match = re.search(r'SET\s+(.+?)\s+WHERE', query, re.IGNORECASE | re.DOTALL)
        if not set_match:
            return
        set_clause = set_match.group(1)
        columns = [c.strip().split("=")[0].strip() for c in set_clause.split(",")]
        tid = params[-1]
        t = FakeCursor.templates.get(tid)
        if not t:
            self.rowcount = 0
            return
        for i, col in enumerate(columns):
            t[col] = params[i]
        t["UpdatedAt"] = datetime.now()
        self.rowcount = 1

    def _delete_template(self, params):
        tid = params[0]
        if tid in FakeCursor.templates:
            del FakeCursor.templates[tid]
            # Cascade TemplateQuestions
            FakeCursor.template_questions = [
                row for row in FakeCursor.template_questions if row[0] != tid
            ]
            self.rowcount = 1
        else:
            self.rowcount = 0

    # ------------------------------------------------------------------
    # TemplateQuestions handlers
    # ------------------------------------------------------------------
    def _insert_template_question(self, params):
        # INSERT INTO TemplateQuestions (TemplateID, QuestionID, IsRequired, DisplayOrder)
        # or legacy (TemplateID, QuestionID, DisplayOrder) — handle both
        if len(params) >= 4:
            FakeCursor.template_questions.append((params[0], params[1], params[2], params[3]))
        else:
            FakeCursor.template_questions.append((params[0], params[1], False, params[2]))
        self.rowcount = 1

    def _delete_template_questions(self, params):
        tid = params[0]
        before = len(FakeCursor.template_questions)
        FakeCursor.template_questions = [
            row for row in FakeCursor.template_questions if row[0] != tid
        ]
        self.rowcount = before - len(FakeCursor.template_questions)

    def _count_template_questions(self, params):
        tid = params[0]
        count = sum(1 for row in FakeCursor.template_questions if row[0] == tid)
        self._row = (count,)

    def _select_template_questions(self, params):
        """Plain SELECT QuestionID, IsRequired, DisplayOrder FROM TemplateQuestions."""
        tid = params[0]
        rows = sorted(
            [(row[1], row[2], row[3]) for row in FakeCursor.template_questions if row[0] == tid],
            key=lambda r: r[2]  # sort by display_order
        )
        self._rows = rows

    def _select_template_questions_join(self, params):
        """JOIN TemplateQuestions + QuestionBank: returns (QuestionID, Title, QuestionContent, ResponseType, IsRequired, DisplayOrder)."""
        tid = params[0]
        linked = sorted(
            [(row[1], row[2], row[3]) for row in FakeCursor.template_questions if row[0] == tid],
            key=lambda r: r[2]  # sort by display_order
        )
        rows = []
        for qid, is_required, display_order in linked:
            q = FakeCursor.questions.get(qid)
            if q:
                rows.append((q["QuestionID"], q["Title"], q["QuestionContent"],
                             q["ResponseType"], is_required, display_order))
        self._rows = rows

    # ------------------------------------------------------------------
    # SurveyAssignment handlers
    # ------------------------------------------------------------------
    def _insert_assignment(self, params):
        aid = FakeCursor.next_assignment_id
        FakeCursor.next_assignment_id += 1
        now = datetime.now()
        FakeCursor.assignments[aid] = {
            "AssignmentID": aid,
            "SurveyID": params[0],
            "AccountID": params[1],
            "AssignedAt": now,
            "DueDate": params[2] if len(params) > 2 else None,
            "CompletedAt": None,
            "Status": params[3] if len(params) > 3 else "pending",
        }
        self.lastrowid = aid
        self.rowcount = 1

    def _select_assignment(self, query, params):
        if "WHERE AssignmentID" in query and params:
            aid = params[0]
            a = FakeCursor.assignments.get(aid)
            if a is None:
                self._row = None
                return
            if "Status" in query and "SurveyID" not in query:
                # SELECT AssignmentID, Status
                self._row = (a["AssignmentID"], a["Status"])
            elif "SurveyID" in query:
                self._row = self._assignment_full_tuple(a)
            else:
                self._row = (a["AssignmentID"],)
            return
        # List by SurveyID (and optional AccountID for dup check)
        if "WHERE SurveyID" in query and "AND AccountID" in query:
            sid, acct_id = params[0], params[1]
            match = next(
                (a for a in FakeCursor.assignments.values()
                 if a["SurveyID"] == sid and a["AccountID"] == acct_id),
                None
            )
            self._row = (match["AssignmentID"],) if match else None
            return
        if "WHERE SurveyID" in query:
            sid = params[0]
            rows = [a for a in FakeCursor.assignments.values() if a["SurveyID"] == sid]
            pi = 1
            if "Status = %s" in query and pi < len(params):
                status = params[pi]
                rows = [r for r in rows if r["Status"] == status]
            rows.sort(key=lambda r: r["AssignedAt"] or datetime.min, reverse=True)
            self._rows = [self._assignment_full_tuple(r) for r in rows]
            return
        # Fallback: empty
        self._rows = []

    def _assignment_full_tuple(self, a):
        return (a["AssignmentID"], a["SurveyID"], a["AccountID"],
                a["AssignedAt"], a["DueDate"], a["CompletedAt"], a["Status"])

    def _update_assignment(self, query, params):
        set_match = re.search(r'SET\s+(.+?)\s+WHERE', query, re.IGNORECASE | re.DOTALL)
        if not set_match:
            return
        set_clause = set_match.group(1)
        columns = [c.strip().split("=")[0].strip() for c in set_clause.split(",")]
        aid = params[-1]
        a = FakeCursor.assignments.get(aid)
        if not a:
            self.rowcount = 0
            return
        for i, col in enumerate(columns):
            a[col] = params[i]
        self.rowcount = 1

    def _delete_assignment(self, query, params):
        # Could be by AssignmentID or by SurveyID
        if "WHERE SurveyID" in query:
            sid = params[0]
            to_del = [aid for aid, a in FakeCursor.assignments.items() if a["SurveyID"] == sid]
            for aid in to_del:
                del FakeCursor.assignments[aid]
            self.rowcount = len(to_del)
        else:
            aid = params[0]
            if aid in FakeCursor.assignments:
                del FakeCursor.assignments[aid]
                self.rowcount = 1
            else:
                self.rowcount = 0

    def _select_my_assignments(self, query, params):
        """JOIN SurveyAssignment + Survey for /me endpoint."""
        acct_id = params[0]
        rows = [a for a in FakeCursor.assignments.values() if a["AccountID"] == acct_id]
        pi = 1
        if "Status IN (" in query:
            # Handle IN clause for multiple statuses
            statuses = params[1:]
            rows = [r for r in rows if r["Status"] in statuses]
        elif "Status = %s" in query and pi < len(params):
            status = params[pi]
            rows = [r for r in rows if r["Status"] == status]
        rows.sort(key=lambda r: r["AssignedAt"] or datetime.min, reverse=True)
        result = []
        # Detect which endpoint/query is being used by checking the SELECT columns
        # /assignments expects: AssignmentID, SurveyID, Title, AssignedAt, DueDate, CompletedAt, Status
        # /participants/surveys expects: SurveyID, Title, StartDate, EndDate, Status, AssignedAt, DueDate, CompletedAt, PublicationStatus
        if "sa.AssignmentID" in query and "sa.SurveyID" in query and "s.Title" in query and "sa.Status" in query:
            for a in rows:
                s = FakeCursor.surveys.get(a["SurveyID"], {})
                due = a["DueDate"] or s.get("EndDate")  # COALESCE
                result.append((
                    a["AssignmentID"],
                    a["SurveyID"],
                    s.get("Title", "Unknown"),
                    a["AssignedAt"],
                    due,
                    a["CompletedAt"],
                    a["Status"],
                ))
        else:
            for a in rows:
                s = FakeCursor.surveys.get(a["SurveyID"], {})
                result.append((
                    a["SurveyID"],
                    s.get("Title", "Unknown"),
                    s.get("StartDate"),
                    s.get("EndDate"),
                    a["Status"],
                    a.get("DraftData"),
                    a["AssignedAt"],
                    a["DueDate"],
                    a["CompletedAt"],
                    s.get("PublicationStatus", "published"),
                ))
        self._rows = result

    # ------------------------------------------------------------------
    # AccountRequest handlers
    # ------------------------------------------------------------------
    def _insert_account_request(self, params):
        rid = FakeCursor.next_request_id
        FakeCursor.next_request_id += 1
        now = datetime.now()
        FakeCursor.account_requests[rid] = {
            "RequestID": rid,
            "FirstName": params[0],
            "LastName": params[1],
            "Email": params[2],
            "RoleID": params[3],
            "Birthdate": params[4],
            "Gender": params[5],
            "GenderOther": params[6],
            "Status": "pending",
            "AdminNotes": None,
            "ReviewedBy": None,
            "CreatedAt": now,
            "ReviewedAt": None,
            "RoleName": {1: "participant", 2: "researcher", 3: "hcp"}.get(params[3], "participant"),
        }
        self.lastrowid = rid
        self.rowcount = 1

    def _count_account_requests(self, query, params):
        count = sum(
            1 for r in FakeCursor.account_requests.values()
            if r["Status"] == "pending"
        )
        self._row = (count,)

    def _select_account_requests(self, query, params):
        # Single request by ID
        if "WHERE RequestID" in query:
            rid = params[0]
            req = FakeCursor.account_requests.get(rid)
            if req is None:
                self._row = None
            else:
                self._row = req  # dictionary cursor
            return
        # List with optional status filter
        rows = list(FakeCursor.account_requests.values())
        if params and "Status = %s" in query:
            rows = [r for r in rows if r["Status"] == params[0]]
        rows.sort(key=lambda r: r["CreatedAt"], reverse=True)
        self._rows = rows

    def _update_account_request(self, query, params):
        # Find request_id (last param)
        rid = params[-1]
        req = FakeCursor.account_requests.get(rid)
        if not req:
            self.rowcount = 0
            return
        if "Status = 'approved'" in query:
            req["Status"] = "approved"
            req["ReviewedAt"] = datetime.now()
        elif "Status = 'rejected'" in query:
            req["Status"] = "rejected"
            req["AdminNotes"] = params[0] if params else None
            req["ReviewedAt"] = datetime.now()
        self.rowcount = 1

    def _check_email_exists(self, params):
        email = params[0]
        self._row = (1,) if email in FakeCursor.used_emails else None

    def _check_pending_request(self, params):
        email = params[0]
        match = any(
            r["Email"] == email and r["Status"] == "pending"
            for r in FakeCursor.account_requests.values()
        )
        self._row = (1,) if match else None

    def _select_account_by_id(self, params):
        account_id = params[0]
        for _, acct in FakeCursor.accounts.items():
            if acct["account_id"] == account_id:
                # Return a tuple (AccountID, AuthID) to match production DB for delete_user
                self._row = (account_id, acct.get("auth_id", 1))
                return
        self._row = None

    def _select_auth_for_change_password(self, params):
        account_id = params[0]
        for _, acct in FakeCursor.accounts.items():
            if acct["account_id"] == account_id:
                self._row = (acct.get("auth_id", 1), acct["password_hash"])
                return
        self._row = None

    def _count_users_with_filters(self, query, params):
        rows = self._filtered_user_accounts(query, params, include_pagination=False)
        self._row = (len(rows),)

    def _select_users_with_filters(self, query, params):
        # Single user lookup by AccountID
        if "WHERE a.AccountID = %s" in query and params:
            account_id = params[0]
            match = None
            for acct in FakeCursor.accounts.values():
                if acct.get("account_id") == account_id:
                    match = acct
                    break
            self._row = self._user_row_tuple(match) if match else None
            return

        rows = self._filtered_user_accounts(query, params, include_pagination=True)
        self._rows = [self._user_row_tuple(acct) for acct in rows]

    def _filtered_user_accounts(self, query, params, include_pagination):
        params = params or []
        accounts = list(FakeCursor.accounts.values())

        pi = 0

        # search uses 3 repeated LIKE params; use first one
        if "a.FirstName LIKE %s" in query and pi + 2 < len(params):
            search_term = str(params[pi]).strip("%").lower()
            pi += 3
            accounts = [
                acct for acct in accounts
                if search_term in str(acct.get("first_name", "")).lower()
                or search_term in str(acct.get("last_name", "")).lower()
                or search_term in str(acct.get("email", "")).lower()
            ]

        if "r.RoleName = %s" in query and pi < len(params):
            role_name = str(params[pi]).lower()
            pi += 1
            accounts = [
                acct for acct in accounts
                if self.roles.get(acct.get("role_id", 1), "participant") == role_name
            ]

        if "a.IsActive = %s" in query and pi < len(params):
            is_active = bool(params[pi])
            pi += 1
            accounts = [acct for acct in accounts if bool(acct.get("is_active", True)) == is_active]

        if include_pagination and "LIMIT %s OFFSET %s" in query and pi + 1 < len(params):
            limit = int(params[pi])
            offset = int(params[pi + 1])
            return accounts[offset: offset + limit]

        return accounts

    def _user_row_tuple(self, acct):
        if not acct:
            return None
        role_name = self.roles.get(acct.get("role_id", 1), "participant")
        return (
            acct.get("account_id"),
            acct.get("first_name", "Test"),
            acct.get("last_name", "User"),
            acct.get("email", ""),
            role_name,
            acct.get("is_active", True),
            acct.get("created_at"),
            acct.get("last_login"),
            acct.get("consent_signed_at"),
            acct.get("consent_version"),
        )

    # ------------------------------------------------------------------
    # fetchone / fetchall / close
    # ------------------------------------------------------------------
    def fetchone(self):
        return self._row

    def fetchall(self):
        if self._rows is not None:
            return self._rows
        return self.results

    def close(self):
        pass


class FakeConnection:
    def __init__(self, results=None):
        self.results = results

    def cursor(self, dictionary=False):
        return FakeCursor(self.results)

    def commit(self):
        pass

    def rollback(self):
        pass

    def close(self):
        pass
