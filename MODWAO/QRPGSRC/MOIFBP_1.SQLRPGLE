     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
     H**************************************************************************
     H/TITLE  Programm für die Kundenspezifische Verarbeitungen
     H**************************************************************************
     H*  Copyright 2014 by    trend SWM
     H*                       EDV-Verwaltungs GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  --------------------------------------------------------------
     H*  Erstellt: JK 31.08.2021 für Kunde Dometic Pj 16637
     H*  --------------------------------------------------------------
     H*
     F**************************************************************************
     F*
     F*  Programm für die Kundenspezifische Prüfungen und Ermittlungen
     F*
     D**************************************************************************
     FWAPR      O    E           K DISK
     F*                                    RENAME(JOB_RUN:JOB_RUN1)
     D**************************************************************************
     D***     T A B E L L E N  U N D  F E L D G R U P P E N                  ***
     D*
     D**************************************************************************
     D/COPY QCPYSRC,EXTRTR
     D*
     D**************************************************************************
     D***     DATEIEN                                                        ***
     D**************************************************************************
     D IFBP          E DS                  INZ
     D KYIFBP        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D**************************************************************************
     D***     KOMMUNIKATIONSPARAMETER                                        ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D*
     D EXTREND       E DS
     D RTTREND       E DS
     D*
     D EXIFBP        E DS
     D RTIFBP        E DS
     D**************************************************************************
     D***     INTERNE DATENSTRUKTUR                                          ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D**************************************************************************
     D***     DATENSTATIONSARBEITSBEREICH                                    ***
     D**************************************************************************
     D EXTRLD        EUDS
     D*
     D**************************************************************************
     D***  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
     D**************************************************************************
     D/COPY QCPYSRC,EXPSDS
     D*
      //--------------------------------------------------
      // Program name: C_EXTSTP
      // Purpose:
      // Returns:
      // Parameter:      #WAPRTSTP
      //--------------------------------------------------
     D C_EXTSTP...
     D                 PR                  EXTPGM('EXTSTP')
     D  #WAPRTSTP                          LIKE(WAPRTSTP)

     C**************************************************************************
     C***     R E C H E N B E S T I M M U N G E N                            ***
     C**************************************************************************
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKFIRM        CASNE     DAFIRM        ANFANG
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      EXJOBA
     C*-------------------------------------------------------------------------
     C     WKFIRM        CASNE     DAFIRM        ETRPA
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C**************************************************************************
     C***                                                                    ***
     C**************************************************************************
     C*-------------------------------------------------------------------------
      /FREE
       EXEC SQL declare IF cursor for
                select * from IFBP where IFBPFIRM = :DAFIRM
                and IFBPUSER = 'INTERCOMP'
                and IFBPSTAT = '00';

       EXEC SQL Open IF;

       DOW SQLCOD = 0;
         EXEC SQL Fetch IF into :IFBP;
         IF SQLCOD = 0;
           EXSR TRANSFER;
         ENDIF;
       ENDDO;

       EXEC SQL close IF;
      /END-FREE
     C                   RETURN
     C                   MOVE      *ON           *INLR
     C**************************************************************************
     C***  ERÖFFNUNGSZYKLUS                                                  ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C                   MOVE      *BLANK        WKC001            1
     C                   Z-ADD     *ZERO         WKN010            1 0
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOMMUNIKATIONSPARAMTER  EXTREND                        ***
     C**************************************************************************
     C     UEBTREND      BEGSR
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ermitteln parameterwerte                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUF                                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        DAFEHL
     C                   MOVE      *BLANK        ##RTCD
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  Verarbeitung                                                      ***
     C**************************************************************************
      /FREE
       BEGSR TRANSFER;
         PCPGST = 'IFBPFR';
         EXSR TRIFBP;
       ENDSR;
      /END-FREE
     C**************************************************************************
     C***  UPDATE DATEI IFBP                                                 ***
     C**************************************************************************
     C     TRIFBP        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXIFBP
     C                   CLEAR                   RTIFBP
     C                   MOVEL(P)  PCPGST        EXIFBPPGST
     C                   Z-ADD     IFBPBEJJ      EXIFBPBEJJ
     C                   MOVEL(P)  IFBPBENR      EXIFBPBENR
     C                   Z-ADD     IFBPBEPO      EXIFBPBEPO
     C                   MOVE      IFBPTSTK      EXIFBPTSTK
     C                   MOVE      IFBPTSTP      EXIFBPTSTP
     C*
     C                   CALL      'TRIFBP'
     C                   PARM                    EXIFBP
     C                   PARM                    RTIFBP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  RTIFBPPROG    WKPROG
     C                   MOVEL(P)  RTIFBPDANA    WKDANA
     C                   MOVEL(P)  RTIFBPFFLD    WKFFLD
     C                   MOVEL(P)  RTIFBPFENR    WKFENR
     C*
     C                   MOVEL(P)  RTIFBPRTCD    #CRTCD
     C*-------------------------------------------------------------------------
      /free
       CLEAR     WAPR1;
       eval      WAPRPROG  = 'MOIFBP';
       eval      WAPRTIME  = %TIME() ;
       eval      WAPRDATE  = %DATE();
       C_EXTSTP(WAPRTSTP);
       eval WAPRDESC=%Editc(IFBPBEJJ:'X')+' '+IFBPBENR+' '+%Editc(IFBPBEPO:'X');
       eval WAPRDESC=%trim(WAPRDESC) + ' ' + WKFENR + ' ' + WKFFLD;
      /end-free
     C                   write     WAPR1
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  Felder definieren                                                 ***
     C**************************************************************************
     C     VLIKE         BEGSR
     C     *LIKE         DEFINE    DAFIRM        WKFIRM
     C     *LIKE         DEFINE    DAUSER        WKUSER
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7
     C     *LIKE         DEFINE    WKC001        ##RTCD
     C     *LIKE         DEFINE    WKC001        ##PGST
     C     *LIKE         DEFINE    WKC001        PCPGST          + 5
     C     *LIKE         DEFINE    RTIFBPPROG    WKPROG
     C     *LIKE         DEFINE    RTIFBPDANA    WKDANA
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1
     C     *LIKE         DEFINE    RTIFBPFFLD    WKFFLD
     C                   ENDSR
     C**************************************************************************
     C***                                                                    ***
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,EXJOBA
     O**************************************************************************
     O*       E N D E  DES PROGRAMMS                                     *
     O**************************************************************************
