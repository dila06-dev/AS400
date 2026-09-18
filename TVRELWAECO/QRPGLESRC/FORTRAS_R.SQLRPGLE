     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*                                                          *
     F************************************************************
     F*  PROGRAMMFUNKTION:                                       *
     F*                                                          *
     F*  SC     Schnittstelle                                    *
     F*  test:  trdsz/spedh0                                     *
     F************************************************************
     H*datfmt(*iso) timfmt(*iso)
     H*datfmt(*eur) timfmt(*eur)

     f*SPEDH0    ip   e             disk    RENAME(SPEDH01:sped)
     fSPEDk0    ip   e             disk    RENAME(SPEDk01:sped)
     F                                     INFDS(DSF1)

     fFORTRAS   uf a f 0512        disk


     D*-------------------------------------------------------------------------
     D*Date             S               D   DATFMT(*EUR)
     DDate             S               D   DATFMT(*ISO)
     Djahr             S              4  0
     Dmonat            S              2  0
     Dtag              S              2  0
     Dstunde           S              2  0
     Dminute           S              2  0
     Dsekunde          S              2  0
     DTime             S               D   DATFMT(*EUR)
     DPLZHelp          S              5A
     D#TIMESTAMP       S               z

     Dtstampi          S               Z
     Ddatum            S               D
     Dzeit             S               T

     D comp            DS
     D  comp1                  1     20    INZ('Dometic WAECO Intern')
     D  comp2                 21     35    INZ('ational GmbH   ')
     D plz             DS
     D  plz1                   1     09    INZ('48282    ')
     D ort             DS
     D  ort1                   1     20    INZ('Emsdetten           ')
     D  ort2                  21     35    INZ('               ')
     D str             DS
     D  str1                   1     20    INZ('Hollefeldstr. 63    ')
     D  str2                  21     35    INZ('               ')
     D lkz             DS
     D  lkz1                   1      3    INZ('D  ')
     D startlox        DS
     D  startlox1              1     20    INZ('@@PHBORD512 05120035')
     D  startlox2             21     41    INZ('00107 DOMETIC LOXX000')
     D endelox         DS
     D  endelox1               1     20    INZ('@@PT                ')
     D  endelox2              21     41    INZ('                     ')
     D startloxk       DS
     D  startlox3              1     20    INZ('@@PHBORD512 05120035')
     D  startlox4             21     41    INZ('00107 132970  KOCHMBH')

     D*-----------Record -------------------------------------------------------
     d*d_record      E DS                  INZ
     D*                                    prefix('#')
     D*-------------------------------------------------------------------------
     D DSF1            DS
     D  F1STS                 11     15  0
     D  F1RRN                397    400B 0
     D*-------------------------------------------------------------------------
     DFORTRASR#        DS
     DFORTRASR                 1   0512
     I*-------------------------------------------------------------------------
     I/COPY ##E

     I*-------------------------------------------------------------------------
     C*Satzart A00 Sendungsdaten Kopf Satz
     C*Häufigkeit: pro Datei einmal
     C*Modalität:  muss
     IFORTRAS   kf  01   01 cA   02 c0   03 c0
     I                             A  001  003  A00SATZART
     I                             A  004  006  A00QUALIF
     I                             A  007  009  A00RELEASE
     I                             A  010  044  A00BORDNR
     I                             A  045  052  A00BORDDAT
     I                             A  053  055  A00VERKEHR
     I                             A  056  058  A00PRODUKT
     I                             A  059  061  A00CODELIS
     I                             A  062  064  A00WAHRUNG
     I                             A  065  099  A00IDENT_V
     I                             A  100  134  A00IDENT_E
     I                             A  135  169  A00FF
     I                             A  170  172  A00FFLAND
     I                             A  173  181  A00FFPLZ
     I                             A  182  216  A00FFORT
     I                             A  217  251  A00KFZKZ1
     I                             A  252  286  A00KFZKZ2
     I                             A  287  321  A00WEITER1
     I                             A  322  356  A00WEITER2
     I                             A  357  382  A00TSTAMP
     I                             A  001  356  A00
     I*
     C*Satzart A10 Ladeeinheitensatz
     C*Häufigkeit: pro Datei einmal
     C*Modalität:  muss bei Datenart STD, sons optional
     I          kf  02   01 cA   02 c1   03 c0
     I                             A  001  003  A10Satzart
     I                             A  004  038  A10LadeEH1
     I                             A  039  073  A10Plombe1
     I                             A  074  108  A10Plombe2
     I                             A  109  143  A10Plombe3
     I                             A  144  178  A10Plombe4
     I                             A  179  213  A10LadeEH2
     I                             A  214  248  A10Plombe1
     I                             A  249  283  A10Plombe2
     I                             A  284  318  A10Plombe3
     I                             A  319  353  A10Plombe4
     I                             A  354  379  A10TSTAMP
     I                             A  001  353  A10
     I*
     C*Satzart B00 Adressen
     C*Häufigkeit: je sendung pro Qualifier einmalig
     C*Modalität:  muss bei jeder Sendung
     I          kf  03   01 cB   02 c0   03 c0
     I                             A  001  003  B00Satzart
     I                             A  004  006  B00BorderP
     I                             A  007  009  B00Qualif
     I                             A  010  044  B00Name_1
     I                             A  045  079  B00STR_NR
     I                             A  080  082  B00LKZ
     I                             A  083  091  B00PLZ1
     I                             A  092  126  B00Ort1
     I                             A  127  161  B00KundeNR
     I                             A  162  196  B00Name_2
     I                             A  197  231  B00Name_3
     I                             A  232  266  B00Ortstei
     I                             A  267  301  B00ILN3
     I                             A  302  336  B00Zoll_Id
     I                             A  337  362  B00TSTAMP
     I                             A  001  336  B00
     I
     C*Satzart B10 Kommunikationsparameter
     C*Häufigkeit:pro B00 Satz bis 9 mal
     C*Modalität:  kann
     I          kf  04   01 cB   02 c1   03 c0
     I                             A  001  003  B10Satzart
     I                             A  004  006  B10BorderP
     I                             A  007  009  B10Qualifi
     I                             A  010  265  B10KommInh
     I                             A  266  291  B10TSTAMP
     I                             A  001  265  B10
     I
     C*Satzart C00 Zollangaben
     C*Häufigkeit: je Sendung einmal
     C*Modalität:  kann
     I          kf  05   01 cC   02 c0   03 c0
     I                             A  001  003  C00Satzart
     I                             A  004  006  C00BorderP
     I                             A  007  009  C00Zollart
     I                             A  010  013  C00Zollver
     I                             A  014  021  C00Zollamt
     I                             A  022  024  C00Hkulnd
     I                             A  025  027  C00Ursplnd
     I                             A  028  030  C00Verslnd
     I                             A  031  033  C00Bestlnd
     I                             A  034  036  C00Bestbun
     I                             A  037  039  C00LndEinf
     I                             A  040  042  C00Statsta
     I                             A  043  077  C00Liefort
     I                             A  078  086  C00Grenzwt
     I                             A  087  089  C00Wahrung
     I                             A  090  092  C00ArtGesc
     I                             A  093  095  C00Verkzwg
     I                             A  096  098  C00InlVerk
     I                             A  099  106  C00EgZolls
     I                             A  107  116  C00VorpapA
     I                             A  117  141  C00Vorpap#
     I                             A  142  147  C00Anlart1
     I                             A  148  167  C00Anl#1
     I                             A  168  175  C00Anldat1
     I                             A  176  181  C00Anlart2
     I                             A  182  201  C00Anl#2
     I                             A  202  209  C00Anldat2
     I                             A  210  215  C00Anlart3
     I                             A  216  235  C00Anl#3
     I                             A  236  243  C00Anldat3
     I                             A  244  269  C00TSTAMP
     I                             A  001  243  C00
     I
     C*Satzart D00 Sendungsposition
     C*Häufigkeit: je Sendung maximal 999 mal
     C*Modalität:  muss
     I          kf  06   01 cD   02 c0   03 c0
     I                             A  001  003  D00Satzart
     I                             A  004  006  D00BorderP
     I                             A  007  009  D00SndPos
     I                             A  010  013  D00PackstA
     I                             A  014  016  D00VerpArt
     I                             A  017  020  D00PackstA
     I                             A  021  023  D00VPart
     I                             A  024  058  D00Inhalt
     I                             A  059  093  D00Zeichen
     I                             A  094  102  D00Gewicht
     I                             A  103  111  D00FRAGEW
     I                             A  112  115  D00LaengeM
     I                             A  116  119  D00BreiteM
     I                             A  120  123  D00HoeheM
     I                             A  124  128  D00Kubikm
     I                             A  129  131  D00Ladem
     I                             A  132  135  D00AnzahlP
     I                             A  136  160  D00TSTAMP
     I                             A  001  135  D00
     I
     C*Satzart D10 Zollangaben der Position
     C*Häufigkeit: je D00 99 mal
     C*Modalität:  kann
     I          kf  07   01 cD   02 c1   03 c0
     I                             A  001  003  D10Satzart
     I                             A  004  006  D10BorderP
     I                             A  007  009  D10SndPos
     I                             A  010  024  D10Warennummer
     I                             A  025  027  D10Ursplnd
     I                             A  028  036  D10Rohm
     I                             A  037  045  D10Eigenm
     I                             A  046  050  D10Verfcod
     I                             A  051  061  D10Zollwert
     I                             A  062  064  D10WZollwer
     I                             A  065  075  D10StatWrt
     I                             A  076  078  D10WstatWr
     I                             A  079  084  D10Anlag1
     I                             A  085  104  D10Anlag#1
     I                             A  105  112  D10Anlagd1
     I                             A  113  118  D10Anlag2
     I                             A  119  138  D10Anlag#2
     I                             A  139  146  D10Anlagd2
     I                             A  147  152  D10Anlag3
     I                             A  153  172  D10Anlag#3
     I                             A  173  180  D10Anlagd3
     I                             A  181  186  D10Anlag4
     I                             A  187  206  D10Anlag#4
     I                             A  207  214  D10Anlagd4
     I                             A  215  240  D10TSTAMP
     I                             A  001  214  D10
     I*
     C*Satzart E00 Gefahrgutsatz
     C*Häufigkeit: je D00 99 mal
     C*Modalität:  kann
     I          kf  08   01 cE   02 c0   03 c0
     I                             A  001  003  E00Satzart
     I                             A  004  006  E00BorderP
     I                             A  007  009  E00SndPos
     I                             A  010  012  E00GGRelP
     I                             A  013  016  E00PackAnz
     I                             A  017  025  E00BGewkg
     I                             A  026  029  E00UN_#MP
     I                             A  030  064  E00VrpDesc
     I                             A  065  068  E00MultMP
     I                             A  069  071  E00IdGGDB
     I                             A  072  081  E00UniqKey
     I                             A  082  291  E00Stoffna
     I                             A  292  361  E00Zusext
     I                             A  362  364  E00GfZMst
     I                             A  365  367  E00GfZMst1
     I                             A  368  370  E00GfZMst2
     I                             A  371  373  E00GfZMst3
     I                             A  374  377  E00VpGrpP
     I                             A  378  386  E00Nettexp
     I                             A  387  387  E00BefKat
     I                             A  388  388  E00LimQty
     I                             A  389  397  E00Punkte
     I                             A  398  423  E00TSTAMP
     I                             A  001  397  E00
     I*
     C*Satzart F00 Barcodes und Referenzen
     C*Häufigkeit: je F00 999 mal
     C*Modalität:  kann
     I          kf  09   01 cE   02 c0   03 c0
     I                             A  001  003  F00Satzart
     I                             A  004  006  F00BorderP
     I                             A  007  009  F00SndPos
     I                             A  010  044  F00Barcode
     I                             A  045  047  F00QualRe1
     I                             A  048  082  F00Ref#kg1
     I                             A  083  085  F00QualRe2
     I                             A  086  120  F00Ref#kg2
     I                             A  121  123  F00QualRe3
     I                             A  124  158  F00Ref#kg3
     I                             A  159  161  F00QualRe4
     I                             A  162  196  F00Ref#kg4
     I                             A  197  199  F00Qualre5
     I                             A  200  234  F00Ref#kg5
     I                             A  235  260  F00TSTAMP
     I                             A  001  234  F00
     I*
     C*Satzart G00 Sendungsnummern
     C*Häufigkeit: je Sendung ein mal
     C*Modalität:  m u s s
     I          kf  10   01 cG   02 c0   03 c0
     I                             A  001  003  G00Satzart
     I                             A  004  006  G00BorderP
     I                             A  007  041  G00TSTAMPt
     I                             A  042  050  G00BruttoG
     I                             A  051  053  G00Frankat
     I                             A  054  054  G00DirZU
     I                             A  055  062  G00Abdate
     I                             A  063  066  G00Abtimea
     I                             A  067  070  G00abtimeb
     I                             A  071  076  G00logmod
     I                             A  077  111  G00sndempf
     I                             A  112  146  G00border1
     I                             A  147  181  G00border2
     I                             A  182  184  G00wgrp
     I                             A  185  195  G00wwert
     I                             A  196  198  G00Waehru
     I                             A  199  207  G00gewFrac
     I                             A  208  212  G00ccm
     I                             A  213  215  G00ladem
     I                             A  216  219  G00PallAnz
     I                             A  220  221  G00ladehm1
     I                             A  222  224  G00ladevA1
     I                             A  225  226  G00ladehm2
     I                             A  227  229  G00ladevA2
     I                             A  230  255  G00TSTAMP
     I                             A  001  229  G00
     I*
     C*Satzart H00 Textschlüssel
     C*Häufigkeit: je Sendung 4 mal
     C*Modalität:  kann
     I          kf  11   01 cH   02 c0   03 c0
     I                             A  001  003  H00Satzart
     I                             A  004  006  H00BorderP
     I                             A  007  009  H00tkey01
     I                             A  010  044  H00text01
     I                             A  045  047  H00tkey02
     I                             A  048  082  H00text02
     I                             A  083  085  H00tkey03
     I                             A  086  120  H00text03
     I                             A  121  123  H00tkey04
     I                             A  124  158  H00text04
     I                             A  159  161  H00tkey05
     I                             A  162  196  H00text05
     I                             A  197  199  H00tkey06
     I                             A  200  234  H00text06
     I                             A  235  260  H00TSTAMP
     I                             A  001  234  H00
     I*
     C*Satzart H10 Textschlüssel
     C*Häufigkeit: je Sendung 9 mal
     C*Modalität:  kann
     I          kf  12   01 cH   02 c1   03 c0
     I                             A  001  003  H10Satzart
     I                             A  004  006  H10BorderP
     I                             A  007  009  H10tkey01
     I                             A  010  079  H10text01
     I                             A  080  082  H10tkey02
     I                             A  083  152  H10text02
     I                             A  153  155  H10tkey03
     I                             A  156  225  H10text03
     I                             A  226  251  H10TSTAMP
     I                             A  001  225  H10
     I*
     C*Satzart I00 Leistungsarten
     C*Häufigkeit: je Sendung 9 mal
     C*Modalität:  kann
     I          kf  13   01 cI   02 c0   03 c0
     I                             A  001  003  I00Satzart
     I                             A  004  006  I00BorderP
     I                             A  007  009  I00Lkey01
     I                             A  010  010  I00tax01
     I                             A  011  019  I00Betra01
     I                             A  020  022  I00Lkey02
     I                             A  023  023  I00tax02
     I                             A  024  032  I00Betra02
     I                             A  033  035  I00Lkey03
     I                             A  036  036  I00tax03
     I                             A  037  045  I00Betra03
     I                             A  046  048  I00Lkey04
     I                             A  049  049  I00tax04
     I                             A  050  058  I00Betra04
     I                             A  059  061  I00Lkey05
     I                             A  062  062  I00tax05
     I                             A  063  071  I00Betra05
     I                             A  072  074  I00Lkey06
     I                             A  075  075  I00tax06
     I                             A  076  084  I00Betra06
     I                             A  085  087  I00Lkey07
     I                             A  088  088  I00tax07
     I                             A  089  097  I00Betra07
     I                             A  098  100  I00Lkey08
     I                             A  101  101  I00tax08
     I                             A  102  110  I00Betra08
     I                             A  111  113  I00Lkey09
     I                             A  114  114  I00tax09
     I                             A  115  123  I00Betra09
     I                             A  124  126  I00Lkey10
     I                             A  127  127  I00tax10
     I                             A  128  136  I00Betra10
     I                             A  137  162  I00TSTAMP
     I                             A  001  136  I00
     I*
     C*Satzart J00 Sendungsdaten Summen
     C*Häufigkeit: 1 mal
     C*Modalität:  muss
     I          kf  14   01 cJ   02 c0   03 c0
     I                             A  001  003  J00Satzart
     I                             A  004  006  J00AnzSnd
     I                             A  007  012  J00SumPos
     I                             A  013  021  J00TBGEWkg
     I                             A  022  025  J00ANZGP
     I                             A  026  029  J00ANZEP
     I                             A  030  033  J00ANZLHM1
     I                             A  034  037  J00ANZLHM2
     I                             A  038  048  J00SUMI001
     I                             A  049  059  J00SUMI002
     I                             A  060  070  J00WNNI00
     I                             A  071  081  J00ZollI00
     I                             A  082  092  J00ErSTI00
     I                             A  093  103  J00MWST
     I                             A  104  129  J00TSTAMP
     I                             A  001  103  J00
     I*
     C*Satzart Z00 Kontrollsatz
     C*Häufigkeit: 1 mal
     C*Modalität:  muss
     I          kf  15   01 cZ   02 c0   03 c0
     I                             A  001  003  Z00Satzart
     I                             A  004  009  Z00AnzStz
     I                             A  010  017  Z00date
     I                             A  018  023  Z00time
     I                             A  024  049  Z00TSTAMP
     I                             A  001  023  Z00
     I*
     I          kf  99
     I*
     I*-------------------------------------------------------------------------
     C                   setoff                                       27
     C*==>sind evtl. alte P-Sätze in der Struktur
     C                   if        lox010 = 'S'
     C                   seton                                        77
     C                   endif

     C*==>Hauptsatz 30=on
     C                   if        lox010 = 'S'  and *in77
     C                   seton                                        30
     C                   add       1             #s                3 0
     C  n51              eval      #lox020   =   lox020
     C  n51              eval      #lox270   =   lox270
     C  n51              eval      #lox470   =   lox470
     C  n51              eval      #lox640   =   lox640
     C  n51              eval      #lox650   =   lox650
     C  n51              eval      #lox660   =   lox660
     C  n51              eval      #lox670   =   lox670
     C  n51              eval      #lox680   =   lox680
     C  n51              eval      #lox690   =   lox690
     C                   seton                                        51
     C                   endif
     C*==>Positionssatz 40=on
     C                   if        lox010 = 'P'  and *in77
     C                   seton                                        40
     C                   setoff                                       30
     C                   endif
     C*==>wechsel Hauptsatz und Positionssatz 30=on 40=on
     c                   if        *in30 ='1' and *in40 ='1'
     c                             and *in77
     c                   exsr      sr_GW
     C                   setoff                                       40
     C                   clear                   #p                3 0
     c                   endif
     C*==>B00
     c                   If        *in77  = '1'
     c   30              exsr      sr_B00
     c                   endif

     C*==>D00
     C*derzeit ohne Positionen
     C*- gewichtsangabe bezieht sich auf Gesamtgewicht: lox320
     C*  wird daher nicht übergeben
     c   40              if        lox380 <> ' ' and lox010 = 'P'
     c                             and *in77
     c                   add       1             #p                3 0
     c                   movel     lox350        zeichen          35
     c                   movel     lox360        anzahl            4
     c                   movel     lox370        packart           3
     c                   movel     lox380        inhalt           35
     c                   move      lox540        laenge            4
     c                   move      lox550        breite            4
     c                   move      lox560        hoehe             4
     c                   exsr      sr_D00
     c                   exsr      sr_F00
     c                   endif
     c   40              if        lox420 <> ' ' and lox010 = 'P'
     c                             and *in77
     c                   add       1             #p                3 0
     c                   movel     lox390        zeichen          35
     c                   movel     lox400        anzahl            4
     c                   movel     lox410        packart           3
     c                   movel     lox420        inhalt           35
     c                   move      lox570        laenge            4
     c                   move      lox580        breite            4
     c                   move      lox590        hoehe             4
     c                   exsr      sr_D00
     c                   exsr      sr_F00
     c                   endif
     c   40              if        lox460 <> ' ' and lox010 = 'P'
     c                             and *in77
     c                   add       1             #p                3 0
     c                   movel     lox430        zeichen          35
     c                   movel     lox440        anzahl            4
     c                   movel     lox450        packart           3
     c                   movel     lox460        inhalt           35
     c                   move      lox600        laenge            4
     c                   move      lox610        breite            4
     c                   move      lox620        hoehe             4
     c                   exsr      sr_D00
     c                   exsr      sr_F00
     c                   endif


     C*Abschluß
     cLR 77              seton                                        55
     cLR 77              exsr      sr_GW
     cLR 77              exsr      sr_J00
     cLR 77              exsr      sr_Z00
     C*Initialisierung mit loxx, evtl. später Variable
     cLR 77              seton                                        17
     cLR 77              exsr      srWrite


     C**************************************************************************
     C*Gruppenwechsel
     C*-------------------------------------------------------------------------
     C*
     C     sr_GW         BEGSR
     C*
     C*==>G00
     c                   exsr      sr_G00
     C*==>H00
     c                   if        #lox640 <> ' ' or
     c                             #lox660 <> ' ' or
     c                             #lox680 <> ' '
     c                   If        #lox640 ='300'
     c                   movel     '000'         hwk1              3
     c                   else
     c                   movel     #lox640       hwk1              3
     c                   endif
     c                   If        #lox660 ='300'
     c                   movel     '000'         hwk2              3
     c                   else
     c                   movel     #lox660       hwk2              3
     c                   endif
     c                   If        #lox680 ='300'
     c                   movel     '000'         hwk3              3
     c                   else
     c                   movel     #lox680       hwk3              3
     c                   endif
     c                   endif
     c                   exsr      sr_H00
     C                   eval      #lox020   =   lox020
     C                   eval      #lox270   =   lox270
     C                   eval      #lox470   =   lox470
     C                   eval      #lox640   =   lox640
     C                   eval      #lox650   =   lox650
     C                   eval      #lox660   =   lox660
     C                   eval      #lox670   =   lox670
     C                   eval      #lox680   =   lox680
     C                   eval      #lox690   =   lox690
     C*
     C     ##_GW         ENDSR

     C**************************************************************************
     C*Ausgabe A00
     C*-------------------------------------------------------------------------
     C*
     C     sr_A00        BEGSR
     C*
     c                   movel     'A00'         A00SATZART
     c                   movel     'STD'         A00QUALIF
     c   27              movel     'KDF'         A00QUALIF
     c                   movel     '100'         A00RELEASE
     c                   eval      A00BORDNR  = '   ' +
     c                                          %char(tstampi)
     c                   eval      A00BORDDAT  = #tag
     c                                         + #Monat
     c                                         + #Jahr
     c                   movel     'L  '         A00VERKEHR
     c                   movel     'STD'         A00PRODUKT
     c   27              movel     'CL '         A00PRODUKT
     c                   movel     'STD'         A00CODELIS
     c   27              movel     'CL '         A00CODELIS
     c                   movel     'EUR'         A00WAHRUNG
     c                   eval      A00IDENT_V =  %subst(startlox2:7:7)
     c   27              eval      A00IDENT_V =  %subst(startlox4:7:7)
     c   27              eval      A00IDENT_E =  '4490        Heinrich Koch'
     c   27              eval      A00FFLAND  =  'D'
     c   27              eval      A00FFPLZ   =  '49076'
     c   27              eval      A00FFORT   =  'Osnabrück'
     c                   seton                                        01
     c                   eval      a00 = A00SATZART  +
     c                                   A00QUALIF   +
     c                                   A00RELEASE  +
     c                                   A00BORDNR   +
     c                                   A00BORDDAT  +
     c                                   A00VERKEHR  +
     c                                   A00PRODUKT  +
     c                                   A00CODELIS  +
     c                                   A00WAHRUNG  +
     c                                   A00IDENT_V  +
     c                                   A00IDENT_E  +
     c                                   A00FF       +
     c                                   A00FFLAND   +
     c                                   A00FFPLZ    +
     c                                   A00FFORT    +
     c                                   A00KFZKZ1   +
     c                                   A00KFZKZ2   +
     c                                   A00WEITER1  +
     c                                   A00WEITER2
     c                   exsr      srWrite
     C*
     C     ##_A00        ENDSR

     C**************************************************************************
     C*Ausgabe B00
     C*-------------------------------------------------------------------------
     C*
     C     sr_B00        BEGSR
     C*
     c                   movel     'B00'         B00Satzart
     c                   movel     #s            B00BorderP
     c                   eval      B00Qualif  = 'SHP'
     c                   eval      B00Name_1  = comp
     c                   eval      B00STR_NR  = str
     c                   eval      B00LKZ     = lkz
     c                   eval      B00plz1    = plz
     c                   eval      B00Ort1    = ort
     c                   seton                                        03
     c                   eval      B00 = B00Satzart  +
     c                                   B00BorderP  +
     c                                   B00Qualif   +
     c                                   B00Name_1   +
     c                                   B00STR_NR   +
     c                                   B00LKZ      +
     c                                   B00PLZ1     +
     c                                   B00Ort1     +
     c                                   B00KundeNR  +
     c                                   B00Name_2   +
     c                                   B00Name_3   +
     c                                   B00Ortstei  +
     c                                   B00ILN3     +
     c                                   B00Zoll_Id
     c                   exsr      srWrite
     c
     c                   seton                                        03
     c                   evalr     %subst(B00:07:03) = 'INV'
     c                   exsr      srWrite
     c
     c                   seton                                        03
     c                   evalr     %subst(B00:07:03) = 'LOA'
     c                   exsr      srWrite
     c
     c                   movel     #s            B00BorderP
     c                   eval      B00Qualif  = 'CON'
     c                   eval      B00Name_1  = lox120
     c                   eval      B00Name_2  = lox130
     c                   eval      B00STR_NR  = lox140
     c                   eval      B00LKZ     = lox150
     c                   eval      B00plz1    = lox160
     c                   eval      B00Ort1    = lox170
     c                   seton                                        03
     c                   eval      B00 = B00Satzart  +
     c                                   B00BorderP  +
     c                                   B00Qualif   +
     c                                   B00Name_1   +
     c                                   B00STR_NR   +
     c                                   B00LKZ      +
     c                                   B00PLZ1     +
     c                                   B00Ort1     +
     c                                   B00KundeNR  +
     c                                   B00Name_2   +
     c                                   B00Name_3   +
     c                                   B00Ortstei  +
     c                                   B00ILN3     +
     c                                   B00Zoll_Id
     c                   exsr      srWrite
     c
     C*
     C     ##_B00        ENDSR

     C**************************************************************************
     C*Ausgabe D00
     C*-------------------------------------------------------------------------
     C*
     C     sr_D00        BEGSR
     C*
     c                   movel     'D00'         D00Satzart
     c                   movel     #s            D00BorderP
     c                   movel     #p            D00SndPos
     c                   evalr     D00PackstA = anzahl
     c   27              evalr     D00PackstA = '0000'
     c                   evalr     D00VerpArt = packart
     c                   evalr     D00Inhalt  = inhalt
     c                   evalr     D00Zeichen = zeichen
     c                   evalr     D00LaengeM = laenge
     c                   evalr     D00BreiteM = breite
     c                   evalr     D00HoeheM  = hoehe
     c     ' ':'0'       xlate     D00gewicht    d00gewicht
     c     ' ':'0'       xlate     D00FRAGEW     D00FRAGEW
     c     ' ':'0'       xlate     D00HoeheM     D00HoeheM
     c     ' ':'0'       xlate     D00Kubikm     D00Kubikm
     c                   seton                                        06
     c                   eval      D00 = D00Satzart  +
     c                                   D00BorderP  +
     c                                   D00SndPos   +
     c                                   D00PackstA  +
     c                                   D00VerpArt  +
     c                                   D00PackstA  +
     c                                   D00VPart    +
     c                                   D00Inhalt   +
     c                                   D00Zeichen  +
     c                                   D00Gewicht  +
     c                                   D00FRAGEW   +
     c                                   D00LaengeM  +
     c                                   D00BreiteM  +
     c                                   D00HoeheM   +
     c                                   D00Kubikm   +
     c                                   D00Ladem    +
     c                                   D00AnzahlP
     c                   exsr      srWrite
     c                   add       1             d00count          5 0
     C*
     C     ##_D00        ENDSR

     C**************************************************************************
     C*Ausgabe F00
     C*-------------------------------------------------------------------------
     C*
     C     sr_F00        BEGSR
     C*
     c                   movel     'F00'         F00Satzart
     c                   movel     #s            F00BorderP
     c                   movel     #p            F00SndPos
     c                   movel     lox480        F00Barcode
     c                   seton                                        09
     c                   eval      F00 = F00Satzart  +
     c                                   F00BorderP  +
     c                                   F00SndPos   +
     c                                   F00Barcode  +
     c                                   F00QualRe1  +
     c                                   F00Ref#kg1  +
     c                                   F00QualRe2  +
     c                                   F00Ref#kg2  +
     c                                   F00QualRe3  +
     c                                   F00Ref#kg3  +
     c                                   F00QualRe4  +
     c                                   F00Ref#kg4  +
     c                                   F00Qualre5  +
     c                                   F00Ref#kg5
     c                   exsr      srWrite
     c                   add       1             F00count          5 0
     c
     C*
     C     ##_F00        ENDSR

     C**************************************************************************
     C*Ausgabe G00
     C*-------------------------------------------------------------------------
     C*
     C     sr_G00        BEGSR
     C*
     c                   movel     'G00'         G00Satzart
     c  n55              eval      #s = #s -1
     c                   movel     #s            G00BorderP
     c                   eval      G00TSTAMPt   = #lox020
     c  n55              eval      #s = #s +1
     c                   evalr     G00BruttoG = %char(lox320*1000)
     c     ' ':'0'       xlate     G00BruttoG    G00BruttoG
     c                   evalr     G00Waehru  = lox630
     c                   evalr     G00ccm     = lox300
     C*                 exw
     c                   evalr     G00Frankat = 'X00'
     c   27              evalr     G00Frankat = '2 N'
     c                   seton                                        10
     c                   eval      G00 = G00Satzart  +
     c                                   G00BorderP  +
     c                                   G00TSTAMPt  +
     c                                   G00BruttoG  +
     c                                   G00Frankat  +
     c                                   G00DirZU    +
     c                                   G00Abdate   +
     c                                   G00Abtimea  +
     c                                   G00abtimeb  +
     c                                   G00logmod   +
     c                                   G00sndempf  +
     c                                   G00border1  +
     c                                   G00border2  +
     c                                   G00wgrp     +
     c                                   G00wwert    +
     c                                   G00Waehru   +
     c                                   G00gewFrac  +
     c                                   G00ccm      +
     c                                   G00ladem    +
     c                                   G00PallAnz  +
     c                                   G00ladehm1  +
     c                                   G00ladevA1  +
     c                                   G00ladehm2  +
     c                                   G00ladevA2  +
     c                                   G00TSTAMP
     c
     c                   exsr      srWrite
     c                   add       lox320        §brutto          1102
     C*
     C     ##_G00        ENDSR

     C**************************************************************************
     C*Ausgabe H00
     C*-------------------------------------------------------------------------
     C*
     C     sr_H00        BEGSR
     C*
     c                   clear                   H00tkey01
     c                   clear                   H00tkey02
     c                   clear                   H00tkey03
     c                   clear                   H00tkey04
     c                   clear                   H00tkey05
     c                   clear                   H00tkey06
     c                   clear                   H00text01
     c                   clear                   H00text02
     c                   clear                   H00text03
     c                   clear                   H00text04
     c                   clear                   H00text05
     c                   clear                   H00text06
     c                   movel     'H00'         H00Satzart
     c  n55              eval      #s = #s -1
     c                   movel     #s            h00BorderP
     c  n55              eval      #s = #s +1
     c                   evalr     H00tkey01  = '504'
     c                   eval      H00text01  = #lox020
     c                   evalr     H00tkey02  = '504'
     c                   eval      H00text02  = #lox270
     c                   evalr     H00tkey03  = '504'
     c                   movel     #lox470       H00text03
     c                   evalr     H00tkey06  = '504'
     c                   eval      H00text06 = %char(tstampi)
     c                   seton                                        11
     c                   eval      h00 = H00Satzart  +
     c                                   H00BorderP  +
     c                                   H00tkey01   +
     c                                   H00text01   +
     c                                   H00tkey02   +
     c                                   H00text02   +
     c                                   H00tkey03   +
     c                                   H00text03   +
     c                                   H00tkey04   +
     c                                   H00text04   +
     c                                   H00tkey05   +
     c                                   H00text05   +
     c                                   H00tkey06   +
     c                                   H00text06
     c
     c                   exsr      srWrite
     c                   clear                   H00tkey01
     c                   clear                   H00tkey02
     c                   clear                   H00tkey03
     c                   clear                   H00tkey04
     c                   clear                   H00tkey05
     c                   clear                   H00tkey06
     c                   clear                   H00text01
     c                   clear                   H00text02
     c                   clear                   H00text03
     c                   clear                   H00text04
     c                   clear                   H00text05
     c                   clear                   H00text06
     c
     c                   if        #lox640 <> ' ' or
     c                             #lox660 <> ' ' or
     c                             #lox680 <> ' '
     c                   movel     'H00'         H00Satzart
     c  n55              eval      #s = #s -1
     c                   movel     #s            h00BorderP
     c  n55              eval      #s = #s +1
     c                   evalr     H00tkey01  = hwk1
     c                   eval      H00text01  = #lox650
     c                   evalr     H00tkey02  = hwk2
     c                   eval      H00text02  = #lox670
     c                   evalr     H00tkey03  = hwk3
     c                   eval      H00text03  = #lox690
     c                   seton                                        11
     c                   eval      h00 = H00Satzart  +
     c                                   H00BorderP  +
     c                                   H00tkey01   +
     c                                   H00text01   +
     c                                   H00tkey02   +
     c                                   H00text02   +
     c                                   H00tkey03   +
     c                                   H00text03   +
     c                                   H00tkey04   +
     c                                   H00text04   +
     c                                   H00tkey05   +
     c                                   H00text05   +
     c                                   H00tkey06   +
     c                                   H00text06
     c
     c                   exsr      srWrite
     c                   endif
     C*
     C     ##_H00        ENDSR

     C**************************************************************************
     C*Ausgabe J00
     C*-------------------------------------------------------------------------
     C*
     C     sr_J00        BEGSR
     C*
     c                   movel     'J00'         J00Satzart
     c                   move      d00count      J00AnzSnd
     c                   evalr     J00TBGEWkg = %char(§brutto)
     c   27              evalr     %subst(J00TBGEWkg:07:01) = '0'
     c                   seton                                        14
     c                   eval      J00 = J00Satzart  +
     c                                   J00AnzSnd   +
     c                                   J00SumPos   +
     c                                   J00TBGEWkg  +
     c                                   J00ANZGP    +
     c                                   J00ANZEP    +
     c                                   J00ANZLHM1  +
     c                                   J00ANZLHM2  +
     c                                   J00SUMI001  +
     c                                   J00SUMI002  +
     c                                   J00WNNI00   +
     c                                   J00ZollI00  +
     c                                   J00ErSTI00  +
     c                                   J00MWST
     c
     c                   exsr      srWrite
     C*
     C     ##_J00        ENDSR

     C**************************************************************************
     C*Ausgabe Z00
     C*-------------------------------------------------------------------------
     C*
     C     sr_Z00        BEGSR
     C*
     c                   movel     'Z00'         Z00Satzart
     c                   evalr     Z00AnzStz  = %CHAR(count-1)
     c   27              eval      count = count -1
     c   27              movel     '0'           Z00AnzStz
     c   27              move      count         Z00AnzStz
     c   27              eval      count = count +1
     c                   evalr     Z00date    = #tag
     c                                        + #Monat
     c                                        + #Jahr
     c                   evalr     Z00time    = #stunde
     c                                        + #minute
     c                                        + #sekunde
     c                   seton                                        15
     c                   eval      z00 = Z00Satzart  +
     c                                   Z00AnzStz   +
     c                                   Z00date     +
     c                                   Z00time
     c
     c                   exsr      srWrite
     C*
     C     ##_Z00        ENDSR

     C**************************************************************************
     C*Ausgabe und fixe Bereiche
     C*-------------------------------------------------------------------------
     C*
     C     srWrite       BEGSR
      *
     C*Übergabe
     c                   clear                   FORTRASR#
     c   01              movel     A00           FORTRASR#
     c   02              movel     A10           FORTRASR#
     c   03              movel     B00           FORTRASR#
     c   04              movel     B10           FORTRASR#
     c   05              movel     C00           FORTRASR#
     c   06              movel     D00           FORTRASR#
     c   07              movel     D10           FORTRASR#
     c   08              movel     E00           FORTRASR#
     c   09              movel     F00           FORTRASR#
     c   10              movel     G00           FORTRASR#
     c   11              movel     H00           FORTRASR#
     c   12              movel     H10           FORTRASR#
     c   13              movel     I00           FORTRASR#
     c   14              movel     J00           FORTRASR#
     c   15              movel     Z00           FORTRASR#
     c   16              movel     startlox      FORTRASR#
     c   27              movel     startloxk     FORTRASR#
     c   17              movel     endelox       FORTRASR#
     c                   write     FORTRAS       FORTRASR#
     c                   movea     '0000000000'  *in(01)
     c                   movea     '0000000000'  *in(11)
     c                   add       1             count             6 0
     C*
     C     ##Write       ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr9999        BEGSR
     C*

     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   qsys2/qsqptabl
     c/end-exec

     C     ##9999        ENDSR

     C*-------------------------------------------------------------------------

     C     *inzsr        BEGSR
      *

     C                   exsr      sr9999
     C                   TIME                    Date
     c                   extrct    date:*Y       jahr
     c                   extrct    date:*M       monat
     C                   extrct    date:*D       tag
     C                   movel     jahr          #jahr             4
     C                   movel     monat         #monat            2
     C                   movel     tag           #tag              2
     c                   extrct    zeit:*seconds sekunde
     c                   extrct    zeit:*minutes minute
     C                   extrct    zeit:*hours   stunde
     C                   movel     sekunde       #sekunde          2
     C                   movel     minute        #minute           2
     C                   movel     stunde        #stunde           2
     C     *LIKE         DEFINE    lox020        #lox020
     C     *LIKE         DEFINE    lox270        #lox270
     C     *LIKE         DEFINE    lox470        #lox470
     C     *LIKE         DEFINE    lox640        #lox640
     C     *LIKE         DEFINE    lox650        #lox650
     C     *LIKE         DEFINE    lox660        #lox660
     C     *LIKE         DEFINE    lox670        #lox670
     C     *LIKE         DEFINE    lox680        #lox680
     C     *LIKE         DEFINE    lox690        #lox690

     C*initialisierung mit loxx, evtl. später Variable
     c                   seton                                        16
     c                   exsr      srWrite
     c                   exsr      sr_A00

     C                   ENDSR

