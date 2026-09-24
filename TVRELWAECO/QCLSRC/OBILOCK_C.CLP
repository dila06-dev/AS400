/*    * PROGRAMMNAME.:$GANG                                                  */
/*    * FUNKTION.....:...                                                    */
/*    * JULI    2010   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *-START SUBSTYSTEM                                                     */
/*    * SELECT TETENR, CHAR('001') LAGER FROM TEIL                            */
/*    *       .                                                               */
/*    *            .                                                          */
/*    *                .                                                      */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&OBILOCK &OBIOBJ)

             DCL        VAR(&OBILOCK)    TYPE(*CHAR) LEN(06) VALUE(' ')
             DCL        VAR(&OBIOBJ)     TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&NORUN)      TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&CODE)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&OBJ)        TYPE(*CHAR) LEN(22)
             DCL        VAR(&SC) TYPE(*DEC) LEN(07 0) VALUE(0000000)
             DCL        VAR(&K)         TYPE(*CHAR) LEN(5)
             DCL        VAR(&#)         TYPE(*CHAR) LEN(1)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&DAFEHL) TYPE(*CHAR) LEN(1)

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

             DCLF       FILE(TVRELWAECO/BESTAND)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('ABESTAND_C')
             RTVMBRD    FILE(TVRELWAECO/QCLSRC) MBR(&PGM) TEXT(&TXT)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('START')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG --------                                      */

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*AFTER TFXF)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             CHGVAR     VAR(&OBJ)    VALUE('/F95/OBI/' *TCAT &OBIOBJ)

/*          DIRECTORY --------------                                      */
             CD         DIR('/F95/OBI/')
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&NORUN) +
                          VALUE('1'))
             IF         COND(&NORUN = '1') THEN(DO)
                GOTO       CMDLBL(ENDPGM)
             ENDDO

/*          BERECHTIGUNG ABLEITEN FÜR ALLE UNTERVERZEICHNISSE             */
             CHGAUT     OBJ('/F95/') USER(*PUBLIC) DTAAUT(*RWX) +
                          OBJAUT(*ALL) SUBTREE(*ALL)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&NORUN) +
                          VALUE('1'))
             IF         COND(&NORUN = '1') THEN(DO)
                GOTO       CMDLBL(ENDPGM)
             ENDDO

/*          SPERRE EINLEITEN                                              */
             IF         COND(&OBILOCK = 'CHKOUT') THEN(DO)
                CHKOUT     OBJ(&OBJ) SUBTREE(*NONE)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&NORUN) +
                             VALUE('1'))
                IF         COND(&NORUN = '1') THEN(DO)
                   DSPJOBLOG  OUTPUT(*PRINT)
                   GOTO       CMDLBL(ENDPGM)
                ENDDO
/*             INAKTIV  DA &NORUN = 'Y'                                         */
                IF         COND(&NORUN = 'Y') THEN(DO)
                   MOV        OBJ(&OBJ) TODIR('/F95/OBI/TRANSFER')
                   MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&NORUN) +
                                VALUE('1'))
/*                IM FEHLERFALL FREIGABE                                        */
                   CHKIN      OBJ(&OBJ) SUBTREE(*NONE)
                   MONMSG     MSGID(CPF0000)
                   DSPJOBLOG  OUTPUT(*PRINT)
                   GOTO       CMDLBL(ENDPGM)
                ENDDO
             ENDDO


/*          SPERRE FREIGEBEN                                              */
             IF         COND(&OBILOCK = 'CHKIN ') THEN(DO)
                CHKIN      OBJ(&OBJ) SUBTREE(*NONE)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&NORUN) +
                             VALUE('1'))
                IF         COND(&NORUN = '1') THEN(DO)
                   DSPJOBLOG  OUTPUT(*PRINT)
                   GOTO       CMDLBL(ENDPGM)
                ENDDO
             ENDDO



 ENDPGM:
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
                MONMSG     MSGID(CPF0000)
             ENDDO

     /*      DSPJOBLOG  OUTPUT(*PRINT)                */


/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('ENDE ')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */


             ENDPGM
