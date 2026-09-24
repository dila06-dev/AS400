/*    * PROGRAMMNAME.:ORDERS                                                 */
/*    * FUNKTION.....:..                                                     */
/*    * SEPTEMBER 2010   GANG, MANFRED                                        */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX         PARM( '88505')                   PGMR.....           */
/******************************************************************************/
             PGM        PARM(&MBR)

             DCL        VAR(&K)    TYPE(*CHAR) LEN(05)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&SC) TYPE(*DEC) LEN(07 0)
             DCL        VAR(&MBR)        TYPE(*CHAR) LEN(10)

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

             IF         COND(&MBR = 'DE113 ') THEN(DO)
/*             SEITZ                                                         */
                OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                           MBR(FACTDE113)
             ENDDO

             IF         COND(&MBR = 'DE111A') THEN(DO)
/*             SIEGEN                                                        */
                OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                           MBR(FACTDE111A)
             ENDDO

         /*  CLRPFM     FILE(TVRELWAECO/QCLSRC) MBR(FACTORLOG) */
         /*  MONMSG     MSGID(CPF0000)                         */
         /*  CHGJOB     CCSID(1144)     */
         /*  MONMSG     MSGID(CPF0000)  */
         /*  CHGJOB     CCSID(65535)    */
         /*  CHGJOB     CCSID(280)      */
         /*  MONMSG     MSGID(CPF0000)  */
             OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +
                          MBR(FACTORLOG)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +
                           'OUTPUT    '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)

             FTP        RMTSYS('DOMETIC-GROUP.COM')
             CHGCURLIB  CURLIB(*CRTDFT)
             DLTOVR     FILE(INPUT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(OUTPUT)
             MONMSG     MSGID(CPF0000)
             CHGJOB     CCSID(65535)
             MONMSG     MSGID(CPF0000)


 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
             ENDDO

             ENDPGM
