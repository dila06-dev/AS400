-- Folgearbeiten für Datei trans-o-flex
-- Erstellt: SZ 31.07.2014 WAECO Sicherung in SPED34

INSERT INTO MODWAO/SPED34
       SELECT A.*,
       TIMESTAMP(GENERATE_UNIQUE())
       FROM MODWAO/SPED30 A;
