/*    * PROGRAMMNAME.:DUMMY512                                               */
/*    * FUNKTION.....:QUERY-MANAGER AUFRUFEN(512 BYTES ÜBERGABE MIT          */
/*    *               UNBESTIMMTEN VARIABLEN IM SQL-STRING                   */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&MD &MSGID &MSGF &OUTPUT &OUTFILE &LIB +
                          &MODUS)

/*----------------------------------------------------------------------------*/
/* &MD       ==> VARIABLEN-ÜBERGABE FÜR MESSAGEFIL                   */
             DCL        VAR(&MD)      TYPE(*CHAR) LEN(256)

/* &MSGID    ==> MESSAGE FÜR AUSWERTUNG                              */
             DCL        VAR(&MSGID)   TYPE(*CHAR) LEN(07)

/* &MSGF     ==> MESSAGEFILE(AUS DER DIE MESSAGE ZU HOLEN IST        */
             DCL        VAR(&MSGF)    TYPE(*CHAR) LEN(10)

/* &OUTPUT   ==> WENN DRUCK, DANN ANGABE DES DRUCKERS                */
             DCL        VAR(&OUTPUT)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&DRUCKER) TYPE(*CHAR) LEN(10)

/* &OUTFILE  ==> WENN DATEI, DANN ANGABE DER DATEI                   */
             DCL        VAR(&OUTFILE) TYPE(*CHAR) LEN(10)

/* &LIB      ==> WENN DATEI, DANN ANGABE DER LIBRARAY                */
             DCL        VAR(&LIB)     TYPE(*CHAR) LEN(10)

/* &MODUS    ==> WENN DATEI, DANN *RELACE ODER *ADD                  */
             DCL        VAR(&MODUS)   TYPE(*CHAR) LEN(10)

/*----------------------------------------------------------------------------*/
/* SQL-Auswahl in den Übergabevariablen stellen             */
/* SQL-Auswahl kann 512 Stellen lang sein, STRQMQRY aber    */
/* gestattet max 55 Stellen pro Variable                    */
/*----------------------------------------------------------------------------*/
             DCL        VAR(&SQL1) TYPE(*CHAR) LEN(55)
             DCL        VAR(&SQL2) TYPE(*CHAR) LEN(55)
             DCL        VAR(&SQL3) TYPE(*CHAR) LEN(55)
             DCL        VAR(&SQL4) TYPE(*CHAR) LEN(55)
             DCL        VAR(&SQL5) TYPE(*CHAR) LEN(36)

             DCL        VAR(&SQL6) TYPE(*CHAR) LEN(55)
             DCL        VAR(&SQL7) TYPE(*CHAR) LEN(55)
             DCL        VAR(&SQL8) TYPE(*CHAR) LEN(55)
             DCL        VAR(&SQL9) TYPE(*CHAR) LEN(55)
             DCL        VAR(&SQL10) TYPE(*CHAR) LEN(36)
/*----------------------------------------------------------------------------*/
             DCL        VAR(&DATA)   TYPE(*CHAR) LEN(512)
             DCL        VAR(&DATA1)  TYPE(*CHAR) LEN(512)
             DCL        VAR(&DATA2)  TYPE(*CHAR) LEN(512)
             DCL        VAR(&DATA3)  TYPE(*CHAR) LEN(512)
             DCL        VAR(&DATA4)  TYPE(*CHAR) LEN(512)
             DCL        VAR(&PGMQ)   TYPE(*CHAR) LEN(10)

             DCL        VAR(&ERROR)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10) VALUE(' ')

/*-ENVIRONMENT ANPASSEN---EVTL. EINGABEKORREKTUREN----------------------------*/
             CHGVAR     VAR(&PGMQ) VALUE('DUMMY512')
             CHGVAR     VAR(&DRUCKER) VALUE(&OUTPUT)

             IF         COND(&MSGF  = '          ') THEN(DO)
                CHGVAR     VAR(&MSGF) VALUE('DOMWECOSQL')
             ENDDO
             IF         COND(&MSGID = '          ') THEN(DO)
                GOTO ENDE
             ENDDO
             IF         COND(&OUTPUT  = '          ') THEN(DO)
                CHGVAR     VAR(&OUTPUT) VALUE('*        ')
             ENDDO
             IF         COND(&OUTPUT *NE '*         ') THEN(DO)
                CHGVAR     VAR(&OUTPUT) VALUE('*PRINT   ')
             ENDDO
             IF         COND(&OUTFILE *NE '          ') THEN(DO)
                CHGVAR     VAR(&OUTPUT) VALUE('*OUTFILE ')
             ENDDO
             IF         COND(&OUTFILE *NE '          ') THEN(DO)
                IF         COND(&LIB     =   '          ') THEN(DO)
                   CHGVAR     VAR(&OUTPUT) VALUE('*        ')
                ENDDO
             ENDDO
             IF         COND(&OUTFILE *NE '          ') THEN(DO)
                IF         COND((&MODUS *NE '*REPLACE  ') *OR (&MODUS +
                             *NE '*add      ')) THEN(DO)
                   CHGVAR     VAR(&OUTPUT) VALUE('*        ')
                ENDDO
             ENDDO

             IF         COND(&OUTPUT  *EQ '*PRINT    ') THEN(DO)
                CHKOBJ     OBJ(&DRUCKER) OBJTYPE(*DEVD)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                           VALUE('1'))
                IF         COND(&ERROR = '1') THEN(DO)
                   CHGVAR     VAR(&DRUCKER) VALUE('          ')
                   CHGVAR     VAR(&OUTPUT) VALUE('          ')
                ENDDO
                IF         COND(&ERROR = '0') THEN(DO)
                  RTVJOBA    USER(&USER)
       /*     OVRPRTF FILE(QPQXPRTF) DEV(&DRUCKER) OUTQ(&DRUCKER) + */
       /*             FORMTYPE('0001') HOLD(*NO) SAVE(*NO) +        */
       /*             USRDTA(&USER)                                 */
       /*     MONMSG     MSGID(CPF0000)                             */
                ENDDO
             ENDDO

