-- Health Tracking seed data — categories, metrics, and translations.
-- Tables are created in 01_create_database.sql.

-- ─────────────────────────────────────────────────────────────────────────────
-- 2. SEED: TrackingCategory
-- ─────────────────────────────────────────────────────────────────────────────

INSERT IGNORE INTO TrackingCategory (CategoryKey, DisplayName, DisplayOrder) VALUES
    ('physical_health',    'Physical Health',           0),
    ('mental_health',      'Mental Health',             1),
    ('nutrition',          'Nutrition & Food Security', 2),
    ('substance_use',      'Substance Use',             3),
    ('housing_stability',  'Housing Stability',         4),
    ('financial_stability','Financial Stability',       5),
    ('social_support',     'Social & Support',          6),
    ('healthcare_access',  'Healthcare Access',         7),
    ('daily_functioning',  'Daily Functioning',         8),
    ('goals_progress',     'Goals & Progress',          9);

-- ─────────────────────────────────────────────────────────────────────────────
-- 3. SEED: TrackingMetric  (CategoryID resolved by subquery on CategoryKey)
-- ─────────────────────────────────────────────────────────────────────────────

-- physical_health
INSERT IGNORE INTO TrackingMetric
    (CategoryID, MetricKey, DisplayName, MetricType, Unit, ScaleMin, ScaleMax, ChoiceOptions, Frequency, DisplayOrder, IsActive, IsBaseline)
VALUES
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'physical_health'),
     'self_rated_health', 'Self-Rated Health', 'scale', NULL, 1, 10, NULL, 'daily', 0, 1, 0),

    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'physical_health'),
     'sleep_hours', 'Hours of Sleep', 'number', 'hours', 1, 10, NULL, 'daily', 1, 1, 0),

    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'physical_health'),
     'sleep_quality', 'Sleep Quality', 'scale', NULL, 1, 10, NULL, 'daily', 2, 1, 0),

    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'physical_health'),
     'pain_level', 'Pain Level', 'scale', NULL, 0, 10, NULL, 'daily', 3, 1, 0),

    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'physical_health'),
     'medications_taken', 'Medications Taken as Prescribed', 'yesno', NULL, 1, 10, NULL, 'daily', 4, 1, 0),

    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'physical_health'),
     'er_visit', 'ER or Hospital Visit', 'yesno', NULL, 1, 10, NULL, 'weekly', 5, 1, 0);

-- mental_health
INSERT IGNORE INTO TrackingMetric
    (CategoryID, MetricKey, DisplayName, MetricType, Unit, ScaleMin, ScaleMax, ChoiceOptions, Frequency, DisplayOrder, IsActive, IsBaseline)
VALUES
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'mental_health'),
     'mood_score', 'Mood', 'scale', NULL, 1, 5, NULL, 'daily', 0, 1, 0),

    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'mental_health'),
     'anxiety_level', 'Anxiety Level', 'scale', NULL, 1, 10, NULL, 'daily', 1, 1, 0),

    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'mental_health'),
     'stress_level', 'Stress Level', 'scale', NULL, 1, 10, NULL, 'daily', 2, 1, 0),

    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'mental_health'),
     'feeling_safe', 'Feeling of Safety', 'scale', NULL, 1, 5, NULL, 'daily', 3, 1, 0),

    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'mental_health'),
     'hopefulness', 'Hopefulness', 'scale', NULL, 1, 5, NULL, 'weekly', 4, 1, 0);

-- nutrition
INSERT IGNORE INTO TrackingMetric
    (CategoryID, MetricKey, DisplayName, MetricType, Unit, ScaleMin, ScaleMax, ChoiceOptions, Frequency, DisplayOrder, IsActive, IsBaseline)
VALUES
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'nutrition'),
     'meals_today', 'Meals Eaten Today', 'number', 'meals', 1, 10, NULL, 'daily', 0, 1, 0),

    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'nutrition'),
     'food_access', 'Access to Food', 'scale', NULL, 1, 5, NULL, 'daily', 1, 1, 0),

    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'nutrition'),
     'water_intake', 'Glasses of Water', 'number', 'glasses', 1, 10, NULL, 'daily', 2, 1, 0);

-- substance_use
INSERT IGNORE INTO TrackingMetric
    (CategoryID, MetricKey, DisplayName, MetricType, Unit, ScaleMin, ScaleMax, ChoiceOptions, Frequency, DisplayOrder, IsActive, IsBaseline)
VALUES
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'substance_use'),
     'alcohol_units', 'Alcohol Units Consumed', 'number', 'units', 1, 10, NULL, 'daily', 0, 1, 0),

    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'substance_use'),
     'smoking', 'Smoked Today', 'yesno', NULL, 1, 10, NULL, 'daily', 1, 1, 0),

    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'substance_use'),
     'drug_use', 'Drug Use Today', 'yesno', NULL, 1, 10, NULL, 'daily', 2, 1, 0);

-- housing_stability
INSERT IGNORE INTO TrackingMetric
    (CategoryID, MetricKey, DisplayName, MetricType, Unit, ScaleMin, ScaleMax, ChoiceOptions, Frequency, DisplayOrder, IsActive, IsBaseline)
