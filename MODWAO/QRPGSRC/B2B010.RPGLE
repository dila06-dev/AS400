**FREE
ctl-opt main(B2B010);
/COPY QCPYSRC,CTLOPTIONS
//*************************************************************************
/TITLE Auswahlformat für den Sammel-Aufruf des Exports meherer Dateien nach B2B
//*************************************************************************
//  Copyright 2025 by    trend SWM EDV-Beratung GmbH & Co. KG
//                       Jechtinger Straße 9
//                       DE 79111 Freiburg
//  -----------------------------------------------------------------------
//  Erstellt: PH 21.05.2025 Projekt Dometic Germany - B2B (Case #03777387)
//  -----------------------------------------------------------------------
//  Änderung: XX XX.XX.XXXX
//*************************************************************************
//
//  Über dieses Programm werden über den Folge-Aufruf B2B010SB meherere B2B-
//  Programme, die die jeweilige Datei ggf. mit Zusatzdaten als XML für B2B
//  in das jeweilige IFS-Verzeichnisse ausgeben.
//
//*************************************************************************
//**  DATEIBESCHREIBUNGEN                                               ***
//*************************************************************************
DCL-F B2B010FM WORKSTN(*EXT) USAGE(*INPUT:*OUTPUT)
    USROPN INDDS(DSINDICATORS);

//*************************************************************************
//**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
//*************************************************************************
/COPY QCPYSRC,EXTRTR

//*************************************************************************
//**  INDICATORS                                                        ***
//*************************************************************************
/COPY QCPYSRC,TRCURSOR
/include QCPYSRC,SXSYSTEM
/COPY QCPYSRC,CXIODCL

//*************************************************************************
//**  DATEIEN                                                           ***
//*************************************************************************
DCL-DS TRPA        EXT INZ END-DS;
DCL-DS KYTRPA      EXT INZ END-DS;

DCL-DS TRTK        EXT INZ END-DS;
DCL-DS KYTRTK      EXT INZ END-DS;

DCL-DS TRTP        EXT INZ END-DS;
DCL-DS KYTRTP      EXT INZ END-DS;

//*************************************************************************
//**  KOMMUNIKATIONSPARAMETER                                           ***
//*************************************************************************
DCL-DS EXTR01      EXT INZ END-DS;
DCL-DS EXTR02      EXT INZ END-DS;
DCL-DS EXTR03      EXT INZ END-DS;

DCL-DS EXFIRM      EXT INZ END-DS;
DCL-DS EXFLPO      EXT INZ END-DS;
DCL-DS EXTRDN      EXT INZ END-DS;

DCL-DS EXDATE      EXT INZ END-DS;
DCL-DS RTDATE      EXT INZ END-DS;

//*************************************************************************
//**  DATENSTATIONSARBEITSBEREICH                                       ***
//*************************************************************************
DCL-DS EXTRLD      EXT DTAARA(*AUTO:*USRCTL:*LDA);
 DASTUZ           ZONED(6) POS(210);
 DASTDA           ZONED(8) POS(216);
END-DS;

//*************************************************************************
//**  INTERNE DATENSTRUKTUR                                             ***
//*************************************************************************
/COPY QCPYSRC,EXTRIN

//*************************************************************************
//**  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
//*************************************************************************
/COPY QCPYSRC,EXPSDS

//*************************************************************************
//**  Einzelfelder                                                      ***
//*************************************************************************
DCL-S WKC001       CHAR(1);
DCL-S WKN010       ZONED(1);
DCL-S ##CHI        CHAR(8);
DCL-S ##RTCD       CHAR(1);
DCL-S WKIFMT       CHAR(2);
DCL-S WKTRTP       CHAR(1);
DCL-S WKTRPA       CHAR(1);
DCL-S WKIOKZ       CHAR(1);
DCL-S WKI000       CHAR(1);
DCL-S WKIN30       CHAR(1);
DCL-S WKIN31       CHAR(1);
DCL-S WKFIRM       LIKE(DAFIRM);
DCL-S WKUSER       LIKE(DAUSER);
DCL-S WKPROG       LIKE(DAPROG);
DCL-S WKBIBL       LIKE(DABIBL);
DCL-S WKFEAT       CHAR(1);
DCL-S WKFENR       CHAR(4);
DCL-S W$PA03       CHAR(10);
DCL-S W$PA04       CHAR(10);
DCL-S W$PA05       CHAR(10);
DCL-S W$PA06       CHAR(10);
DCL-S W$PA07       CHAR(10);
DCL-S W$PA08       CHAR(10);

