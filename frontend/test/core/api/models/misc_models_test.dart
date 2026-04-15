import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/api/models/account_request.dart';
import 'package:frontend/src/core/api/models/assignment.dart';
import 'package:frontend/src/core/api/models/audit_log.dart';
import 'package:frontend/src/core/api/models/consent.dart';
import 'package:frontend/src/core/api/models/database.dart';
import 'package:frontend/src/core/api/models/hcp_link.dart';
import 'package:frontend/src/core/api/models/impersonation.dart';
import 'package:frontend/src/core/api/models/message.dart';
import 'package:frontend/src/core/api/models/two_factor.dart';

void main() {
  group('Misc API models', () {
    test('account request models round-trip', () {
      expect(
        AccountRequestCreate.fromJson(
          const AccountRequestCreate(
            firstName: 'Ada',
            lastName: 'Lovelace',
            email: 'ada@example.com',
            roleId: 2,
            birthdate: '1990-01-02',
            gender: 'Other',
            genderOther: 'Nonbinary',
          ).toJson(),
        ),
        const AccountRequestCreate(
          firstName: 'Ada',
          lastName: 'Lovelace',
          email: 'ada@example.com',
          roleId: 2,
          birthdate: '1990-01-02',
          gender: 'Other',
          genderOther: 'Nonbinary',
        ),
      );

      expect(
        AccountRequestResponse.fromJson(
          const AccountRequestResponse(
            requestId: 1,
            firstName: 'Ada',
            lastName: 'Lovelace',
            email: 'ada@example.com',
            roleId: 2,
            status: 'pending',
            adminNotes: 'Review soon',
            reviewedBy: 5,
            createdAt: '2024-01-01T00:00:00Z',
            reviewedAt: '2024-01-02T00:00:00Z',
          ).toJson(),
        ),
        const AccountRequestResponse(
          requestId: 1,
          firstName: 'Ada',
          lastName: 'Lovelace',
          email: 'ada@example.com',
          roleId: 2,
          status: 'pending',
          adminNotes: 'Review soon',
          reviewedBy: 5,
          createdAt: '2024-01-01T00:00:00Z',
          reviewedAt: '2024-01-02T00:00:00Z',
        ),
      );

      expect(
        AccountRequestCountResponse.fromJson(
          const AccountRequestCountResponse(count: 3).toJson(),
        ),
        const AccountRequestCountResponse(count: 3),
      );
      expect(
        AccountRequestRejectBody.fromJson(
          const AccountRequestRejectBody(adminNotes: 'Rejected').toJson(),
        ),
        const AccountRequestRejectBody(adminNotes: 'Rejected'),
      );
      expect(
        DeletionRequestResponse.fromJson(
          const DeletionRequestResponse(
            requestId: 2,
            accountId: 7,
            fullName: 'Ada Lovelace',
            email: 'ada@example.com',
            status: 'pending',
            requestedAt: '2024-01-03T00:00:00Z',
          ).toJson(),
        ),
        const DeletionRequestResponse(
          requestId: 2,
          accountId: 7,
          fullName: 'Ada Lovelace',
          email: 'ada@example.com',
          status: 'pending',
          requestedAt: '2024-01-03T00:00:00Z',
        ),
      );
      expect(
        DeletionRequestCountResponse.fromJson(
          const DeletionRequestCountResponse(count: 4).toJson(),
        ),
        const DeletionRequestCountResponse(count: 4),
      );
    });

    test('assignment models and enum serialize correctly', () {
      expect(AssignmentStatus.pending.name, 'pending');
      expect(
        AssignmentCreate.fromJson(
          AssignmentCreate(
            accountId: 1,
            dueDate: DateTime.parse('2024-02-01T00:00:00.000Z'),
          ).toJson(),
        ),
        AssignmentCreate(
          accountId: 1,
          dueDate: DateTime.parse('2024-02-01T00:00:00.000Z'),
        ),
      );
      expect(
        BulkAssignmentCreate.fromJson(
          BulkAssignmentCreate(
            accountIds: const [1, 2, 3],
            dueDate: DateTime.parse('2024-02-02T00:00:00.000Z'),
          ).toJson(),
        ),
        BulkAssignmentCreate(
          accountIds: const [1, 2, 3],
          dueDate: DateTime.parse('2024-02-02T00:00:00.000Z'),
        ),
      );
      expect(
        BulkAssignmentResult.fromJson(
          const BulkAssignmentResult(
            assigned: 10,
            skipped: 2,
            totalTargeted: 12,
          ).toJson(),
        ),
        const BulkAssignmentResult(
          assigned: 10,
          skipped: 2,
          totalTargeted: 12,
        ),
      );
      expect(
        AssignmentUpdate.fromJson(
          AssignmentUpdate(
            dueDate: DateTime.parse('2024-02-03T00:00:00.000Z'),
            status: 'completed',
          ).toJson(),
        ),
        AssignmentUpdate(
          dueDate: DateTime.parse('2024-02-03T00:00:00.000Z'),
          status: 'completed',
        ),
      );
      expect(
        Assignment.fromJson(
          Assignment(
            assignmentId: 1,
            surveyId: 2,
            accountId: 3,
            assignedAt: DateTime.parse('2024-02-01T00:00:00.000Z'),
            dueDate: DateTime.parse('2024-02-05T00:00:00.000Z'),
            completedAt: DateTime.parse('2024-02-04T00:00:00.000Z'),
            status: 'completed',
          ).toJson(),
        ),
        Assignment(
          assignmentId: 1,
          surveyId: 2,
          accountId: 3,
          assignedAt: DateTime.parse('2024-02-01T00:00:00.000Z'),
          dueDate: DateTime.parse('2024-02-05T00:00:00.000Z'),
          completedAt: DateTime.parse('2024-02-04T00:00:00.000Z'),
          status: 'completed',
        ),
      );
      expect(
        MyAssignment.fromJson(
          MyAssignment(
            assignmentId: 1,
            surveyId: 2,
            surveyTitle: 'Mood Survey',
            assignedAt: DateTime.parse('2024-02-01T00:00:00.000Z'),
            dueDate: DateTime.parse('2024-02-05T00:00:00.000Z'),
            completedAt: DateTime.parse('2024-02-04T00:00:00.000Z'),
            status: 'completed',
          ).toJson(),
        ),
        MyAssignment(
          assignmentId: 1,
          surveyId: 2,
          surveyTitle: 'Mood Survey',
          assignedAt: DateTime.parse('2024-02-01T00:00:00.000Z'),
          dueDate: DateTime.parse('2024-02-05T00:00:00.000Z'),
          completedAt: DateTime.parse('2024-02-04T00:00:00.000Z'),
          status: 'completed',
        ),
      );
    });

    test('messaging models round-trip', () {
      expect(
        Conversation.fromJson(
          Conversation(
            convId: 1,
            otherParticipantId: 9,
            otherParticipantName: 'Grace',
            lastMessage: 'hello',
            lastMessageAt: DateTime.parse('2024-03-01T00:00:00.000Z'),
          ).toJson(),
        ),
        Conversation(
          convId: 1,
          otherParticipantId: 9,
          otherParticipantName: 'Grace',
          lastMessage: 'hello',
          lastMessageAt: DateTime.parse('2024-03-01T00:00:00.000Z'),
        ),
      );
      expect(
        Message.fromJson(
          Message(
            messageId: 3,
            senderId: 4,
            senderName: 'Grace',
            body: 'Hello',
            sentAt: DateTime.parse('2024-03-02T00:00:00.000Z'),
          ).toJson(),
        ),
        Message(
          messageId: 3,
          senderId: 4,
          senderName: 'Grace',
          body: 'Hello',
          sentAt: DateTime.parse('2024-03-02T00:00:00.000Z'),
        ),
      );
      expect(
        FriendRequest.fromJson(
          FriendRequest(
            requestId: 4,
            requesterId: 10,
            requesterName: 'Researcher',
            requestedAt: DateTime.parse('2024-03-03T00:00:00.000Z'),
          ).toJson(),
        ),
        FriendRequest(
          requestId: 4,
          requesterId: 10,
          requesterName: 'Researcher',
          requestedAt: DateTime.parse('2024-03-03T00:00:00.000Z'),
        ),
      );
      expect(
        ResearcherResult.fromJson(
          const ResearcherResult(accountId: 12, displayName: 'Dr. Smith').toJson(),
        ),
        const ResearcherResult(accountId: 12, displayName: 'Dr. Smith'),
      );
      expect(
        ConversationCreated.fromJson(
          const ConversationCreated(convId: 22).toJson(),
        ),
        const ConversationCreated(convId: 22),
      );
      expect(
        MessageCreated.fromJson(
          const MessageCreated(messageId: 23).toJson(),
        ),
        const MessageCreated(messageId: 23),
      );
    });

    test('two-factor and consent models round-trip', () {
      expect(
        TwoFactorEnrollResponse.fromJson(
          const TwoFactorEnrollResponse(provisioningUri: 'otpauth://totp/x').toJson(),
        ),
        const TwoFactorEnrollResponse(provisioningUri: 'otpauth://totp/x'),
      );
      expect(
        TwoFactorConfirmResponse.fromJson(
          const TwoFactorConfirmResponse(message: 'enabled').toJson(),
        ),
        const TwoFactorConfirmResponse(message: 'enabled'),
      );
      expect(
        TwoFactorDisableResponse.fromJson(
          const TwoFactorDisableResponse(message: 'disabled').toJson(),
        ),
        const TwoFactorDisableResponse(message: 'disabled'),
      );
      expect(
        TwoFactorConfirmRequest.fromJson(
          const TwoFactorConfirmRequest(code: '123456').toJson(),
        ),
        const TwoFactorConfirmRequest(code: '123456'),
      );
      expect(
        ConsentStatusResponse.fromJson(
          const ConsentStatusResponse(
            hasSignedConsent: false,
            consentVersion: 'v1',
            consentSignedAt: '2024-01-01',
            currentVersion: 'v2',
            needsConsent: true,
          ).toJson(),
        ),
        const ConsentStatusResponse(
          hasSignedConsent: false,
          consentVersion: 'v1',
          consentSignedAt: '2024-01-01',
          currentVersion: 'v2',
          needsConsent: true,
        ),
      );
      expect(
        ConsentSubmitRequest.fromJson(
          const ConsentSubmitRequest(
            documentText: 'terms',
            documentLanguage: 'en',
            signatureName: 'Ada',
          ).toJson(),
        ),
        const ConsentSubmitRequest(
          documentText: 'terms',
          documentLanguage: 'en',
          signatureName: 'Ada',
        ),
      );
      expect(
        ConsentSubmitResponse.fromJson(
          const ConsentSubmitResponse(
            accepted: true,
            version: 'v2',
            consentRecordId: 9,
          ).toJson(),
        ),
        const ConsentSubmitResponse(
          accepted: true,
          version: 'v2',
          consentRecordId: 9,
        ),
      );
      expect(
        UserConsentRecordResponse.fromJson(
          const UserConsentRecordResponse(
            consentRecordId: 9,
            accountId: 1,
            roleId: 2,
            consentVersion: 'v2',
            documentLanguage: 'en',
            documentText: 'full text',
            signatureName: 'Ada',
            signedAt: '2024-01-02',
            ipAddress: '127.0.0.1',
            userAgent: 'test',
          ).toJson(),
        ),
        const UserConsentRecordResponse(
          consentRecordId: 9,
          accountId: 1,
          roleId: 2,
          consentVersion: 'v2',
          documentLanguage: 'en',
          documentText: 'full text',
          signatureName: 'Ada',
          signedAt: '2024-01-02',
          ipAddress: '127.0.0.1',
          userAgent: 'test',
        ),
      );
    });

    test('database, audit, hcp link, and impersonation models round-trip', () {
      const schema = TableSchema(
        name: 'users',
        description: 'System users',
        columns: [
          ColumnInfo(
            name: 'account_id',
            type: 'int',
            isPrimaryKey: true,
          ),
        ],
        rowCount: 5,
      );
      expect(TableSchema.fromJson(schema.toJson()), schema);
      expect(
        TableData.fromJson(
          const TableData(
            name: 'users',
            columns: ['account_id', 'email'],
            rows: [
              {'account_id': 1, 'email': 'ada@example.com'},
            ],
            total: 1,
          ).toJson(),
        ),
        const TableData(
          name: 'users',
          columns: ['account_id', 'email'],
          rows: [
            {'account_id': 1, 'email': 'ada@example.com'},
          ],
          total: 1,
        ),
      );
      expect(TableListResponse.fromJson(const TableListResponse(tables: [schema]).toJson()),
          const TableListResponse(tables: [schema]));
      expect(
        TableDetailResponse.fromJson(
          const TableDetailResponse(
            schemaInfo: schema,
            data: TableData(
              name: 'users',
              columns: ['account_id'],
              rows: [
                {'account_id': 1},
              ],
              total: 1,
            ),
          ).toJson(),
        ),
        const TableDetailResponse(
          schemaInfo: schema,
          data: TableData(
            name: 'users',
            columns: ['account_id'],
            rows: [
              {'account_id': 1},
            ],
            total: 1,
          ),
        ),
      );
      expect(
        PasswordResetRequest.fromJson(
          const PasswordResetRequest(newPassword: 'secret').toJson(),
        ),
        const PasswordResetRequest(newPassword: 'secret'),
      );
      expect(
        PasswordResetResponse.fromJson(
          const PasswordResetResponse(message: 'ok', userId: 1).toJson(),
        ),
        const PasswordResetResponse(message: 'ok', userId: 1),
      );
      expect(
        SendResetEmailRequest.fromJson(
          const SendResetEmailRequest(
            temporaryPassword: 'temp',
            emailOverride: 'ada@example.com',
          ).toJson(),
        ),
        const SendResetEmailRequest(
          temporaryPassword: 'temp',
          emailOverride: 'ada@example.com',
        ),
      );
      expect(
        SendResetEmailResponse.fromJson(
          const SendResetEmailResponse(
            message: 'sent',
            sentTo: 'ada@example.com',
            userId: 1,
          ).toJson(),
        ),
        const SendResetEmailResponse(
          message: 'sent',
          sentTo: 'ada@example.com',
          userId: 1,
        ),
      );

      const event = AuditEvent(
        auditEventId: 1,
        createdAt: '2024-01-01T00:00:00Z',
        actorType: 'admin',
        action: 'approve',
        resourceType: 'account_request',
        status: 'success',
        metadata: {'request_id': 1},
      );
      expect(AuditEvent.fromJson(event.toJson()), event);
      expect(
        AuditLogResponse.fromJson(
          const AuditLogResponse(events: [event], total: 1, limit: 50, offset: 0).toJson(),
        ),
        const AuditLogResponse(events: [event], total: 1, limit: 50, offset: 0),
      );

      final link = HcpLink(
        linkId: 1,
        hcpId: 2,
        patientId: 3,
        hcpName: 'Dr. Smith',
        patientName: 'Ada',
        status: 'active',
        requestedBy: 'patient',
        requestedAt: DateTime.parse('2024-04-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2024-04-02T00:00:00.000Z'),
        consentRevoked: true,
      );
      expect(HcpLink.fromJson(link.toJson()), link);

      const impersonatedUser = ImpersonatedUserInfo(
        accountId: 1,
        firstName: 'Ada',
        lastName: 'Lovelace',
        email: 'ada@example.com',
        role: 'participant',
      );
      expect(ImpersonatedUserInfo.fromJson(impersonatedUser.toJson()), impersonatedUser);
      expect(
        ImpersonateResponse.fromJson(
          const ImpersonateResponse(
            message: 'ok',
            sessionToken: 'token',
            expiresAt: '2024-05-01',
            isImpersonating: true,
            impersonatedUser: impersonatedUser,
            adminAccountId: 4,
          ).toJson(),
        ),
        const ImpersonateResponse(
          message: 'ok',
          sessionToken: 'token',
          expiresAt: '2024-05-01',
          isImpersonating: true,
          impersonatedUser: impersonatedUser,
          adminAccountId: 4,
        ),
      );
      expect(
        EndImpersonationResponse.fromJson(
          const EndImpersonationResponse(message: 'ended', adminAccountId: 4).toJson(),
        ),
        const EndImpersonationResponse(message: 'ended', adminAccountId: 4),
      );
      const sessionUser = SessionUserInfo(
        accountId: 1,
        firstName: 'Ada',
        lastName: 'Lovelace',
        email: 'ada@example.com',
        role: 'participant',
        roleId: 1,
      );
      const impersonationInfo = ImpersonationInfo(
        adminAccountId: 4,
        adminFirstName: 'Admin',
        adminLastName: 'User',
        adminEmail: 'admin@example.com',
      );
      const viewingAs = ViewingAsUserInfo(
        userId: 1,
        firstName: 'Ada',
        lastName: 'Lovelace',
        email: 'ada@example.com',
        role: 'participant',
        roleId: 1,
      );
      expect(SessionUserInfo.fromJson(sessionUser.toJson()), sessionUser);
      expect(ImpersonationInfo.fromJson(impersonationInfo.toJson()), impersonationInfo);
      expect(ViewingAsUserInfo.fromJson(viewingAs.toJson()), viewingAs);
      expect(
        SessionMeResponse.fromJson(
          const SessionMeResponse(
            user: sessionUser,
            isImpersonating: true,
            impersonationInfo: impersonationInfo,
            viewingAs: viewingAs,
            sessionExpiresAt: '2024-05-01',
            hasSignedConsent: true,
            needsProfileCompletion: false,
          ).toJson(),
        ),
        const SessionMeResponse(
          user: sessionUser,
          isImpersonating: true,
          impersonationInfo: impersonationInfo,
          viewingAs: viewingAs,
          sessionExpiresAt: '2024-05-01',
          hasSignedConsent: true,
          needsProfileCompletion: false,
        ),
      );
      expect(
        ViewAsResponse.fromJson(
          const ViewAsResponse(
            message: 'ok',
            isViewingAs: true,
            viewedUser: viewingAs,
          ).toJson(),
        ),
        const ViewAsResponse(
          message: 'ok',
          isViewingAs: true,
          viewedUser: viewingAs,
        ),
      );
      expect(
        EndViewAsResponse.fromJson(
          const EndViewAsResponse(message: 'done').toJson(),
        ),
        const EndViewAsResponse(message: 'done'),
      );
    });
  });
}
