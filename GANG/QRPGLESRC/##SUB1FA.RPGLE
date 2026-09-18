     C**************************************************************************
     C* PROGRAMMNAME.:##SUBF1A                                                
     C* FUNKTION.....:STEUERFERLDER FÜR 1. SUBFILE
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
     C     1             SUBST     FUNKT:7       CTL87             1
     C     1             SUBST     FUNKT:8       CTL88             1
     C     1             SUBST     FUNKT:9       CTL89             1
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
     C                   MOVEA     FKTTST        *IN(35)
     C*
     C                   Z-ADD     *ZERO         ZEILE             2 0
     C                   Z-ADD     *ZERO         SPALTE            3 0
     C                   Z-ADD     9             CTLARB
     C                   EXSR      FKTPGM
     C                   Z-ADD     *ZERO         CTLARB
     C                   Z-ADD     *ZERO         NEUFNR
     C                   MOVE      *BLANK        NEUFKT
     C                   EXSR      TASTEN
     C                   EXSR      FKTPGM
     C                   EXSR      MODATR
     C                   EXSR      SRATTR
     C                   EXSR      SR1199
     C*
