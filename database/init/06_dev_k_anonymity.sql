-- dev environment: k-anonymity threshold set to 1 so all seed data is visible
UPDATE SystemSettings
SET    SettingValue = '1'
WHERE  SettingKey   = 'k_anonymity_threshold';
