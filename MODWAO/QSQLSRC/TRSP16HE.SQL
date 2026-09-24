-- Folgearbeiten für Datei Hellmann
-- Erstellt: SZ 31.07.2014 WAECO Sicherung in SPED04

INSERT INTO MODWAO/SPED04
       SELECT A.*,
       TIMESTAMP(GENERATE_UNIQUE())
       FROM MODWAO/SPED00 A;