/*ENTSPRECHENDE MESSAGE HOLEN FÜR SQL-----------------------------------------*/
             RMVMSG     CLEAR(*ALL)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGF) MSGDTA(&MD) +
                          TOPGMQ(*PRV)
             MONMSG     MSGID(CPF0000)
             RCVMSG     PGMQ(*PRV (* &PGMQ)) MSGTYPE(*LAST) +
                          RMV(*YES) SECLVL(&DATA)
             MONMSG     MSGID(CPF0000)
/*------*/
             CHGVAR     VAR(&SQL1) VALUE(%SST(&DATA 1 55))
             CHGVAR     VAR(&SQL2) VALUE(%SST(&DATA 56 55))
             CHGVAR     VAR(&SQL3) VALUE(%SST(&DATA 111 55))
             CHGVAR     VAR(&SQL4) VALUE(%SST(&DATA 166 55))
             CHGVAR     VAR(&SQL5) VALUE(%SST(&DATA 221 36))
/*------*/
             CHGVAR     VAR(&SQL6) VALUE(%SST(&DATA 257 55))
             CHGVAR     VAR(&SQL7) VALUE(%SST(&DATA 312 55))
             CHGVAR     VAR(&SQL8) VALUE(%SST(&DATA 367 55))
             CHGVAR     VAR(&SQL9) VALUE(%SST(&DATA 422 55))
             CHGVAR     VAR(&SQL10) VALUE(%SST(&DATA 477 36))

/*----------------------------------------------------------------------------*/

             IF         COND(&OUTFILE *NE '          ') THEN(DO)
                CHGVAR     VAR(&OUTPUT) VALUE('*OUTFILE')
             STRQMQRY   QMQRY(GANG/#DUMMY512) OUTPUT(&OUTPUT) +
                          OUTFILE(&LIB/&OUTFILE) OUTMBR(*FIRST +
                          &MODUS) SETVAR((S1 &SQL1) (S2 &SQL2) (S3 +
                          &SQL3) (S4 &SQL4) (S5 &SQL5) (S6 &SQL6) +
                          (S7 &SQL7) (S8 &SQL8) (S9 &SQL9) (S10 +
                          &SQL10))
                MONMSG     MSGID(CPF0001) EXEC(GOTO CMDLBL(MESSAGES))
                MONMSG     MSGID(CPF9999) EXEC(GOTO CMDLBL(MESSAGES))
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
                GOTO ENDE
             ENDDO
             IF         COND(&OUTFILE *EQ '          ') THEN(DO)
             STRQMQRY   QMQRY(GANG/#DUMMY512) OUTPUT(&OUTPUT) +
                          OUTMBR(*FIRST) DATETIME(*NO) PAGNBR(*NO) +
                          SETVAR((S1 &SQL1) (S2 &SQL2) (S3 &SQL3) +
                          (S4 &SQL4) (S5 &SQL5) (S6 &SQL6) (S7 +
                          &SQL7) (S8 &SQL8) (S9 &SQL9) (S10 &SQL10))
                MONMSG     MSGID(CPF0001) EXEC(GOTO CMDLBL(MESSAGES))
                MONMSG     MSGID(CPF9999) EXEC(GOTO CMDLBL(MESSAGES))
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
                GOTO ENDE
             ENDDO
/*--KEINE DIFFERENZIERTEN MELDUNGEN MEHR--------------------------------------*/
 MESSAGES:
             GOTO ENDE
             CHGVAR     VAR(&PGMQ) VALUE('SYS0005R')
             SNDPGMMSG  MSGID(ALG0000) MSGF(GANG) +
                            MSGDTA(&DATA) TOPGMQ(*SAME (&PGMQ))
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
             RCVMSG     PGMQ(*SAME (* QSQXCUTE)) MSGTYPE(*ANY) +
                          MSGKEY(*NONE) RMV(*YES) MSG(&DATA1)
             MONMSG     MSGID(CPF0000)
             SNDPGMMSG  MSG(&DATA1) TOPGMQ(*SAME (&PGMQ))
             MONMSG     MSGID(CPF0000)
             RCVMSG     PGMQ(*SAME (* QQXSNDMG)) MSGTYPE(*ANY) +
                          MSGKEY(*NONE) RMV(*YES) MSG(&DATA2)
             MONMSG     MSGID(CPF0000)
             SNDPGMMSG  MSG(&DATA2) TOPGMQ(*SAME (&PGMQ))
             MONMSG     MSGID(CPF0000)
       /*    DLTOVR     FILE(QPQXPRTF)      */
       /*    MONMSG     MSGID(CPF0000)      */
 ENDE:
             ENDPGM
