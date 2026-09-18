     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2017')
      //*************************************************************************
      /TITLE  EMailermittlung Projektschritt Abschluss
      //*************************************************************************
      //  Copyright 2017 by    trend SWM
      //                       Verwaltung GmbH
      //                       Gundelfinger Straße 11
      //                       DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: NI 27.10.2017
      //  -----------------------------------------------------------------------
      //
      //*************************************************************************
      //
      //  EMailermittlung Projektschritt Abschluss
      //
      //  Kurzbeschreibung:
      //
      //  Übergeben an das Programm werden die Pointer für den
      //  Before-Rec (WKRECB§) und den After-Rec (WKRECA§)
      //  Diese werden den Record-Abbildern zugordnet sodass die Daten
      //  der Sätze im Programm zur Verfügung stehen.
      //
      //  Im Rückgabeparameter muss dann die ermittelte EMailadresse
      //  an den Workflow zurück gegeben werden.
      //
      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR
      //
      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D PJPO          E DS                  INZ
     D PJPOA           S          10000    BASED(WKRECA§)
     D PJPOB           S          10000    BASED(WKRECB§)
      //
     D USZU          E DS                  INZ
     D KYUSZU        E DS                  INZ
      //
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
      //
      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
      //
     D EXTXST        E DS                  INZ
      //
      //*************************************************************************
      //**  INTERNE DATENSTRUKTUR                                             ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRIN
      //
      //*************************************************************************
      //**  DATENSTATIONSARBEITSBEREICH                                       ***
      //*************************************************************************
     D EXTRLD        EUDS                  DTAARA(*LDA)
      //
      //*************************************************************************
      //**  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
      //*************************************************************************
     D/COPY QCPYSRC,EXPSDS
      //
      //*************************************************************************
      //**  VARIABLE                                                          ***
      //*************************************************************************
     D ##CHI           S              8
     D ##RTCD          S              1
     D ##PGST          S              1
     D WKRTCD          S              1
     D WKTRTP          S              1
     D WKTRPA          S              1
     D WKI000          S              1
     D WKFENR          S              4
     D I0              S              3S 0
     D I1              S              3S 0
     D I2              S              3S 0
     D WKFIRM          S                   LIKE(DAFIRM)
     D WKUSER          S                   LIKE(DSUSER)
     D WKJDAT          S                   LIKE(DSJDAT)
     D WKJZEI          S                   LIKE(DSJZEI)
     D PCPGST          S                   LIKE(#CPGST)
     D WKPJPO          S                   LIKE(POPJMB)
      //*************************************************************************
      //**  KONSTANTEN                                                        ***
      //*************************************************************************
     D cTrue           C                   const(*on )
     D cFalse          C                   const(*off)
      //*************************************************************************
      //**  ÜBERGABE-PARAMETER                                                ***
      //*************************************************************************
     D WKRECA§         S               *
     D WKRECB§         S               *
     D WKMAIL          S            100
     D WKOBJN          S             10
      //*************************************************************************
      //**  R E C H E N B E S T I M M U N G E N                               ***
      //*************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    WKOBJN
     C                   PARM                    WKRECA§
     C                   PARM                    WKRECB§
     C                   PARM                    WKMAIL
      /FREE
       EXSR UEBTREND;
       IN EXTRLD;
         SELECT;
         WHEN WKFIRM <> DAFIRM;
           EXSR ANFANG;
         ENDSL;
       EXSR EXJOBA;
         SELECT;
         WHEN WKFIRM <> DAFIRM;
           EXSR ETRPA;
         ENDSL;
       EXSR VORLAUF;
       //*************************************************************************
       //**  PROGRAMMSTEUERUNG                                                 ***
       //*************************************************************************
         EXSR VPJPO;
       RETURN;
       *INLR = *ON;
       //*************************************************************************
       //**  ERÖFFNUNGSZYKLUS                                                  ***
       //*************************************************************************
       BEGSR ANFANG;
         WKI000 = *ON;
         WKCHPN = EXPSDSPROC;
         WKCHPL = EXPSDSBIBL;
         WKUSER = EXPSDSUSER;

         KYTAFI = DAFIRM;                                                       // TRPA
       ENDSR;
       //*************************************************************************
       //**  UEBERNAHME KOMMUNIKATIONSPARAMTER EXTREND                         ***
       //*************************************************************************
       BEGSR UEBTREND;

         CLEAR WKMAIL;

       ENDSR;
       //*************************************************************************
       //**  VORLAUF                                                           ***
       //*************************************************************************
       BEGSR VORLAUF;
         DAFEHL = *BLANK;
         ##RTCD = *BLANK;
         #CRTCD = *BLANK;
       ENDSR;
       //*************************************************************************
       //**  Ermittlung nächster offene Projektschritt                         ***
       //*************************************************************************
       BEGSR VPJPO;
         WKFENR = '0000';

         PJPO = PJPOA;            //PJPO = After-Record

         EXEC SQL
           SELECT POPJMB INTO :WKPJPO FROM PJPO
             WHERE POFIRM = :POFIRM AND
                   POPRNR = :POPRNR AND
                   POPJDF > :POPJDF AND
                   POPJST < '90'
             FETCH FIRST 1 ROWS ONLY;
         IF SQLCOD <> *ZERO;
           EXSR VPROJ;
           LEAVESR;
         ENDIF;

         USZUBENU = WKPJPO;
         EXSR ERMAIL;

       ENDSR;
       //*************************************************************************
       //**  Ermittlung Projektverantwortlicher                                ***
       //*************************************************************************
       BEGSR VPROJ;
         WKFENR = '0000';

         EXEC SQL
           SELECT PJSABE INTO :WKPJPO FROM PROJ
             WHERE PJFIRM = :POFIRM AND
                   PJPRNR = :POPRNR
             FETCH FIRST 1 ROWS ONLY;
         IF SQLCOD <> *ZERO;
           LEAVESR;
         ENDIF;

         KYUSZUFIRM = POFIRM;
         KYUSZUSABE = WKPJPO;
         KYUSZUBENU = *BLANKS;
         CHIDS = '03+';
         EXSR CHUSZU;
         IF USZUFIRM = KYUSZUFIRM AND
            USZUSABE = KYUSZUSABE;
           EXSR ERMAIL;
         ENDIF;

       ENDSR;
       //*************************************************************************
       //**  Ermittlung EMailadresse                                           ***
       //*************************************************************************
       BEGSR ERMAIL;
         WKFENR = '0000';

         CLEAR EXTXST;
         EXTTPGCD = 'TEXT';
         EXTTTCDE = 'TRTX64';
         EXTTBENU = USZUBENU;
         EXTTSPCD = DASPCD;
         EXTTUCDE = 'EMAIL ';
         EXSR TRTX50;
         WKMAIL = %UCS2(%TRIM(EXTTTEXT));

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN PARAMETERWERTE                                          ***
       //*************************************************************************
       BEGSR ETRPA;
         WKTRPA = *ON;
       ENDSR;
       //*************************************************************************
       //**  COPY-MODULE                                                       ***
       //*************************************************************************
      /END-FREE
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHUSZU
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,TRTX50

      //*************************************************************************
      //**  ENDE DES PROGRAMMS                                                ***
      //*************************************************************************
