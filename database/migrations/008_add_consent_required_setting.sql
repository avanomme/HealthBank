-- Migration 008: Add consent_required system setting
-- Adds a toggle that lets admins disable the consent requirement
-- (e.g. for jurisdictions where it is not required).
-- Default is true — existing behaviour is preserved.

INSERT IGNORE INTO SystemSettings (SettingKey, SettingValue, Description)
VALUES ('consent_required', 'true',
        'Whether users must sign the consent form before accessing the app. Default: true.');
