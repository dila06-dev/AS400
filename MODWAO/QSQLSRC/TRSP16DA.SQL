-- Folgearbeiten für Datei Dachser
-- Erstellt: SZ 06.08.2014 WAECO Sicherung in SPED84

INSERT INTO MODWAO/SPED84
       SELECT A.*,
       TIMESTAMP(GENERATE_UNIQUE())
       FROM MODWAO/SPED80 A;