//*************************************************************************
//**  Externe Call-Prozeduren                                           ***
//*************************************************************************
//--------------------------------------------------
// Program name: C_B2B010SB
// Purpose:
// Returns:
//--------------------------------------------------
DCL-PR C_B2B010SB  EXTPGM('B2B010SB');
END-PR;

//--------------------------------------------------
// Program name: C_TRFEHLCL
// Purpose:
// Returns:
// Parameter:      #WKFENR
// Parameter:      #KEYVAR
// Parameter:      #DSJNAM
// Parameter:      #DSUSER
// Parameter:      #W$PA03
// Parameter:      #W$PA04
// Parameter:      #W$PA05
// Parameter:      #W$PA06
// Parameter:      #W$PA07
//--------------------------------------------------
DCL-PR C_TRFEHLCL  EXTPGM('TRFEHLCL');
  #WKFENR          LIKE(WKFENR);
  #KEYVAR          LIKE(KEYVAR);
  #DSJNAM          LIKE(DSJNAM);
  #DSUSER          LIKE(DSUSER);
  #W$PA03          LIKE(W$PA03);
  #W$PA04          LIKE(W$PA04);
  #W$PA05          LIKE(W$PA05);
  #W$PA06          LIKE(W$PA06);
  #W$PA07          LIKE(W$PA07);
END-PR;

//--------------------------------------------------
// Program name: B2B010
// Purpose: Hauptprozedur des Programms
//--------------------------------------------------
dcl-pr B2B010      extpgm('B2B010');
end-pr;

