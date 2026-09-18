-- Folgearbeiten für Datei NightStar
-- Erstellt: SZ 31.07.2014 WAECO Sicherung in SPEDC4

INSERT INTO MODWAO/SPEDC4
       SELECT A.*,
       TIMESTAMP(GENERATE_UNIQUE())
       FROM MODWAO/SPEDC0 A;