VALUES
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'housing_stability'),
     'housing_status', 'Current Housing Status', 'single_choice', NULL, 1, 10,
     '["Shelter","Transitional Housing","Permanent Housing","No Housing"]',
     'weekly', 0, 1, 0),

    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'housing_stability'),
     'housing_security', 'Feeling of Housing Security', 'scale', NULL, 1, 10, NULL, 'weekly', 1, 1, 0),

    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'housing_stability'),
     'days_housed', 'Days in Current Housing', 'number', 'days', 1, 10, NULL, 'weekly', 2, 1, 0);

-- financial_stability
INSERT IGNORE INTO TrackingMetric
    (CategoryID, MetricKey, DisplayName, MetricType, Unit, ScaleMin, ScaleMax, ChoiceOptions, Frequency, DisplayOrder, IsActive, IsBaseline)
VALUES
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'financial_stability'),
     'income_source', 'Current Income Source', 'single_choice', NULL, 1, 10,
     '["Employment","Government Benefits","No Income","Other"]',
     'monthly', 0, 1, 0),

    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'financial_stability'),
     'afford_essentials', 'Able to Afford Essentials', 'scale', NULL, 1, 5, NULL, 'weekly', 1, 1, 0);

-- social_support
INSERT IGNORE INTO TrackingMetric
    (CategoryID, MetricKey, DisplayName, MetricType, Unit, ScaleMin, ScaleMax, ChoiceOptions, Frequency, DisplayOrder, IsActive, IsBaseline)
VALUES
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'social_support'),
     'social_interactions', 'Social Interactions This Week', 'number', 'interactions', 1, 10, NULL, 'weekly', 0, 1, 0),

    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'social_support'),
     'support_access', 'Access to Support System', 'scale', NULL, 1, 5, NULL, 'weekly', 1, 1, 0);

-- healthcare_access
INSERT IGNORE INTO TrackingMetric
    (CategoryID, MetricKey, DisplayName, MetricType, Unit, ScaleMin, ScaleMax, ChoiceOptions, Frequency, DisplayOrder, IsActive, IsBaseline)
VALUES
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'healthcare_access'),
     'doctor_visit', 'Doctor or Clinic Visit', 'yesno', NULL, 1, 10, NULL, 'weekly', 0, 1, 0),

    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'healthcare_access'),
     'missed_appointment', 'Missed Appointment', 'yesno', NULL, 1, 10, NULL, 'weekly', 1, 1, 0),

    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'healthcare_access'),
     'medication_access', 'Able to Access Medications', 'yesno', NULL, 1, 10, NULL, 'weekly', 2, 1, 0);

-- daily_functioning
INSERT IGNORE INTO TrackingMetric
    (CategoryID, MetricKey, DisplayName, MetricType, Unit, ScaleMin, ScaleMax, ChoiceOptions, Frequency, DisplayOrder, IsActive, IsBaseline)
VALUES
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'daily_functioning'),
     'energy_level', 'Energy Level', 'scale', NULL, 1, 10, NULL, 'daily', 0, 1, 0),

    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'daily_functioning'),
     'task_completion', 'Ability to Complete Daily Tasks', 'scale', NULL, 1, 5, NULL, 'daily', 1, 1, 0),

    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'daily_functioning'),
     'exercise_minutes', 'Minutes of Physical Activity', 'number', 'minutes', 1, 10, NULL, 'daily', 2, 1, 0);

-- goals_progress
INSERT IGNORE INTO TrackingMetric
    (CategoryID, MetricKey, DisplayName, MetricType, Unit, ScaleMin, ScaleMax, ChoiceOptions, Frequency, DisplayOrder, IsActive, IsBaseline)
VALUES
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'goals_progress'),
     'goal_progress', 'Progress Toward Personal Goals', 'scale', NULL, 1, 10, NULL, 'weekly', 0, 1, 0),

    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'goals_progress'),
     'self_improvement', 'Self-Perceived Overall Improvement', 'scale', NULL, 1, 10, NULL, 'weekly', 1, 1, 0);

-- ─────────────────────────────────────────────────────────────────────────────
-- 4. SEED: TrackingCategoryTranslation — French (fr)
-- ─────────────────────────────────────────────────────────────────────────────

INSERT IGNORE INTO TrackingCategoryTranslation (CategoryID, LanguageCode, DisplayName) VALUES
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'physical_health'),    'fr', 'Santé Physique'),
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'mental_health'),      'fr', 'Santé Mentale'),
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'nutrition'),          'fr', 'Nutrition et Sécurité Alimentaire'),
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'substance_use'),      'fr', 'Consommation de Substances'),
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'housing_stability'),  'fr', 'Stabilité du Logement'),
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'financial_stability'),'fr', 'Stabilité Financière'),
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'social_support'),     'fr', 'Soutien Social'),
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'healthcare_access'),  'fr', 'Accès aux Soins de Santé'),
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'daily_functioning'),  'fr', 'Fonctionnement Quotidien'),
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'goals_progress'),     'fr', 'Objectifs et Progrès');

