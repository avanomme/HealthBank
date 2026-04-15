// Created with the Assistance of Claude Code
// frontend/lib/core/api/services/user_api.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/models.dart';

part 'user_api.g.dart';

/// User API service using Retrofit with typed models
///
/// Run `dart run build_runner build` to generate user_api.g.dart
@RestApi()
abstract class UserApi {
  factory UserApi(Dio dio, {String? baseUrl}) = _UserApi;

  /// List all users with optional filters
  @GET('/users')
  Future<UserListResponse> listUsers({
    @Query('role') String? role,
    @Query('is_active') bool? isActive,
    @Query('search') String? search,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  });

  /// Get a single user by ID
  @GET('/users/{id}')
  Future<User> getUser(@Path('id') int id);

  /// Create a new user
  @POST('/users')
  Future<User> createUser(@Body() UserCreate user);

  /// Update a user
  @PUT('/users/{id}')
  Future<User> updateUser(
    @Path('id') int id,
    @Body() UserUpdate user,
  );

  /// Toggle user active status
  @PATCH('/users/{id}/status')
  Future<User> toggleUserStatus(
    @Path('id') int id,
    @Query('is_active') bool isActive,
  );

  /// Delete a user
  @DELETE('/users/{id}')
  Future<void> deleteUser(@Path('id') int id);
}
