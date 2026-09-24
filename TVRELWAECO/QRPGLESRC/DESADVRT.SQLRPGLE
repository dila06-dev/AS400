      //***********************************************************************
      //
      //      >>> WICHTIG: TEST-Umgebung !!! <<<
      //
      //     Programmname       DESADVRT
      //     Erstellt  am       08.10.2025
      //     Erstellt von       M.Gang / D.Langlitz
      //
      //     Beschreibung       Verarbeitung DESADV-Bestandsmeldungen
      //                         - relevante DESADV-Header (100er) laden
      //                         - Ladungsträger/NVE pro Lieferschein ermitteln
      //                         - neue 150/157-Segmente je NVE erzeugen
      //                         - alte 150/157-Segmente mit Status 'S ' mark.
      //                         - Lieferschein-Header auf Status 'M ' setzen
      //
      //     Status-Kennzeichen (SCDDAT):
      //       'S ' = zum Löschen markiert (alte 150/157-Segmente)
      //       'M ' = modifiziert (Header 100er nach Neuberechnung)
      //       '  ' = unverändert / Ausgangszustand
      //
      //     Datenkontrolle      DESADVR30T (Steuerdatei) / DESADVNVET (NVE)
      //                         prüfen auf Dubletten und inhaltliche Konsist.
      //***********************************************************************
      // Übersetzungshinweise:
      // - Programm läuft vollautomatisch im Batch-Modus
      // - schreibt Verarbeitungsprotokoll via DUMMY512 in JOB_RUN
      // - verarbeitet gruppiert nach Lieferschein (MAIKEY)
      // - markiert alte Segmente mit 'S ' zur späteren Löschung
      //
      // Beteiligte Prozeduren (DESADV-Schnittstelle für STDDAT Strukturen):
      // - PDESADV150  Erzeugt neue 150er-Segmente (Packmittel/Ladungseinheit)
      // - PDESADV157  Erzeugt neue 157er-Segmente (NVE-Artikel-Details)
      //
      // Beteiligte Dateien:
      // - EDIFACTT/STDDAT         (Quell-DESADV-Sätze, Original)
      // - TVRELWAECO/DESADVR30T  (Kontroll-Steuerdatei pro Lieferschein)
      // - TVRELWAECO/DESADVNVET   (Arbeits-Datei für Packmittel/NVE)
      // - DOMDATV7/PSAVEAK       (Rückmeldung Auftragskopf: KOM-Schein-Nr.)
      // - DOMDATV7/PPAKET        (Verpackungsdaten nach Artikel)
      // - TVPF/AFLP01            (Auftragspositionen)
      //***********************************************************************
      // Debug-Hilfe (SQL-Abfragen für Kontrolle):
      //  select * from tvrelwaeco/DESADVR30T  -- Steuer-Status pro LS
      //  select * from tvrelwaeco/DESADVNVET   -- aktuelle NVE-Sätze
      //-----------------------------------------------------------------------
      // CHANGE LOG:
      // - Langlitz D.  04.12.2025  - Anpassung der PRTNUM Filterkriterien
      // - Aktuell nur für Tradeinn / DAF Lieferscheine
      //
      //-----------------------------------------------------------------------

      //-----------------------------------------------------------------------
      //   S T E U E R - B E S T I M M U N G E N
      //-----------------------------------------------------------------------

     h datfmt(*EUR)
     h datedit(*DMY.)
     h timfmt(*HMS:)
     h decedit('0,')
     h langid('DE')
     h option(*SRCSTMT:*NoDebugIO)
     h dftactgrp(*NO) actgrp(*CALLER)

      //-----------------------------------------------------------------------
      //   D A T E I - D E F I N I T I O N E N
      //-----------------------------------------------------------------------

     fDESADVR30Tuf   e           k DISK    usropn
     f                                     RENAME(DESADVR30T:PHY01R)
     fDESADVNVETuf   e           k DISK    usropn
     f                                     RENAME(DESADVNVET:PHY02R)

      /eject
      //-----------------------------------------------------------------------
      //   D A T E N S T R U K T U R E N
      //-----------------------------------------------------------------------

      // Program Status Data Structure (Job-, User-, Programm-Infos)
     d DSPGM          SDS
     d  §§§PGM                 1     10
     d  §§§STS                11     15
     d  §§§SEQ                21     28
     d  §§§SR                 29     36
     d  §§§MSG                40     46
     d  §§§LIB                81     90
     d  §§§MTX                91    170
     d  §§§FIL               201    208
     d  §§§FST               209    243
     d  §§§JOB               244    253
     d  §§§USR               254    263
     d  §§§JNO               264    269  0
     d  §§§SDT               276    281  0
     d  §§§STM               282    287  0

      // Diverse, historisch genutzte Arbeits-Arrays (z. T. ungenutzt)
     D MD#2            S              1    DIM(512)
     D ATR             S              1    DIM(63)
     D ATTS            S              1    DIM(1)
     D ATTK            S              1    DIM(1)
     D ATTO            S              1    DIM(1)
     D KEY             S              2    DIM(24)
     D FKTTST          S              1    DIM(6)

       // -----------------------------------------------------------------
       // qmhsndpm  generische Message-Send-Routine (zurzeit ungenutzt)
       // -----------------------------------------------------------------
     D QMHSNDPM        PR                  ExtPgm('QMHSNDPM')
     D   MessageID                    7A   Const
     D   QualMsgF                    20A   Const
     D   MsgData                    256A   Const
     D   MsgDtaLen                   10I 0 Const
     D   MsgType                     10A   Const
     D   CallStkEnt                  10A   Const
     D   CallStkCnt                  10I 0 Const
     D   MessageKey                   4A
     D   ErrorCode                    1A

       // -----------------------------------------------------------------
       // DUMMY512  schreibt Protokolle in Datei JOB_RUN in TVRELWAECO
       // -----------------------------------------------------------------
     D DUMMY512        PR                  ExtPgm('DUMMY512')
     D p_md                         256a
     D p_MSG                          7a
     D p_MSGF                        10a
     D p_PRINT                       10a
     D p_OUTFIL                      10a
     D p_LIB                         10a
     D P_REPADD                      10a

       // -----------------------------------------------------------------
       // PDESADV  generische DESADV-Schnittstelle (Prototyp, Infozwecke)
       // -----------------------------------------------------------------
     D PDESADV         PR                  ExtPgm('PDESADV')
     D pLiefNr                       10a
     D pPKIDEN                       15a
     D pDatum                         8a
     D pPKVENR                       14a
     D pPKPMEN                        7p 3
     D pPKPTYP                        3a
     D pUPDATE                        1S 0

       // -----------------------------------------------------------------
       // Externe Dateistrukturen (ExtName)
       // -----------------------------------------------------------------
     d DESADVR30T_i  e ds                  ExtName(DESADVR30T:*input)
     d                                     Qualified

     d DESADVR30T_o  E DS                  ExtName(DESADVR30T:*output)
     d                                     Qualified

     d DESADVR30T_k  E DS                  ExtName(DESADVR30T:*key)
     d                                     Qualified

     d DESADVNVET_i  e ds                  ExtName(DESADVNVET:*input)
     d                                     Qualified

     d DESADVNVET_o  e ds                  ExtName(DESADVNVET:*output)
     d                                     Qualified

      //-----------------------------------------------------------------------
      //   V A R I A B L E N  /  QCMDEXC
      //-----------------------------------------------------------------------

     D Wrk             DS                  Qualified inz
     D Var1                         460A   inz(' ')
     D L               s              9  0

     D QCMDEXC         PR                  ExtPgm('QCMDEXC')
     D cmd                        32702A   const options(*varsize)
     D len                           15P 5 const

     D cmd             s            460A   varying

      // Parameter für DUMMY512 (Protokoll)
     D p_md            s            256a   inz
     D p_MSG           s              7a   inz
     D p_MSGF          s             10a   inz
     D p_PRINT         s             10a   inz
     D p_OUTFIL        s             10a   inz
     D p_LIB           s             10a   inz
     D P_REPADD        s             10a   inz

      // Message-Variablen (QMHSNDPM  derzeit nicht verwendet)
     D MessageID       s              7A   inz
     D QualMsgF        s             20A   inz
     D MsgData         s            256A   inz
     D MsgDtaLen       s             10I 0 inz
     D MsgType         s             10A   inz

      // PDESADV-Parameter als Arbeitsvariablen
     D pLiefNr         s             35a   inz
     D pPKIDEN         s             35a   inz
     D pDatum          s              8a   inz
     D lastDatum       s              8a   inz
     D pPKVENR         s             70a   inz
     D pPKPMEN         s              7p 3 inz
     D pPKPTYP         s              3a   inz
     D pUPDATE         s              1S 0 inz


      // interne Steuer- / Log-Variablen
     D status          s            132A   inz
     D breakpoint      s              1a   inz
     D err_msg         s              1a   inz
     D week            s              1s 0 inz
     d NumSysTime      s              6s 0
     d myDate          s               d

     D suffix          s             06A   inz
     D transfer        s             30A   inz
     D string_file     s             60A   inz
     D years           s              4s 0 inz
     D §ENTRY#         s             11A   inz
     D §rkreda         s              8s 0 inz
     D §rplipo         s              4a   inz
     D §rkkon          s             10a   inz
     D §rpnesu         s             13s 2 inz
     D §§rpnesu        s             13s 2 inz
     D §upload         s            256a   inz
     D §monat          s              2s 0 inz
     D §search         s              1a   inz
     D §string         s            100a   inz
     D §replace        s              1a   inz
     D §pos            s              3s 0 inz
     D §records        s              9s 0 inz
     D §text           s             48a   inz
     D §SNDREC         s              3a   inz
     D §PRTNUM         s             35a   inz
     D §MSGTYP         s              6a   inz
     D §MAIKEY         s             35a   inz
     D §HRCLVL         s              9a   inz
     D §LINNUM         s              6s 0 inz

      // Arbeitsvariablen zur Steuerung der DESADV-Verarbeitung
      //------------------------------------------------------------------
      // Letzte Lieferscheinnummer (für Gruppenwechsel)
     d lastLiefNr      s             10a   inz
     d currLiefNr      s             10a   inz
      // Letzte NVE / Verpackungsnummer
     d lastPKVENR      s             20a   inz
      // Laufende LINNUM (wird hochgezählt)
     d lnumCount       s              6s 0 inz
     d lnumPosPk       s              6s 0 inz
      // Flags Reserven
     d firstForCombo   s               n   inz(*on)
     d firstRun        s               n   inz(*on)

      // Input-Spezifikation: Status-Feld ins §status laden
     IPHY01R
     I              status                      §status
      /eject

      /eject
      //***********************************************************************
      //         -----------------
      //         M A I N - L I N E
      //         -----------------
      //***********************************************************************

      /FREE
       // Startmeldung ins Protokoll
       status = 'Start FTP Transfer for DESADVR      ';
       exsr  SR_log;

       // Hauptlogik: Aufbau Steuerdatei + NVE-Datei und Verarbeitung
       exsr sr_DESADV;

       // DESADVR30T einmalig öffnen/schließen (z. B. Trigger / Commit)
       open  DESADVR30T;
       close DESADVR30T;

       // Joblog als Spoolfile ausgeben
       monitor;
         Wrk.var1 = 'DSPJOBLOG OUTPUT(*PRINT) ';
         cmd     = %TrimR(Wrk.Var1);
         l       = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status = 'error in DSPJOBLOG OUTPUT(*PRINT)';
          exsr SR_log;
       endmon;

       // Endemeldung ins Protokoll
       status = 'Ende  FTP Transfer for DESADVR      ';
       exsr  SR_log;

       *inlr = *on;

      /eject
       //*******************************************************************
       //   S U B R O U T I N E S
       //*******************************************************************
       // srinit            : Initialisierung / SQL-Handler
       // sr_DESADV         : Aufbau Steuerdatei + NVE-Datei
       // SR_log            : Schreiben eines Logeintrages
       // PROCESS_DESADV_NVE: Erzeugen der 150/157-Segmente je NVE
       //*******************************************************************

       //==================================================================
       // SRINIT
       //  - Initialisiert globale Variablen
       //  - Setzt SQL-Error-Handling auf CONTINUE
       //==================================================================
       begsr srinit;

         clear Wrk.var1;
         clear status;
         err_msg = ' ';

         // SQL-Fehlerbehandlung: Programm läuft weiter, keine Ausnahmen
         exec sql
              whenever not found CONTINUE;
         exec sql
              WHENEVER SQLWARNING CONTINUE;
         exec sql
              WHENEVER SQLERROR  CONTINUE;

       endsr;

       //------------------------------------------------------------------
       // SR_DESADV
       //  - Befüllt DESADVR30T (Steuerdatei) aus EDIFACTT/STDDAT
       //  - Befüllt DESADVNVET (Arbeitsdatei) aus PSAVEAK/PPAKET/AFLP01
       //  - Ruft PROCESS_DESADV_NVE auf (Erzeugung 150/157)
       //------------------------------------------------------------------
       begsr sr_DESADV;

       //, Bypass die Lieferscheine aufhalten, die noch nicht abgeschlossen worden sind

       // Sätze für zusätzliche NVE auf Ebene Artikel / Verpackung
       exec sql
          insert into tvrelwaeco.DESADVR30T
          SELECT a.SNDREC,
                 a.PRTNUM,
                 a.MSGTYP,
                 a.MAIKEY,
                 dec(substr(WRTDAT, 1, 4), 4, 0) LJahr,
                 a.HRCLVL,
                 a.LINNUM,
                 dec(count(*), 10) anzahl,
                 char('  ', 2) status,
                 char('HRCLVLZUAB', 10) errortyp,
                 current timestamp as tstamp
            FROM  EDIFACTT.stddat a
            WHERE HRCLVL ='100000000' and MSGTYP ='DESADV' and
                ( PRTNUM like 'TRADEINN_LIEFERSCHEIN%' or
                  PRTNUM like 'DAF_LIEFERSCHEIN%' or
                  PRTNUM like 'MM_LIEFERSCHEIN%' or
                  PRTNUM like 'GALAXUS_LIEFERSCHEIN%' or
                  PRTNUM like 'NEUKUNDE_ABC%'
                 )
             and dec(substr(WRTDAT, 1, 4), 4, 0) > 2025
             // Nur Sätze ab dem 04.12.2024 berücksichtigen (Startpunkt) !!!
             and WRTDAT > 20260210
             and a.MAIKEY not in (
                  select b.MAIKEY
                    from tvrelwaeco.DESADVR30T b
                   where a.MSGTYP = b.MSGTYP
                 )
           GROUP BY SNDREC, PRTNUM, MSGTYP, MAIKEY, HRCLVL, LINNUM,
                    dec(substr(WRTDAT, 1, 4), 4, 0);

       // Ladungsträger / NVE in Arbeitsdatei DESADVNVET schreiben
       exec sql
         insert into tvrelwaeco.DESADVNVET
              WITH LMAP AS (
                SELECT
                  l.*,
                  // Reverse LS: if AFLP01 already contains the NEW delivery note,
                  // take the ORIGINAL LS from mapping (BEALBZLI).
                  COALESCE(
                    NULLIF(TRIM(CHAR(b_ls_rev.BEALBZLI)), ''),
                    TRIM(CHAR(l.ALLINR))
                  ) AS ALLINR_ORIG,
                  // Forward LS: if AFLP01 contains the ORIGINAL delivery note,
                  // take the NEW LS from mapping (BEALLINR).
                  COALESCE(
                    NULLIF(TRIM(CHAR(b_ls_fwd.BEALLINR)), ''),
                    TRIM(CHAR(l.ALLINR))
                  ) AS ALLINR_FINAL,
                  // Reverse KOMM: if AFLP01 already contains the NEW commission number,
                  // take the ORIGINAL KOMM from mapping (BEALBZKM).
                  COALESCE(
                    NULLIF(TRIM(CHAR(b_km_rev.BEALBZKM)), ''),
                    TRIM(CHAR(l.ALKMNR))
                  ) AS KMNR_ORIG,
                  // Forward KOMM: if AFLP01 contains the ORIGINAL commission number,
                  // take the NEW KOMM from mapping (BEALKMNR).
                  COALESCE(
                    NULLIF(TRIM(CHAR(b_km_fwd.BEALKMNR)), ''),
                    TRIM(CHAR(l.ALKMNR))
                  ) AS KMNR_FINAL,
                  // Flags: mapping exists (either forward or reverse hit).
                  CASE
                    WHEN b_ls_fwd.BEALLINR IS NOT NULL
                      OR b_ls_rev.BEALBZLI IS NOT NULL
                    THEN 1 ELSE 0
                  END AS HAS_LS_MAP,
                  CASE
                    WHEN b_km_fwd.BEALKMNR IS NOT NULL
                      OR b_km_rev.BEALBZKM IS NOT NULL
                    THEN 1 ELSE 0
                  END AS HAS_KM_MAP
                FROM tvpf.aflp01 l
                // LS Forward: ORIGINAL -> NEW
                LEFT JOIN tvpf.beal01 b_ls_fwd
                  ON  b_ls_fwd.BEALBZFI = l.ALFIRM
                  AND b_ls_fwd.BEALBZLJ = l.ALAFJJ
                  AND b_ls_fwd.BEALBZLI = l.ALLINR
                // LS Reverse: NEW -> ORIGINAL
                LEFT JOIN tvpf.beal01 b_ls_rev
                  ON  b_ls_rev.BEALBZFI = l.ALFIRM
                  AND b_ls_rev.BEALLIJJ = l.ALAFJJ
                  AND b_ls_rev.BEALLINR = l.ALLINR
                // KOMM Forward: ORIGINAL -> NEW
                LEFT JOIN tvpf.beal01 b_km_fwd
                  ON  b_km_fwd.BEALBZFI = l.ALFIRM
                  AND b_km_fwd.BEALBZKJ = l.ALKMJJ
                  AND b_km_fwd.BEALBZKM = l.ALKMNR
                // KOMM Reverse: NEW -> ORIGINAL
                LEFT JOIN tvpf.beal01 b_km_rev
                  ON  b_km_rev.BEALBZFI = l.ALFIRM
                  AND b_km_rev.BEALKMJJ = l.ALKMJJ
                  AND b_km_rev.BEALKMNR = l.ALKMNR
                WHERE l.ALLIJJ = '2026'
              )
              SELECT
                  p.PKIDEN,
                  p.PKMPKN,
                  p.PKPKNR,
                  CASE
                  WHEN p.PKVART IN ('220','068', '221')
                    // Fuer Dachser komplette Nummer
                    // ohne 2 fuehrende Nullen uebernehmen
                    THEN SUBSTR(p.PKVENR, 3, 18)
                    // Fuer DPD ab Stelle 9, max. 14 Zeichen
                    ELSE SUBSTR(p.PKVENR, 9, 14)
                  END AS PKVENR,
                  SUM(p.PKPMEN) AS PKPMEN,
                  p.PKANRP,
                  l.ALAFNR,
                  l.ALKMJJ,
                  l.ALKMNR,
                  l.ALKMPO,
                  l.ALLIJJ,
                  // Output: show ORIGINAL vs FINAL (after mapping).
                  l.ALLINR_ORIG AS ALLINR,
                  // l.ALLINR_FINAL,
                  // l.KMNR_ORIG,
                  // l.KMNR_FINAL,
                  // l.HAS_LS_MAP,
                  // l.HAS_KM_MAP,
                  l.ALLIPO,
                  CHAR('  ', 2) AS statusNVE,
                  CURRENT TIMESTAMP AS tstamp,
                  COALESCE(h.PKPTYP, 'CT ') AS PKPTYP
              FROM DOMDATV7.ppaket p
              JOIN DOMDATV7.psaveak vs
                ON  vs.AKFIRM = p.PKFIRM
                AND vs.AKAPN  = p.PKAPN
              JOIN LMAP l
                ON  p.PKANRP = l.ALKMPO
                AND p.PKIDEN = l.ALTENR
                AND p.PKKDNR = l.ALKDNR
                // STATUS check if shipment has been completed
                AND ((vs.AKPSTS = '49' AND vs.AKDTL > 0)
                  OR (vs.AKPSTS = '44' AND p.PKDTB > 0))
                // p.PKANR1 can be built with OLD or NEW KOMM -> allow both.
                AND p.PKANR1 IN (
                      ('K01' CONCAT l.ALKMJJ CONCAT l.KMNR_ORIG),
                      ('K01' CONCAT l.ALKMJJ CONCAT l.KMNR_FINAL)
                    )
                LEFT JOIN DOMDATV7.ppaket h
                   ON  p.PKVENR = h.PKVENR
                     AND p.PKKDNR = h.PKKDNR
                     AND p.PKFIRM = h.PKFIRM
                     AND p.PKVART = h.PKVART
                     AND p.PKANR1 = h.PKANR1
                WHERE TRIM(p.PKIDEN) <> ''
                    AND l.ALAFJJ = '2026'
                    AND l.ALFIRM = '01'
                    AND h.PKPTYP <> ' '
                // Consider new stddat records
                AND EXISTS (
                  SELECT 1
                  FROM tvrelwaeco.DESADVR30T d
                  WHERE d.MAIKEY = l.ALLINR_ORIG
                    AND d.status = '  '
                    AND d.lJahr  = l.ALLIJJ
                )
                // Optional: only rows where mapping exists.
                // AND (l.HAS_LS_MAP = 1 OR l.HAS_KM_MAP = 1)
                // Optional: test on a specific (current/new) LS in AFLP01.
                // AND TRIM(CHAR(l.ALLINR)) = '411178'
                // Optional: Dachser-specific notes (activate if needed):
                // AND p.PKVART = '220'
                // PKVENR is built with SUBSTR(p.PKVENR, 9, 14)
                // AND p.PKTOUR IN ('DACHSE', 'DAF')
              GROUP BY
                  p.PKIDEN,
                  p.PKMPKN,
                  p.PKPKNR,
                  p.PKVENR,
                  p.PKANRP,
                  l.ALAFNR,
                  l.ALKMJJ,
                  l.ALKMNR,
                  l.ALKMPO,
                  l.ALLIJJ,
                  l.ALLINR_ORIG,
                  l.ALLINR_FINAL,
                  l.KMNR_ORIG,
                  l.KMNR_FINAL,
                  l.HAS_LS_MAP,
                  l.HAS_KM_MAP,
                  l.ALLIPO,
                  p.PKVART,
                  h.PKPTYP
              ORDER BY
                  tstamp,
                  l.ALLIJJ,
                  l.ALLINR_ORIG,
                  PKVENR,
                  PKIDEN;

        //¦ 1) DESADV-Header (100er) auf 'NF' = Nicht fertig setzen,
        //¦    wenn KEIN Packmittel/NVE in DESADVNVET vorhanden ist.
        //¦    Nur für Datensätze, die in DESADVR30T (Steuerdatei) vorhanden sind.
        exec sql
          UPDATE edifactt.stddat a
             SET a.scddat = 'NF'
           WHERE a.hrclvl = '100000000'
             AND a.msgtyp = 'DESADV'
             AND a.scddat NOT IN ('Yce', 'M ')
             AND EXISTS (
                   SELECT 1
                     FROM tvrelwaeco.DESADVR30T d
                    WHERE d.maikey = a.maikey
                      AND d.msgtyp = a.msgtyp
                      AND d.ljahr  = DEC(SUBSTR(a.wrtdat, 1, 4), 4, 0)
                 )
             AND NOT EXISTS (
                   SELECT 1
                     FROM tvrelwaeco.DESADVNVET b
                    WHERE b.allinr = a.maikey
                      AND DEC(SUBSTR(a.wrtdat, 1, 4), 4, 0) = b.ALKMJJ
                 )
        ;

        //¦ 2) DESADV-Header wieder auf R = Resend setzen,
        //¦    wenn Packmittel/NVE in DESADVNVET vorhanden ist.
        //¦    Ebenfalls nur für Datensätze aus DESADVR30T.
        exec sql
          UPDATE edifactt.stddat a
             SET a.scddat = 'R'
           WHERE a.hrclvl = '100000000'
             AND a.msgtyp = 'DESADV'
             AND a.scddat = 'NF'
             AND EXISTS (
                   SELECT 1
                     FROM tvrelwaeco.DESADVR30T d
                    WHERE d.maikey = a.maikey
                      AND d.msgtyp = a.msgtyp
                      AND d.ljahr  = DEC(SUBSTR(a.wrtdat, 1, 4), 4, 0)
                 )
             AND EXISTS (
                   SELECT 1
                     FROM tvrelwaeco.DESADVNVET b
                    WHERE b.allinr = a.maikey
                      AND DEC(SUBSTR(a.wrtdat, 1, 4), 4, 0) = b.ALKMJJ
                 )
        ;

        //¦ 3) WRTDAT auf Tagesdatum setzen (YYYYMMDD),
        //¦    für ALLE Positionen (alle HRCLVL) der jeweiligen Nachricht.
        //¦    Voraussetzung: Der 100er-Header derselben Nachricht
        //¦    wurde in Schritt 2
        //¦    bereits auf R = Resend freigegeben.
        //¦    Schlüssel für "dieselbe Nachricht": MAIKEY + altes WRTDAT.
        exec sql
          UPDATE edifactt.stddat a
             SET a.wrtdat = VARCHAR_FORMAT(CURRENT DATE, 'YYYYMMDD')
           WHERE a.msgtyp = 'DESADV'
             AND EXISTS (
             SELECT 1
             FROM edifactt.stddat h
              WHERE h.maikey = a.maikey
              AND h.msgtyp = a.msgtyp
              AND h.wrtdat = a.wrtdat
              AND h.hrclvl = '100000000'
              AND h.scddat = 'R'
              AND EXISTS (
              SELECT 1
                FROM tvrelwaeco.DESADVR30T d
               WHERE d.maikey = h.maikey
                 AND d.msgtyp = h.msgtyp
                 AND d.ljahr  = DEC(SUBSTR(h.wrtdat, 1, 4), 4, 0)
               )
              AND EXISTS (
                   SELECT 1
                     FROM tvrelwaeco.DESADVNVET b
                    WHERE b.allinr = a.maikey
                      AND DEC(SUBSTR(a.wrtdat, 1, 4), 4, 0) = b.ALKMJJ
                 ))
        ;

       // Verarbeitung der NVE-Sätze: neue 150/157 erzeugen
       exsr PROCESS_DESADV_NVE;

       // Ersten passender DESADVR30T-Satz auf Status '10' (vorbereitet)
       exec sql
          update TVRELWAECO/DESADVR30T a
             set status = '10'
           where ljahr concat MAIKEY =  (
                    select allijj concat ALLINR
                      from tvrelwaeco/DESADVNVET
                      fetch first 1 row only
                 )
             and status= ' ';
       endsr;

       //------------------------------------------------------------------
       // SR_LOG
       //  - schreibt kurze Statusinformation in JOB_RUN via DUMMY512
       //------------------------------------------------------------------
       begsr sr_log;

         clear p_md;

         // Protokollstring: Programm + Job + User + Status
         p_md =  §§§PGM + §§§JOB + §§§USR + status;

         p_msg    = '#DC0002';
         p_msgf   = *blank;
         p_print  = *blank;
         p_outfil = 'JOB_RUN   ';
         p_lib    = 'TVRELWAECO';
         p_repadd = '*ADD';

         callP DUMMY512(p_md:     p_msg:    p_msgf:     p_print:
                        p_outfil: p_lib:    p_repadd);
         clear status;

       endsr;

       //------------------------------------------------------------------
       // PROCESS_DESADV_NVE
       //  - läuft über DESADVNVET
       //  - je Lieferschein:
       //       1) alte 150/157 auf 'S ' markieren
       //       2) neue 150 (Packmittel) via PDESADV150 erzeugen
       //       3) neue 157 (NVE) via PDESADV157 erzeugen
       //       4) alte 150/157 löschen, 100er auf 'M ' setzen
       //  - Status in DESADVR30T auf '20' setzen
       //------------------------------------------------------------------
       begsr PROCESS_DESADV_NVE;

         // Initialwerte je Lauf
         lastLiefNr = *blanks;
         lastPKVENR = *blanks;
         lastDatum  = *blanks;
         lnumCount  = 0;
         lnumPosPk  = 0;

         // DESADVNVET sequenziell lesen
         open DESADVNVET;

         setll *start DESADVNVET;
         read DESADVNVET DESADVNVET_i;

         dow not %eof(DESADVNVET);

             // 1. aktuelle Lieferscheinnummer und Datum bestimmen
             pLiefNr = DESADVNVET_i.ALLINR;

             // TSTAMP-Format: YYYY-MM-DD-HH.MM.SS
             // -> WRTDAT-Format: YYYYMMDD
             pDatum =
                %subst(%char(DESADVNVET_i.TSTAMP):1:4) +
                %subst(%char(DESADVNVET_i.TSTAMP):6:2) +
                %subst(%char(DESADVNVET_i.TSTAMP):9:2);

             pPKIDEN = DESADVNVET_i.PKIDEN;
             pPKVENR = DESADVNVET_i.PKVENR;
             pPKPMEN = DESADVNVET_i.PKPMEN;
             pPKPTYP = DESADVNVET_i.PKPTYP;

             // 2. Erster Satz oder Lieferschein-Wechsel?
             if (lastLiefNr = *blanks) or (pLiefNr <> lastLiefNr);

                // 2a. alten Lieferschein abschließen (falls vorhanden)
                if (lastLiefNr <> *blanks) and (pLiefNr <> lastLiefNr);
                   // 100er-Satz dieses LS auf 'M ' (modifiziert) setzen
                   exec sql
                      update EDIFACTT.STDDAT
                         set SCDDAT = 'M '
                       where MAIKEY = :lastLiefNr
                         and WRTDAT = :lastDatum
                         and SCDDAT <> 'M'
                         and SCDDAT <> 'Yce'
                         and HRCLVL = '100000000';
                endif;

                                lnumPosPk = 0;

                // 2b. für neuen Lieferschein: bestehende 150/157 markieren
                exec sql
                   update EDIFACTT.STDDAT A
                      set A.SCDDAT = 'S '
                    where A.MAIKEY = :pLiefNr
                      and A.WRTDAT = :pDatum
                      and A.HRCLVL in ('150000000','157000000')
                      and A.MAIKEY IN(
                        SELECT C.MAIKEY FROM EDIFACTT.STDDAT C
                        WHERE  A.MAIKEY = C.MAIKEY AND
                               A.MSGTYP = C.MSGTYP AND
                               A.WRTDAT = C.WRTDAT AND
                               C.SCDDAT <> 'Yce' AND
                               C.SCDDAT <> 'M'   AND
                               C.HRCLVL = '100000000');

                // 2c. LINNUM-Basiswert für neuen LS ermitteln
                exec sql
                   // Gibt das Ergebnis zurück, ODER 2 falls max(LINNUM) null ist
                   select coalesce(decimal(max(LINNUM), 6, 0), 2)
                     into :lnumCount
                     from EDIFACTT.STDDAT
                    where MAIKEY = :pLiefNr
                      and WRTDAT = :pDatum
                      and SCDDAT <> 'S ';

                // 2d. Packmittel-Vergleich für neuen LS zurücksetzen
                lastPKVENR = *blanks;
             endif; // Ende LS-Wechsel

             // 3. Neues Packmittel (NVE) ? -> neuen 150er-Satz anlegen
             // Die Datensätze immer als Neuanlage (ohne Update)
             if %trim(pPKVENR) <> %trim(lastPKVENR);
                lnumCount += 1;
                //lnumPosPk = 0;
                exec sql
                   call EDIFACTT.PDESADV150(
                      :pLiefNr,
                      :pDatum,
                      :lnumCount,
                      :pPKPTYP,
                      0
                   );
             endif;

             // 4. Für jede NVE immer einen 157er-Satz erzeugen
             lnumCount += 1;
             lnumPosPk += 10;

             // Die Datensätze immer als Neuanlage (ohne Update)
             pUPDATE = 0;

             exec sql
                call EDIFACTT.PDESADV157(
                   :pLiefNr,
                   :pPKIDEN,
                   :pDatum,
                   :lnumCount,
                   :lnumPosPk,
                   :pPKVENR,
                   :pPKPMEN,
                   :pUPDATE
                );

             // 5. Steuerstatus in DESADVR30T auf '20' (verarbeitet)
             exec sql
                update TVRELWAECO/DESADVR30T
                   set status = '20'
                 where maikey = :pLiefNr
                   and Ljahr  = dec(substr(:pDatum, 1, 4), 4, 0);

             // 6. Werte für nächsten Schleifendurchlauf merken
             lastLiefNr  = pLiefNr;
             lastPKVENR  = %trim(pPKVENR);
             lastDatum   = pDatum;

             // 7. Nächsten Satz aus DESADVNVET lesen
             read DESADVNVET DESADVNVET_i;
           enddo;

           // 8. Letzten Lieferschein abschließen
           if lastLiefNr <> *blanks;
              // 100er auf 'M ' setzen
              exec sql
                 update EDIFACTT.STDDAT
                    set SCDDAT = 'M '
                  where MAIKEY = :lastLiefNr
                    and WRTDAT = :lastDatum
                    and SCDDAT <> 'M'
                    and SCDDAT <> 'Yce'
                    and HRCLVL = '100000000';

           endif;

           // Alte Datensätze endgültig entfernen
           exec sql
           delete from EDIFACTT.STDDAT A
             where A.SCDDAT = 'S'
              AND A.HRCLVL in ('150000000', '157000000')
              AND A.MSGTYP = 'DESADV'
              AND A.MAIKEY NOT IN (
              SELECT C.MAIKEY FROM EDIFACTT.STDDAT C
                 WHERE  A.MAIKEY = C.MAIKEY AND
                   A.MSGTYP = C.MSGTYP AND
                   A.WRTDAT = C.WRTDAT AND
                   A.PRTNUM = C.PRTNUM AND
                   C.SCDDAT = 'Yce' AND
                   C.HRCLVL = '100000000');

           close DESADVNVET;

        endsr;

        //==================================================================
        //==========================EDNE====================================

