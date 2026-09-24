/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:IDCO                                                   */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    * .                                                                     */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&PARM)

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURR##)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('SC05084_C ')
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
/*          PROTOKOLLIERUNG ---                                           */

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*AFTER TFXF)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
  /*   GOTO SAVE   */

             IF         COND(&PARM *EQ '1' ) THEN(DO)
/*             GENERELLER AUFBAU                                             */
/*             ZIEHEN RELEVANTER DATEN AUS #LBLB                             */
            CALL       PGM(DUMMY512) PARM(&MD '#DC4011' ' ' ' ' +
                       '#AFRK05084' 'TVRELWAECO' '*ADD')
            MONMSG     MSGID(CPF0000)
      /*    CALL       PGM(DUMMY512) PARM(&MD '#CT0501' ' ' ' ' + */
      /*                '#AFRK05084' 'TVRELWAECO' '*ADD')         */
      /*     MONMSG     MSGID(CPF0000)                            */
             CPYF       FROMFILE(TVRELWAECO/DOMINV_FI) +
                           TOFILE(TVRELWAECO/DOMINV_FIS) +
                           TOMBR(*FIRST) MBROPT(*ADD) CRTFILE(*NO)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(TVRELWAECO/DOMINV_FI)
                MONMSG     MSGID(CPF0000)

                CPYF       FROMFILE(TVRELWAECO/DOMINV_FI2) +
                           TOFILE(TVRELWAECO/DOMINV_FIZ) +
                           TOMBR(*FIRST) MBROPT(*ADD) CRTFILE(*NO)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(TVRELWAECO/DOMINV_FI2)
                MONMSG     MSGID(CPF0000)

                CALL       PGM(SC05084_R)
                MONMSG     MSGID(CPF0000)

                CPYF       FROMFILE(TVRELWAECO/DOMINV_FI) +
                             TOFILE(WAECOEDI/DOMINVCHCK) +
                             MBROPT(*REPLACE) CRTFILE(*NO)
                MONMSG     MSGID(CPF0000)
                CPYF       FROMFILE(TVRELWAECO/DOMINV_FI2) +
                             TOFILE(TVRELWAECO/DOMINV_FI) +
                             MBROPT(*REPLACE) CRTFILE(*NO)
                MONMSG     MSGID(CPF0000)
                CPYF       FROMFILE(TVRELWAECO/DOMINV_FI) +
                             TOFILE(WAECOEDI/DOMINVCHCK) +
                             MBROPT(*REPLACE) CRTFILE(*NO)
                MONMSG     MSGID(CPF0000)

    SAVE:
                RTVMBRD    FILE(TVRELWAECO/DOMINV_FI) +
                           NBRCURRCD(&NBRCURRCD)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&NBRCURRCD) +
                           VALUE(0))
                IF         COND(&NBRCURRCD *NE 0) THEN(DO)
                   CALL       PGM(GFTPINV) PARM('fi')
                   MONMSG     MSGID(CPF0000)
                ENDDO

             ENDDO
/*                                                                            */
 ENDPGM:

/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('ENDE ')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CHGVAR     VAR(%SST(&MD 100 14)) VALUE('Sätze verarb.')
             CHGVAR     VAR(&NBRCURR##) VALUE(&NBRCURRCD)
             CHGVAR     VAR(%SST(&MD 115 10)) VALUE(&NBRCURR##)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
                MONMSG     MSGID(CPF0000)
             ENDDO
             ENDPGM
