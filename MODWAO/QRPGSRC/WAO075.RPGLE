     H DECEDIT('0,') DATEDIT(*DMY.)  debug(*yes)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2004')
     H**************************************************************************
     H/TITLE Übernahme LBBS / LBLB in BGFS
     F**************************************************************************
     F***  Dateibeschreibung                                                 ***
     F**************************************************************************
     FPCLB      IF A E           K DISK
     F                                     RENAME(PCLB1:BGFSSATZ)
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D LBBS          E DS
     D LBLB          E DS
     D*
     D EXFIRM        E DS                  INZ
     D*
     D LBSD          E DS                  INZ
     D KYLBSD        E DS                  INZ
     D*
     D LBSS          E DS                  INZ
     D KYLBSS        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D**************************************************************************
     D***  D A T E N S T R U K T U R E N                                     ***
     D**************************************************************************
     D/COPY TAMP/QCPYSRC,EXTRIN
     D*
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRTR
     D*
     D**************************************************************************
     D***  INDICATORS                                                        ***
     D**************************************************************************
     D/COPY QCPYSRC,TRCURSOR
     D*
     D  WKTDAT                         D   DATFMT(*ISO) INZ
     D**************************************************************************
     D***  DATENSTATIONSARBEITSBEREICH                                       ***
     D**************************************************************************
     D EXTRLD        EUDS
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    WKBCOD            2
     C                   PARM                    LBBS
     C                   PARM                    LBLB
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C                   EXSR      ETRPA
     C*
     C                   EXSR      ANFANG
     C*-------------------------------------------------------------------------
     C************       dump
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKBCOD        WHENEQ    '01'
     C                   MOVEL(P)  LBLBLSTC      KYLSTC                         B-Key
     C                   MOVEL(P)  LBLBLANR      KYLDLA                         Lager
     C                   MOVEL(P)  LBLBTENR      KYTENR                         Teil
     C                   EXSR      VBGFS
     C     WKBCOD        WHENEQ    '02'
     C                   MOVEL(P)  LBBSLANR      KYLDLA                         Lager
     C                   MOVEL(P)  LBBSTENR      KYTENR                         Teil
     C                   EXSR      VBGFSSP1
     C     WKBCOD        WHENEQ    '03'
     C                   MOVEL(P)  LBBSLANR      KYLDLA                         Lager
     C                   MOVEL(P)  LBBSTENR      KYTENR                         Teil
     C                   EXSR      VBGFSSP2
     C                   OTHER
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           *INLR
     C**************************************************************************
     C***  Eröffnungszyklus                                                  ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C                   MOVE      *OFF          *IN
     C*
     C                   MOVE      *BLANK        WKC001            1
     C                   Z-ADD     *ZERO         WKN010            1 0
     C                   MOVE      *BLANKS       KZBUCH            1
     C*
     C                   MOVEL(P)  DAFIRM        KYLDFI                         LBSD
     C                   MOVEL(P)  DAFIRM        KYLSFI                         LBSS
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
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
     C***  Datenatz für BGFS erstellen                                       ***
     C**************************************************************************
     C     VBGFS         BEGSR
     C*
     C     LBBSSPKZ      IFEQ      'J'
     C     LBLBLSTC      ANDNE     '955'
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVE      *BLANKS       KYLSLA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBSS
     C     WKFENR        IFNE      *ZEROS
     C                   LEAVESR
     C                   ENDIF
     C                   MOVE      LSSBEZ        KZBUCH
     C     KZBUCH        IFNE      '*'
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBSD
     C     WKFENR        IFNE      *ZEROS
     C                   LEAVESR
     C                   ENDIF
     C                   MOVE      LDLBZ1        KZBUCH
     C     KZBUCH        IFNE      '*'
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVE      *BLANK        KYTEEZ
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C     WKFENR        IFNE      *ZEROS
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   BGFSSATZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  LBLBFIRM      PCLBFIRM
     C                   MOVEL(P)  LBLBTENR      PCLBTENR
     C                   MOVEL(P)  LBLBLANR      PCLBLANR
     C                   MOVEL(P)  LBLBLORT      PCLBLORT
     C                   MOVE      '00'          PCLBSTAT
     C*
     C                   SELECT
     C     LBLBSTMG      WHENGT    0
     C                   Z-ADD     LBLBSTMG      PCLBBUMG
     C                   MOVE      'ZUG'         PCLBBUKZ
     C     LBLBSTMG      WHENLT    0
     C     LBLBSTMG      MULT      -1            PCLBBUMG
     C                   MOVE      'ABG'         PCLBBUKZ
     C     LBLBSTMG      WHENEQ    0
     C                   Z-ADD     LBBSLAGB      PCLBBUMG
     C     LSLSTC        IFEQ      '955'
     C                   MOVE      'ABG'         PCLBBUKZ
     C                   ELSE
     C                   MOVE      'ZUG'         PCLBBUKZ
     C                   ENDIF
     C                   ENDSL
     C*
     C                   MOVEL(P)  'BGFS'        PCLBDANA
     C                   Z-ADD     LBLBTMST      PCLBTMST
     C*
     C                   CALL      'EXTSTP'
     C                   PARM                    PCLBTSTP
     C*
     C                   MOVEL(P)  TEMEIN        PCLBMEIN
     C                   MOVEL(P)  TETBZ1        PCLBBEZ1
     C                   MOVEL(P)  TETBZ2        PCLBBEZ2
     C*
     C                   MOVEL(P)  LBLBLSTC      PCLBFREX
     C*
     C                   MOVEL(P)  LBLBCHAR      PCLBCHAR
     C*--------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        PCLBJNAM
     C                   MOVEL(P)  DAPROG        PCLBPROG
     C                   MOVEL(P)  DABIBL        PCLBBIBL
     C                   MOVEL(P)  DAUSER        PCLBUSER
     C                   MOVE      *DATE         #CDATV
     C                   MOVEL(P)  '*EUR'        #CFMTV
     C                   MOVEL(P)  '*ISO'        #CFMTN
     C                   EXSR      TRDAUM
     C                   Z-ADD     #CDATN        PCLBJDAT
     C                   TIME                    DUN060
     C                   Z-ADD     DUN060        PCLBJZEI
     C*
     C                   Z-ADD     PCLBJDAT      PCLBSEDA
     C*-------------------------------------------------------------------------
     C                   WRITE     BGFSSATZ
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  Datenatz für BGFS erstellen                                       ***
     C**************************************************************************
     C     VBGFSSP1      BEGSR
     C*
     C     LBBSSPKZ      IFEQ      'J'
     C     LBBSSPKZ      OREQ      ' '
     C     LBBSLAGB      OREQ      0
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBSD
     C     WKFENR        IFNE      *ZEROS
     C                   LEAVESR
     C                   ENDIF
     C                   MOVE      LDLBZ1        KZBUCH
     C     KZBUCH        IFNE      '*'
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVE      *BLANK        KYTEEZ
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C     WKFENR        IFNE      *ZEROS
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   BGFSSATZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  LBBSFIRM      PCLBFIRM
     C                   MOVEL(P)  LBBSTENR      PCLBTENR
     C                   MOVEL(P)  LBBSLANR      PCLBLANR
     C                   MOVEL(P)  LBBSLORT      PCLBLORT
     C                   MOVE      '00'          PCLBSTAT
     C*
     C     LBLBBWMG      IFLT      0
     C                   EVAL      PCLBBUMG = LBBSLAGB + LBLBBWMG
     C                   ELSE
     C                   EVAL      PCLBBUMG = LBBSLAGB - LBLBBWMG
     C                   ENDIF
     C*
     C*    LBBSSPKZ      IFNE      'J'
     C*    LBBSLAGB      IFLT      0
     C*                  EVAL      PCLBBUMG = LBBSLAGB * -1
     C*                  ELSE
     C*                  EVAL      PCLBBUMG = LBBSLAGB
     C*                  ENDIF
     C*                  ELSE
     C*    LBLBBWMG      IFLT      0
     C*                  EVAL      PCLBBUMG = LBLBBWMG * -1
     C*                  ELSE
     C*                  EVAL      PCLBBUMG = LBLBBWMG
     C*                  ENDIF
     C*                  ENDIF
     C*
     C                   MOVE      'ABG'         PCLBBUKZ
     C                   MOVE      'SPE'         PCLBFREX
     C*
     C*    LBLBSTMG      IFGT      *ZERO
     C*                  Z-ADD     LBLBSTMG      PCLBBUMG
     C*                  MOVE      'ZUG'         PCLBBUKZ
     C*                  MOVE      'ENS'         PCLBFREX
     C*                  ELSE
     C*    LBLBSTMG      MULT      -1            PCLBBUMG
     C*                  MOVE      'ABG'         PCLBBUKZ
     C*                  MOVE      'SPE'         PCLBFREX
     C*                  ENDIF
     C*
     C                   MOVEL(P)  'BGFS'        PCLBDANA
     C                   MOVE      *LOVAL        PCLBTMST
     C*
     C                   CALL      'EXTSTP'
     C                   PARM                    PCLBTSTP
     C*
     C                   MOVEL(P)  TEMEIN        PCLBMEIN
     C                   MOVEL(P)  TETBZ1        PCLBBEZ1
     C                   MOVEL(P)  TETBZ2        PCLBBEZ2
     C*
     C                   MOVEL(P)  LBBSCHAR      PCLBCHAR
     C*--------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        PCLBJNAM
     C                   MOVEL(P)  DAPROG        PCLBPROG
     C                   MOVEL(P)  DABIBL        PCLBBIBL
     C                   MOVEL(P)  DAUSER        PCLBUSER
     C                   MOVE      *DATE         #CDATV
     C                   MOVEL(P)  '*EUR'        #CFMTV
     C                   MOVEL(P)  '*ISO'        #CFMTN
     C                   EXSR      TRDAUM
     C                   Z-ADD     #CDATN        PCLBJDAT
     C                   TIME                    DUN060
     C                   Z-ADD     DUN060        PCLBJZEI
     C*
     C                   Z-ADD     PCLBJDAT      PCLBSEDA
     C*-------------------------------------------------------------------------
     C                   WRITE     BGFSSATZ
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  Datenatz für BGFS erstellen                                       ***
     C**************************************************************************
     C     VBGFSSP2      BEGSR
     C*
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBSD
     C     WKFENR        IFNE      *ZEROS
     C                   LEAVESR
     C                   ENDIF
     C                   MOVE      LDLBZ1        KZBUCH
     C     KZBUCH        IFNE      '*'
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVE      *BLANK        KYTEEZ
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C     WKFENR        IFNE      *ZEROS
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   BGFSSATZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  LBBSFIRM      PCLBFIRM
     C                   MOVEL(P)  LBBSTENR      PCLBTENR
     C                   MOVEL(P)  LBBSLANR      PCLBLANR
     C                   MOVEL(P)  LBBSLORT      PCLBLORT
     C                   MOVE      '00'          PCLBSTAT
     C*
     C     LBBSLAGB      IFLT      0
     C     LBBSLAGB      MULT      -1            PCLBBUMG
     C                   ELSE
     C                   Z-ADD     LBBSLAGB      PCLBBUMG
     C                   ENDIF
     C*
     C     LBBSSPKZ      IFNE      'J'
     C                   MOVE      'ZUG'         PCLBBUKZ
     C                   MOVE      'ENS'         PCLBFREX
     C                   ELSE
     C                   MOVE      'ABG'         PCLBBUKZ
     C                   MOVE      'SPE'         PCLBFREX
     C                   ENDIF
     C*
     C                   MOVEL(P)  'BGFS'        PCLBDANA
     C                   MOVE      *LOVAL        PCLBTMST
     C*
     C                   CALL      'EXTSTP'
     C                   PARM                    PCLBTSTP
     C*
     C                   MOVEL(P)  TEMEIN        PCLBMEIN
     C                   MOVEL(P)  TETBZ1        PCLBBEZ1
     C                   MOVEL(P)  TETBZ2        PCLBBEZ2
     C*
     C                   MOVEL(P)  LBBSCHAR      PCLBCHAR
     C*--------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        PCLBJNAM
     C                   MOVEL(P)  DAPROG        PCLBPROG
     C                   MOVEL(P)  DABIBL        PCLBBIBL
     C                   MOVEL(P)  DAUSER        PCLBUSER
     C                   MOVE      *DATE         #CDATV
     C                   MOVEL(P)  '*EUR'        #CFMTV
     C                   MOVEL(P)  '*ISO'        #CFMTN
     C                   EXSR      TRDAUM
     C                   Z-ADD     #CDATN        PCLBJDAT
     C                   TIME                    DUN060
     C                   Z-ADD     DUN060        PCLBJZEI
     C*
     C                   Z-ADD     PCLBJDAT      PCLBSEDA
     C*-------------------------------------------------------------------------
     C                   WRITE     BGFSSATZ
     C*-------------------------------------------------------------------------
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
     C/COPY TAMP/QCPYSRC,CHLBSD
     C/COPY TAMP/QCPYSRC,CHLBSS
     C/COPY TAMP/QCPYSRC,CHTEIL
     C/COPY TAMP/QCPYSRC,PRFIRMFIRM
     C/COPY TAMP/QCPYSRC,TRDAUM
