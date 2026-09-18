

      //*********************************************************************************************
      //                                                                                            *
      //      Programmname                                                                          *
      //      Erstellt  am                                                                          *
      //      Erstellt von                                                                          *
      //                                                                                            *
      //      Beschreibung       Zentrale Steuerung WebServices                                     *
      //                                                                                            *
      // ----------------------------------+--------------------------------------------------------*
      // Geändert am Kürzel Name           ! Anfo-Nr. (Zeile 1) + Beschreibung                      *
      // ----------------------------------+--------------------------------------------------------*
      //                                   !                                                        *
      //  tt.mm.jjjj  xx01  .............. !                                                        *
      //                                   !                                                        *
      //*********************************************************************************************

      //--------------------------------------------------------------------------------------------*
      //    S T E U E R - B E S T I M M U N G E N                                                   *
      //--------------------------------------------------------------------------------------------*

     H datfmt(*EUR)
     H datedit(*DMY.)
     H timfmt(*HMS:)
     H decedit('0,')
     H langid('DE')
     H option(*SRCSTMT:*NODEBUGIO)
     H dftactgrp(*NO) actgrp(*NEW)
     H PGMINFO(*PCML:*Module)

      //--------------------------------------------------------------------------------------------*
      //   D A T E N S T R U K T U R E N                                                            *
      //--------------------------------------------------------------------------------------------*

      // System-Datenstruktur

     d dsSystem       sds
     d  aThisProgramm          1     10
     d  aThisWorkStn         244    253
     d  aThisUser            254    263

      //--------------------------------------------------------------------------------------------*
      //    V A R I A B L E N                                                                       *
      //--------------------------------------------------------------------------------------------*

     d dTagesDatum     s               d   inz(*job) datfmt(*iso)
     d nAktDat         s              8  0

     d aProgramm       s                   like(eProgramm)
     d aEingParm       s                   like(eEingParm)
     d nAnzahl         s                   like(eAnzahl)
     d nZaehl          s              3  0 inz
     d nAbStelle       s              3  0 inz
     d nLaenge         s              3  0 inz
     d nPosC           s              4  0 inz

      //--------------------------------------------------------------------------------------------*
      //    K O N S T A N T E N                                                                     *
      //--------------------------------------------------------------------------------------------*

     d cSemi           c                   ';'

      //--------------------------------------------------------------------------------------------*
      //    A R R A Y S                                                                             *
      //--------------------------------------------------------------------------------------------*

      // Für Array Eingabe
     d   aEingAyParm   s           1000    dim(1000)

      // Für Array Ausgaben
     d   eAusgAyParm   s           1000    dim(1000)

     d  dsWMD940R      ds                  qualified
     d                                     dim(1000)
     d   ds_ISIN                     12
     d   ds_ARBG                      1
     d   ds_LOKZ                      1
     d   ds_FNAM                     10
     d   ds_FINH                    100

     d WMD940RU        PR
     d   pmod                         4
     d   pBuLaufNr                    6  0
     d   pSysNam                      8
     d   pWelt                        2
     d   pISIN                       12
     d   pZaehler                    11  0
     d   dsWM940Rx                         likeds(dsWMD940R)
     d   pRTC                         4
     d   pMSGID                       7

      //--------------------------------------------------------------------------------------------*
      //    E N T R Y - P A R A M E T E R                                                           *
      //--------------------------------------------------------------------------------------------*

     c     *entry        plist
     c                   parm                    eProgramm        10
     c                   parm                    eEingParm       100
     c                   parm                    eAusgAyParm
     c                   parm                    eAnzahl           9 0
     c                   parm                    eRtc              4

      //--------------------------------------------------------------------------------------------*
      //    V O R B E R E I T E N D E   A R B E I T E N                                             *
      //--------------------------------------------------------------------------------------------*

      // Übertragen Entry-Parameter

      /FREE
       aProgramm   = eProgramm;
       aEingParm   = eEingParm;
       nAnzahl     = eAnzahl;

       // Initialisieren Returnparameter

       eRtc    = '*ERR';

      /eject
       //*********************************************************************************************
       //    -----------------                                                                       *
       //    M A I N - L I N E                                                                       *
       //    -----------------                                                                       *
       //*********************************************************************************************

       // Aufruf WMD940RU
       if eProgramm  = 'WMD940RU';
         exsr srWMD940RU;
       endif;

       // Setzen - *inlr-Schalter
       *inlr = *on;

       // Verlassen - Programm

       return;

      /eject
       //*********************************************************************************************
       //    ---------------------                                                                   *
       //    S U B R O U T I N E S                                                                   *
       //    ---------------------                                                                   *
       //*********************************************************************************************

      /eject
       //--------------------------------------------------------------------------------------------*
       //    zentrale Steuerung                                                                      *
       //--------------------------------------------------------------------------------------------*

       begsr srWMD940RU;

         // Aufruf für Programm WMD940RU
         exsr srParameter;

         pMod    = aEingAyParm(1);
         if aEingAyParm(2) <> *blank;
           pBuLaufNr = %dec(aEingAyParm(2):6:0);
         else;
           pBuLaufNr = *zero;
         endif;
         pSysnam = aEingAyParm(3);
         pWelt   = aEingAyParm(4);
         pISIN   = aEingAyParm(5);



      /END-FREE
     c                   call      'WMD940RU'
     c                   parm                    pMod              4
     c                   parm                    pBuLaufNr         6 0
     c                   parm                    pSysNam           8
     c                   parm                    pWelt             2
     c                   parm                    pISIN            12
     c                   parm                    pZaehler         11 0
     c                   parm                    dsWMD940R
     c                   parm                    pRTC              4
     c                   parm                    pMSGID            7

      /FREE
         eRtc    = pRtc;
         eAnzahl = pZaehler;

       endsr;

      /eject
       //--------------------------------------------------------------------------------------------*
       //   Eingangsparameter aufbereiten                                                            *
       //--------------------------------------------------------------------------------------------*

       begsr srParameter;

         nZaehl    = *zero;
         nLaenge   = *zero;
         nabStelle = 1;

         dou nPosC >= 100;
           nPosC = %scan(cSemi : aEingParm : nabStelle);
           if nPosC <> 0;
             nLaenge = nPosC - nAbstelle;
             nZaehl = nZaehl + 1;
             nPosC = nPosC + 1;
             aEingAyParm(nZaehl) = %subst(aEingParm:
                 nAbStelle : nLaenge);
             if nLaenge = 0;
               leave;
             endif;
             nabStelle = nAbStelle + nLaenge + 1;
           else;
             leave;
           endif;
         enddo;

       endsr;

      /eject
       //-------------------------------------------------------------------------
      /END-FREE
