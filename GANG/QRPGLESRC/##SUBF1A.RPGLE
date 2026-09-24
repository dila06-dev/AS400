     C**************************************************************************
     C* PROGRAMMNAME.:##SUBF1A                                                
     C* FUNKTION.....:STEUERFERLDER FÜR 1. SUBFILE BEI ALPHAKEY
     C* Oktober 2009   GANG, MANFRED
     C*-------------------------------------------------------------------------
     C**************************************************************************
     C*INITIALISIERUNG                                                 *********
     C* WERTE AUS VORLAUFKARTE VERARBEITEN / INITIALISIERUNG
     C*-------------------------------------------------------------------------
     C*
     C     *LIKE         DEFINE    SFLDR1        SFLRN1
     C     *LIKE         DEFINE    SFLDR1        SFLAS1
     C     *LIKE         DEFINE    SFLDR1        SFLBK1
     C     *LIKE         DEFINE    SFLDR1        SFLPG1
     C     *LIKE         DEFINE    SFLDR1        SAVDR1
     C     *LIKE         DEFINE    SFLDR1        CRTREC
     C     *LIKE         DEFINE    SFLDR1        DLTREC
     C     *LIKE         DEFINE    SFLDR1        MODREC
     C*
     C     1             SUBST     FUNKT:2       CTL82             1
     C     1             SUBST     FUNKT:3       CTL83             1
     C     1             SUBST     FUNKT:4       CTL84             1
     C     1             SUBST     FUNKT:5       CTL85             1
     C     1             SUBST     FUNKT:6       CTL86             1
     C     1             SUBST     FUNKT:9       CTLC9             1
     C                   MOVEL     §§§PGM        MSGPGM
     C                   MOVE      SFLP1         SFLPG1
     C                   MOVE      '0'           CTLF07            1
     C                   MOVE      'J'           CTLLD             1
     C                   MOVE      'N'           CTLCHG            1
     C                   MOVE      'N'           CTLVLD            1
     C                   MOVE      ' '           CTLMOD            1
     C                   MOVEA     DSPMOD        *IN(33)
     C                   MOVEA     FUNKT         *IN(81)
     C                   Z-ADD     *ZERO         SFLDR1
     C*
     C                   EXSR      #MSL
     C   82              MOVEL     I§§F02        VI02
     C   82              MOVEL     '012'         VL02
     C                   MOVEL     I§§F03        VI03
     C                   MOVEL     '012'         VL03
     C                   MOVEL     I§§F04        VI04
     C                   MOVEL     '012'         VL04
     C                   MOVEL     I§§F05        VI05
     C                   MOVEL     '012'         VL05
     C   83              MOVEL     I§§F06        VI06
     C   83              MOVEL     '012'         VL06
     C                   MOVEL     I§§F12        VI07
     C                   MOVEL     '012'         VL07
     C   86              MOVEL     I§§F15        VI08
     C   86              MOVEL     '012'         VL08
     C   85              MOVEL     I§§F21        VI09
     C   85              MOVEL     '012'         VL09
     C   84              MOVEL     I§§F23        VI10
     C   84              MOVEL     '012'         VL10
     C     MSGLIS        PLIST
     C                   PARM      '*LIBL'       MSGL             10
     C                   PARM      'FWLMSGF'     MSGF             10
     C                   PARM      'AL00028'     MSGID             7
     C                   PARM      'M'           MSGMOD            1
     C                   PARM                    MSVLEN           30
     C                   PARM                    MSVTXT
     C                   PARM                    MSDATA          132
     C                   PARM                    MSLPOS            3
     C                   CALL      '##PGMSGR'    MSGLIS                 97
     C     MSLPOS        IFGT      '074'
     C                   MOVEL     I§§F24        VI01
     C                   MOVEL     '012'         VL01
     C                   MOVE      '1'           CTL29             1
     C                   CALL      '##PGMSGR'    MSGLIS                 97
     C                   ENDIF
     C                   MOVEL     MSDATA        D1FT01
     C                   MOVE      MSDATA        D1FT02
     C                   EXSR      #MSL
     C                   EXSR      MODATR
     C                   EXSR      SRATTR
     C                   EXSR      SR1199
     C*
     C     C1KEY         IFNE      *BLANK
     C                   MOVEL     'J'           CTLLD
     C                   END
     C*
     C     C1KEYV        IFEQ      *BLANK
     C                   MOVEL     *LOVAL        C1KEYV
     C                   END
     C*
     C     C1KEYB        IFEQ      *BLANK
     C                   MOVEL     *HIVAL        C1KEYB
     C                   END
     C*
     C     *LIKE         DEFINE    §§§KEY        LSTKY1
     C     *LIKE         DEFINE    §§§KEY        FSTKY1
     C     *LIKE         DEFINE    §§§KEY        MODKY1
     C     *LIKE         DEFINE    §§§KEY        C1KEYV
     C     *LIKE         DEFINE    §§§KEY        C1KEYB
