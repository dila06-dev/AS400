     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      *               ...
      *
      * 15. Okt.2010   GANG, MANFRED
      *
      * WAECO International GmbH
      *
      * Hollefeldstrasse 63
      *
      * 48282 Emsdetten
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************

     fabestand  uf a e           k disk

     DDate             S               D   DATFMT(*EUR)
     Djahr             S              4  0
     Dmonat            S              2  0
     Dtag              S              2  0
     DTime             S               D   DATFMT(*EUR)
     DPLZHelp          S              5A
     D#TIMESTAMP       S               z

     Dtstampi          S               Z
     Ddatum            S               D
     Dzeit             S               T
     D
     D**********************************************************************
     ****
     D***  KOMMUNIKATIONSPARAMETER
     ***
     D**********************************************************************
     D/COPY QCPYSRC,EXTRIN
     D KOM             S              1    DIM(220)                             Kommunikation
     D EXTR02        E DS
     I*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
b
     C     *ENTRY        PLIST
     C                   PARM                    TETENR           15
     C                   PARM                    LAGER             3

     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------


     C*                 update bestand
     c     key001        klist
     c                   kfld                    TETENR
     c                   kfld                    LAGER

     c     key001        chain     ABESTAND                           93
     C*  93              clear                   ABESTANDR
     C                   EXSR      sr1000
     C   93              write     ABESTANDR
     C  n93              update    ABESTANDR

     C                   EXSR      RETURN

     C**************************************************************************
     C*ermittlung
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
     C*
     C                   MOVE      *BLANK        KOM
     C                   MOVE      *ON           KOM(1)                         PRÜFUNG-KZ
     C                   MOVE      *ON           KOM(2)                         LAGERBESTAND
     C                   MOVE      *ON           KOM(3)                         LAGERRESERVIERUNG
     C                   MOVE      *OFF          KOM(4)                         DIST-RESERVIERUNG
     C                   MOVE      *OFF          KOM(5)                         KZ-BED.PLAUNGSLÄGER
     C                   MOVE      *BLANK        KOM(6)                         LAGERBEREICH
     C                   MOVE      *ON           KOM(7)                         SPERRKENNZEICHEN
     C                   MOVEA     TETENR        KOM(10)                        ARTIKEL
     C                   Z-ADD     *ZERO         DUN114
     C                   MOVEA     DUC011        KOM(86)
     C                   MOVEA     '001'         KOM(99)                        LAGERBEREICH
     C                   MOVEA     DUC008        KOM(202)                       ABGRENZUNGSDATUM
     C                   MOVEA     KOM           #CKOMM
     C                   MOVEL     *BLANK        #CPGST
     C*
     C                   CALL      'TRLBB2'
     C                   PARM                    EXTR02
     C
     C                   MOVEA     #CKOMM        KOM
     C                   MOVEA     KOM(01)       DUC013
     C                   Z-ADD     DUN134        DSLBBSIDBS       13 4          GES-BESTAND
     C                   Z-ADD     DSLBBSIDBS    BESTAND                        GES-BESTAND
     C                   MOVEA     KOM(92)       DUC013
     C                   Z-ADD     DUN134        DSLBBSRSBE       13 4          RESERV-BSTD
     C                   Z-ADD     DSLBBSRSBE    RESERV                         RESERV-BSTD
     C
     C*                  Z-ADD     WKLAGB        DUN134                         LAGERBESTAND
     C*                  MOVEA     DUC013        KOM(1)
     C*                  Z-ADD     WKSIBE        DUN134                         SICHERHEITSBESTD.
     C*                  MOVEA     DUC013        KOM(14)
     C*                  Z-ADD     WKDUMO        DUN134                         DURCHNITTSVERBRAUCH
     C*                  MOVEA     DUC013        KOM(27)
     C*                  Z-ADD     WKRESN        DUN134                         RESERVIERUNG-NORMAL
     C*                  MOVEA     DUC013        KOM(40)
     C*                  Z-ADD     WKRESS        DUN134                         RESERVIERUNG-SONDER
     C*                  MOVEA     DUC013        KOM(53)
     C*                  Z-ADD     WKBESN        DUN134                         BESTELLBEST.-NORMAL
     C*                  MOVEA     DUC013        KOM(66)
     C*                  Z-ADD     WKBESS        DUN134                         BESTELLBEST.-SONDER
     C*                  MOVEA     DUC013        KOM(79)
     C*                  Z-ADD     WKRESL        DUN134                         RESERVIERUNG-LAGER
     C*                  MOVEA     DUC013        KOM(92)
     C*                  Z-ADD     WKCHMG        DUN134                         CHARGENMENGE
     C*                  MOVEA     DUC013        KOM(105)
     C*                  Z-ADD     WKKMMG        DUN134                         KOMMISSIONIERMENGE
     C*                  MOVEA     DUC013        KOM(118)
     C*                  Z-ADD     WKMXBS        DUN134                         LAGERPALTZBESTAND
     C*                  MOVEA     DUC013        KOM(131)                       MIX-LAGERUNG ANZAHL
     C*                  Z-ADD     WKSPBS        DUN134
     C*                  MOVEA     DUC013        KOM(144)                       GESPERRTER BESTAND
     C*                  Z-ADD     WKAZRL        DUN134
     C*                  MOVEA     DUC013        KOM(157)                       ANZAHL ROLLEN
     C*                  Z-ADD     WKRSRL        DUN134
     C*                  MOVEA     DUC013        KOM(170)                       ANZAHL RES. ROLLEN
     C*                  MOVEA     WKLBBS        KOM(183)                       BESTAND JA/NEIN
     C*                  Z-ADD     WKAZGB        DUN100
     C*                  MOVEA     DUC010        KOM(184)                       ANZAHL GEBINDE
     C*                  MOVEA     WKLANR        KOM(194)
     C*                  MOVEA     WKBSLA        KOM(197)
     C*                  Z-ADD     WKGWNT        DUN134
     C*                  MOVEA     DUC013        KOM(200)                       NETTOGEWICHT
     C*                  Z-ADD     WKRESP        DUN071
     C*                  MOVEA     DUC007        KOM(213)                       RES-PLANBEDARF
     C*
     C     ##1000        ENDSR

     C*-------------------------------------------------------------------------
     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr9999        BEGSR
     C*

     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   gang/systempf
     c/end-exec

     C     ##9999        ENDSR

     C*-------------------------------------------------------------------------

     C     *inzsr        BEGSR
      *

     C                   TIME                    Date
     c                   extrct    date:*Y       jahr
     c                   extrct    date:*M       monat
     C                   extrct    date:*D       tag

     c                   CLEAR                   ATR
     c                   CALL      '#MODATR'                            97
     c                   PARM                    ATR
     C                   ENDSR

     C**************************************************************************
     C* PROGRAMM VERLASSEN
     C*-------------------------------------------------------------------------
     C*
     C     RETURN        BEGSR
     C                   MOVE      '1'           *INLR
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C*
     C**************************************************************************
