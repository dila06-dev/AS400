/*    * PROGRAMMNAME.: $GANG                                                 */
/*    * FUNKTION.....: ...                                                   */
/*    * OKTOBER  2010   GANG, MANFRED                                         */
/*    *                                                                       */
/*    *...                                                                   */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&CLIENT)

             DCL        VAR(&CLIENT)     TYPE(*CHAR) LEN(07)
             DCL        VAR(&CRTDATE)    TYPE(*CHAR) LEN(13)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&MBR)        TYPE(*CHAR) LEN(10)
             DCL        VAR(&RECORDS)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATETIME)   TYPE(*CHAR) LEN(20)
             DCL        VAR(&TXT50)      TYPE(*CHAR) LEN(50)

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('ORDERIN_C ')
             RTVMBRD    FILE(TVRELWAECO/QCLSRC) MBR(&PGM) TEXT(&TXT)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('START')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CHGVAR     VAR(%SST(&MD 100 7)) VALUE(&CLIENT)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

             RTVJOBA    USER(&USER) DATETIME(&DATETIME)
             MONMSG     MSGID(CPF0000)
             DLYJOB     DLY(1)

/*          UPDATE CUR_STOCK                                              */
             CALL       PGM(DUMMY512) PARM('&MD' 'CUR0010' ' ' ' ' +
                          'CUR_STOCK' 'TVRELWAECO' '*REPLACE')
             MONMSG     MSGID(CPF0000)

/*          UPDATE SLOWMOVER CURRENT STOCK                                */
             CALL       PGM(DUMMY512) PARM('&MD' 'CUR0014' ' ' ' ' +
                          'SLOWMOVER' 'TVRELWAECO' '*REPLACE')
             MONMSG     MSGID(CPF0000)

             RTVMBRD    FILE(TVRELWAECO/ORDERINPUT) MBR(TXT) +
                          CRTDATE(&CRTDATE) NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDPGM))

             IF         COND( &NBRCURRCD *NE 0) THEN(DO)
                CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('XX')
                IF         COND(&CLIENT *EQ '0088505') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('FR')
                ENDDO
                IF         COND(&CLIENT *EQ 'XX88505') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('TR')
                ENDDO
                IF         COND(&CLIENT *EQ '0040631') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('UK')
                ENDDO
                IF         COND(&CLIENT *EQ 'XX40631') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('TK')
                ENDDO
                IF         COND(&CLIENT *EQ '0055278') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('IT')
                ENDDO
                IF         COND(&CLIENT *EQ '0078146') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('ES')
                ENDDO
                IF         COND(&CLIENT *EQ '0008138') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('SE')
                ENDDO
                IF         COND(&CLIENT *EQ '0054939') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('AT')
                ENDDO
                IF         COND(&CLIENT *EQ '0002921') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('CH')
                ENDDO
                IF         COND(&CLIENT *EQ '0001887') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('DK')
                ENDDO
                IF         COND(&CLIENT *EQ '0078678') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('PL')
                ENDDO
                IF         COND(&CLIENT *EQ 'XX78678') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('TL')
                ENDDO
                IF         COND(&CLIENT *EQ '0042634') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('NO')
                ENDDO
                IF         COND(&CLIENT *EQ '0191453') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('RU')
                ENDDO
                IF         COND(&CLIENT *EQ '0015177') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('NL')
                ENDDO
                IF         COND(&CLIENT *EQ '0062765') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('NL')
                ENDDO
                IF         COND(&CLIENT *EQ '0098264') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('NL')
                ENDDO
                IF         COND(&CLIENT *EQ '0052774') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('LU')
                ENDDO
                IF         COND(&CLIENT *EQ '0752774') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('L7')
                ENDDO
                IF         COND(&CLIENT *EQ '0002511') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('SK')
                ENDDO
                IF         COND(&CLIENT *EQ '0772511') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('S7')
                ENDDO
                IF         COND(&CLIENT *EQ '0096690') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('HU')
                ENDDO
                IF         COND(&CLIENT *EQ '0796690') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('H7')
                ENDDO
                IF         COND(&CLIENT *EQ '0005084') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('FI')
                ENDDO
                IF         COND(&CLIENT *EQ '0035671') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('I2')
                ENDDO
                IF         COND(&CLIENT *EQ '0040670') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('U2')
                ENDDO
                IF         COND(&CLIENT *EQ '0040642') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('U3')
                ENDDO
/*          DOMETIC CLAIM SYSTEM                                          */
                IF         COND(&CLIENT *EQ '0000005') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('CC')
                ENDDO
                CHGVAR    VAR(%SST(&MBR 3 6)) VALUE(%SST(&CRTDATE 8 6))
                CHGVAR    VAR(%SST(&MBR 9 2)) +
                                         VALUE(%SST(&DATETIME 19 2))
                CPYF      FROMFILE(TVRELWAECO/ORDERINPUT) +
                          TOFILE(TVRELWAECO/ORDERINPUT) +
                          FROMMBR(TXT) TOMBR(&MBR) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NOCHK)
                MONMSG    MSGID(CPF0000)
                CHGVAR     VAR(%SST(&TXT50 1 20)) VALUE(&DATETIME)
                CHGVAR     VAR(%SST(&TXT50 22 10)) VALUE(&USER)
                CHGVAR     VAR(&RECORDS) VALUE(&NBRCURRCD)
                CHGVAR     VAR(%SST(&TXT50 33 10)) VALUE(&RECORDS)
                CHGPFM    FILE(TVRELWAECO/ORDERINPUT) MBR(&MBR) +
                          TEXT(&TXT50)
                MONMSG    MSGID(CPF0000)
                OVRDBF     FILE(ORDERINPUT) +
                          TOFILE(TVRELWAECO/ORDERINPUT) MBR(&MBR)
                MONMSG    MSGID(CPF0000)
/*          NOT DOMETIC CLAIM SYSTEM                                          */
                IF         COND(&CLIENT *NE '0000005') THEN(DO)
                   CALL       PGM(ORDERIN_R)
                   MONMSG    MSGID(CPF0000)
                ENDDO
/*          DOMETIC CLAIM SYSTEM                                          */
                IF         COND(&CLIENT *EQ '0000005') THEN(DO)
                   CALL       PGM(ORDERIN_R7)
                   MONMSG    MSGID(CPF0000)
                ENDDO
             ENDDO

 ENDPGM:

             DLTOVR     FILE(ORDERINPUT)
             MONMSG     MSGID(CPF0000)
     /*      DSPJOBLOG  OUTPUT(*PRINT)                */

/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('ENDE ')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CHGVAR     VAR(%SST(&MD 100 7)) VALUE(&CLIENT)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

             ENDPGM
