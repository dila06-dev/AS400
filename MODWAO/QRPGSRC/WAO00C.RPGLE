     H DECEDIT('0,') DATEDIT(*DMY.) DEBUG(*YES)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H**************************************************************************
     H/TITLE Dialog-SST WAECO-Identstamm
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FARTIKEL01 IF A E           K DISK
     F                                     RENAME(ANDART02:ARTIKEL)
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY TAMP/QCPYSRC,EXTRTR
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D LIEF          E DS                  INZ
     D KYLIEF        E DS                  INZ
     D*
     D TEBB          E DS                  INZ
     D KYTEBB        E DS                  INZ
     D*
     D TEUF          E DS                  INZ
     D KYTEUF        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D PREI          E DS                  INZ
     D KYPREI        E DS                  INZ
     D*
     D LPIF          E DS                  INZ
     D KYLPIF        E DS                  INZ
     D*
     D LAND          E DS                  INZ
     D KYLAND        E DS                  INZ
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D**************************************************************************
     D***  DATENSTATIONSARBEITSBEREICH                                       ***
     D**************************************************************************
     D EXTRLD        EUDS
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY TAMP/QCPYSRC,EXTRIN
     D*
     D  WKTDAT                         D   DATFMT(*ISO) INZ
     D**************************************************************************
     D***  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
     D**************************************************************************
     D/COPY TAMP/QCPYSRC,EXPSDS
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*
     C     WKI000        CASNE     *ON           ANFANG
     C                   ENDCS
     C*
     C     WKTRPA        CASNE     *ON           ETRPA
     C                   ENDCS
     C*
     C                   EXSR      VORLAUF
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   EXSR      VTEIL
     C*
     C                   MOVE      *ON           *INLR
     C**************************************************************************
     C***  ERÖFFNUNGSZYKLUS                                                  ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C                   MOVE      *ON           WKI000
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1
     C                   Z-ADD     *ZERO         WKN010            1 0
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '01'          DAFIRM                         TEUF
     C                   MOVEL(P)  'SST_IDENT'   DAJNAM                         TEUF
     C                   MOVEL(P)  'MODWAO'      DABIBL                         TEUF
     C                   MOVEL(P)  'BATCH'       DAUSER                         TEUF
     C                   MOVEL(P)  'WAO00C'      DAPROG                         TEUF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        EXFIRMFIRM
     C                   MOVEL(P)  DAFIRM        KYTEBBFIRM                     TEUF
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYLFFI                         LIEF
     C                   MOVEL(P)  DAFIRM        KYTUFI                         TEUF
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DAFIRM        KYPRFI                         PREI
     C                   MOVEL(P)  DAFIRM        KYLPFI                         LPIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'D'           KYTPSP                         TRTP
     C*
     C                   MOVE      *OFF          *IN
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUF                                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C                   EXSR      PRFIRMFIRM
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C                   MOVEL     *ON           WKTRPA
     C*
     C                   ENDSR
     C**************************************************************************
     C***  DATEI VERARBEITUNG                                                ***
     C**************************************************************************
     C     VTEIL         BEGSR
     C*
     C     *IN(98)       DOWEQ     *OFF
     C     *IN(99)       ANDEQ     *OFF
     C*
     C                   MOVE      *OFF          *IN
     C*
     C                   READ      ARTIKEL                              9899
     C*
     C     *IN(98)       IFEQ      *ON
     C     *IN(99)       OREQ      *ON
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVEL(P)  ART030        DUC002
     C     DUC002        IFEQ      'P-'
     C                   ITER
     C                   ENDIF
     C     ART180        IFEQ      'X'
     C                   ITER
     C                   ENDIF
     C*
     C                   EXSR      UTEIL
     C*
     C     KZAE          IFEQ      'NEU'
     C     KZAEND        OREQ      *ON
     C                   EXSR      UTEBB
     C*
     C     TESTLF        IFNE      *BLANKS
     C*
     C     TETART        IFNE      '1'
     C     KZAE          IFEQ      'NEU'
     C                   EXSR      UPREI
     C                   ENDIF
     C                   ENDIF
     C*
     C     WKFENR        IFEQ      *ZEROS
     C                   EXSR      ULPIF
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C                   EXSR      UTEUF
     C                   ENDIF
     C*
     C                   ENDDO
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AENDERUNGSPRUEFUNG                                                ***
     C**************************************************************************
     C     UAEND         BEGSR
     C*
     C                   MOVEL     *OFF          KZAEND            1
     C*
     C     ART060        IFNE      TETBZ1
     C***  ART640        ORNE      TETBZ2
     C     FAN030        ORNE      TEEANR
     C     ART040        ORNE      TEMAGR
     C     ART050        ORNE      TEPRGR
     C     ART100        ORNE      TEERTE
     C     ART220        ORNE      TEZOTN
     C***  ART250        ORNE      TEVOLU
     C***  ARZ215        ORNE      TELOGR
     C***  ARZ210        ORNE      TEMIBM
     C     ART180        ORNE      TEABC1
     C***  ART230        ORNE      TEIVPE
     C*
     C     WKURLD        ORNE      TEURLD
     C**** WKDIAV        ORNE      TEDIAV   nach neuer Versorgung global wieder aktivieren
     C**** WKSTLF        ORNE      TESTLF
     C**** WKTART        ORNE      TETART
     C     WKWEMT        ORNE      TEWEMT
     C***  WKTEST        ORNE      TETEST
     C**** WKLVZ1        ORNE      TELVZ1
     C**** WKGWBR        ORNE      TEGWBR
     C***  WKMCBG        ORNE      TEMCBG
     C**** WKDIEK        ORNE      TEDIEK
     C*
     C                   MOVEL     *ON           KZAEND
     C*
     C                   ENDIF
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI TEIL                                                 ***
     C**************************************************************************
     C     UTEIL         BEGSR
     C*
     C                   MOVEL(P)  'AEN'         KZAE              3
     C*
     C                   DO
     C*
     C                   MOVEL(P)  ART030        KYTENR
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHTEIL
     C* Neuaufnahme
     C     WKFENR        IFNE      *ZEROS
     C                   MOVEL(P)  'NEU'         KZAE
     C                   MOVEL(P)  DAFIRM        TEFIRM
     C                   MOVEL(P)  'T'           TELVA1
     C                   MOVEL(P)  '331000'      TEWBKT
     C                   MOVEL(P)  'S'           TEMEIN
     C                   MOVEL(P)  'S'           TEMEAV
     C                   MOVEL(P)  '001'         TEWKNR
     C                   MOVEL(P)  '1'           TEBESL
     C                   MOVEL(P)  '1'           TEPDEK
     C                   MOVEL(P)  '1'           TEPDAV
     C                   MOVEL(P)  '1'           TENGKZ
     C                   MOVEL(P)  'S'           TEMEEK
     C                   MOVEL(P)  'S'           TEMPEK
     C                   MOVEL(P)  '1'           TEPDVK
     C                   MOVEL(P)  'S'           TEMPVK
     C                   MOVEL(P)  'S'           TEMEVK
     C                   MOVEL(P)  '16'          TEMWST
     C                   MOVEL(P)  '001'         TELANR
     C                   MOVEL(P)  '1'           TEGWDI
     C                   Z-ADD     1             TEVOZ1
     C                   MOVEL(P)  'T'           TEVOA1
     C*
     C                   MOVEL(P)  '1'           TEPDAV
     C                   MOVEL(P)  '1'           TEPDEK
     C*
     C                   Z-ADD     ART330        TESTPR
     C*
     C                   MOVEL(P)  EXFIRMNEKZ    TEFBKZ
     C                   MOVEL(P)  EXFIRMNEKZ    TEGKKZ
     C                   MOVEL(P)  EXFIRMNEKZ    TEALDI
     C                   MOVEL(P)  EXFIRMNEKZ    TEGKKZ
     C                   MOVEL(P)  EXFIRMNEKZ    TERPZT
     C                   MOVEL(P)  EXFIRMNEKZ    TEFBKZ
     C                   MOVEL(P)  EXFIRMNEKZ    TEGKKZ
     C                   MOVEL(P)  EXFIRMNEKZ    TEKOKZ
     C                   MOVEL(P)  EXFIRMNEKZ    TEZOAN
     C                   MOVEL(P)  EXFIRMNEKZ    TEEBKZ
     C                   MOVEL(P)  EXFIRMJAKZ    TEBONU
     C                   MOVEL(P)  EXFIRMJAKZ    TEBSKZ
     C                   MOVEL(P)  EXFIRMJAKZ    TEAWKZ
     C                   MOVEL(P)  EXFIRMJAKZ    TEZUAB
     C                   MOVEL(P)  EXFIRMJAKZ    TEKOKZ
     C                   MOVEL(P)  EXFIRMJAKZ    TEZUAB
     C                   MOVEL(P)  EXFIRMNEKZ    TEGKKZ
     C                   MOVEL(P)  EXFIRMNEKZ    TEZOAN
     C                   MOVEL(P)  EXFIRMNEKZ    TEEBKZ
     C                   MOVEL(P)  EXFIRMNEKZ    TERPZT
     C                   MOVEL(P)  EXFIRMNEKZ    TEFBKZ
     C                   MOVEL(P)  EXFIRMJAKZ    TEBSKZ
     C                   MOVEL(P)  EXFIRMNEKZ    TEGBKZ
     C                   MOVEL(P)  EXFIRMNEKZ    TEGPKZ
     C                   MOVEL(P)  EXFIRMNEKZ    TECTKZ
     C                   MOVEL(P)  EXFIRMNEKZ    TERPKZ
     C                   MOVEL(P)  EXFIRMNEKZ    TEDOKZ
     C                   MOVEL(P)  EXFIRMNEKZ    TECHKZ
     C                   MOVEL(P)  EXFIRMNEKZ    TEQSME
     C                   MOVEL(P)  EXFIRMNEKZ    TEGBKZ
     C                   MOVEL(P)  EXFIRMNEKZ    TEGPKZ
     C                   MOVEL(P)  EXFIRMNEKZ    TECTKZ
     C                   MOVEL(P)  EXFIRMNEKZ    TERPKZ
     C                   MOVEL(P)  EXFIRMNEKZ    TEDOKZ
     C                   MOVEL(P)  EXFIRMNEKZ    TECHKZ
     C*
     C                   EVAL      WKLVZ1 = ARZ060 + ARZ065
     C                   EVAL      WKLVZ1 = WKLVZ1 / 7 * 5
     C*
     C                   EVAL      WKTEBBTEXT = 'Neu in BGFS'
     C*
     C                   ENDIF
     C*
     C     ART510        IFNE      '999'
     C     ART510        ANDNE     *BLANKS
     C                   EVAL      WKSTLF = '90' + ART510
     C                   ELSE
     C                   MOVEL     *BLANKS       WKSTLF
     C                   ENDIF
     C*
     C                   MOVEL(P)  WKSTLF        KYLFNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLIEF
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL     *BLANKS       WKSTLF
     C                   ENDIF
     C*
     C     ART240        MULT      10            WKGWBR
     C     ART630        CAT       ART620:1      WKMCBG
     C*
     C                   MOVEL(P)  TETEST        WKTEST
     C     ART999        IFEQ      '9'
     C                   MOVEL(P)  '90'          WKTEST
     C                   ELSE
     C     TETEST        IFNE      '88'
     C     TETEST        ANDNE     '90'
     C                   MOVEL(P)  '01'          WKTEST
     C                   ENDIF
     C                   ENDIF
     C*
     C     ART400        IFEQ      'WEINKO'
     C                   MOVEL(P)  '1'           WKWEMT
     C                   ELSE
     C                   MOVEL(P)  ' '           WKWEMT
     C                   ENDIF
     C*
     C                   SELECT
     C     ART040        WHENEQ    '900'
     C                   MOVEL(P)  '3'           WKTART
     C     ART390        WHENNE    *BLANKS
     C                   MOVEL(P)  '1'           WKTART
     C                   OTHER
     C                   MOVEL(P)  '2'           WKTART
     C                   ENDSL
     C*
     C     ART180        IFEQ      'A'
     C                   SELECT
     C     ART050        WHENEQ    '108'
     C                   MOVEL     '400'         WKDIAV
     C     ART050        WHENEQ    '404'
     C                   MOVEL     '100'         WKDIAV
     C     ART050        WHENEQ    '405'
     C                   MOVEL     '100'         WKDIAV
     C     ART050        WHENEQ    '406'
     C                   MOVEL     '100'         WKDIAV
     C     ART050        WHENEQ    '407'
     C                   MOVEL     '200'         WKDIAV
     C     ART050        WHENEQ    '408'
     C                   MOVEL     '500'         WKDIAV
     C     ART050        WHENEQ    '410'
     C                   MOVEL     '300'         WKDIAV
     C     ART050        WHENEQ    '411'
     C                   MOVEL     '100'         WKDIAV
     C     ART050        WHENEQ    '412'
     C                   MOVEL     '300'         WKDIAV
     C                   OTHER
     C                   MOVEL     *BLANKS       WKDIAV
     C                   ENDSL
     C                   ENDIF
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     ART210        WHENGE    'D01'
     C     ART210        ANDLE     'D99'
     C                   MOVEL(P)  '004'         WKURLD
     C     ART210        WHENEQ    '   '
     C                   MOVEL(P)  '958'         WKURLD
     C                   OTHER
     C                   MOVEL(P)  ART210        KYLNIS
     C                   MOVE      *BLANKS       KYLNNR
     C                   MOVEA     '03+     '    CHI
     C                   EXSR      CHLAND
     C     WKFENR        IFEQ      *ZEROS
     C     ART210        ANDEQ     LNLISO
     C                   MOVEL(P)  LNLDNR        WKURLD
     C                   ELSE
     C                   MOVEL(P)  '958'         WKURLD
     C                   ENDIF
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C*                  SELECT
     C*    ART210        WHENEQ    'USA'
     C*                  MOVEL(P)  '400'         WKURLD
     C*    ART210        WHENEQ    '  A'
     C*    ART210        OREQ      'A  '
     C*                  MOVEL(P)  '038'         WKURLD
     C*    ART210        WHENEQ    '  B'
     C*    ART210        OREQ      'B  '
     C*                  MOVEL(P)  '017'         WKURLD
     C*    ART210        WHENEQ    '  D'
     C*    ART210        OREQ      ' D '
     C*    ART210        OREQ      'D  '
     C*                  MOVEL(P)  '004'         WKURLD
     C*    ART210        WHENEQ    '  E'
     C**   ART210        OREQ      'E  '
     C*                  MOVEL(P)  '011'         WKURLD
     C*    ART210        WHENEQ    '  F'
     C*    ART210        OREQ      'F  '
     C*                  MOVEL(P)  '001'         WKURLD
     C*    ART210        WHENEQ    '  H'
     C*    ART210        OREQ      'H  '
     C*                  MOVEL(P)  '064'         WKURLD
     C*    ART210        WHENEQ    '  I'
     C*    ART210        OREQ      'I  '
     C*                  MOVEL(P)  '005'         WKURLD
     C*    ART210        WHENEQ    '  J'
     C*    ART210        OREQ      'J  '
     C*                  MOVEL(P)  '732'         WKURLD
     C*    ART210        WHENEQ    '  N'
     C*    ART210        OREQ      'N  '
     C*                  MOVEL(P)  '028'         WKURLD
     C*    ART210        WHENEQ    '  P'
     C*    ART210        OREQ      'P  '
     C*                  MOVEL(P)  '010'         WKURLD
     C*    ART210        WHENEQ    '  S'
     C*    ART210        OREQ      'S  '
     C*                  MOVEL(P)  '030'         WKURLD
     C*    ART210        WHENEQ    '  T'
     C*    ART210        OREQ      'T  '
     C*                  MOVEL(P)  '680'         WKURLD
     C*    ART210        WHENEQ    'CH '
     C*    ART210        OREQ      ' CH'
     C*                  MOVEL(P)  '039'         WKURLD
     C*    ART210        WHENEQ    'DK '
     C*    ART210        OREQ      ' DK'
     C*                  MOVEL(P)  '008'         WKURLD
     C*    ART210        WHENEQ    'GB '
     C*    ART210        OREQ      ' GB'
     C*                  MOVEL(P)  '006'         WKURLD
     C*    ART210        WHENEQ    'HK '
     C*    ART210        OREQ      ' HK'
     C*                  MOVEL(P)  '740'         WKURLD
     C*    ART210        WHENEQ    'IL '
     C*    ART210        OREQ      ' IL'
     C*                  MOVEL(P)  '624'         WKURLD
     C*    ART210        WHENEQ    'NL '
     C*    ART210        OREQ      ' NL'
     C*                  MOVEL(P)  '003'         WKURLD
     C*    ART210        WHENEQ    'TR '
     C*    ART210        OREQ      ' TR'
     C*                  MOVEL(P)  '052'         WKURLD
     C*    ART210        WHENEQ    'PL '
     C*    ART210        OREQ      ' PL'
     C*                  MOVEL(P)  '060'         WKURLD
     C*    ART210        WHENEQ    'SK '
     C*    ART210        OREQ      ' SK'
     C*                  MOVEL(P)  '063'         WKURLD
     C*    ART210        WHENEQ    'MK '
     C*    ART210        OREQ      ' MK'
     C*                  MOVEL(P)  '096'         WKURLD
     C*    ART210        WHENEQ    'CZ '
     C*    ART210        OREQ      ' CZ'
     C*                  MOVEL(P)  '061'         WKURLD
     C*    ART210        WHENEQ    'EC '
     C*    ART210        OREQ      ' EC'
     C*                  MOVEL(P)  '500'         WKURLD
     C*    ART210        WHENEQ    'ZA '
     C*    ART210        OREQ      ' ZA'
     C*                  MOVEL(P)  '388'         WKURLD
     C*    ART210        WHENEQ    'CDN'
     C*                  MOVEL(P)  '404'         WKURLD
     C*    ART210        WHENEQ    'D09'
     C*                  MOVEL(P)  '004'         WKURLD
     C*    ART210        WHENEQ    'D01'
     C*                  MOVEL(P)  '004'         WKURLD
     C*    ART210        WHENEQ    'D02'
     C*                  MOVEL(P)  '004'         WKURLD
     C*    ART210        WHENEQ    'D03'
     C*                  MOVEL(P)  '004'         WKURLD
     C*    ART210        WHENEQ    'D04'
     C*                  MOVEL(P)  '004'         WKURLD
     C*    ART210        WHENEQ    'D05'
     C*                  MOVEL(P)  '004'         WKURLD
     C*    ART210        WHENEQ    'D06'
     C*                  MOVEL(P)  '004'         WKURLD
     C*    ART210        WHENEQ    'D07'
     C*                  MOVEL(P)  '004'         WKURLD
     C*    ART210        WHENEQ    'D08'
     C*                  MOVEL(P)  '004'         WKURLD
     C*    ART210        WHENEQ    'D11'
     C*                  MOVEL(P)  '004'         WKURLD
     C*    ART210        WHENEQ    'D12'
     C*                  MOVEL(P)  '004'         WKURLD
     C*    ART210        WHENEQ    'D14'
     C*                  MOVEL(P)  '004'         WKURLD
     C*    ART210        WHENEQ    'D16'
     C*                  MOVEL(P)  '004'         WKURLD
     C*    ART210        WHENEQ    'EST'
     C*                  MOVEL(P)  '053'         WKURLD
     C*    ART210        WHENEQ    'IRL'
     C*                  MOVEL(P)  '007'         WKURLD
     C*    ART210        WHENEQ    'PRC'
     C*                  MOVEL(P)  '720'         WKURLD
     C*    ART210        WHENEQ    'ROC'
     C*                  MOVEL(P)  '736'         WKURLD
     C*    ART210        WHENEQ    'ROK'
     C*                  MOVEL(P)  '728'         WKURLD
     C*                  OTHER
     C*                  MOVEL(P)  '004'         WKURLD
     C*                  ENDSL
     C*
     C* Hier SAB aus Tabelle aufbereiten
     C**                 SELECT
     C**   ARZ180        WHENEQ    '1'
     C**                 MOVEL(P)  '?'           WKDIEK
     C**                 OTHER
     C**                 MOVEL(P)  '?'           WKDIEK
     C**                 ENDSL
     C*
     C* Änderung
     C     KZAE          IFEQ      'AEN'
     C                   EXSR      UAEND
     C     KZAEND        IFEQ      *OFF
     C                   LEAVE
     C                   ENDIF
     C*
     C                   EVAL      WKTEBBTEXT = 'Änd. in BGFS:'
     C     TETBZ1        IFNE      ART060
     C                   EVAL      WKTEBBTEXT = %TRIMR(WKTEBBTEXT) + ' ' +
     C                             'Bezeichnung'
     C                   ENDIF
     C     TEEANR        IFNE      FAN030
     C                   EVAL      WKTEBBTEXT = %TRIMR(WKTEBBTEXT) + ' ' +
     C                             'EAN-Nr.'
     C                   ENDIF
     C     TEMAGR        IFNE      ART040
     C                   EVAL      WKTEBBTEXT = %TRIMR(WKTEBBTEXT) + ' ' +
     C                             'Materialgruppe'
     C                   ENDIF
     C     TEPRGR        IFNE      ART050
     C                   EVAL      WKTEBBTEXT = %TRIMR(WKTEBBTEXT) + ' ' +
     C                             'Produktgruppe'
     C                   ENDIF
     C     TEERTE        IFNE      ART100
     C                   EVAL      WKTEBBTEXT = %TRIMR(WKTEBBTEXT) + ' ' +
     C                             'Ersatzartikel-Nr.'
     C                   ENDIF
     C     TEZOTN        IFNE      ART220
     C                   EVAL      WKTEBBTEXT = %TRIMR(WKTEBBTEXT) + ' ' +
     C                             'Zolltarif-Nr.'
     C                   ENDIF
     C     TEABC1        IFNE      ART180
     C                   EVAL      WKTEBBTEXT = %TRIMR(WKTEBBTEXT) + ' ' +
     C                             'ABC-KZ'
     C                   ENDIF
     C     TEURLD        IFNE      WKURLD
     C                   EVAL      WKTEBBTEXT = %TRIMR(WKTEBBTEXT) + ' ' +
     C                             'Ursprungsland'
     C                   ENDIF
     C**   TESTLF        IFNE      WKSTLF
     C**                 EVAL      WKTEBBTEXT = %TRIMR(WKTEBBTEXT) + ' ' +
     C**                           'Standardlieferant'
     C**                 ENDIF
     C     TEWEMT        IFNE      WKWEMT
     C                   EVAL      WKTEBBTEXT = %TRIMR(WKTEBBTEXT) + ' ' +
     C                             'QS-Prüfung'
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C     KZAE          IFEQ      'NEU'
     C*
     C                   MOVEL(P)  ART640        TETBZ2
     C* KM 24.05.2006    Z-ADD     ART250        TEVOLU
     C                   Z-ADD     1             TEVOLU
     C                   Z-ADD     ARZ215        TELOGR
     C                   Z-ADD     ARZ210        TEMIBM
     C                   Z-ADD     ART230        TEIVPE
     C*
     C                   MOVEL(P)  WKDIAV        TEDIAV
     C                   MOVEL(P)  WKTART        TETART
     C                   MOVEL(P)  WKTEST        TETEST
     C                   Z-ADD     WKLVZ1        TELVZ1
     C     TELVZ1        IFNE      *ZEROS
     C                   MOVEL(P)  'T'           TELVA1
     C                   ENDIF
     C                   MOVEL(P)  WKGWBR        TEGWBR
     C                   MOVEL(P)  WKMCBG        TEMCBG
     C     TEDIEK        IFEQ      *BLANKS
     C                   MOVEL(P)  '?'           TEDIEK
     C                   ENDIF
     C*
     C                   MOVEL(P)  WKSTLF        TESTLF
     C*
     C                   ENDIF
     C*
     C                   MOVEL(P)  ART060        TETBZ1
     C                   MOVEL(P)  WKWEMT        TEWEMT
     C                   MOVEL(P)  WKURLD        TEURLD
     C                   MOVEL(P)  ART180        TEABC1
     C                   MOVEL(P)  ART180        TEABC2
     C                   MOVEL(P)  ART180        TEABC3
     C                   MOVEL(P)  ART220        TEZOTN
     C                   MOVEL(P)  ART100        TEERTE
     C                   MOVEL(P)  ART050        TEPRGR
     C                   MOVEL(P)  ART040        TEMAGR
     C                   MOVEL(P)  FAN030        TEEANR
     C*
     C                   MOVEL(P)  ARTBED        TEUSER
     C                   MOVEL(P)  DAJNAM        TEJNAM
     C                   MOVEL(P)  DAPROG        TEPROG
     C                   MOVEL(P)  DABIBL        TEBIBL
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        TEJZEI
     C                   MOVE      WKTDAT        TEJDAT
     C*
     C                   SELECT
     C     KZAE          WHENEQ    'NEU'
     C                   MOVEA     '01W     '    CHI                            SATZ HINZU-
     C                   EXSR      CHTEIL                                       FÜGEN
     C     KZAE          WHENEQ    'AEN'
     C                   MOVEA     '01U     '    CHI                            SATZ UPDATEN
     C                   EXSR      CHTEIL
     C                   ENDSL
     C*
     C                   ENDDO
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI TEBB                                                 ***
     C**************************************************************************
     C     UTEBB         BEGSR
     C*
     C* Hier SAB aus Tabelle aufbereiten
     C                   SELECT
     C     ARZ180        WHENEQ    '1'
     C     ARZ180        OREQ      '2'
     C                   MOVEL(P)  'EK1'         KYTEBBABTL
     C     ARZ180        WHENEQ    '3'
     C     ARZ180        OREQ      '4'
     C                   MOVEL(P)  'EK3'         KYTEBBABTL
     C     ARZ180        WHENEQ    '8'
     C     ARZ180        OREQ      '9'
     C                   MOVEL(P)  'AV1'         KYTEBBABTL
     C                   OTHER
     C                   MOVEL(P)  'EK3'         KYTEBBABTL
     C                   ENDSL
     C*
     C                   MOVEL(P)  '00'          KYTEBBSTAT
     C                   MOVEL(P)  TETENR        KYTEBBTENR
     C                   Z-ADD     0             KYTEBBAENR
     C                   Z-ADD     0             KYTEBBLFZN
     C*
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEBB
     C     WKFENR        IFNE      *ZEROS
     C*
     C                   EVAL      TEBBTEXT = WKTEBBTEXT
     C*
     C                   MOVEL(P)  DAJNAM        TEBBJNAM
     C                   MOVEL(P)  DAPROG        TEBBPROG
     C                   MOVEL(P)  DABIBL        TEBBBIBL
     C                   MOVEL(P)  DAUSER        TEBBUSER
     C*
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        TEBBJZEI
     C                   MOVE      WKTDAT        TEBBJDAT
     C*
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHTEBB
     C*
     C                   ENDIF
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI PREI                                                 ***
     C**************************************************************************
     C     UPREI         BEGSR
     C*
     C                   DO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LP1'         KYPRBG
     C                   MOVEL(P)  LFLFNR        KYPRKL
     C                   MOVEL(P)  TETENR        KYPRTE
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     ART340        WHENEQ    0
     C                   MOVEL(P)  'EUR'         KYPRWC                         PREIS-DIM. EK
     C     ART340        WHENEQ    3
     C                   MOVEL(P)  'JPY'         KYPRWC                         PREIS-DIM. EK
     C     ART340        WHENEQ    9
     C                   MOVEL(P)  'USD'         KYPRWC                         PREIS-DIM. EK
     C     ART340        WHENEQ    11
     C                   MOVEL(P)  'CAD'         KYPRWC                         PREIS-DIM. EK
     C     ART340        WHENEQ    99
     C                   MOVEL(P)  'EUR'         KYPRWC                         PREIS-DIM. EK
     C                   OTHER
     C                   MOVEL(P)  LFWACD        KYPRWC                         PREIS-DIM. EK
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        PRJZEI
     C                   MOVE      WKTDAT        KYPRDA
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHPREI
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  TEPDEK        PRPDVK
     C                   MOVEL(P)  TEMPEK        PRMEPR
     C*-------------------------------------------------------------------------
     C                   CALL      'EXTSTP'
     C                   PARM                    PRTSTP
     C*--------------------------------------------------------
     C                   Z-ADD     ART330        PREZPR
     C*--------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        PRJNAM
     C                   MOVEL(P)  DAPROG        PRPROG
     C                   MOVEL(P)  DABIBL        PRBIBL
     C                   MOVEL(P)  DAUSER        PRUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        PRJZEI
     C                   MOVE      WKTDAT        PRJDAT
     C*--------------------------------------------------------
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHPREI
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI LPIF                                                 ***
     C**************************************************************************
     C     ULPIF         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  LFLFNR        KYLPLF
     C                   MOVEL(P)  TETENR        KYLPTE
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLPIF
     C*-------------------------------------------------------------------------
     C     WKFENR        IFNE      *ZEROS
     C                   MOVEL(P)  LFLAND        LPHKLD
     C                   MOVEL(P)  LFUREG        LPUREG
     C                   MOVEL(P)  EXFIRMJAKZ    LPBONU
     C                   MOVEL(P)  EXFIRMJAKZ    LPDRIB
     C                   MOVEL(P)  EXFIRMJAKZ    LPLFKZ
     C*--------------------------------------------------------
     C***  PRS080        IFNE      *BLANKS
     C***                MOVEL(P)  PRS080        LPIDEN
     C***                ELSE
     C                   MOVEL(P)  TETENR        LPIDEN
     C***                ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        LPJNAM
     C                   MOVEL(P)  DAPROG        LPPROG
     C                   MOVEL(P)  DABIBL        LPBIBL
     C                   MOVEL(P)  DAUSER        LPUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        LPJZEI
     C                   MOVE      WKTDAT        LPJDAT
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01W     '    CHI                            SATZ HINZU-
     C                   EXSR      CHLPIF                                       FÜGEN
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI TEUF                                                 ***
     C**************************************************************************
     C     UTEUF         BEGSR
     C*
     C                   MOVEL(P)  TEFIRM        KYTUFI
     C                   MOVEL(P)  TETENR        KYTUTE
     C                   MOVEL(P)  TEMEIN        KYTUME
     C*
     C                   MOVEA     '01C     '    CHI                            LESEN FÜR
     C                   EXSR      CHTEUF                                       UPDATE
     C     CHI(6)        IFEQ      *ON
     C*
     C                   Z-ADD     1             TUUFAK
     C                   MOVEL     'S'           TUMEIN
     C                   Z-ADD     1             TUUMV1
     C                   Z-ADD     1             TUUMV2
     C                   MOVEL(P)  'N'           TUANBR
     C*
     C                   MOVEL(P)  DAJNAM        TUJNAM
     C                   MOVEL(P)  DAPROG        TUPROG
     C                   MOVEL(P)  DABIBL        TUBIBL
     C                   MOVEL(P)  DAUSER        TUUSER
     C*
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        TUJZEI
     C                   MOVE      WKTDAT        TUJDAT
     C*
     C                   MOVEA     '01W     '    CHI                            SATZ HINZU-
     C                   EXSR      CHTEUF
     C                   ENDIF
     C*
     C                   ENDSR
     C**************************************************************************
     C***  DEFINITION DER WORKFELDER...                                      ***
     C**************************************************************************
     C     VLIKE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKC001                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7
     C     *LIKE         DEFINE    WKC001        ##RTCD
     C     *LIKE         DEFINE    WKC001        ##PGST
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1
     C     *LIKE         DEFINE    WKC001        WKRTCD
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKTRPA
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    TEBBTEXT      WKTEBBTEXT     +100
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    TEURLD        WKURLD
     C     *LIKE         DEFINE    TEDIAV        WKDIAV
     C     *LIKE         DEFINE    TESTLF        WKSTLF
     C     *LIKE         DEFINE    TETART        WKTART
     C     *LIKE         DEFINE    TEWEMT        WKWEMT
     C     *LIKE         DEFINE    TETEST        WKTEST
     C     *LIKE         DEFINE    TELVZ1        WKLVZ1
     C     *LIKE         DEFINE    TEGWBR        WKGWBR
     C     *LIKE         DEFINE    TEMCBG        WKMCBG
     C     *LIKE         DEFINE    TEDIEK        WKDIEK
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY TAMP/QCPYSRC,CHTEIL
     C/COPY TAMP/QCPYSRC,CHLAND
     C/COPY TAMP/QCPYSRC,CHTEUF
     C/COPY TAMP/QCPYSRC,CHTEBB
     C/COPY TAMP/QCPYSRC,CHTRTP
     C/COPY TAMP/QCPYSRC,CHPREI
     C/COPY TAMP/QCPYSRC,CHLPIF
     C/COPY TAMP/QCPYSRC,CHLIEF
     C/COPY TAMP/QCPYSRC,PRFIRMFIRM
