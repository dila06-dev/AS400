-- Folgearbeiten für Datei PartsExpress
-- Erstellt: SZ 31.07.2014 WAECO Sicherung in SPED14

INSERT INTO MODWAO/SPED14
       SELECT A.*,
       TIMESTAMP(GENERATE_UNIQUE())
       FROM MODWAO/SPED10 A;
