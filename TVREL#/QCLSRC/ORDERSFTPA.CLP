/*    * PROGRAMMNAME.:ORDERS                                                 */
/*    * FUNKTION.....:..                                                     */
/*    * SEPTEMBER 2010   GANG, MANFRED                                        */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX         PARM( '88505')                   PGMR.....           */
/******************************************************************************/
             PGM        PARM(&K)

             DCL        VAR(&K)    TYPE(*CHAR) LEN(05)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR3)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&GESTERN) TYPE(*CHAR) LEN(08)
             DCL        VAR(&TAG)   TYPE(*DEC) LEN(02 0)
             DCL        VAR(&MONAT) TYPE(*DEC) LEN(02 0)
             DCL        VAR(&JAHR)  TYPE(*DEC) LEN(04 0)
             DCL        VAR(&WOTAG) TYPE(*DEC) LEN(02 0)
             DCL        VAR(&OUTFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&QDATE)   TYPE(*CHAR) LEN(20)
             DCL        VAR(&QDATEV)  TYPE(*CHAR) LEN(20)
             DCL        VAR(&FILE)    TYPE(*CHAR) LEN(10)

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
             ADDLIBLE   LIB(TVRELWAECO) POSITION(*FIRST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))
   /*        CALL       PGM(INVOICESR) PARM(&K &D)      */
             IF         COND(&K *NE '88505' *AND &K *NE '40631') +
                          THEN(DO)
                GOTO ENDPGM
             ENDDO

             OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                          MBR(ORDERCMDA)
     /*    IF         COND(&K = '88505') THEN(DO)                    */
     /*       CALL     PGM(DUMMY512) PARM(&MD '#DC0101' ' ' ' ' ' ' +*/
     /*                 ' ' ' ')                                     */
     /*       CALL     PGM(DUMMY512) PARM(&MD '#DC0102' ' ' ' ' ' ' +*/
     /*                 ' ' ' ')                                     */
     /*    ENDDO                                                     */

             CLRPFM     FILE(TVRELWAECO/QCLSRC) MBR(ORDERLOGA)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +
                          MBR(ORDERLOGA)
             FTP        RMTSYS('DOMETIC-GROUP.COM')
             CHGCURLIB  CURLIB(*CRTDFT)
             DLTOVR     FILE(INPUT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(OUTPUT)
             MONMSG     MSGID(CPF0000)

             IF         COND(&PARM = '1') THEN(DO)
             ENDDO
 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
             ENDDO

             ENDPGM
