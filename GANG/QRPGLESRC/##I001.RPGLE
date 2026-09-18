     * PROGRAMM-STATUS-DATENSTRUKTUR
     D DSPGM          SDS
     D  §§§PGM                 1     10
     D  §§§STS                11     15  0
     D  §§§SEQ                21     28
     D  §§§SR                 29     36
     D  §§§MSG                40     46
     D  §§§LIB                81     90
     D  §§§MTX                91    170
     D  §§§FIL               201    208
     D  §§§FST               209    243
     D  §§§JOB               244    253
     D  §§§USR               254    263
     D  §§§JNO               264    269  0
     D  §§§SDT               276    281  0
     D  §§§STM               282    287  0
     * LOCAL DATA AEREA (LDA)
     D LDA            UDS
     D* FREIER PRAGRAMMBEREICH
     D  LDABER               002    256
     D* AKTIVE PROGRAMME
     D* DRUCKER-PROGRAMME/STEUERUNGEN FELDER
     D  DHTSYS               400    407
     D  DHTDOK               408    415
     D  DHTPGM               416    423
     D  DHTVTL               424    427
     D  DHTDAT               428    433
     D  DHTTIM               434    439
     D  DHTPAG               440    445
     D  DHFLIN               446    446
     D  DHELIN               447    447
     D* DRUCKER-ZEILENMAXIMAL-STANDARD/FORM/DEVICE/DEVICE-ÜBER RTVJOB
     D  DHZL1                480    482  0
     D  DHFORM               507    510
     D  DHDEV                511    512
     D  DHPRT1               520    530
     D* DATENÜBERGABEBEREICH VON 256BYTES (Z.B. AREA MD)
     D  DATEN1               601    856
     D* RELATIVE SATZNUMMER BEI Z.B F4 MATCHCODE ODER READ FIRST
     D  FXRRN                875    889  0
     D* MESSAGE-FILE
     D  MSGF                 890    899
     D* MENÜ-PROGRAMM
     D* COMITSTEUERUNG
     D  E1COM                900    900
     D* DATEIMODIFIZIERUNGEN
     D  E1CRT                902    913  0
     D  E1MOD                914    925  0
     D  E1DLT                926    937  0
     D* FUNKTIONSTASTERÜCKKEHR
     D  CTLTST               950    951
     D* CONDECODE
     D  RC                   952    953
     D* PROGRAMM, WELCHE NACHRICHT ERHALTEN SOLL
     D  MSGPGM               954    963
     D* DATUMSANGABEN
     D* DATUM UND ZEIT *EUR
     D  E1DEUR               975    984
     D  E1ZEUR               985    992
     D*
     D* DATUM 8-STELLIG (FORMAT: LDADTP-HHJJMMTT, LDADTD-TTMMHHJJ)
     D  LDAHJ               1009   1012  0
     D  LDADTP              1009   1016  0
     D  LDADTH              1009   1010  0
     D  LDADTJ              1011   1012  0
     D  LDADTM              1013   1014  0
     D  LDADTT              1015   1016  0
     D  LDADTD              1017   1024  0
