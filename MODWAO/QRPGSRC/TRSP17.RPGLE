     H DECEDIT('0,') DATEDIT(*DMY.)
     H ALWNULL(*USRCTL)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2001')
     H**************************************************************************
     H/TITLE  Empfangen Speditionsdaten
     H**************************************************************************
     H*  Copyright 2001 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: SZ 06.03.2011 Projekt 1790
     H*  -----------------------------------------------------------------------
     H*  Änderung: SZ 30.05.2011 Projekt 7195, Übernahme DPD
     H*  Änderung: SZ 28.07.2011 Übernahme DPD überarbeitet
     H*  Änderung: SZ 10.08.2011 Übernahme NightStar und Hellmann Aktion
     H*  Änderung: SZ 11.08.2011 Übernahme DPD Aktion
     H*  Änderung: SZ 11.08.2011 Übernahme Parts Express
     H*  Änderung: SZ 19.08.2011 Projekt 7722, Übernahme GLS angepaßt
     H*  Änderung: SZ 23.08.2011 Übernahme Daten GLS gemäß Mailverkehr mit Herrn
     H*            Mach von GLS angepaßt.
     H*  Änderung: SZ 25.08.2011 teilweise unvollständige KDNR von GLS auffüllen
     H*  Änderung: SZ 21.09.2011 Projekt 7197 Hamacher
     H*  Änderung: SZ 16.02.2012 Projekt 8260 Kühne + Nagel
     H*  Änderung: SZ 26.05.2012 Projekt 8390 Schenker
     H*  Änderung: SZ 05.07.2012 Projekt 8390 Korrektur Feldpositionen
     H*  Änderung: SZ 10.09.2012 Anpassung Übernahme t-o-f nach Programmupdate
     H*            von trans-o-flex
     H*  Änderung: SZ 20.12.2012 Projekt 9128 BRT Italien
     H*  Änderung: SZ 16.02.2013 Projekt 9032, Anpassungen Parts Express für
     H*            Firma '08' und '52'.
     H*  Änderung: SZ 22.09.2014 Service 20140917-008, KMJJ nicht mit *YEAR
     H*            füllen, sondern aus dem Sendedatum ermitteln.
     H*  Änderung: SZ 16.10.2014 Feldpositionen SPEDH2 korrigiert
     H*  Änderung: SZ 18.11.2014 Zusammensetzen DPDN für Firma '52' abweichend
     H*            dto. Firma '08'
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm wird vom jeweiligen Speditionsrechner aus aufgerufen
     F*  und verarbeitet die aktuell übertragene Datei mit den Sendungsdaten.
     F*  Der Aufruf erfolgt jeweils über ein CL TRSP17xx. Die jeweils zu ver-
     F*  arbeitende Datei wird als Parameter übergeben.
     F*  Nach dem Einlesen der übernommenen Daten wird TRSP18 zur Verarbeitung
     F*  aufgerufen.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FSPED02    UF   E             DISK    USROPN                               HELLMANN
     FSPED12    UF   E             DISK    USROPN                               PARTS EXPRESS
     FSPED22    UF   E             DISK    USROPN                               HAMACHER
     FSPED32    UF   E             DISK    USROPN                               TRANS-O-FLEX
     FSPED42    UF   E             DISK    USROPN                               GERMAN PARCEL/GLS
     FSPED52    UF   E             DISK    USROPN                               DPD
     FSPED62    UF   E             DISK    USROPN                               BOLL/UNITRANS
     FSPED72    UF   E             DISK    USROPN                               ADLATUS
     FSPED82    UF   E             DISK    USROPN                               DACHSER
     FSPEDA2    UF   E             DISK    USROPN                               HELLMANN AKTION
     F*PEDB2    UF   E             DISK    USROPN                               DPD AKTION
     FSPEDC2    UF   E             DISK    USROPN                               NIGHTSTAR
     FSPEDD2    UF   E             DISK    USROPN                               SCHENKER OBI
     FSPEDF2    UF   E             DISK    USROPN                               KÜHNE + NAGEL
     FSPEDG2    UF   E             DISK    USROPN                               SCHENKER
     FSPEDH2    UF   E             DISK    USROPN                               BRT
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRTR
     D*
     D W1024           S              1    DIM(1024)                            FELDGRUPPE DATEN
     D POSN            S                   DIM(1024) LIKE(WAOEKMPO)
     D PAKN            S                   DIM(1024) LIKE(WAOEPAKN)
     D AZVP            S                   DIM(1024) LIKE(WAOEAZVP)
     D VPMI            S                   DIM(1024) LIKE(WAOEVPMI)
     D HINW            S                   DIM(1024) LIKE(WAOEHINW)
     D GWBR            S                   DIM(1024) LIKE(WAOEGWBR)
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D AFKM          E DS                  INZ
     D KYAFKM        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D WAOE          E DS                  INZ
     D KYWAOE        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D  WKTDAT         S               D   DATFMT(*ISO) INZ
     D  WKDATE         S               D   DATFMT(*EUR) INZ
     D*
     D**************************************************************************
     D***  DATENSTATIONSARBEITSBEREICH                                       ***
     D**************************************************************************
     D EXTRLD        EUDS
     D*
     D**************************************************************************
     D***  DATENSTRUKTUR ANGABEN SPOOLDATEI                                  ***
     D**************************************************************************
     D/COPY QCPYSRC,TRSPOL
     D*
     D**************************************************************************
     D***  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
     D**************************************************************************
     D/COPY QCPYSRC,EXPSDS
     D*
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    WKDATN
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C                   EXSR      ANFANG                                       ANFANGSROUTINE
     C                   EXSR      ETRPA                                        PARAMETERWERTE
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   SELECT
     C                   WHEN      WKDATN      = 'SPED02'
     C                   OPEN      SPED02
     C                   EXSR      VSPED02
     C                   CLOSE     SPED02
     C                   WHEN      WKDATN      = 'SPED12'
     C                   OPEN      SPED12
     C                   EXSR      VSPED12
     C                   CLOSE     SPED12
     C                   WHEN      WKDATN      = 'SPED22'
     C                   OPEN      SPED22
     C                   EXSR      VSPED22
     C                   CLOSE     SPED22
     C                   WHEN      WKDATN      = 'SPED32'
     C                   OPEN      SPED32
     C                   EXSR      VSPED32
     C                   CLOSE     SPED32
     C                   WHEN      WKDATN      = 'SPED42'
     C                   OPEN      SPED42
     C                   EXSR      VSPED42
     C                   CLOSE     SPED42
     C                   WHEN      WKDATN      = 'SPED52'
     C                   OPEN      SPED52
     C                   EXSR      VSPED52
     C                   CLOSE     SPED52
     C                   WHEN      WKDATN      = 'SPED62'
     C                   OPEN      SPED62
     C                   EXSR      VSPED62
     C                   CLOSE     SPED62
     C                   WHEN      WKDATN      = 'SPED72'
     C                   OPEN      SPED72
     C                   EXSR      VSPED72
     C                   CLOSE     SPED72
     C                   WHEN      WKDATN      = 'SPED82'
     C                   OPEN      SPED82
     C                   EXSR      VSPED82
     C                   CLOSE     SPED82
     C                   WHEN      WKDATN      = 'SPEDA2'
     C                   OPEN      SPEDA2
     C                   EXSR      VSPEDA2
     C                   CLOSE     SPEDA2
     C                   WHEN      WKDATN      = 'SPEDB2'
     C                   OPEN      SPED52
     C                   EXSR      VSPED52
     C                   CLOSE     SPED52
     C                   WHEN      WKDATN      = 'SPEDC2'
     C                   OPEN      SPEDC2
     C                   EXSR      VSPEDC2
     C                   CLOSE     SPEDC2
     C                   WHEN      WKDATN      = 'SPEDD2'
     C                   OPEN      SPEDD2
     C                   EXSR      VSPEDD2
     C                   CLOSE     SPEDD2
     C                   WHEN      WKDATN      = 'SPEDF2'
     C                   OPEN      SPEDF2
     C                   EXSR      VSPEDF2
     C                   CLOSE     SPEDF2
     C                   WHEN      WKDATN      = 'SPEDG2'
     C                   OPEN      SPEDG2
     C                   EXSR      VSPEDG2
     C                   CLOSE     SPEDG2
     C                   WHEN      WKDATN      = 'SPEDH2'
     C                   OPEN      SPEDH2
     C                   EXSR      VSPEDH2
     C                   CLOSE     SPEDH2
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   IF        WKAFVS      = *ON
     C                   EXSR      VWAOE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           *INLR
     C**************************************************************************
     C***  EROEFFNUNGSZYKLUS                                                 ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C                   MOVE      *ON           WKI000
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1            INITIALISIEREN
     C                   Z-ADD     *ZERO         WKN010            1 0          FELDER
     C                   Z-ADD     *ZERO         WKN110           11 0
     C                   Z-ADD     *ZERO         WKN112           11 2
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYAMFI                         AFKM
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         I1
     C                   Z-ADD     *ZERO         I2
     C                   Z-ADD     *ZERO         I3
     C*-------------------------------------------------------------------------
     C                   EVAL      WKKMPO      = *ZERO
     C                   MOVE      *OFF          WKAFVS
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DER PARAMETERWERTE                                      ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'MEIN'        KYTATC
     C                   MOVEL(P)  'KILO'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAKILO
     C*
     C                   IF        WKTRPAKILO  = *BLANK
     C                   EVAL      WKTRPAKILO  = 'K'
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  DEFINITION DER WORKFELDER                                         ***
     C**************************************************************************
     C     VLIKE         BEGSR
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7            STEUERUNG
     C     *LIKE         DEFINE    WKC001        ##PGST                         PROGRAMMSTATUS
     C     *LIKE         DEFINE    WKC001        ##RTCD                         RETURN-CODE
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKI000                         IND.ANFANG
     C     *LIKE         DEFINE    WKC001        WKIUPD                         IND.UPDATE
     C     *LIKE         DEFINE    WKC001        WKTRTP                         IND.TABELLE
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1            NÄCHST.BILD
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKAFVS
     C     *LIKE         DEFINE    WKC001        WKAVKZ
     C     *LIKE         DEFINE    WKC001        WKKDBL          + 9
     C     *LIKE         DEFINE    WKC001        WKDMY6          + 5
     C     *LIKE         DEFINE    WKC001        WKYMD6          + 5
     C     *LIKE         DEFINE    WKC001        WKDAT1          + 9
     C     *LIKE         DEFINE    WKC001        WKDAT2          + 7
     C     *LIKE         DEFINE    WKC001        WKDAT3          + 7
     C     *LIKE         DEFINE    WKC001        SVDAT3          + 7
     C     *LIKE         DEFINE    WKC001        WKLDKZ          + 1
     C     *LIKE         DEFINE    WKC001        WKGW50          + 4
     C     *LIKE         DEFINE    WKC001        WKGW72          + 6
     C     *LIKE         DEFINE    WKC001        WKGW82          + 7
     C     *LIKE         DEFINE    WKC001        WKGW93          + 8
     C     *LIKE         DEFINE    WKC001        WKGWFL          + 4
     C     *LIKE         DEFINE    WKC001        WKGWF2          + 7
     C     *LIKE         DEFINE    WKC001        WKVPCD          + 1
     C     *LIKE         DEFINE    WKC001        WKFRAN          + 1
     C     *LIKE         DEFINE    WKC001        WKANZA          + 1
     C     *LIKE         DEFINE    WKC001        WKNABT          + 8
     C     *LIKE         DEFINE    WKC001        WKNAB2          +10
     C     *LIKE         DEFINE    WKC001        WKWACD          + 2
     C     *LIKE         DEFINE    WKC001        SVWACD          + 2
     C     *LIKE         DEFINE    WKC001        WKPOSI          + 2
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I1              + 2            INDEX 1
     C     *LIKE         DEFINE    WKN010        I2              + 2            INDEX 2
     C     *LIKE         DEFINE    WKN010        I3              + 2            INDEX 3
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        WKAZPK          + 2            ANZAHL PAKETE
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    AMJDAT        WKJDAT
     C     *LIKE         DEFINE    AMJZEI        WKJZEI
     C     *LIKE         DEFINE    AMNAM1        WKNAM1
     C     *LIKE         DEFINE    AMPOLZ        WKPOLZ
     C     *LIKE         DEFINE    AMWORT        WKWORT
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WAOEKMJJ      WKKMJJ
     C     *LIKE         DEFINE    WAOEKMNR      WKKMNR
     C     *LIKE         DEFINE    WAOEKMPO      WKKMPO
     C     *LIKE         DEFINE    WAOEKMPO      WKPOSN
     C     *LIKE         DEFINE    WAOEKDNR      WKKDNR
     C     *LIKE         DEFINE    WAOEPAKN      WKPAKN
     C     *LIKE         DEFINE    WAOEDPDN      WKDPDN
     C     *LIKE         DEFINE    WAOEDPDN      SVDPDN
     C     *LIKE         DEFINE    WAOEGWBR      WKGWBR
     C     *LIKE         DEFINE    WAOEGWDI      WKGWDI
     C     *LIKE         DEFINE    WAOEGWDI      WKTRPAKILO
     C     *LIKE         DEFINE    WAOEVPMI      WKVPMI
     C     *LIKE         DEFINE    WAOEVPM2      WKVPM2
     C     *LIKE         DEFINE    WAOEAZVP      WKAZVP
     C     *LIKE         DEFINE    WAOEAZV2      WKAZV2
     C     *LIKE         DEFINE    WAOEHINW      WKHINW
     C     *LIKE         DEFINE    WAOESEDA      WKSEDA
     C     *LIKE         DEFINE    WAOEDATN      WKDATN
     C     *LIKE         DEFINE    WAOESTAT      WKSTAT
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS AFKM                                          ***
     C**************************************************************************
     C     EAFKM         BEGSR
     C*-------------------------------------------------------------------------
     C                   EVAL      KYAMFI = KYWAOEFIRM
     C                   Z-ADD     WKKMJJ        KYAMJH
     C                   MOVEL(P)  WKKMNR        KYAMKM
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKM
     C*--------------------------------------------------------
     C                   IF        WKFENR     <> *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EVAL      WKKDNR      = AMKDNR
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ZUSAMMENSETZEN REFERENZNUMMER                                     ***
     C**************************************************************************
     C     EDPDN         BEGSR
     C*-------------------------------------------------------------------------
     C                   SELECT
     C                   WHEN      KYWAOEFIRM = '08'
     C                   EVAL      WKDPDN = %SUBST(WKKDNR:1:7) + WKKMNR + '1'
     C                   WHEN      KYWAOEFIRM = '52'
     C                   EVAL      WKDPDN = %SUBST(WKKDNR:1:7) + WKKMNR + '1'
     C                   OTHER
     C                   EVAL      WKDPDN      = '1' + %SUBST(WKKDNR:1:6) +
     C                                           WKKMNR + '1'
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN DATEN HELLMANN                                        ***
     C**************************************************************************
     C     VSPED02       BEGSR
     C*-------------------------------------------------------------------------
     C                   DOW       *INLR       = *OFF
     C                   EVAL      *IN98       = *OFF
     C                   EVAL      *IN99       = *OFF
     C                   READ      SPED02                               9899
     C*--------------------------------------------------------
     C                   IF        *IN98       = *ON           OR
     C                             *IN99       = *ON
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      IWKFLD
     C*--------------------------------------------------------
     C                   EVAL      WKKDBL      = SPED02KDBL
     C                   EVAL      WKKMNR      = %SUBST(SPED02DPDN:9:6)
     C                   EVAL      WKDPDN      = %SUBST(SPED02DPDN:2:14)
     C                   EVAL      WKPAKN      = SPED02PAKN
     C                   EVAL      WKFRAN      = SPED02FRAN
     C                   EVAL      WKDAT1      = SPED02DATE
     C                   EVAL      WKANZA      = SPED02ANZA
     C                   EVAL      WKVPCD      = SPED02VPCD
     C                   EVAL      WKGWF2      = SPED02GW02
     C*--------------------------------------------------------
     C                   EXSR      VSPED
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON
     C                   EXSR      UWAOE
     C                   DELETE    SPED02                               98
     C                   EVAL      WKAFVS      = *ON
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN DATEN PARTS EXPRESS                                   ***
     C**************************************************************************
     C     VSPED12       BEGSR
     C*-------------------------------------------------------------------------
     C                   DOW       *INLR       = *OFF
     C                   EVAL      *IN98       = *OFF
     C                   EVAL      *IN99       = *OFF
     C                   READ      SPED12                               9899
     C*--------------------------------------------------------
     C                   IF        *IN98       = *ON           OR
     C                             *IN99       = *ON
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C                   WHEN      %SUBST(SPED12FELD:1:3) = '*OD'
     C                   EXSR      IWKFLD
     C                   EVAL      WKDAT2      = %SUBST(SPED12FELD:4:8)
     C                   DELETE    SPED12                               98
     C                   ITER
     C                   WHEN      %SUBST(SPED12FELD:1:3) = '*01'
     C**? verifizieren   EVAL      WKKDNR      = %SUBST(SPED12FELD:9:7)
     C                   EVAL      WKKMNR      = %SUBST(SPED12FELD:16:6)
     C                   EVAL      WKLDKZ      = %SUBST(SPED12FELD:147:3)
     C                   EVAL      WKPOLZ      = %SUBST(SPED12FELD:150:9)
     C                   EVAL      WKANZA      = %SUBST(SPED12FELD:230:2)
     C                   EVAL      WKGW72      = %SUBST(SPED12FELD:232:7)
     C                   EVAL      WKNABT      = %SUBST(SPED12FELD:245:9)
     C                   EVAL      WKWACD      = %SUBST(SPED12FELD:254:3)
     C                   DELETE    SPED12                               98
     C                   ITER
     C                   WHEN      %SUBST(SPED12FELD:1:3) = '*03'
     C                   DELETE    SPED12                               98
     C                   ITER
     C                   WHEN      %SUBST(SPED12FELD:1:3) = '*04'
     C                   EVAL      WKPAKN      = %SUBST(SPED12FELD:43:16)
     C                   ENDSL
     C*--------------------------------------------------------
     C                   EXSR      VSPED
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON
     C                   EXSR      UWAOE
     C                   DELETE    SPED12                               98
     C                   EVAL      WKAFVS      = *ON
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN DATEN HAMACHER                                        ***
     C**************************************************************************
     C     VSPED22       BEGSR
     C*-------------------------------------------------------------------------
     C                   DOW       *INLR       = *OFF
     C                   EVAL      *IN98       = *OFF
     C                   EVAL      *IN99       = *OFF
     C                   READ      SPED22                               9899
     C*--------------------------------------------------------
     C                   IF        *IN98       = *ON           OR
     C                             *IN99       = *ON
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C                   WHEN      %SUBST(SPED22FELD:1:3) = '@@P'
     C                   DELETE    SPED22                               98
     C                   ITER
     C                   WHEN      %SUBST(SPED22FELD:1:3) = 'A00'
     C                   EVAL      SVDAT3      = %SUBST(SPED22FELD:45:8)
     C                   EVAL      SVWACD      = %SUBST(SPED22FELD:62:3)
     C                   DELETE    SPED22                               98
     C                   ITER
     C                   WHEN      %SUBST(SPED22FELD:1:3) = 'B00' AND
     C                             %SUBST(SPED22FELD:7:3) = 'CON'
     C                   EXSR      IWKFLD
     C                   EVAL      WKDAT3      = SVDAT3
     C                   EVAL      WKWACD      = SVWACD
     C                   EVAL      WKPOLZ      = %TRIM(%SUBST(SPED22FELD:83:9))
     C                   DELETE    SPED22                               98
     C                   ITER
     C                   WHEN      %SUBST(SPED22FELD:1:3) = 'B00'
     C                   DELETE    SPED22                               98
     C                   ITER
     C                   WHEN      %SUBST(SPED22FELD:1:3) = 'D00'
     C                   EVAL      WKPOSI      = %SUBST(SPED22FELD:7:3)
     C                   EVAL      WKANZA      = %SUBST(SPED22FELD:12:2)
     C                   EVAL      WKVPCD      = %SUBST(SPED22FELD:14:2)
     C                   EVAL      WKHINW      = %SUBST(SPED22FELD:24:30)
     C                   EVAL      WKGW93      = %SUBST(SPED22FELD:94:9)
     C                   EXSR      VSPED
     C                   EVAL      I2          = I2 + 1
     C                   EVAL      POSN(I2)    = WKPOSN
     C                   EVAL      AZVP(I2)    = WKAZVP
     C                   EVAL      VPMI(I2)    = WKVPMI
     C                   EVAL      HINW(I2)    = WKHINW
     C                   EVAL      GWBR(I2)    = WKGWBR
     C                   DELETE    SPED22                               98
     C                   ITER
     C                   WHEN      %SUBST(SPED22FELD:1:3) = 'E00'
     C                   DELETE    SPED22                               98
     C                   ITER
     C                   WHEN      %SUBST(SPED22FELD:1:3) = 'F00'
     C                   EVAL      I1          = I1 + 1
     C                   EVAL      PAKN(I1)    = %SUBST(SPED22FELD:10:20)
     C                   DELETE    SPED22                               98
     C                   ITER
     C                   WHEN      %SUBST(SPED22FELD:1:3) = 'G00'
     C                   DELETE    SPED22                               98
     C                   ITER
     C                   WHEN      %SUBST(SPED22FELD:1:3) = 'G99'
     C                   DELETE    SPED22                               98
     C                   ITER
     C                   WHEN      %SUBST(SPED22FELD:1:3) = 'H00' AND
     C                             %SUBST(SPED22FELD:7:3) = '504'
     C                   EVAL      WKDPDN      = %SUBST(SPED22FELD:11:14)
     C                   EVAL      WKKMNR      = %SUBST(SPED22FELD:18:6)
     C                   DELETE    SPED22                               98
     C                   EXSR      VSPED22PN
     C                   ITER
     C                   WHEN      %SUBST(SPED22FELD:1:3) = 'H00' AND
     C                             %SUBST(SPED22FELD:45:3) = '504'
     C                   EVAL      WKDPDN      = %SUBST(SPED22FELD:49:14)
     C                   EVAL      WKKMNR      = %SUBST(SPED22FELD:56:6)
     C                   DELETE    SPED22                               98
     C                   EXSR      VSPED22PN
     C                   ITER
     C                   WHEN      %SUBST(SPED22FELD:1:3) = 'H00' AND
     C                             %SUBST(SPED22FELD:83:3) = '504'
     C                   EVAL      WKDPDN      = %SUBST(SPED22FELD:87:14)
     C                   EVAL      WKKMNR      = %SUBST(SPED22FELD:94:6)
     C                   DELETE    SPED22                               98
     C                   EXSR      VSPED22PN
     C                   ITER
     C                   WHEN      %SUBST(SPED22FELD:1:3) = 'H00' AND
     C                             %SUBST(SPED22FELD:121:3) = '504'
     C                   EVAL      WKDPDN      = %SUBST(SPED22FELD:125:14)
     C                   EVAL      WKKMNR      = %SUBST(SPED22FELD:132:6)
     C                   DELETE    SPED22                               98
     C                   EXSR      VSPED22PN
     C                   ITER
     C                   WHEN      %SUBST(SPED22FELD:1:3) = 'H10'
     C                   DELETE    SPED22                               98
     C                   ITER
     C                   WHEN      %SUBST(SPED22FELD:1:3) = 'I00'
     C                   DELETE    SPED22                               98
     C                   ITER
     C                   WHEN      %SUBST(SPED22FELD:1:3) = 'J00'
     C                   EVAL      WKNAB2      = %SUBST(SPED22FELD:60:11)
     C                   DELETE    SPED22                               98
     C                   ITER
     C                   WHEN      %SUBST(SPED22FELD:1:3) = 'Z00'
     C                   DELETE    SPED22                               98
     C                   ITER
     C                   OTHER
     C                   DELETE    SPED22                               98
     C                   ITER
     C                   ENDSL
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN FELDGRUPPE PAKETNR. HAMACHER                          ***
     C**************************************************************************
     C     VSPED22PN     BEGSR
     C*-------------------------------------------------------------------------
     C                   EXSR      VSPED
     C*-------------------------------------------------------------------------
     C                   DO        I1            I2
     C                   EVAL      WKPAKN      = PAKN(I2)
     C                   EVAL      WKPOSN      = POSN(I2)
     C                   EVAL      WKAZVP      = AZVP(I2)
     C                   EVAL      WKVPMI      = VPMI(I2)
     C                   EVAL      WKHINW      = HINW(I2)
     C                   EVAL      WKGWBR      = GWBR(I2)
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON
     C                   EXSR      UWAOE
     C                   EVAL      WKAFVS      = *ON
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN DATEN TRANS-O-FLEX                                    ***
     C**************************************************************************
     C     VSPED32       BEGSR
     C*-------------------------------------------------------------------------
     C                   DOW       *INLR       = *OFF
     C                   EVAL      *IN98       = *OFF
     C                   EVAL      *IN99       = *OFF
     C                   READ      SPED32                               9899
     C*--------------------------------------------------------
     C                   IF        *IN98       = *ON           OR
     C                             *IN99       = *ON
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        %SUBST(SPED32FELD:1:2) = '13'
     C                   EXSR      IWKFLD
     C                   EVAL      WKKMNR      = %SUBST(SPED32FELD:80:6)
     C                   DELETE    SPED32                               98
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        %SUBST(SPED32FELD:1:2) <> '14'
     C                   DELETE    SPED32                               98
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EVAL      WKKDBL      = %SUBST(SPED32FELD:3:9)
     C                   EVAL      WKYMD6      = %SUBST(SPED32FELD:12:6)
     C                   EVAL      WKPAKN      = %SUBST(SPED32FELD:32:12)
     C                   EVAL      WKLDKZ      = %SUBST(SPED32FELD:44:2)
     C                   EVAL      WKPOLZ      = %SUBST(SPED32FELD:46:5)
     C                   EVAL      WKGW82      = %SUBST(SPED32FELD:121:8)
     C*
     C                   IF        WKKMNR      = *BLANK
     C                   EVAL      WKKMNR      = %SUBST(SPED32FELD:32:6)
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      VSPED
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON
     C                   EXSR      UWAOE
     C                   DELETE    SPED32                               98
     C                   EXSR      IWKFLD
     C                   EVAL      WKAFVS      = *ON
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN DATEN GERMAN PARCEL/GLS                               ***
     C**************************************************************************
     C     VSPED42       BEGSR
     C*-------------------------------------------------------------------------
     C                   DOW       *INLR       = *OFF
     C                   EVAL      *IN98       = *OFF
     C                   EVAL      *IN99       = *OFF
     C                   READ      SPED42                               9899
     C*--------------------------------------------------------
     C                   IF        *IN98       = *ON           OR
     C                             *IN99       = *ON
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        %SUBST(SPED42FELD:113:2) <> '01'
     C**                 DELETE    SPED42                               98
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      IWKFLD
     C*--------------------------------------------------------
     C                   EVAL      WKPAKN      = %SUBST(SPED42FELD:1:12)
     C                   EVAL      WKDPDN      = %SUBST(SPED42FELD:114:14)
     C                   EVAL      WKDAT1      = %SUBST(SPED42FELD:28:10)
     C                   EVAL      WKGWFL      = %SUBST(SPED42FELD:128:5)
     C                   EVAL      WKKDNR      = %SUBST(SPED42FELD:38:6)
     C                   EVAL      WKLDKZ      = %SUBST(SPED42FELD:44:3)
     C                   EVAL      WKPOLZ      = %SUBST(SPED42FELD:47:6)
     C                   EVAL      WKNAM1      = %SUBST(SPED42FELD:53:30)
     C                   EVAL      WKWORT      = %SUBST(SPED42FELD:83:30)
     C                   EVAL      WKKMNR      = %SUBST(SPED42FELD:121:6)
     C*--------------------------------------------------------
     C                   EXSR      VSPED
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON
     C                   EXSR      UWAOE
     C                   DELETE    SPED42                               98
     C                   EVAL      WKAFVS      = *ON
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN DATEN DPD                                             ***
     C**************************************************************************
     C     VSPED52       BEGSR
     C*-------------------------------------------------------------------------
     C                   DOW       *INLR       = *OFF
     C                   EVAL      *IN98       = *OFF
     C                   EVAL      *IN99       = *OFF
     C                   READ      SPED52                               9899
     C*--------------------------------------------------------
     C                   IF        *IN98       = *ON           OR
     C                             *IN99       = *ON
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        SPED52KDNR  = *BLANK
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      IWKFLD
     C*--------------------------------------------------------
     C                   EVAL      WKDPDN      = %SUBST(SPED52REFN:2:14)
     C                   EVAL      WKPAKN      = SPED52PKN1
     C                   EVAL      WKKDNR      = SPED52KDNR
     C                   EVAL      WKLDKZ      = SPED52POLD
     C                   EVAL      WKPOLZ      = SPED52POLZ
     C                   EVAL      WKKMNR      = %SUBST(SPED52REFN:9:6)
     C                   EVAL      WKGWF2      = %CHAR(SPED52GEWI)
     C                   Z-ADD     SPED52ANZA    WKAZPK
     C                   Z-ADD     SPED52PKST    WKAZVP
     C                   EVAL      WKDAT1      = SPED52DATE
     C                   EVAL      WKVPMI      = SPED52PKSA
     C*--------------------------------------------------------
     C                   EXSR      VSPED
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON
     C                   EXSR      UWAOE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON           AND
     C                             SPED52PKN2 <> *BLANK
     C                   EVAL      WKPAKN      = SPED52PKN2
     C                   EVAL      WKGWF2      = %TRIM(SPED52GW02)
     C                   EXSR      VSPED
     C                   EXSR      UWAOE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON           AND
     C                             SPED52PKN3 <> *BLANK
     C                   EVAL      WKPAKN      = SPED52PKN3
     C                   EVAL      WKGWF2      = %TRIM(SPED52GW03)
     C                   EXSR      VSPED
     C                   EXSR      UWAOE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON           AND
     C                             SPED52PKN4 <> *BLANK
     C                   EVAL      WKPAKN      = SPED52PKN4
     C                   EVAL      WKGWF2      = %TRIM(SPED52GW04)
     C                   EXSR      VSPED
     C                   EXSR      UWAOE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON           AND
     C                             SPED52PKN5 <> *BLANK
     C                   EVAL      WKPAKN      = SPED52PKN5
     C                   EVAL      WKGWF2      = %TRIM(SPED52GW05)
     C                   EXSR      VSPED
     C                   EXSR      UWAOE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON           AND
     C                             SPED52PKN6 <> *BLANK
     C                   EVAL      WKPAKN      = SPED52PKN6
     C                   EVAL      WKGWF2      = %TRIM(SPED52GW06)
     C                   EXSR      VSPED
     C                   EXSR      UWAOE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON           AND
     C                             SPED52PKN7 <> *BLANK
     C                   EVAL      WKPAKN      = SPED52PKN7
     C                   EVAL      WKGWF2      = %TRIM(SPED52GW07)
     C                   EXSR      VSPED
     C                   EXSR      UWAOE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON           AND
     C                             SPED52PKN8 <> *BLANK
     C                   EVAL      WKPAKN      = SPED52PKN8
     C                   EVAL      WKGWF2      = %TRIM(SPED52GW08)
     C                   EXSR      VSPED
     C                   EXSR      UWAOE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON           AND
     C                             SPED52PKN9 <> *BLANK
     C                   EVAL      WKPAKN      = SPED52PKN9
     C                   EVAL      WKGWF2      = %TRIM(SPED52GW09)
     C                   EXSR      VSPED
     C                   EXSR      UWAOE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON           AND
     C                             SPED52PK10 <> *BLANK
     C                   EVAL      WKPAKN      = SPED52PK10
     C                   EVAL      WKGWF2      = %TRIM(SPED52GW10)
     C                   EXSR      VSPED
     C                   EXSR      UWAOE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON           AND
     C                             SPED52PK11 <> *BLANK
     C                   EVAL      WKPAKN      = SPED52PK11
     C                   EVAL      WKGWF2      = %TRIM(SPED52GW11)
     C                   EXSR      VSPED
     C                   EXSR      UWAOE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON           AND
     C                             SPED52PK12 <> *BLANK
     C                   EVAL      WKPAKN      = SPED52PK12
     C                   EVAL      WKGWF2      = %TRIM(SPED52GW12)
     C                   EXSR      VSPED
     C                   EXSR      UWAOE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON           AND
     C                             SPED52PK13 <> *BLANK
     C                   EVAL      WKPAKN      = SPED52PK13
     C                   EVAL      WKGWF2      = %TRIM(SPED52GW13)
     C                   EXSR      VSPED
     C                   EXSR      UWAOE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON           AND
     C                             SPED52PK14 <> *BLANK
     C                   EVAL      WKPAKN      = SPED52PK14
     C                   EVAL      WKGWF2      = %TRIM(SPED52GW14)
     C                   EXSR      VSPED
     C                   EXSR      UWAOE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON           AND
     C                             SPED52PK15 <> *BLANK
     C                   EVAL      WKPAKN      = SPED52PK15
     C                   EVAL      WKGWF2      = %TRIM(SPED52GW15)
     C                   EXSR      VSPED
     C                   EXSR      UWAOE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON           AND
     C                             SPED52PK16 <> *BLANK
     C                   EVAL      WKPAKN      = SPED52PK16
     C                   EVAL      WKGWF2      = %TRIM(SPED52GW16)
     C                   EXSR      VSPED
     C                   EXSR      UWAOE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON           AND
     C                             SPED52PK17 <> *BLANK
     C                   EVAL      WKPAKN      = SPED52PK17
     C                   EVAL      WKGWF2      = %TRIM(SPED52GW17)
     C                   EXSR      VSPED
     C                   EXSR      UWAOE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON           AND
     C                             SPED52PK18 <> *BLANK
     C                   EVAL      WKPAKN      = SPED52PK18
     C                   EVAL      WKGWF2      = %TRIM(SPED52GW18)
     C                   EXSR      VSPED
     C                   EXSR      UWAOE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON           AND
     C                             SPED52PK19 <> *BLANK
     C                   EVAL      WKPAKN      = SPED52PK19
     C                   EVAL      WKGWF2      = %TRIM(SPED52GW19)
     C                   EXSR      VSPED
     C                   EXSR      UWAOE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON           AND
     C                             SPED52PK20 <> *BLANK
     C                   EVAL      WKPAKN      = SPED52PK20
     C                   EVAL      WKGWF2      = %TRIM(SPED52GW20)
     C                   EXSR      VSPED
     C                   EXSR      UWAOE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON
     C                   DELETE    SPED52                               98
     C                   EVAL      WKAFVS      = *ON
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN DATEN BOLL/UNITRANS                                   ***
     C**************************************************************************
     C     VSPED62       BEGSR
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN DATEN ADLATUS                                         ***
     C**************************************************************************
     C     VSPED72       BEGSR
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN DATEN DACHSER                                         ***
     C**************************************************************************
     C     VSPED82       BEGSR
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN DATEN HELLMANN AKTION                                 ***
     C**************************************************************************
     C     VSPEDA2       BEGSR
     C*-------------------------------------------------------------------------
     C                   DOW       *INLR       = *OFF
     C                   EVAL      *IN98       = *OFF
     C                   EVAL      *IN99       = *OFF
     C                   READ      SPEDA2                               9899
     C*--------------------------------------------------------
     C                   IF        *IN98       = *ON           OR
     C                             *IN99       = *ON
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      IWKFLD
     C*--------------------------------------------------------
     C                   EVAL      WKKDBL      = SPEDA2KDBL
     C                   EVAL      WKKMNR      = %SUBST(SPEDA2DPDN:9:6)
     C                   EVAL      WKDPDN      = %SUBST(SPEDA2DPDN:2:14)
     C                   EVAL      WKPAKN      = SPEDA2PAKN
     C                   EVAL      WKFRAN      = SPEDA2FRAN
     C                   EVAL      WKDAT1      = SPEDA2DATE
     C                   EVAL      WKANZA      = SPEDA2ANZA
     C                   EVAL      WKVPCD      = SPEDA2VPCD
     C                   EVAL      WKGWF2      = SPEDA2GW02
     C*--------------------------------------------------------
     C                   EXSR      VSPED
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON
     C                   EXSR      UWAOE
     C                   DELETE    SPEDA2                               98
     C                   EVAL      WKAFVS      = *ON
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN DATEN NIGHTSTAR                                       ***
     C**************************************************************************
     C     VSPEDC2       BEGSR
     C*-------------------------------------------------------------------------
     C                   DOW       *INLR       = *OFF
     C                   EVAL      *IN98       = *OFF
     C                   EVAL      *IN99       = *OFF
     C                   READ      SPEDC2                               9899
     C*--------------------------------------------------------
     C                   IF        *IN98       = *ON           OR
     C                             *IN99       = *ON
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      IWKFLD
     C*--------------------------------------------------------
     C                   EVAL      WKKDBL      = SPEDC2KDBL
     C                   EVAL      WKKMNR      = %SUBST(SPEDC2DPDN:9:6)
     C                   EVAL      WKDPDN      = %SUBST(SPEDC2DPDN:2:14)
     C                   EVAL      WKPAKN      = SPEDC2PAKN
     C                   EVAL      WKFRAN      = SPEDC2FRAN
     C                   EVAL      WKDAT1      = SPEDC2DATE
     C                   EVAL      WKANZA      = SPEDC2ANZA
     C                   EVAL      WKVPCD      = SPEDC2VPCD
     C                   EVAL      WKGWF2      = SPEDC2GW02
     C*--------------------------------------------------------
     C                   EXSR      VSPED
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON
     C                   EXSR      UWAOE
     C                   DELETE    SPEDC2                               98
     C                   EVAL      WKAFVS      = *ON
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN DATEN SCHENKER OBI                                    ***
     C**************************************************************************
     C     VSPEDD2       BEGSR
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN DATEN KÜHNE + NAGEL                                   ***
     C**************************************************************************
     C     VSPEDF2       BEGSR
     C*-------------------------------------------------------------------------
     C                   DOW       *INLR       = *OFF
     C                   EVAL      *IN98       = *OFF
     C                   EVAL      *IN99       = *OFF
     C                   READ      SPEDF2                               9899
     C*--------------------------------------------------------
     C                   IF        *IN98       = *ON           OR
     C                             *IN99       = *ON
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C                   WHEN      %SUBST(SPEDF2FELD:1:1) = 'K'                 KOPFDATEN
     C                   EXSR      IWKFLD
     C                   EVAL      WKDPDN      = %SUBST(SPEDF2FELD:3:14)
     C                   EVAL      WKKMNR      = %SUBST(SPEDF2FELD:10:6)
     C                   EVAL      WKPOLZ      = %SUBST(SPEDF2FELD:229:10)
     C                   EVAL      WKKDNR      = %SUBST(SPEDF2FELD:264:8)
     C                   DELETE    SPEDF2                               98
     C                   ITER
     C                   WHEN      %SUBST(SPEDF2FELD:1:1) = 'P'                 POSITIONEN
     C                   EVAL      WKANZA      = %SUBST(SPEDF2FELD:527:2)
     C                   EVAL      WKGW50      = %SUBST(SPEDF2FELD:497:5)
     C                   EVAL      WKPAKN      = %SUBST(SPEDF2FELD:641:20)
     C                   ENDSL
     C*--------------------------------------------------------
     C                   EXSR      VSPED
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON
     C                   EXSR      UWAOE
     C                   DELETE    SPEDF2                               98
     C                   EVAL      WKAFVS      = *ON
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN DATEN SCHENKER                                        ***
     C**************************************************************************
     C     VSPEDG2       BEGSR
     C*-------------------------------------------------------------------------
     C                   DOW       *INLR       = *OFF
     C                   EVAL      *IN98       = *OFF
     C                   EVAL      *IN99       = *OFF
     C                   READ      SPEDG2                               9899
     C*--------------------------------------------------------
     C                   IF        *IN98       = *ON           OR
     C                             *IN99       = *ON
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C                   WHEN      %SUBST(SPEDG2FELD:1:1) = 'S'                 KOPFDATEN
     C                   EXSR      IWKFLD
     C                   EVAL      WKDPDN      = %SUBST(SPEDG2FELD:3:14)
     C                   EVAL      WKKMNR      = %SUBST(SPEDG2FELD:10:6)
     C                   EVAL      WKLDKZ      = %SUBST(SPEDG2FELD:222:3)
     C                   EVAL      WKPOLZ      = %SUBST(SPEDG2FELD:225:10)
     C                   EVAL      WKKDNR      = %SUBST(SPEDG2FELD:260:8)
     C                   EVAL      WKNAM1      = %SUBST(SPEDG2FELD:147:25)
     C                   EVAL      WKWORT      = %SUBST(SPEDG2FELD:235:25)
     C                   DELETE    SPEDG2                               98
     C                   ITER
     C                   WHEN      %SUBST(SPEDG2FELD:1:1) = 'P'                 POSITIONEN
     C                   EVAL      WKVPCD      = %SUBST(SPEDG2FELD:525:2)
     C                   EVAL      WKANZA      = %SUBST(SPEDG2FELD:523:2)
     C                   EVAL      WKGW50      = %SUBST(SPEDG2FELD:493:5)
     C                   EVAL      WKPAKN      = %SUBST(SPEDG2FELD:637:20)
     C                   ENDSL
     C*--------------------------------------------------------
     C                   EXSR      VSPED
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON
     C                   EXSR      UWAOE
     C                   DELETE    SPEDG2                               98
     C                   EVAL      WKAFVS      = *ON
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN DATEN BRT ITALIEN                                     ***
     C**************************************************************************
     C     VSPEDH2       BEGSR
     C*-------------------------------------------------------------------------
     C                   DOW       *INLR       = *OFF
     C                   EVAL      *IN98       = *OFF
     C                   EVAL      *IN99       = *OFF
     C                   READ      SPEDH2                               9899
     C*--------------------------------------------------------
     C                   IF        *IN98       = *ON           OR
     C                             *IN99       = *ON
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C                   WHEN      %SUBST(SPEDH2FELD:1:1) = 'S'                 KOPFDATEN
     C                   EXSR      IWKFLD
     C                   EVAL      WKDPDN      = %SUBST(SPEDH2FELD:3:14)
     C                   EVAL      WKKMNR      = %SUBST(SPEDH2FELD:10:6)
     C                   EVAL      WKLDKZ      = %SUBST(SPEDH2FELD:251:3)
     C                   EVAL      WKPOLZ      = %SUBST(SPEDH2FELD:254:10)
     C                   EVAL      WKKDNR      = %SUBST(SPEDH2FELD:294:10)
     C                   EVAL      WKNAM1      = %SUBST(SPEDH2FELD:161:30)
     C                   EVAL      WKWORT      = %SUBST(SPEDH2FELD:264:30)
     C                   DELETE    SPEDH2                               98
     C                   ITER
     C                   WHEN      %SUBST(SPEDH2FELD:1:1) = 'P'                 POSITIONEN
     C                   EVAL      WKVPCD      = %SUBST(SPEDH2FELD:581:2)
     C                   EVAL      WKANZA      = %SUBST(SPEDH2FELD:579:2)
     C                   EVAL      WKGW50      = %SUBST(SPEDH2FELD:549:5)
     C                   EVAL      WKPAKN      = %SUBST(SPEDH2FELD:693:20)
     C                   ENDSL
     C*--------------------------------------------------------
     C                   EXSR      VSPED
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON
     C                   EXSR      UWAOE
     C                   DELETE    SPEDH2                               98
     C                   EVAL      WKAFVS      = *ON
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  INITIALISIEREN WK-FELDER                                          ***
     C**************************************************************************
     C     IWKFLD        BEGSR
     C*-------------------------------------------------------------------------
     C                   EVAL      WKPOSI      = *BLANK
     C                   EVAL      WKKDNR      = *BLANK
     C                   EVAL      WKKDBL      = *BLANK
     C                   EVAL      WKYMD6      = *BLANK
     C                   EVAL      WKDAT1      = *BLANK
     C                   EVAL      WKDAT2      = *BLANK
     C                   EVAL      WKDAT3      = *BLANK
     C                   EVAL      WKKMNR      = *BLANK
     C                   EVAL      WKDPDN      = *BLANK
     C                   EVAL      WKPAKN      = *BLANK
     C                   EVAL      WKNAM1      = *BLANK
     C                   EVAL      WKLDKZ      = *BLANK
     C                   EVAL      WKPOLZ      = *BLANK
     C                   EVAL      WKWORT      = *BLANK
     C                   EVAL      WKWACD      = *BLANK
     C                   EVAL      WKNABT      = *BLANK
     C                   EVAL      WKNAB2      = *BLANK
     C                   EVAL      WKGW50      = *BLANK
     C                   EVAL      WKGW72      = *BLANK
     C                   EVAL      WKGW82      = *BLANK
     C                   EVAL      WKGW93      = *BLANK
     C                   EVAL      WKGWFL      = *BLANK
     C                   EVAL      WKGWF2      = *BLANK
     C                   EVAL      WKVPMI      = *BLANK
     C                   EVAL      WKVPM2      = *BLANK
     C                   EVAL      WKVPCD      = *BLANK
     C                   EVAL      WKFRAN      = *BLANK
     C                   EVAL      WKANZA      = *BLANK
     C                   EVAL      WKAZVP      = 1
     C                   EVAL      WKAZV2      = *ZERO
     C                   EVAL      WKAZPK      = *ZERO
     C                   EVAL      WKSEDA = %DEC(%DATE():*ISO)
     C                   EVAL      WKIUPD      = *OFF
     C                   EVAL      DUC021      = *BLANK
     C                   EVAL      WKHINW      = *BLANK
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         I1
     C                   Z-ADD     *ZERO         I2
     C                   MOVEA     *ZERO         POSN
     C                   MOVEA     *BLANK        PAKN
     C                   MOVEA     *ZERO         GWBR
     C                   MOVEA     *ZERO         AZVP
     C                   MOVEA     *BLANK        VPMI
     C                   MOVEA     *BLANK        HINW
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  VERVOLLSTÄNDIGEN BEREITGESTELLTE DATEN                            ***
     C**************************************************************************
     C     VSPED         BEGSR
     C*-------------------------------------------------------------------------
     C                   EVAL      WKKMJJ      = *YEAR
     C                   EVAL      WKSTAT      = '00'
     C                   EVAL      WKGWBR      = *ZERO
     C                   EVAL      WKGWDI      = WKTRPAKILO
     C*--------------------------------------------------------
     C                   IF        WKVPMI      = *BLANK
     C                   EVAL      WKVPMI      = '2'                            KARTON
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C                   WHEN      WKVPCD      = 'CO'
     C                   EVAL      WKVPMI      = '1'                            COLLI
     C                   WHEN      WKVPCD      = 'KT'
     C                   EVAL      WKVPMI      = '2'                            KARTON
     C                   WHEN      WKVPCD      = 'FP'
     C                   EVAL      WKVPMI      = '3'                            EUROPALETTE
     C                   WHEN      WKVPCD      = 'EP'
     C                   EVAL      WKVPMI      = '4'                            EINWEGPALETTE
     C                   WHEN      WKVPCD      = 'GE'
     C                   EVAL      WKVPMI      = '5'                            GITTERBOX
     C                   WHEN      WKVPCD      = 'KI'
     C                   EVAL      WKVPMI      = '6'                            KISTE
     C                   WHEN      WKVPCD      = 'PL'
     C                   EVAL      WKVPMI      = '7'                            FREMDPALETTE
     C                   WHEN      WKVPCD      = 'HP'
     C                   EVAL      WKVPMI      = '8'                            HALBPALETTE
     C                   ENDSL
     C*--------------------------------------------------------
     C                   TESTN                   WKGW50               97
     C
     C                   IF        *IN97       = *ON
     C                   EVAL      DUC005      = WKGW50
     C                   Z-ADD     DUN050        WKGWBR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   TESTN                   WKGW82               97
     C
     C                   IF        *IN97       = *ON
     C                   EVAL      DUC008      = WKGW82
     C                   Z-ADD     DUN082        WKGWBR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   TESTN                   WKGW72               97
     C
     C                   IF        *IN97       = *ON
     C                   EVAL      DUC007      = WKGW72
     C                   Z-ADD     DUN072        WKGWBR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKGW93     <> *BLANK
     C     ' ':'0'       XLATE     WKGW93        WKGW93
     C                   TESTN                   WKGW93               97
     C
     C                   IF        *IN97       = *ON
     C                   EVAL      DUC009      = WKGW93
     C                   Z-ADD     DUN093        WKGWBR
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKGWFL     <> *BLANK
     C                   MOVEL     WKGWFL        DUC021
     C                   EXSR      UMNUMM
     C                   Z-ADD     DUN309        WKGWBR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKGWF2     <> *BLANK
     C                   MOVEL     WKGWF2        DUC021
     C                   EXSR      UMNUMM
     C                   Z-ADD     DUN309        WKGWBR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKYMD6     <> *BLANK
     C                   CLEAR                   EXDATE
     C                   MOVE      WKYMD6        EXDATEDATV
     C                   MOVEL     *YEAR         EXDATEDATV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   Z-ADD     RTDATEDATE    WKSEDA
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKDAT1     <> *BLANK
     C     *EUR          TEST(D)                 WKDAT1                 98
     C*
     C                   IF        *IN98       = *OFF
     C                   MOVE      WKDAT1        WKDATE
     C                   MOVE      WKDATE        EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   Z-ADD     RTDATEDATE    WKSEDA
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKDAT2     <> *BLANK
     C                   TESTN                   WKDAT2               97
     C
     C                   IF        *IN97       = *ON
     C                   MOVE      WKDAT2        WKSEDA
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKDAT3     <> *BLANK
     C                   MOVE      WKDAT3        EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   Z-ADD     RTDATEDATE    WKSEDA
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      WKSEDA        WKTDAT
     C                   EVAL      WKKMJJ = %SUBDT(WKTDAT:*YEARS)
     C*--------------------------------------------------------
     C                   IF        WKKMNR     <> *BLANK
     C                   EVAL      WKIUPD      = *ON
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      KYWAOEFIRM = DAFIRM
     C*
     C                   SELECT
     C                   WHEN      WKDATN = 'SPED12' AND %SUBST(WKKMNR:1:1)
     C                             = '7' AND DAFIRM = '01'
     C                   EVAL      KYWAOEFIRM = '08'
     C                   WHEN      WKDATN = 'SPED12' AND %SUBST(WKKMNR:1:1)
     C                             = '6' AND DAFIRM = '01'
     C                   EVAL      KYWAOEFIRM = '52'
     C                   ENDSL
     C*--------------------------------------------------------
     C                   IF        %SUBST(WKKDNR:1:1) = ' '
     C                   EVAL      %SUBST(WKKDNR:1:1) = '0'
     C                   ENDIF
     C*
     C                   IF        %SUBST(WKKDNR:2:1) = ' '
     C                   EVAL      %SUBST(WKKDNR:2:1) = '0'
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKKMNR <> *BLANK AND
     C                             (WKKDNR = *BLANK OR
     C                             %SUBST(WKKDNR:6:1) = *BLANK OR
     C                             %SUBST(WKKDNR:1:1) = *BLANK OR
     C                             %SUBST(WKKDNR:1:4) = '00  ' OR
     C                             %SUBST(WKKDNR:1:4) = '100 ')
     C                   EXSR      EAFKM
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKDPDN = *BLANK OR %SUBST(WKDPDN:1:5) =
     C                             '100  '
     C                   EXSR      EDPDN
     C                   ENDIF
     C*--------------------------------------------------------
     C                   TESTN                   WKANZA               97
     C
     C                   IF        *IN97       = *ON
     C                   EVAL      DUC002      = WKANZA
     C                   Z-ADD     DUN020        WKAZVP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   IF        WKDPDN     <> SVDPDN
     C                   EVAL      WKKMPO      = *ZERO
     C                   ENDIF
     C*
     C                   EVAL      WKKMPO      = WKKMPO + 1
     C                   EVAL      SVDPDN      = WKDPDN
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN DATEI WAOE                                            ***
     C**************************************************************************
     C     VWAOE         BEGSR
     C*-------------------------------------------------------------------------
     C                   CALL      'TRSP18CL'                           98
     C                   PARM                    WKDATN
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE WAOE                                                       ***
     C**************************************************************************
     C     UWAOE         BEGSR
     C*-------------------------------------------------------------------------
     C                   EVAL      KYWAOEKMJJ  = WKKMJJ
     C                   EVAL      KYWAOEKMNR  = WKKMNR
     C                   EVAL      KYWAOEKMPO  = WKKMPO
     C                   EVAL      KYWAOEUPOS  = *ZERO
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAOE
     C*-------------------------------------------------------------------------
     C                   EVAL      WAOEKDNR    = WKKDNR
     C                   EVAL      WAOEPAKN    = WKPAKN
     C                   EVAL      WAOEDPDN    = WKDPDN
     C                   EVAL      WAOEDATN    = WKDATN
     C                   EVAL      WAOEGWBR    = WKGWBR
     C                   EVAL      WAOEGWDI    = WKGWDI
     C                   EVAL      WAOEVPMI    = WKVPMI
     C                   EVAL      WAOEAZVP    = WKAZVP
     C                   EVAL      WAOESEDA    = WKSEDA
     C                   EVAL      WAOEVPM2    = WKVPM2
     C                   EVAL      WAOEAZV2    = WKAZV2
     C                   EVAL      WAOEHINW    = WKHINW
     C*--------------------------------------------------------
     C                   EVAL      WAOEJNAM = DAJNAM
     C                   EVAL      WAOEPROG = EXPSDSPROC
     C                   EVAL      WAOEBIBL = EXPSDSBIBL
     C                   EVAL      WAOEUSER = EXPSDSUSER
     C                   EVAL      WAOEJZEI = %DEC(%TIME())
     C                   EVAL      WAOEJDAT = %DEC(%DATE():*ISO)
     C*--------------------------------------------------------
     C                   SELECT
     C                   WHEN      CHI(06)     = *ON
     C                   EVAL      WAOESTAT    = WKSTAT
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHWAOE
     C                   WHEN      CHI(06)     = *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHWAOE
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  NUMERISCH UMSETZEN                                                ***
     C**************************************************************************
     C     UMNUMM        BEGSR
     C*-------------------------------------------------------------------------
     C     '.':','       XLATE     DUC021        DUC021
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DUC021        KOM(1)                         ALPHAFELD
     C                   Z-ADD     4             DUN010
     C                   MOVEA     DUC001        KOM(22)                        ANZAHL DEZIMALE
     C                   MOVE      *OFF          KOM(23)                        MINUS EINGABE
     C                   MOVEA     KOM           #CKOMM
     C*
     C                   CALL      'UMNUMM'
     C                   PARM                    EXTR02
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  #CKOMM        KOM
     C                   MOVEA(P)  KOM(1)        WKFENR
     C                   MOVEA(P)  KOM(5)        DUC030
     C*-------------------------------------------------------------------------
     C                   ENDSR
     O**************************************************************************
     O***  COPYMODULE                                                        ***
     C**************************************************************************
     C/COPY QCPYSRC,CHAFKM
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHWAOE
     C/COPY QCPYSRC,TRDATE
     C*
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
