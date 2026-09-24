/*    * PROGRAMMNAME.:#DEFLDA                                                */
/*    * FUNKTION.....:DEFINITIONEN IN DER LDA                                */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM
             DCL        VAR(&E1CRT)    TYPE(*CHAR) LEN(12)
             DCL        VAR(&E1MOD)    TYPE(*CHAR) LEN(12)
             DCL        VAR(&E1DLT)    TYPE(*CHAR) LEN(12)
             DCL        VAR(&DEV)      TYPE(*CHAR) LEN(2)
             DCL        VAR(&WSTATION) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTDEV)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&QDATETIME) TYPE(*CHAR) LEN(20)
             DCL        VAR(&F4RRN) TYPE(*CHAR) LEN(15) +
                          VALUE('000000000000000')
             DCL        VAR(&PGMQ)  TYPE(*CHAR) LEN(10)
/*       INPUTFILE                                            */
             DCLF       FILE(GANG/USERJOB)
/******************************************************************************/
/* STANDARDZEILE DEFINIEREN                                            -------*/
             CHGVAR     VAR(&PGMQ) VALUE('#DEFLDA  ')
/*                                                                     ********/
/* FORMAT JJJJMMTT 1009-1016 UND TTMMHHJJ 1017 1024 IN *LDA SCHREIBEN         */
             RTVSYSVAL  SYSVAL(QDATETIME) RTNVAR(&QDATETIME)
             CHGDTAARA  DTAARA(*LDA (1009 4)) VALUE(%SST(&QDATETIME +
                          1 4))
             CHGDTAARA  DTAARA(*LDA (1013 2)) VALUE(%SST(&QDATETIME +
                          5 2))
             CHGDTAARA  DTAARA(*LDA (1015 2)) VALUE(%SST(&QDATETIME +
                          7 2))
             CHGDTAARA  DTAARA(*LDA (1017 2)) VALUE(%SST(&QDATETIME +
                          7 2))
             CHGDTAARA  DTAARA(*LDA (1019 2)) VALUE(%SST(&QDATETIME +
                          5 2))
             CHGDTAARA  DTAARA(*LDA (1021 4)) VALUE(%SST(&QDATETIME +
                          1 4))
/* DATUM/ZEIT IM FORMAT *EUR  IN *LDA SCHREIBEN                               */
             CHGDTAARA  DTAARA(*LDA (975 4)) VALUE(%SST(&QDATETIME +
                          1 4))
             CHGDTAARA  DTAARA(*LDA (979 1)) VALUE(-)
             CHGDTAARA  DTAARA(*LDA (980 2)) VALUE(%SST(&QDATETIME +
                          5 2))
             CHGDTAARA  DTAARA(*LDA (982 1)) VALUE(-)
             CHGDTAARA  DTAARA(*LDA (983 2)) VALUE(%SST(&QDATETIME +
                          7 2))

             CHGDTAARA  DTAARA(*LDA (985 2)) VALUE(%SST(&QDATETIME +
                         09 02))
             CHGDTAARA  DTAARA(*LDA (987 1)) VALUE(':')
             CHGDTAARA  DTAARA(*LDA (988 2)) VALUE(%SST(&QDATETIME +
                         11 02))
             CHGDTAARA  DTAARA(*LDA (990 1)) VALUE(':')
             CHGDTAARA  DTAARA(*LDA (991 2)) VALUE(%SST(&QDATETIME +
                         13 02))
/* F4RRN (RELATIVE SATZNUMMER INITIALISIEREN)                        */
             CHGDTAARA  DTAARA(*LDA (875 15)) VALUE(&F4RRN)

/* LDA SONSTIGE FELDER ----------------------------------------------*/
             CHGVAR     VAR(&E1CRT) VALUE('000000000000')
             CHGDTAARA  DTAARA(*LDA (902 12)) VALUE(&E1CRT)
             CHGVAR     VAR(&E1MOD) VALUE('000000000000')
             CHGDTAARA  DTAARA(*LDA (915 12)) VALUE(&E1MOD)
             CHGVAR     VAR(&E1DLT) VALUE('000000000000')
             CHGDTAARA  DTAARA(*LDA (928 12)) VALUE(&E1DLT)

/* BEREICHE FÜR DRUCKERÜBERGABE IN LDA                               */
             RTVJOBA    JOB(&WSTATION) USER(&USER) PRTDEV(&PRTDEV)
             CHGVAR     VAR(&DEV) VALUE('  ')
             CHGDTAARA DTAARA(*LDA (520 10)) VALUE(&PRTDEV)
             CHGDTAARA  DTAARA(*LDA (890 10)) VALUE('DOMWECOSQL')
             CHGDTAARA  DTAARA(*LDA (480 03)) VALUE('072')
LOOP: +
     RCVF
          MONMSG MSGID(CPF0864) EXEC(GOTO CMDLBL(EOF))
          IF         COND(&#WSTATION *NE &WSTATION *AND &#USER +
                       *NE &USER) THEN(GOTO CMDLBL(LOOP))
             CHGDTAARA  DTAARA(*LDA (890 10)) VALUE(&#MSGF)
             CHGDTAARA  DTAARA(*LDA (480 03)) VALUE(&#ZEILEN)
             CHGDTAARA  DTAARA(*LDA (520 10)) VALUE(#PRINTER)
 EOF:

             ENDPGM
