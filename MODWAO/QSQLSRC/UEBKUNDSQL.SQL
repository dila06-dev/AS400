-- FOLGEARBEITEN FÜR UEBKUND
-- ERSTELLT: RH 16.11.2010 KUNDE WAECO PROJEKT 6883
-- ÄNDERUNG: SZ 14.12.2010 D - F OHNE ERWEITERUNG
UPDATE KUND
SET    KDKSTC =
         COALESCE(
           (SELECT MAX(SUBSTR(SALESAREA, 1, 1)
                       CONCAT '0' CONCAT
                       SUBSTR(SALESAREA, 2, 1))
            FROM   SBGKDS00CU
            WHERE  KDS010 = 01
              AND  ('0' CONCAT DIGITS(KDS020)) = KDKDNR
              AND  SUBSTR(SALESAREA, 1, 1) BETWEEN 'A' AND 'Z'
              AND  SUBSTR(SALESAREA, 2, 1) BETWEEN '0' AND '9'),
         '   ');
UPDATE KUND
SET    KDKSTC =
         COALESCE(
           (SELECT MAX(SUBSTR(SALESAREA, 1, 1)
                       CONCAT '01')
            FROM   SBGKDS00CU
            WHERE  KDS010 = 01
              AND  ('0' CONCAT DIGITS(KDS020)) = KDKDNR
              AND  SUBSTR(SALESAREA, 1, 1) BETWEEN 'D' AND 'F'
              AND  SUBSTR(SALESAREA, 2, 2) = '  '),
         '   ') WHERE KDKSTC = ' ';
UPDATE KUND SET KDSPCD = 'E' WHERE KDFIRM='01' AND KDSPCD NOT IN
('D', 'E');
