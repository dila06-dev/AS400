-- Folgearbeiten für Datei GLS
-- Erstellt: SZ 31.07.2014 WAECO Sicherung in SPED44

INSERT INTO MODWAO/SPED44
       SELECT A.*,
       TIMESTAMP(GENERATE_UNIQUE())
       FROM MODWAO/SPED40 A;
