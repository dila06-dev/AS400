--  ----------------------------------------------------------------------------
--  Copyright 2022 by    trend SWM
--                       Verwaltung GmbH
--                       Jechtinger Straße 9
--                       DE 79111 Freiburg
--  ----------------------------------------------------------------------------
--  View offene Auslagerungen
--  ----------------------------------------------------------------------------
--  Erstellt: SZ 30.11.2022
--
--  ----------------------------------------------------------------------------
     CREATE OR REPLACE VIEW LBAPVW01
       (LBAPFIRM,
       LBAPKMJJ,
       LBAPKMNR,
       LBAPKMPO,
       LBAPAFJJ,
       LBAPAFNR,
       LBAPAFPO,
       LBAPTENR,
       TEEWSKUN,
       AMKMDA,
       AMKDNR,
       AMNAM1,
       AMNAM2,
       AMNAM3,
       AMSTRA,
       AMPOLD,
       AMPOLZ,
       AMWORT,
       AMLAND,
       AMWKNR,
       AMLFTE)
     AS SELECT
       LBAPFIRM,
       LBAPKMJJ,
       LBAPKMNR,
       LBAPKMPO,
       LBAPAFJJ,
       LBAPAFNR,
       LBAPAFPO,
       LBAPTENR,
       TEEWSKUN,
       AMKMDA,
       AMKDNR,
       AMNAM1,
       AMNAM2,
       AMNAM3,
       AMSTRA,
       AMPOLD,
       AMPOLZ,
       AMWORT,
       AMLAND,
       AMWKNR,
       AMLFTE
     FROM LBAP
     INNER JOIN AFKM
        ON LBAPFIRM = AMFIRM
        AND LBAPKMJJ = AMKMJJ
        AND LBAPKMNR = AMKMNR
     LEFT JOIN TEEW
        ON LBAPFIRM = TEEWFIRM
        AND LBAPTENR = TEEWTENR
     WHERE LBAPFIRM = '01'
       AND LBAPDANA = 'AFKM'
       AND LBAPSTAT = '00'
