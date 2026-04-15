-- Migration 010: Set k_anonymity_threshold default to 1.
-- Previously seeded as 5 (init) and overridden to 3 (dev init).
-- The admin can raise this value in Admin → Settings at any time.
UPDATE SystemSettings
SET    SettingValue = '1'
WHERE  SettingKey   = 'k_anonymity_threshold'
  AND  SettingValue IN ('3', '5');
