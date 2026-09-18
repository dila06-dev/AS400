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
     F************************************************************
     Hdatfmt(*eur) timfmt(*eur)

     fORDERINPUTip   f 1381        disk

     forderh    if a e             disk    RENAME(orderhpf:header)
     forderl    if a e             disk    RENAME(orderlpf:line  )

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

     D*-----------Record -------------------------------------------------------
     d*d_record      E DS                  INZ
     D*                                    prefix('#')

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
     I                             A  803 1314  #H310
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
     I          kf  99
     I*
     I*-------------------------------------------------------------------------

     c   01              exsr      srheader
     c   02              exsr      srline

     c   01              write     header
     c   02              write     line

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
     c   20              eval         error = error + %triml (' H060')

     c                   setoff                                       20
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
     c   20              eval         error = error + %triml (' H070')

     c                   setoff                                       20
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
     c   20              eval         error = error + %triml (' H360')

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
     c   20              eval         error = error + %triml (' H370')
     c
     c                   movel     #h010         h010
     c                   movel     #h020         h020
     c                   movel     #h030         h030
     c                   movel     #h040         h040
     c                   movel     #h050         h050
     c                   movel     #h060         h060
     c                   movel     #h070         h070
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
     c                   movel     #h250         h250
     c                   movel     #h260         h260
     c                   movel     #h270         h270
     c                   movel     #h280         h280
     c                   movel     #h290         h290
     c                   movel     #H300         H300
     c                   movel     #H310         H310
     c                   movel     #H320         H320
     c                   movel     #H330         H330
     c                   movel     #H340         H340
     c                   movel     #H350         H350
     c                   movel     #H360         H360
     c                   movel     #H370         H370

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
     c   20              eval         error = error + %triml (' L060')

     c                   setoff                                       20
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
     c   20              eval         error = error + %triml (' L180')

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
     c   20              eval         error = error + %triml (' L190')

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
     c   20              eval         error = error + %triml (' L200')

     c                   movel     #L010         L010
     c                   movel     #L020         L020
     c                   movel     #L030         L030
     c                   movel     #L040         L040
     c                   movel     #L050         L050
     c                   movel     #L060         L060
     c                   movel     #L070         L070
     c                   movel     #L080         L080
     c                   movel     #L090         L090
     c                   movel     #L100         L100
     c                   movel     #L100         L100
     c                   movel     #L100         L100
     c                   movel     #L100         L100
     c                   movel     #L100         L100
     c                   movel     #L100         L100
     c                   movel     #L110         L110
     c                   movel     #L120         L120
     c                   movel     #L130         L130
     c                   movel     #L140         L140
     c                   movel     #L150         L150
     c                   movel     #L160         L160
     c                   movel     #L170         L170
     c                   movel     #L180         L180
     c                   movel     #L190         L190
     c                   movel     #L200         L200
     c                   movel     #L210         L210
     c                   movel     #L220         L220
     c                   movel     #L230         L230
     c                   movel     #L240         L240
     c                   movel     #L250         L250
     c                   movel     #L990         L990

     C     ##line        ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr9999        BEGSR
     C*

     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   D_ORDER
     c/end-exec

     C     ##9999        ENDSR

     C*-------------------------------------------------------------------------

     C     *inzsr        BEGSR
      *

     C                   TIME                    Date
     c                   extrct    date:*Y       jahr
     c                   extrct    date:*M       monat
     C                   extrct    date:*D       tag

     C                   ENDSR

