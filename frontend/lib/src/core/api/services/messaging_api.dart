// Created with the Assistance of Claude Code
// frontend/lib/src/core/api/services/messaging_api.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:frontend/src/core/api/models/models.dart';

part 'messaging_api.g.dart';

@RestApi()
abstract class MessagingApi {
  factory MessagingApi(Dio dio, {String? baseUrl}) = _MessagingApi;

  @POST('/messages/conversations')
  Future<ConversationCreated> createConversation(
      @Body() Map<String, dynamic> body);

  @GET('/messages/conversations')
  Future<List<Conversation>> getConversations();

  @GET('/messages/conversations/{convId}/messages')
  Future<List<Message>> getMessages(@Path('convId') int convId);

  @POST('/messages/conversations/{convId}/messages')
  Future<MessageCreated> sendMessage(
      @Path('convId') int convId, @Body() Map<String, dynamic> body);

  @POST('/messages/friend-request')
  Future<void> sendFriendRequest(@Body() Map<String, dynamic> body);

  @GET('/messages/friends')
  Future<List<ResearcherResult>> getFriends();

  @GET('/messages/researchers/search')
  Future<List<ResearcherResult>> searchResearchers(
      @Query('q') String query);

  @GET('/messages/researchers')
  Future<List<ResearcherResult>> listResearchers(
      {@Query('q') String? query});

  @POST('/messages/friend-request/direct')
  Future<void> sendDirectFriendRequest(@Body() Map<String, dynamic> body);

  @GET('/messages/friend-requests/incoming')
  Future<List<FriendRequest>> getIncomingFriendRequests();

  @PUT('/messages/friend-requests/{requestId}/respond')
  Future<void> respondToFriendRequest(
      @Path('requestId') int requestId,
      @Body() Map<String, dynamic> body);

  @DELETE('/messages/conversations/{convId}/messages/{messageId}')
  Future<void> deleteMessage(
      @Path('convId') int convId, @Path('messageId') int messageId);

  @DELETE('/messages/contacts/{contactId}')
  Future<void> deleteContact(@Path('contactId') int contactId);
}
