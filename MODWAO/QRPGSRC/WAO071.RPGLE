     H DECEDIT('0,') DATEDIT(*DMY.) DEBUG(*YES)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2019')
     H DFTACTGRP(*NO)
     H BNDDIR('TRTXT')
      //*************************************************************************
      /TITLE Firmen LFS in Schleife ermitteln
      //*************************************************************************
      //  Copyright 2019 by    trend SWM
      //                       Verwaltungs GmbH
      //                       Jechtinger Straße 9
      //                       DE 79111 Freiburg
      //  ----------------------------------------------------------------------
      //  Erstellt: SZ 08.08.2019 Projekt 15084 Dometic
      //  ----------------------------------------------------------------------
      //  Änderung:
      //
      //*************************************************************************
      //  Ermitteln der Firmen LFS aus SYTP.
      //
      //*************************************************************************
      //**  T A B E L L E N  U N D  F E L D G R U P P E N                     ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR

     D MND             S                   DIM(99) INZ LIKE(WKLFSM)

      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D SYTP          E DS                  INZ
     D KYSYTP        E DS                  INZ

     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ

      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS

      //*************************************************************************
      //**  VARIABLE                                                          ***
      //*************************************************************************
     D WKTSTP          S               Z
     D WKC001          S              1
     D WKN010          S              1S 0
     D I1              S              3S 0
     D I2              S              3S 0
     D ##CHI           S              8
     D PCPGST          S              6
     D WKFENR          S              4
     D WKTRTP          S              1
     D WKTRPA          S              1
     D WKI000          S              1
     D WKLFSM          S              3
     D WKPGST          S                   LIKE(#CPGST)

      //*************************************************************************
      //**  DATENSTATIONSARBEITSBEREICH                                       ***
      //*************************************************************************
     D EXTRLD        EUDS                  DTAARA(*LDA)


      //*************************************************************************
      //**                                                                    ***
      //*************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXTR02
      /FREE
       EXSR UEBKOM;
       IN EXTRLD;

       IF WKI000 <> *ON;
         EXSR ANFANG;
       ENDIF;

       IF WKTRPA <> *ON;
         EXSR ETRPA;
       ENDIF;
       //*************************************************************************
       //**     P R O G R A M M S T E U E R U N G                              ***
       //*************************************************************************
       SELECT;
       WHEN WKPGST = 'INIT';
         EXSR ESYTP;
       WHEN WKPGST = 'READ';
         EXSR VSYTP;
       ENDSL;

       *INLR = *ON;
       //*************************************************************************
       //**  Eröffnungszyklus                                                  ***
       //*************************************************************************
       BEGSR ANFANG;

         WKI000 = *ON;

         WKC001 = *BLANK;
         WKN010 = *ZERO;

         WKFENR = '0000';

         KYTAFI = DAFIRM;
         KYSYTPFIRM = DAFIRM;

       ENDSR;
       //*************************************************************************
       //**  ÜBERNAHME KOM-BEREICH                                             ***
       //*************************************************************************
       BEGSR UEBKOM;

         WKPGST = #CPGST;
         I2 = #CMCAZ;
         #CMCDE = *BLANK;

       ENDSR;
       //*************************************************************************
       //**  VERARBEITEN INHALTE SYTP                                          ***
       //*************************************************************************
       BEGSR VSYTP;

         IF I2 <> 0;
           #CMCDE = MND(I2);
         ENDIF;

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN AUS FIRMEN-PARAMETER                              ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN FIRMEN LFS AUS TABELLE                                  ***
       //*************************************************************************
       BEGSR ESYTP;

         CLEAR MND;
         KYSYTPTART = '$$COMPANY';
         KYSYTPTCDE = *BLANK;
         KYSYTPTFLG = *ZERO;
         CHIDS = '01L';
         EXSR CHSYTP;

         FOR I1 = 1 TO 99;
           CHIDS = '01R';
           EXSR CHSYTP;

           IF WKFENR <> *ZERO
             OR SYTPFIRM <> KYSYTPFIRM
             OR SYTPTART <> KYSYTPTART;
             LEAVE;
           ENDIF;

           MND(I1) = SYTPTCDE;
         ENDFOR;

       ENDSR;
       //*************************************************************************
       //**  A U F R U F - M O D U L E                                         ***
       //*************************************************************************
      /END-FREE
      /COPY QCPYSRC,CHSYTP
      /COPY QCPYSRC,CHTRPA
      //*************************************************************************
      //**  ENDE DES PROGRAMMS                                                ***
      //*************************************************************************
