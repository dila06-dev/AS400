     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H**************************************************************************
     H/TITLE Übernahme IST-Werte
     F**************************************************************************
     F*
     F*  Dieses Programm übernimmt die IST-Werte Periode 08-12/2010
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FUMSABSALT IF   E             DISK
     F                                     RENAME(UMSABSALT:UMSABSALT1)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRBR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TVAM          E DS                  INZ
     D KYTVAM        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D*
     D EXTVAM        E DS                  INZ
     D RTTVAM        E DS                  INZ
     D*
     D**************************************************************************
     D***  DATENSTATIONSARBEITSBEREICH                                       ***
     D**************************************************************************
     D EXTRLD        EUDS
     D*
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D  WKTDAT                         D   DATFMT(*ISO) INZ
     D*
     D**************************************************************************
     D***  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
     D**************************************************************************
     D/COPY QCPYSRC,EXPSDS
     D*
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKI000        CASNE     *ON           ANFANG
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C     WKTRPA        CASNE     *ON           ETRPA
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   EXSR      VTVAM
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           *INLR
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
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYVMFI                         TVAM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUF                                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C                   MOVEL     *ON           WKTRPA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'JAHR'        KYTATC
     C                   MOVEL(P)  'BILANZ'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL     TAPCDE        DUC004
     C*
     C     DUC004        IFLE      *ZERO
     C                   Z-ADD     3112          DUN040
     C                   ENDIF
     C*
     C                   MOVE      DUC004        WKTRPAMONA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SPEICHERN ERHÜHUNGSTABELLE <- KD-STEUERUNGS-CODE/PRODUKT-GRUPPE   ***
     C**************************************************************************
     C     VTVAM         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          *IN
     C*-------------------------------------------------------------------------
     C     *IN(98)       DOWEQ     *OFF
     C     *IN(99)       ANDEQ     *OFF
     C*-------------------------------------------------------------------------
     C                   READ      UMSABSALT1                           9899
     C*
     C     *IN(98)       IFEQ      *ON
     C     *IN(99)       OREQ      *ON
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Ermitteln Masseneinheit aus dem Ident-Stamm
     C*-------------------------------------------------------------------------
     C                   MOVEL     KCJ040        KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*-------------------------------------------------------------------------
     C     1             DO        12            I0
     C                   SELECT
     C     I0            WHENEQ    01
     C                   Z-ADD     KCJ070        DUN090
     C                   Z-ADD     JAN           DUN112
     C     I0            WHENEQ    02
     C                   Z-ADD     KCJ080        DUN090
     C                   Z-ADD     FEB           DUN112
     C     I0            WHENEQ    03
     C                   Z-ADD     KCJ090        DUN090
     C                   Z-ADD     MRZ           DUN112
     C     I0            WHENEQ    04
     C                   Z-ADD     KCJ100        DUN090
     C                   Z-ADD     APR           DUN112
     C     I0            WHENEQ    05
     C                   Z-ADD     KCJ110        DUN090
     C                   Z-ADD     MAI           DUN112
     C     I0            WHENEQ    06
     C                   Z-ADD     KCJ120        DUN090
     C                   Z-ADD     JUN           DUN112
     C     I0            WHENEQ    07
     C                   Z-ADD     KCJ130        DUN090
     C                   Z-ADD     JUL           DUN112
     C     I0            WHENEQ    08
     C                   Z-ADD     KCJ140        DUN090
     C                   Z-ADD     AUG           DUN112
     C     I0            WHENEQ    09
     C                   Z-ADD     KCJ150        DUN090
     C                   Z-ADD     SEP           DUN112
     C     I0            WHENEQ    10
     C                   Z-ADD     KCJ160        DUN090
     C                   Z-ADD     OKT           DUN112
     C     I0            WHENEQ    11
     C                   Z-ADD     KCJ170        DUN090
     C                   Z-ADD     NOV           DUN112
     C     I0            WHENEQ    12
     C                   Z-ADD     KCJ180        DUN090
     C                   Z-ADD     DEV           DUN112
     C                   ENDSL
     C*
     C     DUN090        IFNE      *ZERO
     C     DUN112        ORNE      *ZERO
     C                   EXSR      UTVAM
     C                   ENDIF
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          *IN
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI TVAM                                                 ***
     C**************************************************************************
     C     UTVAM         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     'ST2'         KYVMBG
     C                   MOVEL     '001'         KYVMWK
     C                   Z-ADD     KCJ020        DUN060
     C                   MOVEL     DUC006        KYVMKD
     C                   MOVEL     KCJ040        KYVMTE
     C                   Z-ADD     KCJ050        KYVMJH
     C                   Z-ADD     I0            KYVMMO
     C                   SELECT
     C     TEMEVK        WHENNE    *BLANK
     C                   MOVEL     TEMEVK        KYVMME
     C     TEMEIN        WHENNE    *BLANK
     C                   MOVEL     TEMEIN        KYVMME
     C                   OTHER
     C                   MOVEL     'S'           KYVMME
     C                   ENDSL
     C                   MOVEA     '01CU    '    CHI                            LESEN FÜR
     C                   EXSR      CHTVAM                                       UPDATE
     C*-------------------------------------------------------------------------
     C                   ADD       DUN090        VMMGST
     C                   ADD       DUN112        VMWTST
     C*-------------------------------------------------------------------------
     C* Ermitteln Geschäftsjahr/Geschäftsmonat
     C*-------------------------------------------------------------------------
     C     WKTRPAMONA    IFEQ      12
     C                   Z-ADD     KYVMMO        VMGEMO
     C                   Z-ADD     KYVMJH        VMGEJH
     C                   ELSE
     C     KYVMMO        SUB       WKTRPAMONA    VMGEMO
     C     VMGEMO        IFLE      *ZERO
     C                   ADD       12            VMGEMO
     C                   ENDIF
     C*
     C                   MOVE      KYVMJH        VMGEJH
     C     KYVMMO        IFLE      WKTRPAMONA
     C     KYVMJH        SUB       1             VMGEJH
     C                   ENDIF
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        VMJNAM
     C                   MOVEL(P)  DAPROG        VMPROG
     C                   MOVEL(P)  WKCHPL        VMBIBL
     C                   MOVEL(P)  DAUSER        VMUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        VMJZEI
     C                   MOVE      WKTDAT        VMJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHTVAM
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHTVAM
     C*--------------------------------------------------------
     C                   ENDSL
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
     C*--------------------------------------------------------
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
     C     *LIKE         DEFINE    RTTVAMPROG    WKPROG
     C     *LIKE         DEFINE    RTTVAMDANA    WKDANA
     C     *LIKE         DEFINE    RTTVAMFFLD    WKFFLD
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    VMMONA        WKTRPAMONA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTVAM
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
