
      //************************************************************************
      //
      //      Programmname       .....................
      //      Erstellt  am       2017
      //      Erstellt von       IT Dometic
      //
      */      Beschreibung
      //      SELECT * FROM checkout WHERE
      //        (ITEM      in ('9105330241','9105100002','CF-018DC','9600000460')
      //      or original  in ('9105330241','9105100002','CF-018DC','9600000460')
      //      or REPLACED1 in ('9105330241','9105100002','CF-018DC','9600000460')
      //      or REPLACED2 in ('9105330241','9105100002','CF-018DC','9600000460')
      //      or REPLACED3 in ('9105330241','9105100002','CF-018DC','9600000460')
      //      or REPLACED4 in ('9105330241','9105100002','CF-018DC','9600000460')
      //      or REPLACED5 in ('9105330241','9105100002','CF-018DC','9600000460')
      //      or REPLACED6 in ('9105330241','9105100002','CF-018DC','9600000460')
      //      or REPLACED7 in ('9105330241','9105100002','CF-018DC','9600000460')
      //      or REPLACED8 in ('9105330241','9105100002','CF-018DC','9600000460')
      //      or REPLACED9 in ('9105330241','9105100002','CF-018DC','9600000460')
      //      or artnr     in ('9105330241','9105100002','CF-018DC','9600000460')
      //      or artbezfra in ('9105330241','9105100002','CF-018DC','9600000460'))
      //      and COUNT_ISO ='NL' and JJ = 2017
      //
      //      SELECT * FROM rpmsales# WHERE DOC like '%2017/116900%'  and
      //      item in ('9105330241','9105100002','CF-018DC','9600000460')
      //
      //      SELECT DISTINCT AFRP01.RPRGJJ, AFRP01.RPRGNR, AFRP01.RPBRSU,
      //      AFRP01.RPLIJJ, AFRP01.RPLINR, AFRP01.RPLIPO FROM afrp01, afrk01
      //      WHERE RPFIRM ='01' and rkkdnr='015177' and AFRK01.RKRGJJ =2017 and
      //      AFRK01.RKFIRM = AFRp01.RpFIRM and AFRK01.RKRGNR =AFRp01.RpRGNR and
      //      AFRK01.RKRGJJ =AFRp01.RpRGJJ and AFRP01.RPTENR in
      //      ('9105330241','9105100002','CF-018DC', '9600000460')
      //   schlüsselermittlung
      //   SELECT COUNT_ISO, CUSTOMER#, CUSTOMER, ITEM, ORIGINAL, ARTNR,
      //   APPRGR,count(*) FROM checkout3 GROUP BY COUNT_ISO, CUSTOMER#,
      //   CUSTOMER, ITEM, ORIGINAL, ARTNR, APPRGR HAVING count(*) > 1 ORDER
      //   BY COUNT_ISO, CUSTOMER#, CUSTOMER, ITEM, ORIGINAL, ARTNR ,APPRGR
      // ----------------------------------+------------------------------------
      // Geändert am Kürzel Name           ! Anfo-Nr. (Zeile 1) + Beschreibung
      // ----------------------------------+------------------------------------
      //                                   !
      //  tt.mm.jjjj  xx01  .............. !
      //                                   !
      //************************************************************************

      //------------------------------------------------------------------------
      //    S T E U E R - B E S T I M M U N G E N
      //------------------------------------------------------------------------
     h datfmt(*EUR)
     h datedit(*DMY.)
     h timfmt(*HMS:)
     h decedit('0,')
     h langid('DE')
     h option(*SRCSTMT:*NoDebugIO)
     h dftactgrp(*no) actgrp(*caller)
     h copyright('IT Dometic 2017')
     h PGMINFO(*PCML:*Module)

      //------------------------------------------------------------------------
      //    D A T E I - D E F I N I T I O N E N
      //------------------------------------------------------------------------

      // Lieferscheinkopf
     fcheckout2 uf   e           k disk    RENAME(checkout2:PHY01R)
      //                                   prefix('$')
     f                                     USROPN
     fcheckout3luf   e           k disk    RENAME(checkout3:PHY02R)
      //                                   prefix('$')
     f                                     USROPN
     fcheckout3 uf   e             disk    RENAME(checkout3:PHY03R)
      //                                   prefix('$')
     f                                     USROPN
     frpmsales$$uf   e             disk    RENAME(rpmsales$$:PHY04R)
      //                                   prefix('$')
     f                                     USROPN
     faflp05    if   e           k disk

      //------------------------------------------------------------------------
      //    D A T E N S T R U K T U R E N
      //------------------------------------------------------------------------
      // System-Datenstruktur



      // System-Datenstruktur
     d DSPGM          SDS
     d  §§§PGM                 1     10
     d  §§§STS                11     15
     d  §§§SEQ                21     28
     d  §§§SR                 29     36
     d  §§§MSG                40     46
     d  §§§LIB                81     90
     d  §§§MTX                91    170
     d  §§§FIL               201    208
     d  §§§FST               209    243
     d  §§§JOB               244    253
     d  §§§USR               254    263
     d  §§§JNO               264    269  0
     d  §§§SDT               276    281  0
     d  §§§STM               282    287  0


     D MD#2            S              1    DIM(512)
     D ATR             S              1    DIM(63)
     D ATTS            S              1    DIM(1)
     D ATTK            S              1    DIM(1)
     D ATTO            S              1    DIM(1)
     D KEY             S              2    DIM(24)
     D FKTTST          S              1    DIM(6)

     d checkout2_k   E DS                  ExtName(checkout2:*key)
     d                                     Qualified
     d checkout2_i   E DS                  ExtName(checkout2:*input)
     d                                     Qualified
     d checkout2_o   E DS                  ExtName(checkout2:*output)
     d                                     Qualified

     d checkout3_k   E DS                  ExtName(checkout3l:*key)
     d                                     Qualified
     d checkout3_i   E DS                  ExtName(checkout3l:*input)
     d                                     Qualified
     d checkout3_o   E DS                  ExtName(checkout3l:*output)
     d                                     Qualified

     d checkout__i   E DS                  ExtName(checkout3:*input)
     d                                     Qualified
     d checkout__o   E DS                  ExtName(checkout3:*output)
     d                                     Qualified

     d rpmsales$$_i  E DS                  ExtName(rpmsales$$:*input)
     d                                     Qualified
     d rpmsales$$_o  E DS                  ExtName(rpmsales$$:*output)
     d                                     Qualified

     d aflp05_k      E DS                  ExtName(aflp05:*key)
     d                                     Qualified
     d aflp05_I      E DS                  ExtName(aflp05:*input)
     d                                     Qualified

      //------------------------------------------------------------------------
      //    V A R I A B L E N
      //------------------------------------------------------------------------
      // qcmdexc
      //------------------------------------------------------------------------
     D Wrk             DS                  Qualified inz
     D Var1                         480A   inz(' ')
     D L               s              9  0
     D
     D QCMDEXC         PR                  ExtPgm('QCMDEXC')
     D cmd                        32702A   const options(*varsize)
     D len                           15P 5 const

     D cmd             s            520A   varying

       // ______________________________________________________________________
       // dummy512
       // ______________________________________________________________________
     D DUMMY512        PR                  ExtPgm('DUMMY512')
       //p_md                         001a   DIM(256)
     D p_md                         256a
     D p_MSG                          7a
     D p_MSGF                        10a
     D p_PRINT                       10a
     D p_OUTFIL                      10a
     D p_LIB                         10a
     D P_REPADD                      10a

      // dummy512
      //------------------------------------------------------------------------
      // p_md            s            001a   inz
      //                                     dim(256)
     D p_md            s            256a   inz
     D p_MSG           s              7a   inz
     D p_MSGF          s             10a   inz
     D p_PRINT         s             10a   inz
     D p_OUTFIL        s             10a   inz
     D p_LIB           s             10a   inz
     D P_REPADD        s             10a   inz

     D w_rrn           s              2  0 inz
     D status          s            132A   inz
     D P_INFIL         s             21A   inz
     D §RECORDS        s              7  0 inz
     D error1          s              1a   inz
     D error2          s              1a   inz
     D error3          s              1a   inz
     D error4          s              1a   inz
     D error5          s              1a   inz
     D Quser           s             10a   inz
     D Qjob            s             10a   inz
     D Qnumber         s              6a   inz
     D link            s             26a   inz
     D Qspool          s             10a   inz
     D qlfdnr          s              4a   inz
     D qoutq           s             10a   inz
     D qinputdat       s             08a   inz
     D qinputdat#      s               d   DATFMT(*ymd)
     D qinputtime      s             08a   inz

     D §search         s              1a   inz
     D §string         s            100a   inz
     D §replace        s              1a   inz
     D §pos            s              3s 0 inz
      //------------------------------------------------------------------------
      //    V A R I A B L E N
      //------------------------------------------------------------------------

      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************

      /FREE

       Exec Sql
        set option commit = *none, datfmt = *iso, timfmt = *iso;

       eval status ='Start CHECKOUTR Analyse über rpm eingeleitet';
       exsr      SR_log;

       //exsr  SR_5000;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/checkout)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/checkout)          ';
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/checkout2)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/checkout2)          ';
             exsr      SR_log;
       endmon;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/rpmsales$$)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(qtemp/rpmsales$$)             ';
             exsr      SR_log;
       endmon;

       exec sql
          insert into  tvrelwaeco/rpmsales$$
          SELECT POSTDATE, ENTITY, COUNT_ISO, ITEM, ITEMDESC, APGLMG, ENTRY#,
          DOCTYPE, DOC, RKREDA, COST_UNIT, RPNESU, RKWACD, APPRGR, DIVISION,
          CUSTOMER#, CUSTOMER, RPMGROUP, AKFIRM, AKAFJJ, AKAFNR, AKAFAT,
          TEPRGR, PLANKUNDE, VAT#, §RKKON, TEDIAV, ABSATZAJ, ABSATZVJ,
          ABSATZVVJ, ABSATZ_, I_RKWACD, I_RPNESU, ARTNR, ARTSKU, ARTBEZFRA,
          ART, J01, A01, A02, A03, A04, A05, A06, A07, A08, A09, A10, A11,
          A12, U01, U02, U03, U04, U05, U06, U07, U08, U09, U10, U11, U12,
          H1, H2, H3, H4, H5, H6, char('  ', 3) Lager FROM rpmsales#;

       open  rpmsales$$;
       read rpmsales$$  rpmsales$$_i;
       dow not %eof(rpmsales$$);
             rpmsales$$_o  = rpmsales$$_i;
       //AFLP05
             select;
             when rpmsales$$_o.ENTITY     = 'DE411';
                  AFLP05_k.AlFIRM = '01';
             when rpmsales$$_o.ENTITY     = 'BE111';
                  AFLP05_k.AlFIRM = '08';
             when rpmsales$$_o.ENTITY     = 'NL411';
                  AFLP05_k.AlFIRM = '52';
             when rpmsales$$_o.ENTITY     = 'CH412';
                  AFLP05_k.AlFIRM = '55';
             when rpmsales$$_o.ENTITY     = 'AT411';
                  AFLP05_k.AlFIRM = '61';
             other;
                  rpmsales$$_o.ENTITY     = 'ERROR';
                  AFLP05_k.AlFIRM = '__';
             endsl;

             AFLP05_k.ALLIJJ = %dec(%subst(rpmsales$$_o.doc:13:04):4:0);
             AFLP05_k.ALLINR = %subst(rpmsales$$_o.doc:18:06);
             AFLP05_k.ALLIPO = %dec(%subst(rpmsales$$_o.doc:25:04):4:0);
             chain %kds(Aflp05_k:4) Aflp05 Aflp05_I;
             if %found(aflp05);
                rpmsales$$_o.lager   = aflp05_i.ALLANR;
             else;
                rpmsales$$_o.lager   = '???';
             endif;
             update phy04r   rpmsales$$_o;
          read rpmsales$$  rpmsales$$_i;
       enddo;
       close rpmsales$$;

       exec sql
          insert into  tvrelwaeco/CHECKOUT
          SELECT COUNT_ISO,CUSTOMER#, CUSTOMER, ITEM, item original,
          ARTNR,ARTBEZFRA, dec((rkreda/10000), 4, 0) jj,
          ENTITY,akafat, char(substr(art, 11, 3), 3) vsbd,
          char(substr(art, 07, 3), 3) dl, lager,
          dec(sum(A01), 13, 2) jana,dec(sum(A02), 13, 2) feba,
          dec(sum(A03), 13, 2) maea,dec(sum(A04), 13, 2) apra,
          dec(sum(A05), 13, 2) maia,dec(sum(A06), 13, 2) juna,
          dec(sum(A07), 13, 2) jula,dec(sum(A08), 13, 2) auga,
          dec(sum(A09), 13, 2) sepa,dec(sum(A10), 13, 2) okta,
          dec(sum(A11), 13, 2) nova,dec(sum(A12), 13, 2) deza,
          dec(sum(u01), 13, 2) janu,dec(sum(u02), 13, 2) febu,
          dec(sum(u03), 13, 2) maeu,dec(sum(u04), 13, 2) apru,
          dec(sum(u05), 13, 2) maiu,dec(sum(u06), 13, 2) junu,
          dec(sum(u07), 13, 2) julu,dec(sum(u08), 13, 2) augu,
          dec(sum(u09), 13, 2) sepu,dec(sum(u10), 13, 2) oktu,
          dec(sum(u11), 13, 2) novu,dec(sum(u12), 13, 2) dezu,
          char(' ', 15) replaced1, char(' ', 15) replaced2,
          char(' ', 15) replaced3, char(' ', 15) replaced4,
          char(' ', 15) replaced5, char(' ', 15) replaced6,
          char(' ', 15) replaced7, char(' ', 15) replaced8,
          char(' ', 15) replaced9, char(' ', 15) replaced10,
          char(' ', 50) descrip ,APPRGR, DIVISION, h4  FROM
                       tvrelwaeco/rpmsales$$
          WHERE ENTITY <> '     ' and
                                       h1 <> 'supplement' and apprgr<> ' '
          GROUP BY COUNT_ISO, CUSTOMER#, CUSTOMER, ITEM, ARTNR ,
          ARTBEZFRA, rkreda,
          ENTITY,akafat, char(substr(art, 11, 3), 3), lager,
          char(substr(art, 07, 3), 3),
              APPRGR ,DIVISION, h4  ORDER BY COUNT_ISO, CUSTOMER#,
          CUSTOMER, ITEM, DIVISION, h4;

       exec sql
          update checkout set Artbezfra=' ' where artbezfra=artnr;

       exec sql
          update checkout set artnr    =' ' where item = artnr;


       //1 replacement über beide Kombinationen
       exec sql
          update tvrelwaeco/checkout a set a.replaced1=
          (select e1 from bar_kalk/kalk_file b
           WHERE a.item = b.artnr and version='$$EL_PS_DB'
                 and a.replaced1=' ')
           where exists
          (select e1 from bar_kalk/kalk_file b
           WHERE a.item = b.artnr and version='$$EL_PS_DB'
                 and a.replaced1=' ');

       exec sql
          update tvrelwaeco/checkout a set a.replaced1=
          (select e1 from bar_kalk/kalk_file b
           WHERE a.artnr= b.artnr and version='$$EL_PS_DB'
                 and a.replaced1=' ')
           where exists
          (select e1 from bar_kalk/kalk_file b
           WHERE a.artnr= b.artnr and version='$$EL_PS_DB'
                 and a.replaced1=' ');

       //2 replacement über beide Kombinationen
       exec sql
          update tvrelwaeco/checkout a set a.replaced2=
          (select e1 from bar_kalk/kalk_file b
           WHERE a.replaced1= b.artnr and version='$$EL_PS_DB'
                 and a.replaced1<>' ')
          where exists
           (select e1 from bar_kalk/kalk_file b
           WHERE a.replaced1= b.artnr and version='$$EL_PS_DB'
                 and a.replaced1<>' ');

       //3 replacement über beide Kombinationen
       exec sql
          update tvrelwaeco/checkout a set a.replaced3=
          (select e1 from bar_kalk/kalk_file b
            WHERE a.replaced2= b.artnr and version='$$EL_PS_DB'
            and a.replaced2<>' ')
           where exists
           (select e1 from bar_kalk/kalk_file b
            WHERE a.replaced2= b.artnr and version='$$EL_PS_DB'
            and a.replaced2<>' ');

       //4 replacement über beide Kombinationen
       exec sql
          update tvrelwaeco/checkout a set a.replaced4=
          (select e1 from bar_kalk/kalk_file b
            WHERE a.replaced3= b.artnr and version='$$EL_PS_DB'
            and a.replaced3<>' ')
           where exists
           (select e1 from bar_kalk/kalk_file b
            WHERE a.replaced3= b.artnr and version='$$EL_PS_DB'
            and a.replaced3<>' ');

       //5 replacement über beide Kombinationen
       exec sql
          update tvrelwaeco/checkout a set a.replaced5=
          (select e1 from bar_kalk/kalk_file b
            WHERE a.replaced4= b.artnr and version='$$EL_PS_DB'
            and a.replaced4<>' ')
           where exists
           (select e1 from bar_kalk/kalk_file b
            WHERE a.replaced4= b.artnr and version='$$EL_PS_DB'
            and a.replaced4<>' ');

       //6 replacement über beide Kombinationen
       exec sql
          update tvrelwaeco/checkout a set a.replaced6=
          (select e1 from bar_kalk/kalk_file b
            WHERE a.replaced5= b.artnr and version='$$EL_PS_DB'
            and a.replaced5<>' ')
           where exists
           (select e1 from bar_kalk/kalk_file b
            WHERE a.replaced5= b.artnr and version='$$EL_PS_DB'
            and a.replaced5<>' ');

       //7 replacement über beide Kombinationen
       exec sql
          update tvrelwaeco/checkout a set a.replaced7=
          (select e1 from bar_kalk/kalk_file b
            WHERE a.replaced6= b.artnr and version='$$EL_PS_DB'
            and a.replaced6<>' ')
           where exists
           (select e1 from bar_kalk/kalk_file b
            WHERE a.replaced6= b.artnr and version='$$EL_PS_DB'
            and a.replaced6<>' ');

       //8 replacement über beide Kombinationen
       exec sql
          update tvrelwaeco/checkout a set a.replaced8=
          (select e1 from bar_kalk/kalk_file b
            WHERE a.replaced7= b.artnr and version='$$EL_PS_DB'
            and a.replaced7<>' ')
           where exists
           (select e1 from bar_kalk/kalk_file b
            WHERE a.replaced7= b.artnr and version='$$EL_PS_DB'
            and a.replaced7<>' ');

       //Übergabe zum Hauptartikel in der Folge
       exec sql
          update checkout set item=REPLACED7
                 where  REPLACED7<> ' 'and REPLACED8 = ' ';
       exec sql
          update checkout set item=REPLACED6
                 where  REPLACED6<> ' 'and REPLACED7 = ' ';
       exec sql
          update checkout set item=REPLACED5
                 where  REPLACED5<> ' 'and REPLACED6 = ' ';
       exec sql
          update checkout set item=REPLACED4
                 where  REPLACED4<> ' 'and REPLACED5 = ' ';
       exec sql
          update checkout set item=REPLACED3
                 where  REPLACED3<> ' 'and REPLACED4 = ' ';
       exec sql
          update checkout set item=REPLACED2
                 where  REPLACED2<> ' 'and REPLACED3 = ' ';
       exec sql
          update checkout set item=REPLACED1
                 where  REPLACED1<> ' 'and REPLACED2 = ' ';

       //Übergabe einheitliche Beschreibung
       exec sql
          update checkout set DESCRIP  =
          (select TETBZ1 from teil01 where tefirm ='01'
           and tetenr = item)
          where exists
          (select TETBZ1 from teil01 where tefirm ='01'
           and tetenr = item);

       exec sql
          update checkout set DESCRIP  =
          (select TETBZ1 from teil01 where tefirm ='01'
           and tetenr = artnr and descrip= ' ')
          where exists
          (select TETBZ1 from teil01 where tefirm ='01'
           and tetenr = artnr and descrip= ' ');

       //Übergabe einheitliche Beschreibung

       exec sql
          delete from tvrelwaeco/checkoutp;

       exec sql
          insert into tvrelwaeco/checkout2
          SELECT COUNT_ISO, CUSTOMER#, CUSTOMER, ITEM, original,
                 ARTNR, ARTBEZFRA,
          DESCRIP, APPRGR, REPLACED1, REPLACED2, REPLACED3, REPLACED4,
          REPLACED5, REPLACED6,jj, entity, akafat, vsbd, dl, lager,
          Division, h4,            char(' ', 5) DISP, char(' ', 5) EK,
          sum(JANA) sel0017 , sum(FEBA) sel0018 ,sum(MAEA) sel0019 ,
          sum(APRA) sel0020 , sum(MAIA) sel0021 ,sum(JUNA) sel0022 ,
          sum(JUlA) sel0023 , sum(AUGA) sel0024 ,sum(SEPA) sel0025 ,
          sum(OKTA) sel0026 , sum(NOVA) sel0027 ,sum(DEZA) sel0028 ,
          sum(JANU) sel0029 , sum(FEBU) sel0030 ,sum(maeu) sel0031 ,
          sum(APRU) sel0032 , sum(MAIU) sel0033 ,sum(JUNU) sel0034 ,
          sum(JUlU) sel0035 , sum(AUGU) sel0036 ,sum(SEPU) sel0037 ,
          sum(OKTU) sel0038 , sum(NOVU) sel0039 ,sum(DEZU) sel0040
          FROM checkout GROUP BY COUNT_ISO,CUSTOMER#,CUSTOMER,item,original,
          ARTNR, ARTBEZFRA, DESCRIP, APPRGR, Division, h4,
          REPLACED1,REPLACED2,REPLACED3,REPLACED4,REPLACED5,REPLACED6,jj,
          entity, akafat, vsbd, dl, lager;
       //Übergabe einheitliche Beschreibung

          exsr SR_5000;

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/ALBERS2)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/ALBERS2)            ';
             exsr      SR_log;
       endmon;

         exec sql
          insert into tvrelwaeco/ALBERS2
          SELECT * FROM CHECKOUT3 WHERE APPRGR ='702' and entity ='DE411'
          AND ( ORIGINAL IN (SELECT ARTNR
                    FROM BAR_KALK/KALK_FILE WHERE VERSION='$$EL_PS_DB' AND
                    ARTBEZ NOT LIKE('%SCHUTZHAUBE%')   AND
            STATNR='106' AND (( LIEFERANT1 ='90862' OR LIEFERANT2 ='90862')
                         OR  ( LIEFERANT1 ='92434' OR LIEFERANT2 ='92434')))
               OR
                ARTNR    IN (SELECT ARTNR
                    FROM BAR_KALK/KALK_FILE WHERE VERSION='$$EL_PS_DB' AND
                    ARTBEZ NOT LIKE('%SCHUTZHAUBE%')   AND
            STATNR='106' AND (( LIEFERANT1 ='90862' OR LIEFERANT2 ='90862')
                         OR  ( LIEFERANT1 ='92434' OR LIEFERANT2 ='92434'))));

          exsr SR_output;

       eval status ='Ende CHECKOUTR Analyse über rpm eingeleitet';
       exsr      SR_log;

       *inlr = *on;


       //-----------------------------------------------------------------------
       //sr5000
       //-----------------------------------------------------------------------

       begsr SR_5000;

       //Übergabe einheitliche Beschreibung

       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(tvrelwaeco/checkout3)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(tvrelwaeco/checkout3)          ';
             exsr      SR_log;
       endmon;

       exec sql
          insert into tvrelwaeco/checkout3
          SELECT distinct
          COUNT_ISO, CUSTOMER#, CUSTOMER, ITEM, ORIGINAL, ARTNR,
          ARTBEZFRA, DESCRIP, APPRGR, REPLACED1, REPLACED2, REPLACED3,
          REPLACED4, REPLACED5, REPLACED6,
          char(' ', 5) DISP, char(' ', 5) EK, division,h4,
          dec(jj*0+2015, 4, 0) jahr_1, entity, akafat, vsbd, dl, lager,
                  dec(sel0017*0, 9, 2) AbJan_1, dec(sel0018*0, 9, 2) AbFeb_1,
                  dec(sel0019*0, 9, 2) AbMAE_1, dec(sel0020*0, 9, 2) AbApr_1,
                  dec(sel0021*0, 9, 2) AbMAi_1, dec(sel0022*0, 9, 2) AbJun_1,
                  dec(sel0023*0, 9, 2) AbJul_1, dec(sel0024*0, 9, 2) AbAug_1,
                  dec(sel0025*0, 9, 2) AbSep_1, dec(sel0026*0, 9, 2) AbOkt_1,
                  dec(sel0027*0, 9, 2) AbNov_1, dec(sel0028*0, 9, 2) AbDez_1,
                  dec(sel0029*0, 9, 2) UmJan_1, dec(sel0030*0, 9, 2) UmFeb_1,
                  dec(sel0031*0, 9, 2) UmMAE_1, dec(sel0032*0, 9, 2) UmApr_1,
                  dec(sel0033*0, 9, 2) UmMAi_1, dec(sel0034*0, 9, 2) UmJun_1,
                  dec(sel0035*0, 9, 2) UmJul_1, dec(sel0036*0, 9, 2) UmAug_1,
                  dec(sel0037*0, 9, 2) UmSep_1, dec(sel0038*0, 9, 2) UmOkt_1,
                  dec(sel0039*0, 9, 2) UmNov_1, dec(sel0040*0, 9, 2) UmDez_1,
          dec(jj*0+2016, 4, 0) jahr_2,
                  dec(sel0017*0, 9, 2) AbJan_2, dec(sel0018*0, 9, 2) AbFeb_2,
                  dec(sel0019*0, 9, 2) AbMAE_2, dec(sel0020*0, 9, 2) AbApr_2,
                  dec(sel0021*0, 9, 2) AbMAi_2, dec(sel0022*0, 9, 2) AbJun_2,
                  dec(sel0023*0, 9, 2) AbJul_2, dec(sel0024*0, 9, 2) AbAug_2,
                  dec(sel0025*0, 9, 2) AbSep_2, dec(sel0026*0, 9, 2) AbOkt_2,
                  dec(sel0027*0, 9, 2) AbNov_2, dec(sel0028*0, 9, 2) AbDez_2,
                  dec(sel0029*0, 9, 2) UmJan_2, dec(sel0030*0, 9, 2) UmFeb_2,
                  dec(sel0031*0, 9, 2) UmMAE_2, dec(sel0032*0, 9, 2) UmApr_2,
                  dec(sel0033*0, 9, 2) UmMAi_2, dec(sel0034*0, 9, 2) UmJun_2,
                  dec(sel0035*0, 9, 2) UmJul_2, dec(sel0036*0, 9, 2) UmAug_2,
                  dec(sel0037*0, 9, 2) UmSep_2, dec(sel0038*0, 9, 2) UmOkt_2,
                  dec(sel0039*0, 9, 2) UmNov_2, dec(sel0040*0, 9, 2) UmDez_2,
          dec(jj*0+2017, 4, 0) jahr_3,
                  dec(sel0017*0, 9, 2) AbJan_3, dec(sel0018*0, 9, 2) AbFeb_3,
                  dec(sel0019*0, 9, 2) AbMAE_3, dec(sel0020*0, 9, 2) AbApr_3,
                  dec(sel0021*0, 9, 2) AbMAi_3, dec(sel0022*0, 9, 2) AbJun_3,
                  dec(sel0023*0, 9, 2) AbJul_3, dec(sel0024*0, 9, 2) AbAug_3,
                  dec(sel0025*0, 9, 2) AbSep_3, dec(sel0026*0, 9, 2) AbOkt_3,
                  dec(sel0027*0, 9, 2) AbNov_3, dec(sel0028*0, 9, 2) AbDez_3,
                  dec(sel0029*0, 9, 2) UmJan_3, dec(sel0030*0, 9, 2) UmFeb_3,
                  dec(sel0031*0, 9, 2) UmMAE_3, dec(sel0032*0, 9, 2) UmApr_3,
                  dec(sel0033*0, 9, 2) UmMAi_3, dec(sel0034*0, 9, 2) UmJun_3,
                  dec(sel0035*0, 9, 2) UmJul_3, dec(sel0036*0, 9, 2) UmAug_3,
                  dec(sel0037*0, 9, 2) UmSep_3, dec(sel0038*0, 9, 2) UmOkt_3,
                  dec(sel0039*0, 9, 2) UmNov_3, dec(sel0040*0, 9, 2) UmDez_3,
          dec(jj*0+2018, 4, 0) jahr_4,
                  dec(sel0017*0, 9, 2) AbJan_4, dec(sel0018*0, 9, 2) AbFeb_4,
                  dec(sel0019*0, 9, 2) AbMAE_4, dec(sel0020*0, 9, 2) AbApr_4,
                  dec(sel0021*0, 9, 2) AbMAi_4, dec(sel0022*0, 9, 2) AbJun_4,
                  dec(sel0023*0, 9, 2) AbJul_4, dec(sel0024*0, 9, 2) AbAug_4,
                  dec(sel0025*0, 9, 2) AbSep_4, dec(sel0026*0, 9, 2) AbOkt_4,
                  dec(sel0027*0, 9, 2) AbNov_4, dec(sel0028*0, 9, 2) AbDez_4,
                  dec(sel0029*0, 9, 2) UmJan_4, dec(sel0030*0, 9, 2) UmFeb_4,
                  dec(sel0031*0, 9, 2) UmMAE_4, dec(sel0032*0, 9, 2) UmApr_4,
                  dec(sel0033*0, 9, 2) UmMAi_4, dec(sel0034*0, 9, 2) UmJun_4,
                  dec(sel0035*0, 9, 2) UmJul_4, dec(sel0036*0, 9, 2) UmAug_4,
                  dec(sel0037*0, 9, 2) UmSep_4, dec(sel0038*0, 9, 2) UmOkt_4,
                  dec(sel0039*0, 9, 2) UmNov_4, dec(sel0040*0, 9, 2) UmDez_4,
          char(' ', 2) stat, dec(0, 9, 3) secstock, dec(0, 9, 3) leadtime
          FROM checkout2;

       exec sql
          create index tvrelwaeco/checkout3l on
                       tvrelwaeco/checkout3
                 (COUNT_ISO, CUSTOMER#, CUSTOMER, ITEM, ORIGINAL, ARTNR,
                  ARTBEZFRA, DESCRIP,   APPRGR,   REPLACED1, REPLACED2,
                  REPLACED3, REPLACED4, REPLACED5, REPLACED6, disp, ek,
                  entity, akafat, vsbd, dl, division, h4, lager);
       open  checkout2 ;
       open  checkout3l;

       read checkout2   checkout2_i;
       dow not %eof(checkout2);
          if checkout2_i.jj        =  2017 and
             checkout2_i.CUSTOMER# = '030583' and
             checkout2_i.ITEM      = '9105330283';
             checkout2_i.ITEM      = '9105330283';
          endif;
       //,,,
          if checkout2_i.jj =  2015 or
             checkout2_i.jj =  2016 or
             checkout2_i.jj =  2017 or
             checkout2_i.jj =  2018;
             checkout3_K.COUNT_ISO  =  checkout2_i.COUNT_ISO;
             checkout3_K.CUSTOMER#  =  checkout2_i.CUSTOMER#;
             checkout3_K.CUSTOMER   =  checkout2_i.CUSTOMER ;
             checkout3_K.ITEM       =  checkout2_i.ITEM     ;
             checkout3_K.ORIGINAL   =  checkout2_i.ORIGINAL ;
             checkout3_K.ARTNR      =  checkout2_i.ARTNR    ;
             checkout3_K.ARTBEZFRA  =  checkout2_i.ARTBEZFRA;
             checkout3_K.DESCRIP    =  checkout2_i.DESCRIP  ;
             checkout3_K.APPRGR     =  checkout2_i.APPRGR   ;
             checkout3_K.REPLACED1  =  checkout2_i.REPLACED1;
             checkout3_K.REPLACED2  =  checkout2_i.REPLACED2;
             checkout3_K.REPLACED3  =  checkout2_i.REPLACED3;
             checkout3_K.REPLACED4  =  checkout2_i.REPLACED4;
             checkout3_K.REPLACED5  =  checkout2_i.REPLACED5;
             checkout3_K.REPLACED6  =  checkout2_i.REPLACED6;
             checkout3_K.entity     =  checkout2_i.entity   ;
             checkout3_K.akafat     =  checkout2_i.akafat   ;
             checkout3_K.vsbd       =  checkout2_i.vsbd     ;
             checkout3_K.disp       =  checkout2_i.disp     ;
             checkout3_K.ek         =  checkout2_i.ek       ;
             checkout3_K.dl         =  checkout2_i.dl       ;
             checkout3_K.division   =  checkout2_i.division ;
             checkout3_K.h4         =  checkout2_i.h4       ;
             checkout3_K.lager      =  checkout2_i.lager    ;
             chain %kds(checkout3_k:23)  checkout3l  checkout3_I;
             if %found(checkout3l);
                checkout3_o   = checkout3_i;
                if checkout2_i.jj = 2015;
                   checkout3_O.JAHR_1     = checkout2_i.jj;
                   checkout3_O.ABJAN_1=checkout3_O.ABJAN_1 +checkout2_i.SEL0017;
                   checkout3_O.ABFEB_1=checkout3_O.ABFEB_1 +checkout2_i.SEL0018;
                   checkout3_O.ABMAE_1=checkout3_O.ABMAE_1 +checkout2_i.SEL0019;
                   checkout3_O.ABAPR_1=checkout3_O.ABAPR_1 +checkout2_i.SEL0020;
                   checkout3_O.ABMAI_1=checkout3_O.ABMAI_1 +checkout2_i.SEL0021;
                   checkout3_O.ABJUN_1=checkout3_O.ABJUN_1 +checkout2_i.SEL0022;
                   checkout3_O.ABJUL_1=checkout3_O.ABJUL_1 +checkout2_i.SEL0023;
                   checkout3_O.ABAUG_1=checkout3_O.ABAUG_1 +checkout2_i.SEL0024;
                   checkout3_O.ABSEP_1=checkout3_O.ABSEP_1 +checkout2_i.SEL0025;
                   checkout3_O.ABOKT_1=checkout3_O.ABOKT_1 +checkout2_i.SEL0026;
                   checkout3_O.ABNOV_1=checkout3_O.ABNOV_1 +checkout2_i.SEL0027;
                   checkout3_O.ABDEZ_1=checkout3_O.ABDEZ_1 +checkout2_i.SEL0028;

                   checkout3_O.UMJAN_1=checkout3_O.UMJAN_1 +checkout2_i.SEL0029;
                   checkout3_O.UMFEB_1=checkout3_O.UMFEB_1 +checkout2_i.SEL0030;
                   checkout3_O.UMMAE_1=checkout3_O.UMMAE_1 +checkout2_i.SEL0031;
                   checkout3_O.UMAPR_1=checkout3_O.UMAPR_1 +checkout2_i.SEL0032;
                   checkout3_O.UMMAI_1=checkout3_O.UMMAI_1 +checkout2_i.SEL0033;
                   checkout3_O.UMJUN_1=checkout3_O.UMJUN_1 +checkout2_i.SEL0034;
                   checkout3_O.UMJUL_1=checkout3_O.UMJUL_1 +checkout2_i.SEL0035;
                   checkout3_O.UMAUG_1=checkout3_O.UMAUG_1 +checkout2_i.SEL0036;
                   checkout3_O.UMSEP_1=checkout3_O.UMSEP_1 +checkout2_i.SEL0037;
                   checkout3_O.UMOKT_1=checkout3_O.UMOKT_1 +checkout2_i.SEL0038;
                   checkout3_O.UMNOV_1=checkout3_O.UMNOV_1 +checkout2_i.SEL0039;
                   checkout3_O.UMDEZ_1=checkout3_O.UMDEZ_1 +checkout2_i.SEL0040;
                   update phy02r   checkout3_o;
                endif;
                if checkout2_i.jj = 2016;
                   checkout3_O.JAHR_2     =  checkout2_i.jj;
                   checkout3_O.ABJAN_2=checkout3_O.ABJAN_2 +checkout2_i.SEL0017;
                   checkout3_O.ABFEB_2=checkout3_O.ABFEB_2 +checkout2_i.SEL0018;
                   checkout3_O.ABMAE_2=checkout3_O.ABMAE_2 +checkout2_i.SEL0019;
                   checkout3_O.ABAPR_2=checkout3_O.ABAPR_2 +checkout2_i.SEL0020;
                   checkout3_O.ABMAI_2=checkout3_O.ABMAI_2 +checkout2_i.SEL0021;
                   checkout3_O.ABJUN_2=checkout3_O.ABJUN_2 +checkout2_i.SEL0022;
                   checkout3_O.ABJUL_2=checkout3_O.ABJUL_2 +checkout2_i.SEL0023;
                   checkout3_O.ABAUG_2=checkout3_O.ABAUG_2 +checkout2_i.SEL0024;
                   checkout3_O.ABSEP_2=checkout3_O.ABSEP_2 +checkout2_i.SEL0025;
                   checkout3_O.ABOKT_2=checkout3_O.ABOKT_2 +checkout2_i.SEL0026;
                   checkout3_O.ABNOV_2=checkout3_O.ABNOV_2 +checkout2_i.SEL0027;
                   checkout3_O.ABDEZ_2=checkout3_O.ABDEZ_2 +checkout2_i.SEL0028;

                   checkout3_O.UMJAN_2=checkout3_O.UMJAN_2 +checkout2_i.SEL0029;
                   checkout3_O.UMFEB_2=checkout3_O.UMFEB_2 +checkout2_i.SEL0030;
                   checkout3_O.UMMAE_2=checkout3_O.UMMAE_2 +checkout2_i.SEL0031;
                   checkout3_O.UMAPR_2=checkout3_O.UMAPR_2 +checkout2_i.SEL0032;
                   checkout3_O.UMMAI_2=checkout3_O.UMMAI_2 +checkout2_i.SEL0033;
                   checkout3_O.UMJUN_2=checkout3_O.UMJUN_2 +checkout2_i.SEL0034;
                   checkout3_O.UMJUL_2=checkout3_O.UMJUL_2 +checkout2_i.SEL0035;
                   checkout3_O.UMAUG_2=checkout3_O.UMAUG_2 +checkout2_i.SEL0036;
                   checkout3_O.UMSEP_2=checkout3_O.UMSEP_2 +checkout2_i.SEL0037;
                   checkout3_O.UMOKT_2=checkout3_O.UMOKT_2 +checkout2_i.SEL0038;
                   checkout3_O.UMNOV_2=checkout3_O.UMNOV_2 +checkout2_i.SEL0039;
                   checkout3_O.UMDEZ_2=checkout3_O.UMDEZ_2 +checkout2_i.SEL0040;
                   update phy02r   checkout3_o;
                endif;
                if checkout2_i.jj = 2017;
                   checkout3_O.JAHR_3     =  checkout2_i.jj;
                   checkout3_O.ABJAN_3=checkout3_O.ABJAN_3 +checkout2_i.SEL0017;
                   checkout3_O.ABFEB_3=checkout3_O.ABFEB_3 +checkout2_i.SEL0018;
                   checkout3_O.ABMAE_3=checkout3_O.ABMAE_3 +checkout2_i.SEL0019;
                   checkout3_O.ABAPR_3=checkout3_O.ABAPR_3 +checkout2_i.SEL0020;
                   checkout3_O.ABMAI_3=checkout3_O.ABMAI_3 +checkout2_i.SEL0021;
                   checkout3_O.ABJUN_3=checkout3_O.ABJUN_3 +checkout2_i.SEL0022;
                   checkout3_O.ABJUL_3=checkout3_O.ABJUL_3 +checkout2_i.SEL0023;
                   checkout3_O.ABAUG_3=checkout3_O.ABAUG_3 +checkout2_i.SEL0024;
                   checkout3_O.ABSEP_3=checkout3_O.ABSEP_3 +checkout2_i.SEL0025;
                   checkout3_O.ABOKT_3=checkout3_O.ABOKT_3 +checkout2_i.SEL0026;
                   checkout3_O.ABNOV_3=checkout3_O.ABNOV_3 +checkout2_i.SEL0027;
                   checkout3_O.ABDEZ_3=checkout3_O.ABDEZ_3 +checkout2_i.SEL0028;

                   checkout3_O.UMJAN_3=checkout3_O.UMJAN_3 +checkout2_i.SEL0029;
                   checkout3_O.UMFEB_3=checkout3_O.UMFEB_3 +checkout2_i.SEL0030;
                   checkout3_O.UMMAE_3=checkout3_O.UMMAE_3 +checkout2_i.SEL0031;
                   checkout3_O.UMAPR_3=checkout3_O.UMAPR_3 +checkout2_i.SEL0032;
                   checkout3_O.UMMAI_3=checkout3_O.UMMAI_3 +checkout2_i.SEL0033;
                   checkout3_O.UMJUN_3=checkout3_O.UMJUN_3 +checkout2_i.SEL0034;
                   checkout3_O.UMJUL_3=checkout3_O.UMJUL_3 +checkout2_i.SEL0035;
                   checkout3_O.UMAUG_3=checkout3_O.UMAUG_3 +checkout2_i.SEL0036;
                   checkout3_O.UMSEP_3=checkout3_O.UMSEP_3 +checkout2_i.SEL0037;
                   checkout3_O.UMOKT_3=checkout3_O.UMOKT_3 +checkout2_i.SEL0038;
                   checkout3_O.UMNOV_3=checkout3_O.UMNOV_3 +checkout2_i.SEL0039;
                   checkout3_O.UMDEZ_3=checkout3_O.UMDEZ_3 +checkout2_i.SEL0040;
                   update phy02r   checkout3_o;
                endif;
                if checkout2_i.jj = 2018;
                   checkout3_O.JAHR_4     =  checkout2_i.jj;
                   checkout3_O.ABJAN_4=checkout3_O.ABJAN_4 +checkout2_i.SEL0017;
                   checkout3_O.ABFEB_4=checkout3_O.ABFEB_4 +checkout2_i.SEL0018;
                   checkout3_O.ABMAE_4=checkout3_O.ABMAE_4 +checkout2_i.SEL0019;
                   checkout3_O.ABAPR_4=checkout3_O.ABAPR_4 +checkout2_i.SEL0020;
                   checkout3_O.ABMAI_4=checkout3_O.ABMAI_4 +checkout2_i.SEL0021;
                   checkout3_O.ABJUN_4=checkout3_O.ABJUN_4 +checkout2_i.SEL0022;
                   checkout3_O.ABJUL_4=checkout3_O.ABJUL_4 +checkout2_i.SEL0023;
                   checkout3_O.ABAUG_4=checkout3_O.ABAUG_4 +checkout2_i.SEL0024;
                   checkout3_O.ABSEP_4=checkout3_O.ABSEP_4 +checkout2_i.SEL0025;
                   checkout3_O.ABOKT_4=checkout3_O.ABOKT_4 +checkout2_i.SEL0026;
                   checkout3_O.ABNOV_4=checkout3_O.ABNOV_4 +checkout2_i.SEL0027;
                   checkout3_O.ABDEZ_4=checkout3_O.ABDEZ_4 +checkout2_i.SEL0028;

                   checkout3_O.UMJAN_4=checkout3_O.UMJAN_4 +checkout2_i.SEL0029;
                   checkout3_O.UMFEB_4=checkout3_O.UMFEB_4 +checkout2_i.SEL0030;
                   checkout3_O.UMMAE_4=checkout3_O.UMMAE_4 +checkout2_i.SEL0031;
                   checkout3_O.UMAPR_4=checkout3_O.UMAPR_4 +checkout2_i.SEL0032;
                   checkout3_O.UMMAI_4=checkout3_O.UMMAI_4 +checkout2_i.SEL0033;
                   checkout3_O.UMJUN_4=checkout3_O.UMJUN_4 +checkout2_i.SEL0034;
                   checkout3_O.UMJUL_4=checkout3_O.UMJUL_4 +checkout2_i.SEL0035;
                   checkout3_O.UMAUG_4=checkout3_O.UMAUG_4 +checkout2_i.SEL0036;
                   checkout3_O.UMSEP_4=checkout3_O.UMSEP_4 +checkout2_i.SEL0037;
                   checkout3_O.UMOKT_4=checkout3_O.UMOKT_4 +checkout2_i.SEL0038;
                   checkout3_O.UMNOV_4=checkout3_O.UMNOV_4 +checkout2_i.SEL0039;
                   checkout3_O.UMDEZ_4=checkout3_O.UMDEZ_4 +checkout2_i.SEL0040;
                   update phy02r   checkout3_o;
                endif;
             endif;
          endif;
          checkout2_o   = checkout2_i;
          update phy01r   checkout2_o;
          read checkout2   checkout2_i;
       enddo;

       close checkout2 ;
       close checkout3l;

       open  checkout3;
       read checkout3   checkout__i;
       dow not %eof(checkout3);
             checkout__o  = checkout__i;
             §search              = ';';
             §string              = checkout__O.CUSTOMER;
             §replace             = ' ';
             §pos                 = 0 ;
             exsr      scanstr;
             checkout__O.CUSTOMER = §string;

             §search              = ',';
             §string              = checkout__O.CUSTOMER;
             §replace             = ' ';
             §pos                 = 0 ;
             exsr      scanstr;
             checkout__O.CUSTOMER = §string;

             §search              = '"';
             §string              = checkout__O.CUSTOMER;
             §replace             = ' ';
             §pos                 = 0 ;
             exsr      scanstr;
             checkout__O.CUSTOMER = §string;

             §search              = '`';
             §string              = checkout__O.CUSTOMER;
             §replace             = ' ';
             §pos                 = 0 ;
             exsr      scanstr;
             checkout3_O.CUSTOMER = §string;

             §search              = ';';
             §string              = checkout__O.ARTBEZFRA;
             §replace             = ' ';
             §pos                 = 0 ;
             exsr      scanstr;
             checkout__O.ARTBEZFRA= §string;

             §search              = ',';
             §string              = checkout__O.ARTBEZFRA;
             §replace             = ' ';
             §pos                 = 0 ;
             exsr      scanstr;
             checkout__O.ARTBEZFRA= §string;

             §search              = '"';
             §string              = checkout__O.ARTBEZFRA;
             §replace             = ' ';
             §pos                 = 0 ;
             exsr      scanstr;
             checkout__O.ARTBEZFRA= §string;

             §search              = '`';
             §string              = checkout__O.ARTBEZFRA;
             §replace             = ' ';
             §pos                 = 0 ;
             exsr      scanstr;
             checkout__O.ARTBEZFRA= §string;

             §search              = ';';
             §string              = checkout__O.DESCRIP ;
             §replace             = ' ';
             §pos                 = 0 ;
             exsr      scanstr;
             checkout__O.DESCRIP  = §string;

             §search              = ',';
             §string              = checkout__O.DESCRIP;
             §replace             = ' ';
             §pos                 = 0 ;
             exsr      scanstr;
             checkout__O.DESCRIP  = §string;

             §search              = '"';
             §string              = checkout__O.DESCRIP;
             §replace             = ' ';
             §pos                 = 0 ;
             exsr      scanstr;
             checkout__O.DESCRIP  = §string;

             §search              = '`';
             §string              = checkout__O.DESCRIP;
             §replace             = ' ';
             §pos                 = 0 ;
             exsr      scanstr;
             checkout__O.DESCRIP  = §string;
             update phy03r   checkout__o;
          read checkout3   checkout__i;
       enddo;
       close checkout3;

       exec sql
         update checkout3 set DISP     =
         (select TEDIEK from teil01 where tefirm ='01'
          and tetenr = item)
         where exists
         (select TEDIEK from teil01 where tefirm ='01'
          and tetenr = item);

       exec sql
         update checkout3 set ek       =
         (select TESAEK from teil01 where tefirm ='01'
          and tetenr = item)
         where exists
         (select TESAEK from teil01 where tefirm ='01'
          and tetenr = item);

       // Vorlaufzeit
       exec sql
         update checkout3 set leadtime =
         (select TEVOZ1 from teil01 where tefirm ='01'
          and tetenr = item)
         where exists
         (select TEVOZ1 from teil01 where tefirm ='01'
          and tetenr = item);

       // Sicherheitsbestand
       exec sql
         update checkout3 set secstock =
         (select TEsibe from teil01 where tefirm ='01'
          and tetenr = item)
         where exists
         (select TEsibe from teil01 where tefirm ='01'
          and tetenr = item);

       // Status
       exec sql
         update checkout3 set stat     =
         (select TETEST from teil01 where tefirm ='01'
          and tetenr = item)
         where exists
         (select TETEST from teil01 where tefirm ='01'
          and tetenr = item);

       //update Gleichheit Division
       //exec sql
       // update TVRELWAECO/checkout3  set division  =
       // (select KDEWKSST from kdew01 where kdewfirm='01'
       //  and kdewkdnr=CUSTOMER#)
       // where exists
       // (select KDEWKSST from kdew01 where kdewfirm='01'
       //  and kdewkdnr=CUSTOMER#);

       //update Gleichheit Division
       //exec sql
       // update TVRELWAECO/checkout3  set division  = case
       // When division = '1001      ' then 'RVOEM     '
       // When division = '1002      ' then 'RVAM      '
       // When division = '1003      ' then 'RETL      '
       // When division = '1004      ' then 'LODG      '
       // When division = '1005      ' then 'CPVOEM    '
       // When division = '1006      ' then 'CPVAM     '
       // When division = '1007      ' then 'MAOEM     '
       // When division = '1008      ' then 'MAAM      '
       // When division = '1009      ' then 'MEDI      '
       // When division = '1015      ' then 'GROUP     '
       // When division = '1020      ' then 'OTHER 1020'
       // When division = '6050      ' then 'OTHER 6050'
       // else 'undefined'
       // end;

       endsr;

       //-----------------------------------------------------------------------
       //%
       //-----------------------------------------------------------------------

       begsr inp;

                   checkout3_O.ABJAN_1=checkout3_O.ABJAN_1 +checkout2_i.SEL0017;
                   checkout3_O.ABFEB_1=checkout3_O.ABFEB_1 +checkout2_i.SEL0018;
                   checkout3_O.ABMAE_1=checkout3_O.ABMAE_1 +checkout2_i.SEL0019;
                   checkout3_O.ABAPR_1=checkout3_O.ABAPR_1 +checkout2_i.SEL0020;
                   checkout3_O.ABMAI_1=checkout3_O.ABMAI_1 +checkout2_i.SEL0021;
                   checkout3_O.ABJUN_1=checkout3_O.ABJUN_1 +checkout2_i.SEL0022;
                   checkout3_O.ABJUL_1=checkout3_O.ABJUL_1 +checkout2_i.SEL0023;
                   checkout3_O.ABAUG_1=checkout3_O.ABAUG_1 +checkout2_i.SEL0024;
                   checkout3_O.ABSEP_1=checkout3_O.ABSEP_1 +checkout2_i.SEL0025;
                   checkout3_O.ABOKT_1=checkout3_O.ABOKT_1 +checkout2_i.SEL0026;
                   checkout3_O.ABNOV_1=checkout3_O.ABNOV_1 +checkout2_i.SEL0027;
                   checkout3_O.ABDEZ_1=checkout3_O.ABDEZ_1 +checkout2_i.SEL0028;

                   checkout3_O.UMJAN_1=checkout3_O.UMJAN_1 +checkout2_i.SEL0029;
                   checkout3_O.UMFEB_1=checkout3_O.UMFEB_1 +checkout2_i.SEL0030;
                   checkout3_O.UMMAE_1=checkout3_O.UMMAE_1 +checkout2_i.SEL0031;
                   checkout3_O.UMAPR_1=checkout3_O.UMAPR_1 +checkout2_i.SEL0032;
                   checkout3_O.UMMAI_1=checkout3_O.UMMAI_1 +checkout2_i.SEL0033;
                   checkout3_O.UMJUN_1=checkout3_O.UMJUN_1 +checkout2_i.SEL0034;
                   checkout3_O.UMJUL_1=checkout3_O.UMJUL_1 +checkout2_i.SEL0035;
                   checkout3_O.UMAUG_1=checkout3_O.UMAUG_1 +checkout2_i.SEL0036;
                   checkout3_O.UMSEP_1=checkout3_O.UMSEP_1 +checkout2_i.SEL0037;
                   checkout3_O.UMOKT_1=checkout3_O.UMOKT_1 +checkout2_i.SEL0038;
                   checkout3_O.UMNOV_1=checkout3_O.UMNOV_1 +checkout2_i.SEL0039;
                   checkout3_O.UMDEZ_1=checkout3_O.UMDEZ_1 +checkout2_i.SEL0040;

       endsr;
       //-----------------------------------------------------------------------
       //%scan Zeichen(§search) ersetzten durch(§replace) in string(§string)
       //-----------------------------------------------------------------------

       begsr scanstr;

             §pos = %scan(§search: §string);
             dow §pos > 0;
                §string = %replace(§replace: §string: §pos: %len(§search));
                if (§pos+%len(§replace) > %len(§string));
                   §pos = 0;
                else;
                   §pos = %scan(§search: §string: §pos+%len(§replace));
                endif;
             enddo;

       endsr;
       //-----------------------------------------------------------------------
       //report
       //-----------------------------------------------------------------------

       begsr SR_output;

         eval p_infil   =  'CHECKOUT_'        +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'CHECKOUT3';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/Lager/CHECKOUT_*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed /Lager/CHECKOUT_*';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object /Lager/CHECKOUT_*';
          exsr      SR_log;
       endmon;

       eval p_outfil =  'CHECKOUT3';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/Lager/'+ p_infil +''  +
                      '.csv'') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done                           ';
          exsr      SR_log;
       on-error;
          status='Error by CVTDBF object CHECKOUT3                 ';
          exsr      SR_log;
       endmon;
       eval p_outfil =  'CHECKOUT3';

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/Lager/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/CHECKOUT3)       ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/CHECKOUT3)    ';
       endmon;


       MONITOR;
       Wrk.var1 =
           'STRPCO PCTA(*NO)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='STRPCO successful                                  ';
       on-error;
          status='Error by STRPCO                                  ';
       endmon;

       MONITOR;
       Wrk.var1 =
           'STRPCCMD PCCMD(''//172.16.100.1/Lager/cpy.cmd'')';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='STRPCCMD successful FILE(TVRELWAECO/CHECKOUT3)       ';
       on-error;
          status='Error by STRPCCMD object (TVRELWAECO/CHECKOUT3)    ';
       endmon;

       endsr;

       //-----------------------------------------------------------------------
       //log report
       //-----------------------------------------------------------------------

       begsr sr_log;

         clear p_md;
       //  %Subarr(p_md:01)  = 'AT_item   ';
       //  %Subarr(p_md:11:10)  = §§§JOB;
       //  %Subarr(p_md:22:10)  = §§§USR;
       //  %Subarr(p_md:33:132) = status;
         eval p_md      =  §§§PGM         +
                           §§§JOB         +
                           §§§USR         +
                           status;

         eval p_msg     =  '#DC0002';
         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_outfil  =  'JOB_RUN   ';
         eval p_lib     =  'TVRELWAECO';
         eval p_repadd  =  '*ADD';

         callP DUMMY512(p_md:     p_msg:    p_msgf:     p_print:
                        p_outfil: p_lib:    p_repadd);
         clear status;

       //callP     QMHSNDPM('CPF9897': 'QCPFMSG   *LIBL':
       //            Msg: MsgLen: '*ESCAPE':
       //            '*': 3: TheKey: dsEC);

       endsr;
