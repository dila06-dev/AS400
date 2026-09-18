     H DECEDIT('0,') DATEDIT(*DMY.)
     H********************************************************************
     H/TITLE        Update  LBPC
     H********************************************************************
     H*  Copyright 1998 by    trend SWM
     H*                       EDV-Verwaltungs GmbH
     H*                       Bötzinger Straße 36
     H*                       D-79111 Freiburg
     H*  --------------------------------------------------------------
     H*  Erstellung...: ZG 06.02.2012
     H*  --------------------------------------------------------------
     H*
     F********************************************************************
     F*
     F*  Neuerstellung der Lagerverbrauchsmengen in der Datei LBVM.
     F*  Es werden nur Sätze welche im Steuerungsschlüssel Gruppe '500'
     F*  geführt sind, verarbeitet.
     F*
     D********************************************************************
     D***     T A B E L L E N  U N D  F E L D G R U P P E N            ***
     D********************************************************************
     D CHI             S              1    DIM(8)                               STEUERUNG ZUGRIFF
     D KOM             S              1    DIM(220)                             KOMMUNIKATION
     D W99             S              1    DIM(99)                              WORK-FELDGRP.
     D*
     D********************************************************************
     D***     DATEIEN                                                  ***
     D********************************************************************
     D LBPC          E DS
     D AFKM          E DS
     D LBAK          E DS
     D LBAP          E DS
     D*
     D********************************************************************
     D***     KOMMUNIKATIONSPARAMETER                                  ***
     D********************************************************************
     D EXTR01        E DS
     D EXTR02        E DS
     D EXTR03        E DS
     D*
     D********************************************************************
     D***     INTERNE DATENSTRUKTUR                                    ***
     D********************************************************************
     D********************************************************************
     D***     DATENSTATIONSARBEITSBEREICH                              ***
     D********************************************************************
     D EXTRLD        EUDS
     C********************************************************************
     C***     R E C H E N B E S T I M M U N G E N                      ***
     C********************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    DUC004            4
     C                   PARM                    DUC006            6
     C*-------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD                                   AS400
     C                   IN        EXTRLD                                                 AS400
     C*-------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7            STEUERUNG
     C*-------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1            INITIALISIEREN
     C                   MOVE      *ZERO         WKN010            1 0          FELDER
     C                   MOVE      *ZERO         DUN040            4 0          FELDER
     C*-------------------------------------------------------------------
     C                   EXSR      ANFANG
     C********************************************************************
     C***     P R O G R A M M S T E U E R U N G                       ****
     C********************************************************************
     C                   EXSR      UPDATE
     C*-------------------------------------------------------------------
     C                   MOVE      '1'           *INLR
     C********************************************************************
     C***  ERÖFFNUNGSZYKLUS                                            ***
     C********************************************************************
     C     ANFANG        BEGSR
     C*
     C*-------------------------------------------------------------------
     C*-------------------------------------------------------------------
     C*
     C                   ENDSR
     C********************************************************************
     C***  VERARBEITEN LBPC                                            ***
     C********************************************************************
     C     UPDATE        BEGSR
     C*
     C*-------------------------------------------------------------------
     C                   MOVE      *ZERO         SQLCOD
     C                   MOVE      DUC004        DUN040
     C*-------------------------------------------------------------------
     C/EXEC SQL
     C+ UPDATE TVPF/AFKM SET AMAFST = '40' WHERE AMKMNR=:DUC006 AND
     C+ AMAFST='20' AND AMFIRM='01' AND AMKMJJ=:DUN040
     C/END-EXEC
     C*-------------------------------------------------------------------
     C/EXEC SQL
     C+ UPDATE LBAK SET LBAKSTAT='90' WHERE LBAKNMKR=:DUC006 AND
     C+ LBAKSTAT<'90' AND LBAKFIRM='01' AND LBAKJAHR=:DUN040 AND
     C+ LBAKDANA='AFKM '
     C/END-EXEC
     C*-------------------------------------------------------------------
     C/EXEC SQL
     C+ UPDATE LBAP SET LBAPSTAT='90' WHERE LBAPNMKR=:DUC006  AND
     C+ LBAPSTAT<'90' AND LBAPFIRM='01' AND LBAPJAHR=:DUN040 AND
     C+ LBAPDANA='AFKM '
     C/END-EXEC
     C*-------------------------------------------------------------------
     C/EXEC SQL
     C+ UPDATE LBPC SET LBPCSTAT = '90' WHERE LBPCNMKR=:DUC006 AND
     C+ LBPCJAHR=:DUN040 AND LBPCFIRM='01' AND LBPCSTAT='50' AND
     C+ EXISTS(SELECT ALGLMG
     C+ FROM AFLP WHERE ALFIRM=LBPCFIRM AND ALKMJJ=LBPCJAHR AND
     C+ ALKMNR=LBPCNMKR AND ALKMPO=LBPCPOSI AND ALTENR=LBPCTENR AND
     C+ LBPCDANA='AFKM' AND LBPCRSMG= ALGLMG ) AND EXISTS (SELECT * FROM
     C+ LBRS WHERE LBRSFIRM=LBPCFIRM AND LBRSTMST=LBPCTMST AND
     C+ LBRSSTAT='90' )
     C/END-EXEC
     C*-------------------------------------------------------------------
     C*
     C                   ENDSR
     O********************************************************************
     O***  COPY MODULE                                                 ***
     C********************************************************************
     O********************************************************************
     O***  E N D E  D E S  P R O G R A M M S                           ***
     O********************************************************************
