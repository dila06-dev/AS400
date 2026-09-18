      * PROGRAMMNAME.:.....                                                   
      * FUNKTION.....:Inventurwerte übergeben
      *               
      * November 2009   GANG, MANFRED
      *
      *
      * SELECT * FROM prodwin51/PRJ535P WHERE WENR ='870716159932'
      * select * from WEKO230712
      *
      * insert into tvrelwaeco/WEKO2307KO
      * SELECT #LBLB.#STATUS, #LBLB.#STATUSWAE, #LBLB.#STATUSBEP, #AELFNRR,
      * #LBLB.#RWERT, #LBLB.#WERTN, #LBLB.#WERTA, #STORNO, #LBLB.#WE#EL,
      * #LBLB.#LBLBLOCK, #LBLB.#LBLBJNAM, #LBLBJDAT, #LBLBJZEI, #LBLBUSER,
      * #LBLBPROG, #LBLBBIBL, #LBLBFIRM, #LBLBTMST, #LBLBBSTY, #LBLBWKNR,
      * #LBLBLANR, #LBLBBSLA, #LBLBTENR, #ARTNUM, #LBLBFBNR, #LBLBGEBI,
      * #LBLBCONT, #LBLBBHNR, #LBLBLORT, #LBLBCHAR, #LBLBFUMG, #LBLBKDNR,
      * #LBLBLFNR, #LBLBMEIN, #LBLBLSTC, #LBLBBDAT, #LBLBBZEI, #LBLBBWMG,
      * #LBLBBWME, #LBLBSTMG, #LBLBSTKZ, #LBLBLGBS, #LBLBDANA, #LBLBDAKY,
      * #LBLBKOTR, #LBLBKSST, #LBLBKOAR, #LBLBMOKZ, #LBLBFBKZ, #LBLBDRKZ,
      * #LBLBRGKZ, #LBLBCSKZ, #LBLBKZ01, #LBLBKZ02, #LBLBBEZ1, #LBLBBEZ2,
      * #LBLBUTMS, #LBLBBSEI, #LBLBQSST, #LBLBQSTM, #LBLBWBKT, #LBLBEBKT,
      * #LBLBSPKZ, #LBLBSPGR, #LBLBFRIN, #LBLBFREX, #BUCHUNG, #ERRORTXT,
      * #TSTAMP, #STATUSX, #ARTNUMS, #BUCKEY, #BBEP, #BBEP2, #BWAE, #BWAE2,
      * #BGFS, #BGFS2, #AEFIRM, #AEBEJJ, #AEBENR, #AEBEPO, #AELFNR,
      * #AEWEJJ, #AEWENR FROM WEKO230712, datenkw/#lblb WHERE t = ' ' and
      * SEL0014 = 2 and zoned((BUCTXT conCAT '0'), 26, 0)= #LBLBTMST
      * Datei WEKO2307KO in TVRELWAECO wurde erstellt.
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      * update     WEKO2307KO set #LBLBSTKZ='S'
      * update     WEKO2307KO set #LBLBprog='KORR_WES'
      * update     WEKO2307KO set #ERRORTXT='Korrektur Wareneingang!!!'
      * wert negativ!!
      *
      * #LBLBBDAT = 20210731 ????
      *
      * '20230724132808920057000000'
      * '20230601073758145382000000'
      *
      * eval      #LBLBBDAT = 20131130             grundsätzlich ändern
      * eval      # = 20131130777777771000000000   grundsätzlich ändern
      * umwandeln
      * call      LAGER905R
      * CHGDTAARA DTAARA(DATENKW/#TIMESTAM2)
      * liblist aufbauen
      *         QTEMP                   SFBS
      *         PROGPRJ2                SMDIBS002
      *         PROGAFPN                TMNP
      *         PROGAFP                 MODWAO
      *         PROGN                   TAMF
      *         PROG                    TAMP
      *         PRODWIN51               TVPF
      *         PROD                    TVPP
      *         QGPL                    TFXF
      *         TEST                    DATENKW
      *         SFBF                    TVRELWAECO
      *         SASF                    BAR_KALK
      *         SFB                     GANG
      *         SAS
      *         SASS
      * CALL PGM(LAGER905R)
      * CALL PGM(LAGERBEW2R) PARM('$$EL_PS_DB' '0' '0')
      *
      *   SELECT BUCTXT FROM prodwin51/prj535p ,WEKO2307KO WHERE WENR =
      *   #WE#EL and substr(BUCTXT, 1, 25) = substr(#LBLBTMST, 1, 25)
      *
      *   select * from prodwin51/prj535p ,WEKO2307KO
      *
      *   where  WENR  =  #WE#EL and
      *                     substr(BUCTXT, 1, 25) =
      *                     substr(#LBLBTMST, 1, 25)
      *
      *
      *-ÄNDERUNGSDIENST---------------------------------------------------------
      * XX.XX.XX                                              PGMR.....
      *-------------------------------------------------------------------------
     Hdatfmt(*eur) timfmt(*eur)
      *                                                                     ----
     fWEKO2307KOip   e             disk    RENAME(WEKO2307KO:phy00r)
      *                                                                     ----
     f#lblb     uf a e           k disk
     F                                     RENAME(#LBLBR:phy01r)
      *                                                                     ----
     DDate             S               D   DATFMT(*EUR)
     Dpjahr            S              4  0
     Dpmonat           S              2  0
     Dptag             S              2  0
     Dvj_jahr          S              4  0
     Dnxt_jahr         S              4  0
     Dkey_jahr         S              4  0
      *                                                                     ----
     D**************************************************************************
     D/COPY ##E
     D*-------------------------------------------------------------------------

     C                   eval      #ERRORTXT='Korrektur Wareneingang!!!'
     C                   eval      #LBLBSTKZ='S'
     C                   eval      #LBLBBWMG=#LBLBBWMG * -1
     C                   eval      #         = #   + 1
     C                   eval      #LBLBTMST = #
     C                   eval      #LBLBBDAT = 20230719
     C                   eval      #LBLBprog ='LAGER905R'
     C                   write     phy01r
     C*
     C**************************************************************************
     C*update
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR
     C*
     C*
     C     ##3000        ENDSR

     C**************************************************************************
     C* INITIALISIERUNGSROUTINE
     C*-------------------------------------------------------------------------
     C     *INZSR        BEGSR
     C*
     C                   TIME                    Date
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag
     C                   eval      vj_jahr = pjahr - 1
     C                   eval      nxt_jahr = pjahr + 1
     C                   movel     #LBLBTMST     #                26 0
     C
     C                   ENDSR
     C**************************************************************************
     C* PROGRAMM VERLASSEN
     C*-------------------------------------------------------------------------
     C*
     C     RETURN        BEGSR
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   ENDSR
     C*
     C**************************************************************************