-- ─────────────────────────────────────────────────────────────────────────────
-- 5. SEED: TrackingCategoryTranslation — Spanish (es)
-- ─────────────────────────────────────────────────────────────────────────────

INSERT IGNORE INTO TrackingCategoryTranslation (CategoryID, LanguageCode, DisplayName) VALUES
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'physical_health'),    'es', 'Salud Física'),
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'mental_health'),      'es', 'Salud Mental'),
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'nutrition'),          'es', 'Nutrición y Seguridad Alimentaria'),
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'substance_use'),      'es', 'Uso de Sustancias'),
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'housing_stability'),  'es', 'Estabilidad de Vivienda'),
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'financial_stability'),'es', 'Estabilidad Financiera'),
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'social_support'),     'es', 'Apoyo Social'),
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'healthcare_access'),  'es', 'Acceso a la Atención Médica'),
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'daily_functioning'),  'es', 'Funcionamiento Diario'),
    ((SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = 'goals_progress'),     'es', 'Metas y Progreso');

-- ─────────────────────────────────────────────────────────────────────────────
-- 6. SEED: TrackingMetricTranslation — French (fr) for key metrics
-- ─────────────────────────────────────────────────────────────────────────────

INSERT IGNORE INTO TrackingMetricTranslation (MetricID, LanguageCode, DisplayName) VALUES
    -- physical_health
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'self_rated_health'),  'fr', 'Santé Auto-Évaluée'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'sleep_hours'),        'fr', 'Heures de Sommeil'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'sleep_quality'),      'fr', 'Qualité du Sommeil'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'pain_level'),         'fr', 'Niveau de Douleur'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'medications_taken'),  'fr', 'Médicaments Pris comme Prescrits'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'er_visit'),           'fr', 'Visite aux Urgences ou à l''Hôpital'),
    -- mental_health
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'mood_score'),         'fr', 'Humeur'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'anxiety_level'),      'fr', 'Niveau d''Anxiété'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'stress_level'),       'fr', 'Niveau de Stress'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'feeling_safe'),       'fr', 'Sentiment de Sécurité'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'hopefulness'),        'fr', 'Espoir'),
    -- nutrition
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'meals_today'),        'fr', 'Repas Mangés Aujourd''hui'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'food_access'),        'fr', 'Accès à la Nourriture'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'water_intake'),       'fr', 'Verres d''Eau'),
    -- housing_stability
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'housing_status'),     'fr', 'Situation de Logement Actuelle'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'housing_security'),   'fr', 'Sentiment de Sécurité du Logement'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'days_housed'),        'fr', 'Jours dans le Logement Actuel'),
    -- daily_functioning
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'energy_level'),       'fr', 'Niveau d''Énergie'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'task_completion'),    'fr', 'Capacité à Accomplir les Tâches Quotidiennes'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'exercise_minutes'),   'fr', 'Minutes d''Activité Physique'),
    -- goals_progress
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'goal_progress'),      'fr', 'Progrès vers les Objectifs Personnels'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'self_improvement'),   'fr', 'Amélioration Globale Auto-Perçue');

-- ─────────────────────────────────────────────────────────────────────────────
-- 7. SEED: TrackingMetricTranslation — Spanish (es) for key metrics
-- ─────────────────────────────────────────────────────────────────────────────

INSERT IGNORE INTO TrackingMetricTranslation (MetricID, LanguageCode, DisplayName) VALUES
    -- physical_health
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'self_rated_health'),  'es', 'Salud Auto-Evaluada'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'sleep_hours'),        'es', 'Horas de Sueño'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'sleep_quality'),      'es', 'Calidad del Sueño'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'pain_level'),         'es', 'Nivel de Dolor'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'medications_taken'),  'es', 'Medicamentos Tomados según lo Prescrito'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'er_visit'),           'es', 'Visita a Urgencias u Hospital'),
    -- mental_health
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'mood_score'),         'es', 'Estado de Ánimo'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'anxiety_level'),      'es', 'Nivel de Ansiedad'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'stress_level'),       'es', 'Nivel de Estrés'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'feeling_safe'),       'es', 'Sensación de Seguridad'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'hopefulness'),        'es', 'Esperanza'),
    -- nutrition
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'meals_today'),        'es', 'Comidas Consumidas Hoy'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'food_access'),        'es', 'Acceso a Alimentos'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'water_intake'),       'es', 'Vasos de Agua'),
    -- housing_stability
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'housing_status'),     'es', 'Situación de Vivienda Actual'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'housing_security'),   'es', 'Sensación de Seguridad en la Vivienda'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'days_housed'),        'es', 'Días en la Vivienda Actual'),
    -- daily_functioning
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'energy_level'),       'es', 'Nivel de Energía'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'task_completion'),    'es', 'Capacidad para Completar Tareas Diarias'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'exercise_minutes'),   'es', 'Minutos de Actividad Física'),
    -- goals_progress
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'goal_progress'),      'es', 'Progreso hacia Metas Personales'),
    ((SELECT MetricID FROM TrackingMetric WHERE MetricKey = 'self_improvement'),   'es', 'Mejora Global Auto-Percibida');
