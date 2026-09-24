-- Folgearbeiten für Datei Loxx
-- Erstellt: SZ 29.04.2013 WAECO Projekt 9228
-- Änderung: SZ 31.07.2014 WAECO Sicherung in SPEDK4

INSERT INTO MODWAO/SPEDK4
       SELECT A.*,
       TIMESTAMP(GENERATE_UNIQUE())
       FROM MODWAO/SPEDK0 A;

DELETE FROM MODWAO/SPEDK0
       WHERE SUBSTR(LOX010, 1, 1) = 'S' AND
       LOX520 = 'J' OR
       SUBSTR(LOX010, 1, 1) = 'P' AND
       LOX520 = 'J';
