-- Folgearbeiten für Datei BRT Italien
-- Erstellt: SZ 20.12.2012 WAECO Projekt 9128
-- Änderung: SZ 31.07.2014 WAECO Sicherung in SPEDH4
-- Änderung:
DELETE FROM MODWAO/SPEDH0
       WHERE SUBSTR(BRT010, 1, 1) = 'S' AND
       BRT520 = 'J' OR
       SUBSTR(BRT010, 1, 1) = 'P' AND
       BRT520 = 'J';

INSERT INTO MODWAO/SPEDH4
       SELECT A.*,
       TIMESTAMP(GENERATE_UNIQUE())
       FROM MODWAO/SPEDH0 A;
