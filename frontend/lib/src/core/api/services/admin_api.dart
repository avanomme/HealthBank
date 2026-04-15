// Created with the Assistance of Claude Code
// frontend/lib/src/core/api/services/admin_api.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/database.dart';
import '../models/impersonation.dart';
import '../models/audit_log.dart';
import '../models/account_request.dart';
import '../models/auth.dart';
import '../models/consent.dart';
import '../models/backup.dart';
import '../models/settings.dart';

part 'admin_api.g.dart';

/// Admin API service for database viewer and user management
///
/// Run `dart run build_runner build` to generate admin_api.g.dart
@RestApi()
abstract class AdminApi {
  factory AdminApi(Dio dio, {String? baseUrl}) = _AdminApi;

  // =========================================================================
  // Database Viewer Endpoints
  // =========================================================================

  /// List all database tables with schema info
  @GET('/admin/tables')
  Future<TableListResponse> listTables();

  /// Get table schema and data
  @GET('/admin/tables/{tableName}')
  Future<TableDetailResponse> getTable(
    @Path('tableName') String tableName, {
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  });

  /// Get table data only
  @GET('/admin/tables/{tableName}/data')
  Future<TableData> getTableData(
    @Path('tableName') String tableName, {
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  });

  // =========================================================================
  // Password Reset Endpoints
  // =========================================================================

  /// Reset a user's password
  @POST('/admin/users/{userId}/reset-password')
  Future<PasswordResetResponse> resetPassword(
    @Path('userId') int userId,
    @Body() PasswordResetRequest request,
  );

  /// Send password reset email to user
  @POST('/admin/users/{userId}/send-reset-email')
  Future<SendResetEmailResponse> sendResetEmail(
    @Path('userId') int userId,
    @Body() SendResetEmailRequest request,
  );

  // =========================================================================
  // View-As Endpoints (System Administrator Only) - New Approach
  // =========================================================================

  /// Start viewing as another user
  ///
  /// Only accessible by system administrators (RoleID = 4).
  /// Updates admin's session with ViewingAsUserID - no new token generated.
  /// This eliminates token switching complexity on the frontend.
  @POST('/admin/users/{userId}/view-as')
  Future<ViewAsResponse> startViewingAs(
    @Path('userId') int userId,
  );

  /// End view-as mode
  ///
  /// Clears ViewingAsUserID from admin's session.
  /// No token switching required - same session continues.
  @POST('/admin/view-as/end')
  Future<EndViewAsResponse> endViewingAs();

  // =========================================================================
  // Impersonation Endpoints (DEPRECATED - Use View-As Instead)
  // =========================================================================

  /// Start impersonating a user
  ///
  /// DEPRECATED: Use [startViewingAs] instead.
  /// This creates a new session token, while view-as updates existing session.
  @Deprecated('Use startViewingAs instead')
  @POST('/admin/users/{userId}/impersonate')
  Future<ImpersonateResponse> impersonateUser(
    @Path('userId') int userId,
  );

  /// End the current impersonation session
  ///
  /// DEPRECATED: Use [endViewingAs] instead.
  @Deprecated('Use endViewingAs instead')
  @POST('/admin/impersonate/end')
  Future<EndImpersonationResponse> endImpersonation();

  // =========================================================================
  // Account Request Endpoints
  // =========================================================================

  /// List account requests filtered by status (default: pending)
  @GET('/admin/account-requests')
  Future<List<AccountRequestResponse>> getAccountRequests({
    @Query('status') String? status,
  });

  /// Get count of pending account requests (for badge)
  @GET('/admin/account-requests/count')
  Future<AccountRequestCountResponse> getAccountRequestCount();

  /// Approve an account request (creates account + sends email)
  @POST('/admin/account-requests/{requestId}/approve')
  Future<MessageResponse> approveAccountRequest(
    @Path('requestId') int requestId,
  );

  /// Reject an account request with optional notes
  @POST('/admin/account-requests/{requestId}/reject')
  Future<MessageResponse> rejectAccountRequest(
    @Path('requestId') int requestId,
    @Body() AccountRequestRejectBody body,
  );

  // =========================================================================
  // Deletion Request Endpoints
  // =========================================================================

  /// List user-submitted deletion requests filtered by status (default: pending)
  @GET('/admin/deletion-requests')
  Future<List<DeletionRequestResponse>> getDeletionRequests({
    @Query('status') String? status,
  });

  /// Get count of pending deletion requests (for badge)
  @GET('/admin/deletion-requests/count')
  Future<DeletionRequestCountResponse> getDeletionRequestCount();

  /// Approve a deletion request — permanently deletes the account
  @POST('/admin/deletion-requests/{requestId}/approve')
  Future<MessageResponse> approveDeletionRequest(
    @Path('requestId') int requestId,
  );

  /// Reject a deletion request — reactivates the account
  @POST('/admin/deletion-requests/{requestId}/reject')
  Future<MessageResponse> rejectDeletionRequest(
    @Path('requestId') int requestId,
    @Body() AccountRequestRejectBody body,
  );

  // =========================================================================
  // Audit Log Endpoints
  // =========================================================================

  /// Get audit log events with optional filtering
  @GET('/admin/audit-logs')
  Future<AuditLogResponse> getAuditLogs({
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('action') String? action,
    @Query('status') String? status,
    @Query('actor_account_id') int? actorAccountId,
    @Query('resource_type') String? resourceType,
    @Query('http_method') String? httpMethod,
    @Query('search') String? search,
    @Query('start_date') String? startDate,
    @Query('end_date') String? endDate,
  });

  /// Get distinct action types for filter dropdowns
  @GET('/admin/audit-logs/actions')
  Future<List<String>> getAuditLogActions();

  /// Get distinct resource types for filter dropdowns
  @GET('/admin/audit-logs/resource-types')
  Future<List<String>> getAuditLogResourceTypes();

  // =========================================================================
  // Consent Record Endpoints
  // =========================================================================

  /// Get a user's most recent consent record (for admin viewing)
  @GET('/admin/users/{userId}/consent')
  Future<UserConsentRecordResponse?> getUserConsentRecord(
    @Path('userId') int userId,
  );

  // =========================================================================
  // Backup Endpoints
  // =========================================================================

  /// List all backup files (daily / weekly / monthly / manual)
  @GET('/admin/backups')
  Future<List<BackupInfo>> listBackups();

  /// Trigger an immediate manual backup
  @POST('/admin/backups/trigger')
  Future<BackupInfo> triggerBackup();

  /// Download a backup file — returns raw bytes
  @GET('/admin/backups/{backupType}/{filename}/download')
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> downloadBackup(
    @Path('backupType') String backupType,
    @Path('filename') String filename,
  );

  /// Delete a manual backup file (only manual type permitted)
  @DELETE('/admin/backups/manual/{filename}')
  Future<void> deleteBackup(
    @Path('filename') String filename,
  );

  /// Restore database from a backup. Auto-creates pre-restore backup first.
  @POST('/admin/backups/{backupType}/{filename}/restore')
  Future<RestoreResult> restoreBackup(
    @Path('backupType') String backupType,
    @Path('filename') String filename,
  );

  // =========================================================================
  // System Settings Endpoints
  // =========================================================================

  /// Get current system-wide settings (admin only)
  @GET('/admin/settings')
  Future<SystemSettings> getSettings();

  /// Update all system-wide settings atomically (admin only)
  @PUT('/admin/settings')
  Future<SystemSettings> updateSettings(@Body() Map<String, dynamic> body);

}
