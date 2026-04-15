Flow:

Enrollment:
The User will log in with a password
They’ll then be taken to create a 2FA (if not enabled already)
The server generates a new ‘secret’ via PyOTP
It’ll be stored within a separate database
The server shows the user a QR code
The User shares the QR code in Microsoft Authenticator
User enters the 6 digit code
Server verifies it
If it’s valid, change the user’s information to show that 2FA is enabled
The server secret needs to be permanently stored. External database that is only decrypted when verifying. 

Verification:
User enters username and password
As long as 2FA is enabled, prompts for a six digit code
User opens Microsoft Authenticator
User types code
Server checks if their secret matches, via the external masterkey
If user enters the wrong code, it does not let them in
Authentication will be rate limited by a function, increasing in time to prevent brute force attacks being efficient

Variables Columns that need to be in the table storing said values:
Totp_enabled, a bool value that will trigger creating the 2FA if false
Totp_failed_attempts, used to increase time between attempts (2^n time in seconds in between each failed attempt to prevent brute force) (can be in the backend instead, if it works better)
User email, can either be entered on creation or a foreign key to their account
Totp_secret, which is where the secret initially created on enrollment is stored in an encrypted state. Will be decrypted and checked externally using the masterkey.

STANDARD INFO:

Secret Generation
	PyOTP will be used as an encryption standard API.
	Each user will have a TOTP secret, which is what is scanned by QR code scanners in authentication apps. (Google Authenticator or Microsoft Authenticator).
	The secret will be stored on the server, for validation. It will be encrypted with a masterkey before storage, and will be the same thing that decrypts it. The masterkey will be an environmental variable, within an API.
QR Code Creation
	QR scanning will be handled by the external authenticator.
	The QR will be generated within the backend, then sent to the user.
