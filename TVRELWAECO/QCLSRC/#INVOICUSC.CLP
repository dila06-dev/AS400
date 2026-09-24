/*    * PROGRAMMNAME.:ABSATZZAHLEN ERMITTELN                                 */
/*    * FUNKTION.....:..                                                     */
/*    * SEPTEMBER 2010   GANG, MANFRED                                        */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                          PGMR.....           */
/******************************************************************************/
             PGM        PARM(&COMPANY &RETURNC)

             DCL        VAR(&PARM) TYPE(*CHAR) LEN(04)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&CALL) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&COMPANY) TYPE(*CHAR) LEN(02) VALUE('  ')
             DCL        VAR(&RETURNC) TYPE(*CHAR) LEN(30) VALUE(' ')
             DCL        VAR(&#COUNTING) TYPE(*CHAR) LEN(06) VALUE(' ')
             DCL        VAR(&INVOICES#C) TYPE(*DEC) LEN(06 0) +
                          VALUE(000000)
             DCL        VAR(&COUNTING) TYPE(*DEC) LEN(06 0) +
                          VALUE(000000)
             DCL        VAR(&DOKUMENT1) TYPE(*CHAR) LEN(030) +
                          VALUE('xml Documents for GXS output ')
             DCL        VAR(&DOKUMENT) TYPE(*CHAR) LEN(120) VALUE(' ')
             DCL        VAR(&IN)  TYPE(*CHAR) LEN(512) VALUE(' ')
             DCL        VAR(&OUT) TYPE(*CHAR) LEN(512) VALUE(' ')

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ABSATZR) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR3)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR4)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR5)  TYPE(*CHAR) LEN(01) VALUE('0')

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('#INVOICUSC')
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

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*FIRST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
             MONMSG     MSGID(CPF0000)

             ADDLIBLE LIB(I4XML) POSITION(*BEFORE GANG)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR3) +
                          VALUE('1'))
             MONMSG     MSGID(CPF0000)

             ADDLIBLE LIB(EINVOICE) POSITION(*BEFORE GANG)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR4) +
                          VALUE('1'))
             MONMSG     MSGID(CPF0000)

             ADDLIBLE LIB(EINVOICEUS) POSITION(*BEFORE EINVOICE)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR5) +
                          VALUE('1'))
             MONMSG     MSGID(CPF0000)

/*          ______________________________________________                   */
             DLTF       FILE(QTEMP/BATCHRUN)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(INVOICES#C) PARM(&COMPANY &INVOICES#C)
             MONMSG     MSGID(CPF0000)

 START:
             CHGVAR     VAR(&COUNTING) VALUE(&COUNTING + 1)
             CHGVAR     VAR(&#COUNTING) VALUE(&COUNTING)
             IF         COND((&COUNTING *LT &INVOICES#C *OR +
                          &COUNTING *EQ &INVOICES#C) *AND +
                          &INVOICES#C > 0) THEN(DO)

/*          INTERFACE TREND MODULE PARAMETER COMPANY                         */
             CALL       PGM(#INVOICUSR) PARM(&COMPANY &RETURNC)
             MONMSG     MSGID(CPF0000)
             RCLRSC
             MONMSG     MSGID(CPF0000)

/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(&MD) VALUE(' ')
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('#INVOICUSC')
             RTVMBRD    FILE(TVRELWAECO/QCLSRC) MBR(&PGM) TEXT(&TXT)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('LOOP ')
             CHGVAR     VAR(%SST(&MD 46 30)) VALUE(&RETURNC)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

/*          EMAIL START                                                   */
       /*   ***                                                              */
             CHGVAR     VAR(&DOKUMENT) +
                          VALUE('                                     -
                                            ')
             CHGVAR     VAR(&DOKUMENT) VALUE('/EINVOICE/Out/' *TCAT +
                          &RETURNC *TCAT '.XML')
             MONMSG     MSGID(CPF0000)
       /*   ***  ACHTUNG KONVERTIERUNG                                       */

             IF         COND(&RETURNC *NE 'no match found') THEN(DO)
                CHGVAR     VAR(&IN) VALUE('/EINVOICE/Out/' *TCAT +
                             &RETURNC *TCAT '.XML')
                CHGVAR     VAR(&OUT) VALUE('/EINVOICE/GXSScan/' *TCAT +
                             &RETURNC *TCAT '.XML')
                REWRITEIFS IFSIN(&IN) IFSOUT(&OUT)
                MONMSG     MSGID(CPF0000)
             ENDDO

       /*   ***                                                              */
             CHGVAR     VAR(&MD) VALUE(' ')
             CHGVAR     VAR(%SST(&MD 01 120)) VALUE(&DOKUMENT)
             CALL       PGM(DUMMY512) PARM(&MD '#GX0020' ' ' ' ' +
                           ' '  ' ' ' ')
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(&MD) VALUE(' ')
             CHGVAR     VAR(%SST(&MD 01 30)) VALUE(&DOKUMENT1)
             CHGVAR     VAR(%SST(&MD 31 120)) VALUE(&DOKUMENT)
             CALL       PGM(DUMMY512) PARM(&MD '#GX0021' ' ' ' ' +
                           ' '  ' ' ' ')
             MONMSG     MSGID(CPF0000)

             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                    FORMTYPE('GXS_OUT_TR') OVRSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)
             IF         COND(&RETURNC *NE 'no match found') THEN(DO)
                RMVLNK OBJLNK('/EINVOICE/MailUS/*')
                MONMSG     MSGID(CPF0000)
                CPY        OBJ(&DOKUMENT) TODIR('/EINVOICE/MailUS')
                MONMSG     MSGID(CPF0000)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)
             ENDDO
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)
       /*   ***                                                              */

/*          EMAIL ENDE                                                    */

             GOTO       CMDLBL(START)
             ENDDO
 END:
/*          ______________________________________________                   */

 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
    /*          RMVLIBLE   LIB(GANG)                       */
             ENDDO
             IF         COND(&ERROR1 = '0') THEN(DO)
    /*          RMVLIBLE   LIB(TVRELWAECO)                 */
             ENDDO
             IF         COND(&ERROR3 = '0') THEN(DO)
                RMVLIBLE   LIB(I4XML)
             ENDDO
             IF         COND(&ERROR4 = '0') THEN(DO)
                RMVLIBLE   LIB(EINVOICE)
             ENDDO
             IF         COND(&ERROR5 = '0') THEN(DO)
                RMVLIBLE   LIB(EINVOICEUS)
             ENDDO

             CHGVAR     VAR(&MD) VALUE(' ')
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
