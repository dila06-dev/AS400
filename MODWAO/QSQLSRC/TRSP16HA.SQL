-- Folgearbeiten für Datei Hamacher
-- Erstellt: SZ 31.07.2014 WAECO Sicherung in SPED24
INSERT INTO MODWAO/SPED24
       SELECT A.*,
       TIMESTAMP(GENERATE_UNIQUE())
       FROM MODWAO/SPED20 A;
