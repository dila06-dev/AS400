-- Folgearbeiten für Datei Schenker
-- Erstellt: SZ 26.05.2012 WAECO Projekt 8390
-- Änderung:
DELETE FROM MODWAO/SPEDG0
       WHERE SUBSTR(SC2010, 1, 1) = 'S' AND
       SC2520 = 'J' OR
       SUBSTR(SC2010, 1, 1) = 'P' AND
       SC2520 = 'J';
