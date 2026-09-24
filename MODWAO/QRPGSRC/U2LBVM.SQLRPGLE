     H DECEDIT('0,') DATEDIT(*DMY.)
     H********************************************************************
     H/TITLE        Neuerstellen der LBVM-Sätze
     H********************************************************************
     H*  Copyright 1998 by    trend SWM
     H*                       EDV-Verwaltungs GmbH
     H*                       Bötzinger Straße 36
     H*                       D-79111 Freiburg
     H*  --------------------------------------------------------------
     H*  Erstellung...: gs 03.03.1998
     H*  --------------------------------------------------------------
     H*  Änderungen...: GD 26.04.2002 Prüfung LDVMKZ
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
     D LBLB          E DS
     D KYLBLB        E DS
     D*
     D LBVM          E DS
     D KYLBVM        E DS
     D*
     D LBSD          E DS
     D KYLBSD        E DS
     D*
     D LBSS          E DS
     D KYLBSS        E DS
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
     D/COPY QCPYSRC,EXTRIN
     D********************************************************************
     D***     DATENSTATIONSARBEITSBEREICH                              ***
     D********************************************************************
     D EXTRLD        EUDS
     C********************************************************************
     C***     R E C H E N B E S T I M M U N G E N                      ***
     C********************************************************************
     C     *DTAARA       DEFINE    *LDA          EXTRLD                                   AS400
     C                   IN        EXTRLD                                                 AS400
     C*-------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7            STEUERUNG
     C*-------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1            INITIALISIEREN
     C                   MOVE      *ZERO         WKN010            1 0          FELDER
     C*-------------------------------------------------------------------
     C                   EXSR      ANFANG
     C********************************************************************
     C***     P R O G R A M M S T E U E R U N G                       ****
     C********************************************************************
     C                   EXSR      DLBVM
     C                   EXSR      OLBLB
     C                   EXSR      VLBLB
     C*-------------------------------------------------------------------
     C                   MOVE      '1'           *INLR
     C********************************************************************
     C***  ERÖFFNUNGSZYKLUS                                            ***
     C********************************************************************
     C     ANFANG        BEGSR
     C*
     C*-------------------------------------------------------------------
     C                   MOVEL     *ZERO         #CDATN                         DATUMSFELDER
     C                   MOVEL     *ZERO         #CDATV                         AUF NULL SETZEN
     C                   MOVEL     *ZERO         #CDAKW
     C                   MOVEL     *ZERO         #CDAJJ
     C                   MOVEL     *ZERO         #CMCAZ
     C                   MOVEL     *ZERO         DSJDAT
     C                   MOVEL     *ZERO         DSJZEI
     C*-------------------------------------------------------------------
     C*
     C                   ENDSR
     C********************************************************************
     C***  SQL-Löschen Datei LBVM                                      ***
     C********************************************************************
     C     DLBVM         BEGSR
     C*
     C*-------------------------------------------------------------------
     C/EXEC SQL
     C+ DELETE FROM LBVM
     C/END-EXEC
     C*-------------------------------------------------------------------
     C*
     C                   ENDSR
     C********************************************************************
     C***  SQL-ÖFFNEN DATEI LBLB                                       ***
     C********************************************************************
     C     OLBLB         BEGSR
     C*
     C*-------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE LBLBC1 CURSOR
     C+ FOR SELECT * FROM LBLB
     C+ WHERE EXISTS (SELECT LSFIRM FROM LBSS WHERE
     C+             LBLB.LBLBFIRM = LBSS.LSFIRM
     C+       AND   LBLB.LBLBLSTC = LBSS.LSLSTC
     C+       AND   LBSS.LSBUGR = '500')
     C+ AND   EXISTS (SELECT LDFIRM FROM LBSD WHERE
     C+             LBLB.LBLBFIRM = LBSD.LDFIRM
     C+       AND   LBLB.LBLBLANR = LBSD.LDLANR
     C+       AND   LBSD.LDVMKZ = :DAJNKZ)
     C+ AND   LBLBFIRM = :DAFIRM
     C+ ORDER BY LBLBFIRM,LBLBTENR,LBLBLANR,LBLBBDAT FOR FETCH ONLY
     C/END-EXEC
     C*-------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN LBLBC1
     C/END-EXEC
     C*-------------------------------------------------------------------
     C*
     C                   ENDSR
     C********************************************************************
     C***  VERARBEITEN LBLB                                            ***
     C********************************************************************
     C     VLBLB         BEGSR
     C*
     C*-------------------------------------------------------------------
     C                   MOVE      *ZERO         SQLCOD
     C*-------------------------------------------------------------------
     C     SQLCOD        DOWEQ     *ZERO
     C*-------------------------------------------------------------------
     C/EXEC SQL
     C+ FETCH LBLBC1 INTO :LBLB
     C/END-EXEC
     C*-------------------------------------------------------------------
     C     SQLCOD        IFEQ      *ZERO
     C*-------------------------------------------------------------------
     C                   MOVEL(P)  LBLBFIRM      KYLMFI
     C                   MOVEL(P)  LBLBTENR      KYLMTE
     C                   MOVE      *BLANK        KYLMEZ
     C                   MOVEL(P)  LBLBLANR      KYLMLA
     C                   MOVEL     LBLBBDAT      KYLMJH
     C                   MOVEL     LBLBBDAT      DUN060
     C                   MOVE      DUN060        KYLMMO
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHLBVM
     C*-------------------------------------------------------------------
     C                   Z-ADD     LBLBBDAT      LMDALA
     C                   MOVE      '500'         LMBUGR
     C*
     C     CHI(6)        IFNE      '1'
     C     LMLAGB        SUB       LBLBSTMG      LMLAGB                         SATZ GEFUNDEN
     C                   ELSE
     C                   Z-SUB     LBLBSTMG      LMLAGB
     C                   END
     C*-------------------------------------------------------------------
     C                   MOVEL(P)  LBLBJNAM      LMJNAM
     C                   MOVEL(P)  LBLBPROG      LMPROG
     C                   MOVEL(P)  LBLBBIBL      LMBIBL
     C                   MOVEL(P)  LBLBUSER      LMUSER
     C                   Z-ADD     LBLBJDAT      LMJDAT
     C                   Z-ADD     LBLBJZEI      LMJZEI
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     CHI(06)       WHENEQ    *ON
     C                   MOVEA     '01W     '    CHI                            SATZ HINZU-
     C                   EXSR      CHLBVM                                       FÜGEN
     C*--------------------------------------------------------
     C     CHI(06)       WHENNE    *ON
     C     LMLAGB        ANDEQ     *ZERO                                        MENGE GLEICH NULL
     C                   MOVEA     '01D     '    CHI                            SATZ LÖSCHEN
     C                   EXSR      CHLBVM
     C*--------------------------------------------------------
     C     CHI(06)       WHENNE    *ON
     C                   MOVEA     '01U     '    CHI                            SATZ UPDATEN
     C                   EXSR      CHLBVM
     C                   ENDSL
     C*-------------------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------
     C*
     C                   ENDSR
     O********************************************************************
     O***  COPY MODULE                                                 ***
     C********************************************************************
     C/COPY QCPYSRC,CHLBVM
     O********************************************************************
     O***  E N D E  D E S  P R O G R A M M S                           ***
     O********************************************************************
