-- Created with the Assistance of Claude Code
-- Backfill Gender and Birthdate for seeded participants so researcher
-- demographic filters (gender / age range) have data to match against.
--
-- Spread: 12 Male, 8 Female, 1 Non-binary, 1 Prefer Not to Say
-- Birthdates span 1965–2000 (ages ~25 to ~60 as of 2026).

UPDATE AccountData SET Gender = 'Female',             Birthdate = '1990-05-15' WHERE AccountID = 2  AND Gender IS NULL;
UPDATE AccountData SET Gender = 'Male',               Birthdate = '1980-03-10' WHERE AccountID = 13 AND Gender IS NULL;
UPDATE AccountData SET Gender = 'Female',             Birthdate = '1975-07-22' WHERE AccountID = 14 AND Gender IS NULL;
UPDATE AccountData SET Gender = 'Male',               Birthdate = '1995-11-05' WHERE AccountID = 15 AND Gender IS NULL;
UPDATE AccountData SET Gender = 'Female',             Birthdate = '1968-02-18' WHERE AccountID = 16 AND Gender IS NULL;
UPDATE AccountData SET Gender = 'Male',               Birthdate = '1988-09-30' WHERE AccountID = 17 AND Gender IS NULL;
UPDATE AccountData SET Gender = 'Female',             Birthdate = '1992-01-14' WHERE AccountID = 18 AND Gender IS NULL;
UPDATE AccountData SET Gender = 'Male',               Birthdate = '1970-04-25' WHERE AccountID = 19 AND Gender IS NULL;
UPDATE AccountData SET Gender = 'Female',             Birthdate = '1985-06-12' WHERE AccountID = 20 AND Gender IS NULL;
UPDATE AccountData SET Gender = 'Male',               Birthdate = '1978-08-07' WHERE AccountID = 21 AND Gender IS NULL;
UPDATE AccountData SET Gender = 'Female',             Birthdate = '1998-12-03' WHERE AccountID = 22 AND Gender IS NULL;
UPDATE AccountData SET Gender = 'Male',               Birthdate = '1983-03-19' WHERE AccountID = 23 AND Gender IS NULL;
UPDATE AccountData SET Gender = 'Female',             Birthdate = '1972-10-28' WHERE AccountID = 24 AND Gender IS NULL;
UPDATE AccountData SET Gender = 'Male',               Birthdate = '1990-07-11' WHERE AccountID = 25 AND Gender IS NULL;
UPDATE AccountData SET Gender = 'Female',             Birthdate = '1996-04-16' WHERE AccountID = 26 AND Gender IS NULL;
UPDATE AccountData SET Gender = 'Male',               Birthdate = '1965-11-22' WHERE AccountID = 27 AND Gender IS NULL;
UPDATE AccountData SET Gender = 'Female',             Birthdate = '1982-02-09' WHERE AccountID = 28 AND Gender IS NULL;
UPDATE AccountData SET Gender = 'Male',               Birthdate = '2000-05-30' WHERE AccountID = 29 AND Gender IS NULL;
UPDATE AccountData SET Gender = 'Non-binary',         Birthdate = '1977-08-14' WHERE AccountID = 30 AND Gender IS NULL;
UPDATE AccountData SET Gender = 'Male',               Birthdate = '1993-01-27' WHERE AccountID = 31 AND Gender IS NULL;
UPDATE AccountData SET Gender = 'Prefer Not to Say',  Birthdate = '1987-06-18' WHERE AccountID = 32 AND Gender IS NULL;
UPDATE AccountData SET Gender = 'Male',               Birthdate = '1974-09-03' WHERE AccountID = 33 AND Gender IS NULL;

-- HCPs and Researchers do not provide Gender or DOB — leave those NULL.
