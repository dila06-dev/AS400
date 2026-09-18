
      //************************************************************************
      //
      //      Programmname       TRGTEIL
      //      Erstellt  am       27.07.15
      //      Erstellt von       Joerg Zeig
      //
      //      Beschreibung       Trigger für Datei TEIL
      //
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
     h copyright('Joerg Zeig 2015')
      //------------------------------------------------------------------------

     FLfsTeilEx if A E           K Disk

      //*********************************************************************
      // Data Structure Definitions                                         *
      //*********************************************************************

     d dsSystem       sds
     d  aThisProgramm          1     10
     d  aThisWorkStn         244    253
     d  aThisUser            254    263

     DParm_01          DS
      // Static Section = 96 bytes
     D  File_Name              1     10
     D  Lib_Name              11     20
     D  Mbr_Name              21     30
     D  Trg_Event             31     31
      //     1=Einfügen neuen Datensatz
      //     2=Löschen
      //     3=Update
     D  Trg_Time              32     32
      //     1=After Record Added/Deleted/Updated
      //     2=Before Record Added/Deleted/Updated
     D  Commit_Lck            33     33
     D  Reserved              34     36
     D  CCSID                 37     40B 0
     D  RRN                   41     44B 0
     D  Filler_01             45     48
     D  Old_Offset            49     52B 0
     D  Old_RcdLen            53     56B 0
     D  Old_NBMOff            57     60B 0
     D  Old_NBMLen            61     64B 0
     D  New_Offset            65     68B 0
     D  New_RcdLen            69     72B 0
     D  New_NBMOff            73     76B 0
     D  New_NBMLen            77     80B 0
     D  Filler_02             81     96

     D  Data                       8192

     DParm_02          DS
     D  Buffer_Len                    4B 0

      //--------------------------------------------------------------------*
     DOld_TAP002     E DS                  ExtName(TEIL)
     D                                     Prefix(O_)

      //--------------------------------------------------------------------*
     DNew_TAP002     E DS                  ExtName(TEIL)
     D                                     Prefix(N_)

     d TTrg_K        E DS                  ExtName(LfsTeilEx:*Key)
     d                                     Qualified
     d TTrg_I        E DS                  ExtName(LfsTeilEx:*Input)
     d                                     Qualified
     d TTrg_O        E DS                  ExtName(LfsTeilEx:*OutPut)
     d                                     Qualified

      //*********************************************************************
      // Programm Konstanten
      //*********************************************************************
     DInsert           S                   LIKE(Trg_Event) INZ('1')
     DDelete           S                   LIKE(Trg_Event) INZ('2')
     DUpdate           S                   LIKE(Trg_Event) INZ('3')

     DAfter            S                   LIKE(Trg_Time ) INZ('1')
     DBefore           S                   LIKE(Trg_Time ) INZ('2')
     Dw_Vakz           s              1a   inz

     C     *Entry        PList
     C                   Parm                    Parm_01
     C                   Parm                    Parm_02


      /FREE

       Old_TAP002 = %subst(Data: Old_Offset-95:
           Old_RcdLen);
       New_TAP002 = %subst(Data: New_Offset-95:
           New_RcdLen);
       Select;

       When Trg_Event = Insert;
           w_Vakz = 'I';
           Exsr SB_WriteStat;

       When Trg_Event = Delete;
           w_Vakz = 'D';
           Exsr SB_DeletStat;

       When Trg_Event = Update;
           w_Vakz = 'U';

         // Wurden Änderungen vorgenommen?
         If (Old_Tap002 <> New_TAP002) and Trg_Time =
               After or Trg_Event = Insert;
           Exsr SB_WriteStat;
         EndIf;

       EndSL;

       *INLR = *ON;

       //--------------------------------------------------------------------*
       // Füllen der Schnittstellendatei                                     *
       //--------------------------------------------------------------------*
       BegSR SB_WriteStat;

         TtRg_K.TxFirm = n_TeFirm;
         TtRg_K.TxTenr = n_TeTenr;
         TtRg_K.TxExSt = *blank;
         chain %kds(TtRg_K:2) LfsTeilEx TtRg_I;
          if not %found(LfsTeilEx);
          clear TtRg_O;
          TtRg_O.TxFirm = n_TeFirm;
          TtRg_O.TxTenr = n_TETenr;
          TtRg_O.TxVakZ = w_Vakz;
          TtRg_O.TxTime = %TimeStamp();
          TtRg_O.TxPGM  = aThisProgramm;
          TtRg_O.TxUser = aThisUser;

         Write RLfsTeilex TtRg_O;
        endif;

       EndSR;

       //--------------------------------------------------------------------*
       // Füllen der Schnittstellendatei (bei Löschungen)                    *
       //--------------------------------------------------------------------*
       BegSR SB_DeletStat;

         TtRg_K.TxFirm = o_TeFirm;
         TtRg_K.TxTenr = o_TeTenr;
         TtRg_K.TxExSt = *blank;
         chain %kds(TtRg_K:2) LfsTeilEx TtRg_I;
          if not %found(LfsTeilEx);
          clear TtRg_O;
          TtRg_O.TxFirm = o_TeFirm;
          TtRg_O.TxTenr = o_TETenr;
          TtRg_O.TxVakZ = w_Vakz;
          TtRg_O.TxTime = %TimeStamp();
          TtRg_O.TxPGM  = aThisProgramm;
          TtRg_O.TxUser = aThisUser;

         Write RLfsTeilex TtRg_O;
        endif;

       EndSR;

      /END-FREE
