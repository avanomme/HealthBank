<!-- Created with the Assistance of Claude Code -->
# Session Initialization Gate

## Problem

On app startup, `_initializeSession()` restores the auth token from secure storage asynchronously. Without a gate, the router renders pages and API calls fire before the token is set on the Dio client, causing 401 errors.

## Solution

`main.dart` watches `sessionInitializedProvider` and shows a loading spinner until session restoration completes:

```dart
final sessionReady = ref.watch(sessionInitializedProvider);

if (!sessionReady) {
  return MaterialApp(
    home: Scaffold(body: Center(child: CircularProgressIndicator())),
  );
}

return MaterialApp.router(routerConfig: appRouter, ...);
```

## Flow

1. App starts, `sessionInitializedProvider` = `false`
2. `_initializeSession()` runs:
   - Reads token from `FlutterSecureStorage`
   - Sets token on Dio via `setAuthToken()`
   - Restores impersonation state
3. `sessionInitializedProvider` set to `true`
4. `MaterialApp.router` renders with GoRouter
5. GoRouter redirect evaluates auth state (token is now set)

## Session Expiry Handler

`ApiClient.onSessionExpired` is set in `_MyAppState.initState()`:

```dart
ApiClient.onSessionExpired = _handleSessionExpired;
```

When a 401 is received on a non-login endpoint:
1. Clears secure storage credentials
2. Clears Dio auth header
3. Resets `authProvider` state (without backend call)
4. `AuthChangeNotifier` triggers GoRouter redirect to login
