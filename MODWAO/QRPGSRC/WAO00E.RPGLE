     H DECEDIT('0,') DATEDIT(*DMY.) DEBUG(*YES)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H**************************************************************************
     H/TITLE Dialog-SST WAECO-Identstamm
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FERTEALT   IF   E           K DISK
     F                                     RENAME(ERTEALT:ARTIKEL)
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY TAMP/QCPYSRC,EXTRTR
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D ERTE          E DS                  INZ
     D KYERTE        E DS                  INZ
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D**************************************************************************
     D***  DATENSTATIONSARBEITSBEREICH                                       ***
     D**************************************************************************
     D EXTRLD        EUDS
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY TAMP/QCPYSRC,EXTRIN
     D*
     D  WKTDAT                         D   DATFMT(*ISO) INZ
     D**************************************************************************
     D***  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
     D**************************************************************************
     D/COPY TAMP/QCPYSRC,EXPSDS
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*
     C                   EXSR      ANFANG
     C                   EXSR      ETRPA
     C                   EXSR      VORLAUF
     C*
     C                   EXSR      LERTE
     C                   EXSR      VERTE
     C*
     C                   SETON                                        LR
     C**************************************************************************
     C***  DATEI VERARBEITUNG                                                ***
     C**************************************************************************
     C     LERTE         BEGSR
     C*
     C                   MOVE      *BLANKS       KYERTEERTE
     C                   MOVE      *BLANKS       KYERTETENR
     C                   MOVEA     '01+U    '    CHI
     C                   EXSR      CHERTE
     C*
     C     WKFENR        DOWEQ     *ZEROS
     C     ERTEFIRM      ANDEQ     KYERTEFIRM
     C*
     C                   MOVEA     '01D     '    CHI
     C                   EXSR      CHERTE
     C*
     C                   MOVEA     '01RU    '    CHI
     C                   EXSR      CHERTE
     C*
     C                   ENDDO
     C*
     C                   ENDSR
     C**************************************************************************
     C***  DATEI VERARBEITUNG                                                ***
     C**************************************************************************
     C     VERTE         BEGSR
     C*
     C                   READ      ARTIKEL                              9899
     C*
     C     *IN98         DOWEQ     *OFF
     C     *IN99         ANDEQ     *OFF
     C*
     C                   EXSR      VERTEU
     C*
     C                   READ      ARTIKEL                              9899
     C                   ENDDO
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI ERTE                                                 ***
     C**************************************************************************
     C     VERTEU        BEGSR
     C*
     C                   DO
     C*-------------------------------------------------------------------------
     C     E10           IFNE      *BLANKS
     C                   MOVEL(P)  E10           KYERTETENR
     C                   MOVEL(P)  E9            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E9            KYERTETENR
     C                   MOVEL(P)  E8            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E8            KYERTETENR
     C                   MOVEL(P)  E7            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E7            KYERTETENR
     C                   MOVEL(P)  E6            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E6            KYERTETENR
     C                   MOVEL(P)  E5            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E5            KYERTETENR
     C                   MOVEL(P)  E4            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E4            KYERTETENR
     C                   MOVEL(P)  E3            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E3            KYERTETENR
     C                   MOVEL(P)  E2            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E2            KYERTETENR
     C                   MOVEL(P)  E1            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E1            KYERTETENR
     C                   MOVEL(P)  ARTNR         KYERTEERTE
     C                   EXSR      WERTE
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     E9            IFNE      *BLANKS
     C                   MOVEL(P)  E9            KYERTETENR
     C                   MOVEL(P)  E8            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E8            KYERTETENR
     C                   MOVEL(P)  E7            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E7            KYERTETENR
     C                   MOVEL(P)  E6            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E6            KYERTETENR
     C                   MOVEL(P)  E5            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E5            KYERTETENR
     C                   MOVEL(P)  E4            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E4            KYERTETENR
     C                   MOVEL(P)  E3            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E3            KYERTETENR
     C                   MOVEL(P)  E2            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E2            KYERTETENR
     C                   MOVEL(P)  E1            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E1            KYERTETENR
     C                   MOVEL(P)  ARTNR         KYERTEERTE
     C                   EXSR      WERTE
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     E8            IFNE      *BLANKS
     C                   MOVEL(P)  E8            KYERTETENR
     C                   MOVEL(P)  E7            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E7            KYERTETENR
     C                   MOVEL(P)  E6            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E6            KYERTETENR
     C                   MOVEL(P)  E5            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E5            KYERTETENR
     C                   MOVEL(P)  E4            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E4            KYERTETENR
     C                   MOVEL(P)  E3            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E3            KYERTETENR
     C                   MOVEL(P)  E2            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E2            KYERTETENR
     C                   MOVEL(P)  E1            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E1            KYERTETENR
     C                   MOVEL(P)  ARTNR         KYERTEERTE
     C                   EXSR      WERTE
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     E7            IFNE      *BLANKS
     C                   MOVEL(P)  E7            KYERTETENR
     C                   MOVEL(P)  E6            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E6            KYERTETENR
     C                   MOVEL(P)  E5            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E5            KYERTETENR
     C                   MOVEL(P)  E4            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E4            KYERTETENR
     C                   MOVEL(P)  E3            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E3            KYERTETENR
     C                   MOVEL(P)  E2            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E2            KYERTETENR
     C                   MOVEL(P)  E1            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E1            KYERTETENR
     C                   MOVEL(P)  ARTNR         KYERTEERTE
     C                   EXSR      WERTE
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     E6            IFNE      *BLANKS
     C                   MOVEL(P)  E6            KYERTETENR
     C                   MOVEL(P)  E5            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E5            KYERTETENR
     C                   MOVEL(P)  E4            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E4            KYERTETENR
     C                   MOVEL(P)  E3            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E3            KYERTETENR
     C                   MOVEL(P)  E2            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E2            KYERTETENR
     C                   MOVEL(P)  E1            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E1            KYERTETENR
     C                   MOVEL(P)  ARTNR         KYERTEERTE
     C                   EXSR      WERTE
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     E5            IFNE      *BLANKS
     C                   MOVEL(P)  E5            KYERTETENR
     C                   MOVEL(P)  E4            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E4            KYERTETENR
     C                   MOVEL(P)  E3            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E3            KYERTETENR
     C                   MOVEL(P)  E2            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E2            KYERTETENR
     C                   MOVEL(P)  E1            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E1            KYERTETENR
     C                   MOVEL(P)  ARTNR         KYERTEERTE
     C                   EXSR      WERTE
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     E4            IFNE      *BLANKS
     C                   MOVEL(P)  E4            KYERTETENR
     C                   MOVEL(P)  E3            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E3            KYERTETENR
     C                   MOVEL(P)  E2            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E2            KYERTETENR
     C                   MOVEL(P)  E1            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E1            KYERTETENR
     C                   MOVEL(P)  ARTNR         KYERTEERTE
     C                   EXSR      WERTE
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     E3            IFNE      *BLANKS
     C                   MOVEL(P)  E3            KYERTETENR
     C                   MOVEL(P)  E2            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E2            KYERTETENR
     C                   MOVEL(P)  E1            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E1            KYERTETENR
     C                   MOVEL(P)  ARTNR         KYERTEERTE
     C                   EXSR      WERTE
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     E2            IFNE      *BLANKS
     C                   MOVEL(P)  E2            KYERTETENR
     C                   MOVEL(P)  E1            KYERTEERTE
     C                   EXSR      WERTE
     C                   MOVEL(P)  E1            KYERTETENR
     C                   MOVEL(P)  ARTNR         KYERTEERTE
     C                   EXSR      WERTE
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     E1            IFNE      *BLANKS
     C                   MOVEL(P)  E1            KYERTETENR
     C                   MOVEL(P)  ARTNR         KYERTEERTE
     C                   EXSR      WERTE
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SCHREIBEN ERTE                                                    ***
     C**************************************************************************
     C     WERTE         BEGSR
     C*
     C                   MOVEL(P)  KYERTETENR    KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C     WKFENR        IFNE      *ZEROS
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVEL(P)  KYERTEERTE    KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C     WKFENR        IFNE      *ZEROS
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVEL(P)  KYERTETENR    ERTETENR
     C                   MOVEL(P)  KYERTEERTE    ERTEERTE
     C*
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHERTE
     C     WKFENR        IFEQ      *ZEROS
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVEL(P)  DAJNAM        ERTEJNAM
     C                   MOVEL(P)  DAPROG        ERTEPROG
     C                   MOVEL(P)  DABIBL        ERTEBIBL
     C                   MOVEL(P)  DAUSER        ERTEUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        ERTEJZEI
     C                   MOVE      WKTDAT        ERTEJDAT
     C*--------------------------------------------------------
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHERTE
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERÖFFNUNGSZYKLUS                                                  ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C                   MOVE      *ON           WKI000
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1
     C                   Z-ADD     *ZERO         WKN010            1 0
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '01'          DAFIRM
     C                   MOVEL(P)  'UEB_ERTE'    DAJNAM
     C                   MOVEL(P)  'MODWAO'      DABIBL
     C                   MOVEL(P)  'BATCH'       DAUSER
     C                   MOVEL(P)  'WAO00E'      DAPROG
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        EXFIRMFIRM
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYERTEFIRM                     ERTE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUF                                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C*
     C                   ENDSR
     C**************************************************************************
     C***  DEFINITION DER WORKFELDER...                                      ***
     C**************************************************************************
     C     VLIKE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKC001                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7
     C     *LIKE         DEFINE    WKC001        ##RTCD
     C     *LIKE         DEFINE    WKC001        ##PGST
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1
     C     *LIKE         DEFINE    WKC001        WKRTCD
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKTRPA
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY TAMP/QCPYSRC,CHTEIL
     C/COPY TAMP/QCPYSRC,CHERTE
