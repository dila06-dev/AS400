-- Folgearbeiten für Datei TNT Innight
-- Erstellt: SZ 14.03.2013 WAECO Projekt 8997
-- Änderung: SZ 31.07.2014 WAECO Sicherung in SPEDI4
-- Änderung:

INSERT INTO MODWAO/SPEDI4
       SELECT A.*,
       TIMESTAMP(GENERATE_UNIQUE())
       FROM MODWAO/SPEDI0 A;

DELETE FROM MODWAO/SPEDI0
       WHERE SUBSTR(TNT010, 1, 1) = 'S' AND
       TNT520 = 'J' OR
       SUBSTR(TNT010, 1, 1) = 'P' AND
       TNT520 = 'J';
