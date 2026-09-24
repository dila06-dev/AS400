     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*                                                          *
     F*      gang                                                *
     F*                                                          *
     F************************************************************
     F* PROGRAMMFUNKTION:                                        *
     F************************************************************

     fLBBS01    ip   e             disk

     fkalk_file2if   e           k disk
     fsystempf  if   e           k disk
     fTEIL00    if   e           k disk

     D*Date             S               D   DATFMT(*ISO)

     DDate             S               D   DATFMT(*YMD)
     Dpjahr            S              2
     Dpmonat           S              2
     Dptag             S              2
     Dvj_jahr          S              4  0
     Dnxt_jahr         S              4  0
     Dkey_jahr         S              4  0

     Dtstampi          S               Z
     Ddatum            S               D
     Dzeit             S               T
     I*-------------------------------------------------------------------------

     * PROGRAMM-call-DATENSTRUKTUR
     D CALLPGM         DS
     D  TYP                    1      1    inz
     D  BUCDAT                 2      9  0 inz
     D  WENR                  10     23  0 inz
     D  BELNUM                24     34  0 inz
     D  LIFNR                 35     45  0 inz
     D  HANR                  46     56    inz
     D  BSTNUM                57     63  0 inz
     D  BSTPOS                64     67  0 inz
     D  KSTSTL                68     74  0 inz
     D  KUNDNR                75     81  0 inz
     D  AFTNUM                82     92  0 inz
     D  AFTPOS                93     96  0 inz
     D  BUCKEY                97     98    inz
     D  ARTNUM                99    109  0 inz
     D  ARTNUMVAR            110    113  0 inz
     D  VARTYP               114    114    inz
     D  LO                   115    122    inz
     D  LO2                  123    130    inz
     D  ENH                  131    135    inz
     D  MNG                  136    147  4 inz
     D  ABM1                 148    158  2 inz
     D  ABM2                 159    169  2 inz
     D  ABM3                 170    180  2 inz
     D  ABMENH               181    183    inz
     D  ERG                  184    194  2 inz
     D  ERGENH               195    197    inz
     D  MNG2                 198    209  4 inz
     D  LOIST                210    217    inz
     D  LOIST2               218    225    inz
     D  ENHIST               226    230    inz
     D  MNGIST               231    242  4 inz
     D  MNGIST2              243    254  4 inz
     D  LOAVW                255    259    inz
     D  MNGAVW               260    271  4 inz
     D  BUCTXT               272    296    inz
     D  ERRCDE               297    298    inz
     D  ERRTXT               299    377    inz
     D  STAINP               378    378    inz
     D  KONKNZ               379    379    inz
     D  KUNKNZ               380    380    inz
     D  MVKNZ                381    384    inz
     D  CHARGE               385    404    inz

     C*-------------------------------------------------------------------------

     C     *ENTRY        PLIST
     C                   PARM                    #version         10
     C                   PARM                    rtncode           1
     C                   PARM                    modus             1

     C* --------------------------------------------------

     c                   if        LBBSFIRM = '01'
      *
     c     KEY1000       klist
     c                   kfld                    #version
     c                   kfld                    LBBSTENR
     C*
      *                 Kalk_file2                                            
     c     KEY1000       chain     kalk_file2
     c                   IF        %found(kalk_file2)
     c                   seton                                        40
     c                   exsr      SR9810
     c                   setoff                                       40
     c                   else
     c                   seton                                        40
     c                   add       1             #sku             10 0
     c                   movel     #sku          artsku
     c                   exsr      SR9810
     c                   setoff                                       40
     c                   ENDIF
     c
     c                   endif

     C**************************************************************************
     C* SR1500:
     C*-------------------------------------------------------------------------

     C     SR1500        BEGSR
     C*
     C
     C*
     C     ##1500        ENDSR

     C**************************************************************************
     C* sr2000: Mengeneinheiten   LBLBMEIN  immer *blank?
     C*-------------------------------------------------------------------------
     C*
     C     SR2000        BEGSR
     c
     c* TEIL-Satz lesen
     c     teilkey       klist
     c                   kfld                    firma
     c                   kfld                    artnr
     c
     c                   if        LBBSMEIN  = *blank
     c     teilkey       chain     TEIL1
     c                   IF        %found(TEIL00)
     c
      *                 Ident-Nr         ME      MEEKP   MEEK                 
      *                 172410050        D       D       M                    
      *                                  temein, tempek, temeek               
     C                   movel     temein        LBBSMEIN
     c                   endif
     c                   endif
     c
     C                   clear                   enh
     C                   select
     C                   when      LBBSMEIN = 'S'
     C                   movel     'ST'          enh
     C                   when      LBBSMEIN = 'D'
     C                   movel     'DM'          enh
     C                   when      LBBSMEIN = 'M'
     C                   movel     'M '          enh
     C                   when      LBBSMEIN = 'Z'
     C                   movel     'CM'          enh
     C                   when      LBBSMEIN = 'K'
     C                   movel     'KG'          enh
     C                   when      LBBSMEIN = 'G'
     C                   movel     'G '          enh
     C                   other
     C                   movel     'ST'          enh
     C                   endsl
     C*
     C     ##2000        ENDSR
     C*
     C**************************************************************************
     C* sr2001: Bewegungsabhängige Buchungsinformationen
     C*-------------------------------------------------------------------------
     C*
     C     SR2001        BEGSR
     C*
     C*                  *defauld - Werte (vorerst)
     C*                  *
     c                   Z-ADD     LBBSLAGB      mng
     C*
     C     ##2001        ENDSR
     C*
     C**************************************************************************
     C* SR9800: lesen Parameterdaten aus DometicSystemdatei
     C*-------------------------------------------------------------------------
     C*
     C     SR9800        BEGSR
     C*
     C     KEY9800       KLIST
     C                   KFLD                    $key1
     C                   KFLD                    $key2
     C                   KFLD                    $key3
     C*
     c     KEY9800       chain     systempf
     c                   IF        %found(systempf)
     c*
     c                   ENDIF
     C*
     C     ##9800        ENDSR
     C*
     C**************************************************************************
     C* SR9810: Call auf Buchungsprogramm
     C*-------------------------------------------------------------------------
     C*
     C     SR9810        BEGSR
     C*
     C                   setoff                                       50
     C*
     c   40              movel     'I'           TYP
     c   40              movel     'IA'          BUCKEY
     c   40              movel     LBBSLORT      LO
     c   40              move      ARTSKU        #ARTNUM          11
     c*  40              movel     '0'           #ARTNUM          11
     c   40              movel     #ARTnum       ARTNUM
     c                   if        LBBSLORT  = *blank
     c   40              movel     '000 #000'    LO
     c   40              movel     LBBSLANR      LO
     c                   endif
     C*
     C                   exsr      SR2000
     C                   exsr      SR2001
     C*
     c                   move      '09/12/31'    xxxx              8
     c*                  move      xxxx          Date
     C                   TIME                    Date
     c                   move      '09/12/31'    Date
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag
     C                   clear                   #d                8
     C                   eval      %subst(#d: 3: 2)    = pjahr
     C                   eval      %subst(#d: 5: 2)    = pmonat
     C                   eval      %subst(#d: 7: 2)    = ptag
     C                   eval      %subst(#d: 1: 2)    = '00'
     C*
     c                   move      #d            BUCDAT
     c                   movel     LBBSTENR      BUCTXT
     c                   movel     LBBSTENR      HANR
     C                   eval      %subst(BUCTXT: 17: 09) =
     C                             'Übernahme'
     C*
     c                   call      'PRJ522U2'
     c                   parm                    callpgm
     c                   clear                   callpgm
     c*
     C     ##9810        ENDSR
     C*
     C*-------------------------------------------------------------------------
     C     *inzsr        BEGSR
     c                   move      '01'          firma             2
     c                   movel     'LP1'         begr              3
     c                   z-add     0000500000    #sku             10 0

     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   kalk_file
     c/end-exec
     C                   TIME                    Date
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag
     C                   clear                   #d                8
     C                   eval      %subst(#d: 3: 2)    = pjahr
     C                   eval      %subst(#d: 5: 2)    = pmonat
     C                   eval      %subst(#d: 7: 2)    = ptag
     C                   eval      %subst(#d: 1: 2)    = '00'
     C                   ENDSR

      ************************************************************
      * LAGERBUCHUNG PARAMETER
      ************************************************************
      *01  LNK538.
      *    02     TYP         PIC X.
      *                           I=INTERAKTIV  BUCHEN
      *                           B=BATCH       BUCHEN
      *                           O=FILE OPEN
      *                           C=FILE CLOSE
      *                           -+ VORZEICHEN AUS JAVA
      *    02     BUCDAT      PIC 9(8).
      *                           BUCHUNGSDATUM 00JJMMTT
      *    02     WENR        PIC 9(14).
      *                           WARENEINGANGSNUMMER + KONTEIERUNG
      *    02     BELNUM      PIC 9(11).
      *                           AUFTRAGSBELEG
      *    02     LIFNR       PIC 9(11).
      *    02     HANR        PIC X(11).
      *    02     BSTNUM      PIC 9(7).
      *    02     BSTPOS      PIC 9(4).
      *    02     KSTSTL      PIC 9(7).
      *    02     KUNDNR      PIC 9(7).
      *    02     AFTNUM      PIC 9(11).
      *    02     AFTPOS      PIC 9(04).
      *    02     BUCKEY      PIC X(02).
      *                           I  =INVENTUR ZUR LAUFZEIT
      *                           Z  =ZUGANG VON LIEFERANT
      *                           N  =EINHEIETNUMRECHNUNG
      *                           U  =UMBUCHUNG
      *                           FA =FERTIGUNGSABGANG
      *                           FZ =FERTIGUNGSZUGANG
      *                           LA =ABGANG AN LIEFERANT
      *                           LU =LIEFERANTENBEREITSTELLUNG
      *                           LV =LIEFERANTENVERBRAUCH
      *                           II = INVENTUR ZUM STICHTAG
      *                           IA = ÜBERNAHME AUS ALTSYSTEM
      *                           KA = ABGANG AN KUNDEN
      *                           KE = RÜCKNAHME VOM KND
      *    02     ARTNUM      PIC 9(11).
      *    02     ARTNUMVAR   PIC 9(04).
      *    02     VARTYP      PIC X.
      *    02     LO          PIC X(8).
      *                       LAGERORT      ANFORDERUNG
      *    02     LO2         PIC X(8).
      *                       LAGERORT      ANFORDERUNG DER UMBUCHUNG
      *    02     ENH         PIC X(5).
      *                       MENGENEINHEIT ANFORDERUNG
      *    02     MNG         PIC S9(8)V9(4).
      *                       MENGE         ANFORDERUNG
      *    02     ABM1        PIC S9(9)V9(2).
      *    02     ABM2        PIC S9(9)V9(2).
      *    02     ABM3        PIC S9(9)V9(2).
      *    02     ABMENH      PIC XXX.
      *    02     ERG         PIC S9(9)V9(2).
      *    02     ERGENH      PIC XXX.
      *                       MENGE         ANFORDERUNG
      *    02     MNG2        PIC S9(8)V9(4).
      *                       MENGE         ANFORDERUNG UMBUCHUNG
      *    02     LOIST       PIC X(8).
      *                       LAGERORT      IST
      *    02     LOIST2      PIC X(8).
      *                       LAGERORT      IST         DER UMBUCHUNG
      *    02     ENHIST      PIC X(5).
      *                       MENGENEINHEIT IST
      *    02     MNGIST      PIC S9(8)V9(4).
      *                       MENGE         IST
      *    02     MNGIST2     PIC S9(8)V9(4).
      *                       MENGE         IST         UMBUCHUNG
      *    02     LOAVW       PIC X(5).
      *                       ORT DER AVW-BUCHUNG
      *    02     MNGAVW      PIC S9(8)V9(4).
      *                       MENGE         IST AVW     IN STÜCK
      *    02     BUCTXT      PIC X(25).
      *                       BUCHUNGSVERMERK
      *    02     ERRCDE      PIC XX.
      *                       FEHLERCODE '  '=OK
      *    02     ERRTXT      PIC X(79).
      *                       FEHLERTEXT
      *    02     STAINP      PIC X(01).
      *                       FERTIGUNGSSTAUS
      *    02     KONKNZ      PIC X.
      *                       KONSIGNATIONSBEWEGUNG
      *    02     KUNKNZ      PIC X.
      *                       KUNDENWARE
      *                       MEHRFACHBELEGUNG
      *                       1= OHNE DATUMSCHECK
      *    02     MVKNZ       PIC X(04).
      *    02     CHARGE      PIC X(20).
