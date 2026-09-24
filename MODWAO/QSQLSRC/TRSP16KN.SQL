-- Folgearbeiten für Datei Kühne + Nagel
-- Erstellt: SZ 17.02.2012 WAECO Projekt 8260
-- Änderung: SZ 08.05.2012 WAECO Projekt 8354
DELETE FROM MODWAO/SPEDF0
       WHERE SUBSTR(KUN010, 1, 1) = 'K' AND
       KUN520 = 'J' OR
       SUBSTR(KUN010, 1, 1) = 'P' AND
       KUN520 = 'J';
