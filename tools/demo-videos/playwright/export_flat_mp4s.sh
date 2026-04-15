#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="${1:-../output/web}"
FLAT_DIR="${2:-../output/web/videos}"

mkdir -p "$FLAT_DIR"
find "$FLAT_DIR" -maxdepth 1 -type f -name '*.mp4' -delete

sanitize_name() {
  printf '%s' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9]+/_/g; s/^_+//; s/_+$//; s/_+/_/g'
}

title_case_tokens() {
  local value="$1"
  local result=""
  for token in $value; do
    case "$token" in
      and|as|in|to|from|of|a|an|the)
        ;;
      *)
        token="${token^}"
        ;;
    esac
    result+="${result:+_}${token}"
  done
  printf '%s' "$result"
}

friendly_name() {
  local parent_dir="$1"
  local stem="${parent_dir%-chromium}"
  local number="${stem%%_*}"

  case "$number" in
    01) printf '01_How_To_Public_Request_Account.mp4' ;;
    02) printf '02_How_To_Participant_First_Login.mp4' ;;
    03) printf '03_How_To_Researcher_First_Login.mp4' ;;
    04) printf '04_How_To_Healthcare_Provider_First_Login.mp4' ;;
    05) printf '05_How_To_Admin_Login.mp4' ;;
    06) printf '06_How_To_Participant_Dashboard_Overview.mp4' ;;
    07) printf '07_How_To_Participant_Tasks_And_Alerts.mp4' ;;
    08) printf '08_How_To_Participant_Surveys_List.mp4' ;;
    09) printf '09_How_To_Participant_Resume_Survey.mp4' ;;
    10) printf '10_How_To_Participant_Start_Survey.mp4' ;;
    11) printf '11_How_To_Participant_Results_And_Comparison.mp4' ;;
    12) printf '12_How_To_Participant_Add_A_Contact.mp4' ;;
    13) printf '13_How_To_Participant_Send_A_Message.mp4' ;;
    14) printf '14_How_To_Participant_Language_Options.mp4' ;;
    15) printf '15_How_To_Participant_Edit_Profile.mp4' ;;
    16) printf '16_How_To_Participant_Settings_Appearance_Themes.mp4' ;;
    17) printf '17_How_To_Participant_Settings_Security_Options.mp4' ;;
    18) printf '18_How_To_Researcher_Dashboard_Overview.mp4' ;;
    19) printf '19_How_To_Researcher_Survey_List_And_Filters.mp4' ;;
    20) printf '20_How_To_Researcher_Build_Survey_From_Scratch.mp4' ;;
    21) printf '21_How_To_Researcher_Build_Survey_From_Question_Bank.mp4' ;;
    22) printf '22_How_To_Researcher_Build_Survey_From_Template.mp4' ;;
    23) printf '23_How_To_Researcher_Publish_Survey.mp4' ;;
    24) printf '24_How_To_Researcher_Assign_Survey_All_Participants.mp4' ;;
    25) printf '25_How_To_Researcher_Assign_Survey_By_Demographic.mp4' ;;
    26) printf '26_How_To_Researcher_Survey_Status_And_Lifecycle.mp4' ;;
    27) printf '27_How_To_Researcher_Template_Library.mp4' ;;
    28) printf '28_How_To_Researcher_Create_New_Template.mp4' ;;
    29) printf '29_How_To_Researcher_Question_Bank.mp4' ;;
    30) printf '30_How_To_Researcher_Messaging_Inbox.mp4' ;;
    31) printf '31_How_To_Researcher_Research_Data_Single_Survey.mp4' ;;
    32) printf '32_How_To_Researcher_Research_Data_Bank_Mode.mp4' ;;
    33) printf '33_How_To_Healthcare_Provider_Dashboard_Overview.mp4' ;;
    34) printf '34_How_To_Healthcare_Provider_My_Patients_List.mp4' ;;
    35) printf '35_How_To_Healthcare_Provider_Request_Patient_Link.mp4' ;;
    36) printf '36_How_To_Healthcare_Provider_View_Patient_Completed_Surveys.mp4' ;;
    37) printf '37_How_To_Healthcare_Provider_Patient_Reports.mp4' ;;
    38) printf '38_How_To_Admin_Dashboard_Overview.mp4' ;;
    39) printf '39_How_To_Admin_User_Management.mp4' ;;
    40) printf '40_How_To_Admin_Account_And_Deletion_Requests.mp4' ;;
    41) printf '41_How_To_Admin_Audit_Log.mp4' ;;
    42) printf '42_How_To_Admin_System_Settings.mp4' ;;
    43) printf '43_How_To_Admin_Database_Viewer_And_Backups.mp4' ;;
    44) printf '44_How_To_Admin_View_As_Impersonate_User.mp4' ;;
    45) printf '45_How_To_Admin_Page_Navigator_Hub.mp4' ;;
    46) printf '46_How_To_Public_Information_Pages.mp4' ;;
    47) printf '47_How_To_Shared_Auth_Support_Pages.mp4' ;;
    48) printf '48_How_To_Shared_Messaging_Friend_Requests.mp4' ;;
    49) printf '49_How_To_Shared_Messaging_Direct_Conversation.mp4' ;;
    50) printf '50_How_To_Admin_Deletion_Queue_Redirect.mp4' ;;
    51) printf '51_How_To_Admin_UI_Test_Page.mp4' ;;
    52) printf '52_How_To_Participant_Results_Toggle_Behavior.mp4' ;;
    53) printf '53_How_To_Admin_Dashboard_Actions_And_Quick_Links.mp4' ;;
    54) printf '54_How_To_Admin_User_Management_Actions.mp4' ;;
    55) printf '55_How_To_Admin_Account_Request_Moderation.mp4' ;;
    56) printf '56_How_To_Admin_Settings_Save_Behavior.mp4' ;;
    57) printf '57_How_To_Admin_Database_Backup_Lifecycle.mp4' ;;
    58) printf '58_How_To_Admin_Audit_Log_Export.mp4' ;;
    59) printf '59_How_To_Participant_Health_Tracking_Log_Today.mp4' ;;
    60) printf '60_How_To_Participant_Health_Tracking_History.mp4' ;;
    61) printf '61_How_To_Admin_Health_Tracking_Settings.mp4' ;;
    62) printf '62_How_To_Researcher_Health_Tracking_Filters_And_Export.mp4' ;;
    63) printf '63_How_To_Participant_Health_Tracking_Baseline.mp4' ;;
    64) printf '64_How_To_Admin_Database_Restore_From_Backup.mp4' ;;
    65) printf '65_How_To_Participant_Health_Tracking_Metric_Types.mp4' ;;
    70) printf '70_Full_Participant_Walkthrough.mp4' ;;
    71) printf '71_Full_Researcher_Walkthrough.mp4' ;;
    72) printf '72_Full_Healthcare_Provider_Walkthrough.mp4' ;;
    73) printf '73_Full_Admin_Walkthrough.mp4' ;;
    *) printf '%s' "$(sanitize_name "$stem").mp4" ;;
  esac
}

while IFS= read -r -d '' input; do
  parent_dir="$(basename "$(dirname "$input")")"
  file_name="$(friendly_name "$parent_dir")"
  cp -f "$input" "$FLAT_DIR/$file_name"
  echo "$FLAT_DIR/$file_name"
done < <(find "$ROOT_DIR" -type f -name 'video.mp4' -not -path "$FLAT_DIR/*" -print0 | sort -z)