//*************************************************************************
//*** Start des Programmes
//*************************************************************************
dcl-proc B2B010;
  dcl-pi *n;
  end-pi;
  IN EXTRLD;

  /include QCPYSRC,PGINIT

  IF WKFIRM <> DAFIRM;
    EXSR ANFANG;
  ENDIF;

  EXSR EXJOBA;

  IF WKFIRM <> DAFIRM;
    EXSR ETRPA;
  ENDIF;

  EXSR VORLAUF;

  *IN = *OFF;
  *IN28  = C#IN28;

  IF WKIOKZ = *ON;
    C#WNDW = *ON;
  ENDIF;

  //*************************************************************************
  //**  P R O G R A M M S T E U E R U N G                                 ***
  //*************************************************************************
  DOW WKIFMT <> '00';

    IF WKIOKZ <> *ON;
      dspOpen('B2B010FM': DSINDICATORS);
      *IN98  = %ERROR;
      WKIOKZ = *ON;
    ENDIF;

    SELECT;
    WHEN WKIFMT = '01';
      EXSR BILD01;
    ENDSL;

  ENDDO;

  IF #CRTCD = 'N' AND WKIOKZ = *ON;
    dspClose('B2B010FM');
    WKIOKZ = *OFF;
  ENDIF;

  WKFIRM = DAFIRM;
  // Rückgabe der Aufrufparameter
  return;

  //*************************************************************************
  //**  ERÖFFNUNGSZYKLUS                                                  ***
  //*************************************************************************
  BEGSR ANFANG;

    WKI000 = *ON;

    WKC001 = *BLANK;
    WKN010 = *ZERO;

    WKPROG = EXPSDSPROC;
    WKBIBL = EXPSDSBIBL;
    WKUSER = EXPSDSUSER;

    KYTAFI = DAFIRM;                                                       // TRPA

    KYTKFI = DAFIRM;                                                       // TRTK
    KYTKSP = DASPCD;

    KYTPFI = DAFIRM;                                                       // TRTP
    KYTPSP = DASPCD;

    EXFIRMFIRM = DAFIRM;
    EXSR PRFIRMFIRM;

    EXTRDNDANA = 'B2B010';
    EXSR RDTRDNTRDN;

    WNKOPF = EXTRDNTEXT;

    EXFLPOFMTN = 'B2B010FM';

  ENDSR;

  //*************************************************************************
  //**  VORLAUF                                                           ***
  //*************************************************************************
  BEGSR VORLAUF;

    C#LCK0 = *OFF;
    C#LCK1 = *OFF;
    WKIN30 = C#LCK0;
    WKIN31 = C#LCK1;

    DAFEHL = *BLANK;
    ##RTCD = *BLANK;
    #CRTCD = *BLANK;
    WKFEAT = 'F';
    MCF = *BLANK;

    WKIFMT = '01';
    FMTDS  = *BLANK;

    FM = 1;
    FMT(FM) = '00';

  ENDSR;

  //*************************************************************************
  //**  STEUERROUTINE BILD01                                              ***
  //*************************************************************************
  BEGSR BILD01;

    IF WKIFMT <> FMT(FM);
      EXSR IFMTS;
    ENDIF;

    EXSR B01DS;

    DOW WKIFMT = '01';
      EXSR EFLPO;
      dspWrite('B2B010W1');
      dspWrite('B2B01001');
      dspWrite('W1B010B2');

      IF WKFENR <> *ZERO;
        EXSR AUMSG;
      ENDIF;

      C#WNDW = *OFF;

      *IN99  = dspRead('B2B01001');
      *IN98  = not dspFound('B2B01001');

      IF *IN98 = *ON OR *IN99 = *ON;
        #CRTCD = 'N';
        DAFEHL = *ON;
        #CPGST = *BLANK;
        WKIFMT = '00';
        LEAVE;
      ENDIF;

      SELECT;

      WHEN C#EXIT = *ON;
        MCF = *BLANK;
        #CPGST = *BLANK;
        DAFEHL = *ON;
        #CRTCD = 'N';
        WKIFMT = '00';

      WHEN C#SELC = *ON;
        EXSR MCAUFR;

        IF WKTRTP = *ON
        OR WKFENR <> *ZERO;
          ITER;
        ENDIF;

      WHEN C#CANC = *ON;
        #CPGST = *BLANK;
        DAFEHL = *ON;
        #CRTCD = 'N';
        EXSR RFMTS;

      WHEN C#INFO = *ON;
        EXSR VINFO;
        C#WNDW = *ON;
        ITER;

      WHEN C#FUKT <> *ZERO;
        WKFENR = '0075';
        ITER;

      OTHER;

        EXSR B01PR;
        IF WKFENR <> *ZERO;
          ITER;
        ENDIF;

        EXSR UPDLDA;
        C_B2B010SB();
        EXSR RFMTS;

      ENDSL;

    ENDDO;

  ENDSR;

  //*************************************************************************
  //**  FÜLLEN BILDSCHIRMFORMAT 01                                        ***
  //*************************************************************************
  BEGSR B01DS;

    C#LCK0 = WKIN30;
    C#LCK1 = WKIN31;

    #CRTCD = *BLANK;

    DSSTDA = %DEC(%DATE():*EUR);
    DSSTUZ = %DEC(%TIME());

    WKFENR = *ZERO;
    EXFLPOFLDN = 'DSSTDA';

  ENDSR;

  //*************************************************************************
  //**  PLAUSIPRÜFUNG FÜR BILD01                                          ***
  //*************************************************************************
  BEGSR B01PR;

    WKFENR = *ZERO;

    EXSR PRSTDA;
    IF WKFENR <> *ZERO;
      LEAVESR;
    ENDIF;

    EXSR PRSTUZ;
    IF WKFENR <> *ZERO;
      LEAVESR;
    ENDIF;

    WKFENR = *ZERO;

  ENDSR;

  //*************************************************************************
  //**  FUNKTIONSTASTE 4 FÜR ALLE BILDER                                  ***
  //*************************************************************************
  BEGSR MCAUFR;

    WKTRTP = *OFF;
    WKFENR = *ZERO;
    EXFLPOFLDN = FLDNAM;

    SELECT;

    WHEN FLDNAM = *BLANK;
      WKFENR = '0050';
      EXFLPOFLDN = 'DSSTDA';

    WHEN FLDNAM = 'DSSTDA';
      EXSR MCAUFRSTDA;

    OTHER;
      WKFENR = '0050';
    ENDSL;

  ENDSR;

  //*************************************************************************
  //**  MC-ROUTINE STDA                                                   ***
  //*************************************************************************
  BEGSR MCAUFRSTDA;

    C#WNDW = *ON;

    CLEAR EXDATE;
    EXDATEDATV = DSSTDA;
    EXDATEFMTV = '*EUR';
    EXDATEFMTN = '*EUR';

    IF DSSTDA = *ZERO;
      EXDATEPGCD = 'POSAKT';
    ENDIF;

    EXSR TRDATE;

    IF WKFENR = *ZERO AND WKTRTP = *OFF;
      DSSTDA = RTDATEDATE;
      WKTRTP = *ON;
    ENDIF;

  ENDSR;

  //*************************************************************************
  //**  PR-ROUTINE STDA                                                   ***
  //*************************************************************************
  BEGSR PRSTDA;

    EXFLPOFLDN = 'DSSTDA';

    CLEAR EXDATE;
    EXDATEDATV = DSSTDA;
    EXDATEFMTV = '*EUR';
    EXDATEFMTN = '*EUR';
    EXDATEPGST = 'TRDAPR';
    EXSR TRDATE;

    IF WKFENR = *ZERO;
      DSSTDA = RTDATEDATE;

      CLEAR EXDATE;
      EXDATEDATV = DSSTDA;
      EXDATEFMTV = '*EUR';
      EXDATEFMTN = '*ISO';
      EXDATEPGST = 'TRDAUM';
      EXSR TRDATE;
      IF RTDATEDATE < %DEC(%DATE():*ISO);
        WKFENR = '0036';
      ENDIF;
    ENDIF;

  ENDSR;

 //*************************************************************************
 //**  PR-ROUTINE STUZ                                                   ***
 //*************************************************************************
 BEGSR PRSTUZ;

   EXFLPOFLDN = 'DSSTUZ';

   #CDATV = DSSTUZ;
   #CFMTV = '  HHMMSS';
   EXSR TRZTPR;

 ENDSR;

  //*************************************************************************
  //**  UPDATE LDA-BEREICH                                                ***
  //*************************************************************************
  BEGSR UPDLDA;

    CLEAR EXDATE;
    EXDATEDATV = DSSTDA;
    EXDATEFMTV = '*EUR';
    EXDATEFMTN = DAJDFM;
    EXDATEPGST = 'TRDAUM';
    EXSR TRDATE;
    DASTDA = RTDATEDATE;
    DASTUZ = DSSTUZ;

    OUT EXTRLD;

  ENDSR;

  //*************************************************************************
  //**  ERMITTELN DATEN AUS FIRMEN-PARAMETER                              ***
  //*************************************************************************
  BEGSR ETRPA;

    WKTRPA = *ON;

  ENDSR;

  //*************************************************************************
  //**  AUFBEREITEN DER NACHRICHTEN                                       ***
  //*************************************************************************
  BEGSR AUMSG;

    C_TRFEHLCL(WKFENR:KEYVAR:DSJNAM:DSUSER:W$PA03:W$PA04:W$PA05:
        W$PA06:W$PA07);

    PGMNAM = 'B2B010';
    C#INIT = *ON;

    SELECT;
    WHEN WKIFMT = '01';
      dspWrite('CTB010W1');
    OTHER;
      dspWrite('B2B010CT');
    ENDSL;

    C#INIT = *OFF;

    SELECT;
    WHEN WKIFMT = '01';
      dspSndMsg('CTB010W1': WKFENR:
          DSJNAM:DSUSER:W$PA03:W$PA04:W$PA05:W$PA06:W$PA07);
    OTHER;
      dspSndMsg('B2B010CT': WKFENR:
          DSJNAM:DSUSER:W$PA03:W$PA04:W$PA05:W$PA06:W$PA07);
    ENDSL;

    W$PA03 = *BLANK;
    W$PA04 = *BLANK;
    W$PA05 = *BLANK;
    W$PA06 = *BLANK;
    W$PA07 = *BLANK;
    W$PA08 = *BLANK;
    WKFENR = *ZERO;

  ENDSR;

  //*************************************************************************
  //**  COPY-MODULE                                                       ***
  //*************************************************************************
  /COPY QCPYSRC,CHTRPA
  /COPY QCPYSRC,CHTRTK
  /COPY QCPYSRC,CHTRTP
  /COPY QCPYSRC,EXFLPO
  /COPY QCPYSRC,EXJOBA
  /COPY QCPYSRC,MCTRTP
  /COPY QCPYSRC,PRFIRMFIRM
  /COPY QCPYSRC,PRFUKT
  /COPY QCPYSRC,RDTRDNTRDN
  /COPY QCPYSRC,TRDATE
  /COPY QCPYSRC,TRIFMT
  /COPY QCPYSRC,TRZTPR
  /COPY QCPYSRC,VINFO
  //*************************************************************************
  //**  Ende des Programms                                                ***
  //*************************************************************************
end-proc;
//**************************************************************************
//*** Prozeduren
//**************************************************************************
/COPY QCPYGEN,B2B010FM
