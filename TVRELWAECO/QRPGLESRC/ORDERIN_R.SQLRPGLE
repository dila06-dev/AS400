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
     F*                                                          *
     F*  Freischaltung: 88505 Frankreich                         *
     F*                 55278 Italien                            *
     F*                 08138 Schweden                           *
     F*                 78146 Spanien                            *
     F*                 42634 Norwegen                           *
     F*                 78678 Polen                              *
     F*                 54939 Österreich                         *
     F*                 01887 Dänemark                           *
     F*                 40631 England                            *
     F*                191453 Russland                           *
     F*           *     15177 Niederlande not yet                *
     F*           *     62765 Benelux     not yet                *
     F*           *     02921 Schweiz     not yet                *
     F*                 52774 Luxemburg                          *
     F*                752774 Luxemburg                          *
     F*                 96690 Ungarn                             *
     F*                796690 Ungarn                             *
     F*                 02511 Slowakia                           *
     F*                772511 Slowakia                           *
     F*                 05084 Finnland                           *
     F*                 40670 England CWL                        *
     F*                 40642 England Blendford St Mary          *
     F************************************************************
     H*datfmt(*iso) timfmt(*iso)
     H*datfmt(*eur) timfmt(*eur)

     fORDERINPUTip   f 1381        disk

     forderh    if a e             disk    RENAME(orderhpf:header)
     forderl    if a e             disk    RENAME(orderlpf:line  )
     fordert    if a e             disk    RENAME(ordertpf:text  )

     D*-------------------------------------------------------------------------
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

     D Chx             DS
     D  chx1                   1     20    INZ('Auftrag in Trend ein')
     D  chx2                  21     40    INZ('geleitet ==> next St')
     D  chx3                  41     50    INZ('ep: ORDERR')

     D*-----------Record -------------------------------------------------------
     d*d_record      E DS                  INZ
     D*                                    prefix('#')

     I*-------------------------------------------------------------------------
     I/COPY ##E

     I*-------------------------------------------------------------------------
     IORDERINPUTkf  01   01 cH
     I                             A    1    1  #H010
     I                             A    2    8  #H020
     I                             A    9   15  #H030
     I                             A   16   25  #H040
     I                             A   26   35  #H050
     I                             A   36   45  #H060
     I                             A   46   53  #H070
     I                             A   54   54  #H080
     I                             A   55   55  #H090
     I                             A   56   85  #H100
     I                             A   86  115  #H110
     I                             A  116  145  #H120
     I                             A  146  175  #H130
     I                             A  176  178  #H140
     I                             A  179  183  #H150
     I                             A  184  213  #H160
     I                             A  214  313  #H170
     I                             A  314  314  #H180
     I                             A  315  414  #H190
     I                             A  415  415  #H200
     I                             A  416  515  #H210
     I                             A  516  516  #H220
     I                             A  517  518  #H230
     I                             A  519  539  #H240
     I                             A  540  540  #H250
     I                             A  541  541  #H260
     I                             A  542  542  #H270
     I                             A  543  642  #H280
     I                             A  643  742  #H290
     I                             A  743  802  #H300
     I
     I                             A  803 1272  #H310
     I*#
     I                             A  803 1218  #H310neu
     I                             A 1219 1221  #H310FO
     I                             A 1222 1223  #H311A
     I                             A 1224 1225  #H311B
     I                             A 1226 1230  #H311C
     I                             A 1231 1231  #H311D
     I                             A 1232 1234  #H311E
     I                             A 1235 1239  #H311F
     I                             A 1240 1244  #H311G
     I                             A 1245 1252  #H311H
     I                             A 1253 1258  #H311I
     I                             A 1259 1264  #H311J
     I                             A 1265 1270  #H311K
     I                             A 1271 1272  #H311
     I*#
     I                             A 1273 1302  #H312
     I                             A 1303 1314  #H315
     I                             A 1315 1324  #H320
     I                             A 1325 1334  #H330
     I                             A 1335 1335  #H340
     I                             A 1336 1345  #H350
     I                             A 1346 1355  #H360
     I                             A 1356 1381  #H370
     I*
     IORDERINPUTkf  02   01 cL
     I                             A    1    1  #L010
     I                             A    2    5  #L020
     I                             A    6   11  #L030
     I                             A   12   21  #L040
     I                             A   22   26  #L050
     I                             A   27   36  #L060
     I                             A   37   37  #L070
     I                             A   38   52  #L080
     I                             A   53   92  #L090
     I                             A   93  100  #L100
     I                             A  101  120  #L110
     I                             A  121  150  #L120
     I                             A  151  151  #L130
     I                             A  152  152  #L140
     I                             A  153  664  #L150
     I                             A  665  674  #L160
     I                             A  675  675  #L170
     I                             A  676  685  #L180
     I                             A  686  711  #L190
     I                             A  712  721  #L200
     I                             A  722  729  #L210
     I                             A  730  733  #L220
     I                             A  734  739  #L230
     I                             A  740  749  #L240
     I                             A  750  756  #L250
     I                             A  757 1381  #L990
     I*
     IORDERINPUTkf  03   01 cT
     I                             A    1    1  #T010
     I                             A    2    8  #T020
     I                             A    9   18  #T030
     I                             A   19   28  #T040
     I                             A   29   36  #T050
     I                             A   37   37  #T060T1
     I                             A   38   47  #T070T1
     I                             A   48  179  #T080T1
     I                             A  180  180  #T060T2
     I                             A  181  190  #T070T2
     I                             A  191  322  #T080T2
     I                             A  323  323  #T060T3
     I                             A  324  333  #T070T3
     I                             A  334  465  #T080T3
     I                             A  466  466  #T060T4
     I                             A  467  476  #T070T4
     I                             A  477  608  #T080T4
     I                             A  609  609  #T060T5
     I                             A  610  619  #T070T5
     I                             A  620  751  #T080T5
     I                             A  752  752  #T060T6
     I                             A  753  762  #T070T6
     I                             A  763  894  #T080T6
     I                             A  895  895  #T060T7
     I                             A  896  905  #T070T7
     I                             A  906 1037  #T080T7
     I                             A 1038 1038  #T060T8
     I                             A 1039 1048  #T070T8
     I                             A 1049 1180  #T080T8
     I                             A 1181 1181  #T060T9
     I                             A 1182 1191  #T070T9
     I                             A 1192 1323  #T080T9
     I                             A 1324 1324  #T060
     I                             A 1325 1334  #T330
     I                             A 1335 1335  #T340
     I                             A 1336 1345  #T350
     I                             A 1346 1355  #T360
     I                             A 1356 1381  #T370
     I*
     I          kf  99
     I*
     I*-------------------------------------------------------------------------

     c   01              exsr      srheader
     c   02              exsr      srline
     c   03              exsr      srtext

     c   01              write     header
     c   01              exsr      sr_save
     c   02              write     line
     c   03              write     text

     C**************************************************************************
     C*header
     C*-------------------------------------------------------------------------
     C*
     C     srheader      BEGSR
      *
     c                   clear                   header
     c                   clear                   error           512
     c                   testn                   #H020                20
     c  n20              eval         error = 'H030'
     c                   testn                   #H030                20
     c  n20              eval         error = error + %triml (' H030')
     c                   testn                   #H040                20
     c  n20              eval         error = error + %triml (' H040')
     c                   testn                   #H150                20
     c  n20              eval         error = error + %triml (' H150')
     c                   setoff                                       20

     c
     c                   movel     #h010         h010
     c                   movel     #h020         h020
     c                   movel     #h030         h030
     c                   movel     #h040         h040
     c                   if        h040  = 0
     c                   move      #h030         h040
     c                   endif
     c                   movel     #h050         h050
     c***                linksbündige *blanks werden eleminiert
     c                   eval      h050      =   %trim(#h050)
     c                   if        H030 = 55278 or H030 = 78146 or
     c                             H030 = 35671
     c                   eval      h050      =   %trim(%char (jahr)) +
     c                                           %trim(#h050)
     c                   endif
      /Free
         MONITOR;
          Test(DE) *EUR #h060;
            If %Error;
                *in20 = '1';
            Endif;
            ON-ERROR;
                *in20 = '1';
         ENDMON;
      /End-Free
     c**n20              eval      #h060  = %char (%date (#h060:*eur) :*eur)
     c  n20              eval      #h060  = %char (%date (#h060:*eur) :*iso)
     c  n20              movel     #h060         h060

     c                   if        *in20 = '1'
     c                   setoff                                       20
      /Free
         MONITOR;
          Test(DE) *iso #h060;
            If %Error;
                *in20 = '1';
            Endif;
            ON-ERROR;
                *in20 = '1';
         ENDMON;
      /End-Free
     c  n20              movel     #h060         H060
     c                   endif

     c
     c   20              movel     date          h060
     c                   setoff                                       20
     c
      /Free
         MONITOR;
            Test(ET) *EUR #h070;
            If %Error;
                *in20 = '1';
            Endif;
            ON-ERROR;
                *in20 = '1';
         ENDMON;
      /End-Free
     c   20              movel     zeit          h070
     c  n20              movel     #h070         h070
     c                   setoff                                       20

     c                   movel     #h080         h080
     c                   movel     #h090         h090
     c                   movel     #h100         h100
     c                   movel     #h110         h110
     c                   movel     #h120         h120
     c                   movel     #h130         h130
     c                   movel     #h140         h140
     c                   movel     #h150         h150
     c                   movel     #h160         h160
     c                   movel     #h170         h170
     c                   movel     #h180         h180
     c                   movel     #h190         h190
     c                   movel     #h200         h200
     c                   movel     #h210         h210
     c                   movel     #h220         h220
     c                   movel     #h230         h230
     c                   movel     #h240         h240
     c
     c                   if        h240   =   *blanks
     c***                linksbündige *blanks werden eleminiert
     c***                Referenze
     c                   eval      h240      =   %trim(#h050)
     c                   endif
     c
     c                   movel     #h250         h250
     c                   movel     #h260         h260
     c                   movel     #h270         h270
     c                   movel     #h280         h280
     c                   movel     #h290         h290
     c***                linksbündige *blanks werden eleminiert
     c                   eval      H300      =   %trim(#H300)
     c                   clear                   H310
     c                   movel     #H310         H310
     c*
     c                   if        #h315 <> *blank
     c                   clear                   h150
     c                   endif
     c                   eval      %subst(h310:471:30)  = #H312
     c                   eval      %subst(h310:501:12)  = #H315
     c*
     c*                  linksbündige *blanks werden eleminiert in Italien
     c                   if        H030 = 55278
     c                   movel     #H315         ##h315           12
     c                   eval      #H315     =   %trim(##H315)
     c                   eval      %subst(h310:501:12)  = #H315
     c                   endif
     c*
     c                   movel     #H320         H320
     c                   movel     #H330         H330
     c                   movel     #H340         H340
     c                   movel     #H350         H350
     c                   movel     '99'          h350
     c                   if        H030 = 55278 or h030 = 78146   or
     c                             H030 = 08138 or h030 = 42634   or
     c                             H030 = 78678 or h030 = 54939   or
     c                             H030 = 88505 or h030 = 40631   or
     c                             H030 = 88505 or h030 = 40631   or
     c                             H030 = 40670 or h030 = 40642   or
     c                             H030 = 05084 or h030 = 191453  or
     c                             H030 = 96690 or h030 = 796690  or
     c                             H030 = 52774 or h030 = 752774  or
     c                             H030 = 35671 or h030 = 035671  or
     c                             H030 = 02511 or h030 = 772511
     c                   movel     '  '          h350
     c                   endif
      /Free
         MONITOR;
            Test(DE)      #h360;
            If %Error;
                *in20 = '1';
            Endif;
            ON-ERROR;
                *in20 = '1';
         ENDMON;
      /End-Free
     c  n20              eval      #h360  = %char (%date (#h360:*eur) :*iso)
     c   20              movel     date          h360
     c  n20              movel     #H360         H360
     c                   setoff                                       20


      /Free
         MONITOR;
            Test(EZ)      #h370;
            If %Error;
                *in20 = '1';
            Endif;
            ON-ERROR;
                *in20 = '1';
         ENDMON;
      /End-Free
     c   20              movel     tstampi       h370
     c  n20              movel     #H370         H370

     C*break Polen
     c                   movel     '0'           distrib           1
      /Free
         MONITOR;
            if H030 = 78678 and h140 <> 'PL';
               distrib = '1';
               H030    = 78680;
               H040    = 78680;
            endif;
            ON-ERROR;
         ENDMON;
      /End-Free

     C     ##header      ENDSR

     C**************************************************************************
     C*line
     C*-------------------------------------------------------------------------
     C*
     C     srline        BEGSR
     C*
     c                   clear                   line
     c                   clear                   error           512
     c                   testn                   #L020                20
     c  n20              eval         error = 'L020'
     c                   testn                   #L030                20
     c  n20              eval         error = error + %triml (' L030')
     c                   testn                   #L050                20
     c  n20              eval         error = error + %triml (' L050')
     c                   testn                   #L250                20
     c  n20              eval         error = error + %triml (' L250')
     c                   setoff                                       20



     c                   movel     #L010         L010
     c                   movel     #L020         L020
     c                   movel     #L030         L030
     c***                linksbündige *blanks werden eleminiert
     c                   eval      l040      =   %trim(#l040)
     c*                  movel     #L040         L040
     c                   movel     #L250         L250
     c                   if        L250 = 55278 or L250 = 78146 or
     c                             L250 = 35671
     c                   eval      l040      =   %trim(%char (jahr)) +
     c                                           %trim(#l040)
     c                   endif
     c                   movel     #L050         L050
     c                   if        L050  > 9999
     c                   eval      L050  = l050 /100
     c                   endif
     c*    I S O - Norm  kommt als iso rein jetzt Umstellung auf *EUR
     c*    in datei ==> *iso
      /Free
         MONITOR;
          Test(DE) *EUR #L060;
            If %Error;
                *in20 = '1';
            Endif;
            ON-ERROR;
                *in20 = '1';
         ENDMON;
      /End-Free
     c* n20              eval      #L060  = %char (%date (#L060:*eur) :*iso)
     c  n20              eval      #L060  = %char (%date (#L060:*eur) :*eur)
     c                   if        H030 = 78146
MG002c******20.01.2016   eval      #L060  = %char (%date (#L060:*eur) :*eur)
MG002c******20.01.2016   eval      #L060  = %char (%date (#L060:*eur) :*iso)
MG002c******20.01.2016   movel     date          L060
     c******20.01.2016   movel     #L060         L060
     c                   else
     c  n20              movel     #L060         L060
     c                   endif

     c                   if        *in20 = '1'
     c                   setoff                                       20
      /Free
         MONITOR;
          Test(DE) *iso #L060;
            If %Error;
                *in20 = '1';
            Endif;
            ON-ERROR;
                *in20 = '1';
         ENDMON;
      /End-Free
     c  n20              movel     #L060         L060
     c                   endif

     c   20              movel     date          L060
     c                   setoff                                       20

     c                   movel     #L070         L070
     c***                linksbündige *blanks werden eleminiert
     c                   eval      L080      =   %trim(#L080)
     c                   movel     #L090         L090
     c                   movel     #L100         L100
     c                   movel     #L110         L110
     c                   movel     #L120         L120
     c                   movel     #L130         L130
     c                   movel     #L140         L140
     c                   movel     #L150         L150
     c                   movel     #L160         L160
     c                   movel     #L170         L170
      /Free
         MONITOR;
          Test(DE) *EUR #L180;
            If %Error;
                *in20 = '1';
            Endif;
            ON-ERROR;
                *in20 = '1';
         ENDMON;
      /End-Free
     c  n20              eval      #L180  = %char (%date (#L180:*eur) :*iso)
     c   20              movel     date          L180
     c  n20              movel     #L180         L180
     c                   setoff                                       20

      /Free
         MONITOR;
          Test(EZ)    #L190;
            If %Error;
                *in20 = '1';
            Endif;
            ON-ERROR;
                *in20 = '1';
         ENDMON;
      /End-Free
     c   20              movel     tstampi       L190
     c  n20              movel     #L190         L190
     c                   setoff                                       20


      /Free
         MONITOR;
          Test(DE) *EUR #L200;
            If %Error;
                *in20 = '1';
            Endif;
         ON-ERROR;
                *in20 = '1';
         ENDMON;
      /End-Free
     c  n20              eval      #L200  = %char (%date (#L200:*eur) :*iso)
     c   20              movel     date          l200
     c  n20              movel     #L200         L200
     c                   setoff                                       20

     c                   movel     #L210         L210
     c                   movel     #L220         L220
     c                   movel     #L230         L230
     c                   movel     #L240         L240
     c                   movel     '99'          L240
     c                   movel     #L250         L250
     c                   movel     #L990         L990
     c                   if        l250 = 55278 or l250 = 78146   or
     c                             l250 = 08138 or l250 = 42634   or
     c                             l250 = 78678 or l250 = 54939   or
     c                             l250 = 88505 or l250 = 40631   or
     c                             l250 = 40670 or l250 = 40642   or
     c                             l250 = 01887 or l250 = 40631   or
     c                             l250 = 05084 or l250 = 191453  or
     c                             l250 = 96690 or l250 = 796690  or
     c                             l250 = 52774 or l250 = 752774  or
     c                             l250 = 35671 or l250 = 035671  or
     c                             l250 = 02511 or l250 = 772511
     c                   movel     '  '          L240
     c                   endif

     C*break Polen
      /Free
         MONITOR;
            if distrib = '1';
               L250    = 78680;
            endif;
            ON-ERROR;
         ENDMON;
      /End-Free


     C     ##line        ENDSR

     C**************************************************************************
     C*text
     C*-------------------------------------------------------------------------
     C*
     C     srtext        BEGSR
      *
     c                   clear                   text
     c                   clear                   error           512

     c                   movel     #T010         T010
     c                   movel     #T020         T020
     c                   movel     #T030         T030
     c***                linksbündige *blanks werden eleminiert
     c                   eval      T030      =   %trim(#T030)
     c******20.01.2016   if        T020 = 55278 or T020 = 78146
     c                   if        H030 = 55278 or H030 = 35671
     c                   eval      T030      =   %trim(%char (jahr)) +
     c                                           %trim(#T030)
     c                   endif
      /Free
         MONITOR;
          Test(DE) *EUR #T040;
            If %Error;
                *in20 = '1';
            Endif;
            ON-ERROR;
                *in20 = '1';
         ENDMON;
      /End-Free
     c**n20              eval      #T040  = %char (%date (#T040:*eur) :*iso)
     c  n20              eval      #T040  = %char (%date (#T040:*eur) :*eur)
     c  n20              movel     #T040         T040

     c                   if        *in20 = '1'
     c                   setoff                                       20
      /Free
         MONITOR;
          Test(DE) *iso #T040;
            If %Error;
                *in20 = '1';
            Endif;
            ON-ERROR;
                *in20 = '1';
         ENDMON;
      /End-Free
     c  n20              movel     #T040         T040
     c                   endif

     c
     c   20              movel     date          T040
     c                   setoff                                       20
     c
      /Free
         MONITOR;
            Test(ET) *EUR #T050;
            If %Error;
                *in20 = '1';
            Endif;
            ON-ERROR;
                *in20 = '1';
         ENDMON;
      /End-Free
     c   20              movel     zeit          T050
     c  n20              movel     #T050         T050
     c                   setoff                                       20

     c*
     c                   movel     #T060T1       T060T1
     c                   movel     #T070T1       T070T1
     c                   movel     #T080T1       T080T1
     c                   movel     #T060T2       T060T2
     c                   movel     #T070T2       T070T2
     c                   movel     #T080T2       T080T2
     c                   movel     #T060T3       T060T3
     c                   movel     #T070T3       T070T3
     c                   movel     #T080T3       T080T3
     c                   movel     #T060T4       T060T4
     c                   movel     #T070T4       T070T4
     c                   movel     #T080T4       T080T4
     c                   movel     #T060T5       T060T5
     c                   movel     #T070T5       T070T5
     c                   movel     #T080T5       T080T5
     c                   movel     #T060T6       T060T6
     c                   movel     #T070T6       T070T6
     c                   movel     #T080T6       T080T6
     c                   movel     #T060T7       T060T7
     c                   movel     #T070T7       T070T7
     c                   movel     #T080T7       T080T7
     c                   movel     #T060T8       T060T8
     c                   movel     #T070T8       T070T8
     c                   movel     #T080T8       T080T8
     c                   movel     #T060T9       T060T9
     c                   movel     #T070T9       T070T9
     c                   movel     #T080T9       T080T9
     c                   movel     #T060         T060
     c*
     c                   movel     #T330         T330
     c                   movel     #T340         T340
     c                   movel     #T350         T350
     c                   movel     '99'          T350
     c                   if        T020 = 55278 or T020 = 78146   or
     c                             T020 = 08138 or T020 = 42634   or
     c                             T020 = 78678 or T020 = 54939   or
     c                             T020 = 88505 or T020 = 40631   or
     c                             T020 = 01887 or T020 = 40631   or
     c                             T020 = 05084 or T020 = 191453  or
     c                             T020 = 96690 or T020 = 796690  or
     c                             T020 = 52774 or T020 = 752774  or
     c                             T020 = 02511 or T020 = 772511
     c                   movel     '  '          T350
     c                   endif
      /Free
         MONITOR;
            Test(DE)      #T360;
            If %Error;
                *in20 = '1';
            Endif;
            ON-ERROR;
                *in20 = '1';
         ENDMON;
      /End-Free
     c  n20              eval      #T360  = %char (%date (#T360:*eur) :*iso)
     c   20              movel     date          T360
     c  n20              movel     #T360         T360
     c                   setoff                                       20


      /Free
         MONITOR;
            Test(EZ)      #T370;
            If %Error;
                *in20 = '1';
            Endif;
            ON-ERROR;
                *in20 = '1';
         ENDMON;
      /End-Free
     c   20              movel     tstampi       t370
     c  n20              movel     #T370         t370

     C*break Polen
      /Free
         MONITOR;
            if distrib = '1';
               T020    = 78680;
            endif;
            ON-ERROR;
         ENDMON;
      /End-Free


     C     ##text        ENDSR

     C**********************************************************************
     C*Sicherung nach Auftragserzeugung und Protokoll
     C*-------------------------------------------------------------------------
     C
     C     sr_save       BEGSR
      *
     C                   clear                   md
     C                   movea(p)  'ORDERIN_R '  md(001)
     C                   movea(p)  '§§§JOB    '  md(011)
     C                   movea(p)  '§§§USR    '  md(022)
     C                   movea(p)  '          '  md(033)
     C                   movea(p)  'LOOP  '      md(040)
     C                   movea(p)  chx           md(046)
     C                   MOVEA     ATR(14)       md(099)
     C                   movea(p)  #h030         md(100)
     C                   movea(p)  h050          md(106)
     C                   MOVEA     ' '           md(117)
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC0002'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      'JOB_RUN   '  OUTFIL           10
     C                   PARM      'TVRELWAECO'  LIB              10
     C                   PARM      '*ADD    '    REPADD           10
     C                   clear                   md
      *
     C     ##_save       ENDSR
     C
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
     c                   CALL      '#MODATR'                            97
     c                   PARM                    ATR

     C                   ENDSR

