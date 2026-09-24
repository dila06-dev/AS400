/*    * PROGRAMMNAME.:ORDER_XC                                               */
/*    * FUNKTION.....:ORDER_XC                                               */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *                                                                       */
/*    *                                                                       */
/*    *                                                                       */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(05)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&TIMESTAMP) TYPE(*CHAR) LEN(11) VALUE(' ')
             DCL        VAR(&TOFILE) TYPE(*CHAR) LEN(32) VALUE('  ')
             DCL        VAR(&SC) TYPE(*DEC) LEN(07 0) VALUE(0055278)

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*AFTER TFXF)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))


                CLRPFM     FILE(QTEMP/ORDERH)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(QTEMP/ORDERL)
                MONMSG     MSGID(CPF0000)
                RTVMBRD    FILE(GANG/ORDER#) +
                           NBRCURRCD(&NBRCURRCD)
                MONMSG     MSGID(CPF0000)
                IF         COND(&NBRCURRCD *GT 00000) THEN(DO)
                   CRTDUPOBJ  OBJ(ORDERH) FROMLIB(TVRELWAECO) +
                             OBJTYPE(*FILE) TOLIB(QTEMP)
                   MONMSG     MSGID(CPF0000)
                   CRTDUPOBJ  OBJ(ORDERL) FROMLIB(TVRELWAECO) +
                             OBJTYPE(*FILE) TOLIB(QTEMP)
                   MONMSG     MSGID(CPF0000)
                   CPYFRMIMPF FROMFILE(GANG/ORDER#) +
                              TOFILE(TVRELWAECO/ORDER#) +
                              MBROPT(*REPLACE) FLDDLM(';') +
                              RPLNULLVAL(*FLDDFT)
                   MONMSG     MSGID(CPF0000)
                   CALL       PGM(ORDER#)
                   MONMSG     MSGID(CPF0000)
                   CPYF       FROMFILE(QTEMP/ORDERH) +
                              TOFILE(TVRELWAECO/ORDERH) MBROPT(*ADD)
                   MONMSG     MSGID(CPF0000)
                   CPYF       FROMFILE(QTEMP/ORDERL) +
                              TOFILE(TVRELWAECO/ORDERL) MBROPT(*ADD)
                   MONMSG     MSGID(CPF0000)
/*          ELTESAN                                                          */
                   CHGVAR     VAR(&SC) VALUE(0032691)
                   CALL       PGM(ORDERR) PARM(&SC)
                   CHGVAR     VAR(&SC) VALUE(0023038)
                   CALL       PGM(ORDERR) PARM(&SC)
     /***          CHGVAR     VAR(&SC) VALUE(0078688)   ***/
     /***          CALL       PGM(ORDERR) PARM(&SC)     ***/
     /***          CHGVAR     VAR(&SC) VALUE(0078677)   ***/
     /***          CALL       PGM(ORDERR) PARM(&SC)     ***/
                ENDDO

/*                                                                            */
 ENDPGM:
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
                MONMSG     MSGID(CPF0000)
             ENDDO
             DLTF       FILE(QTEMP/ORDERH)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/ORDERL)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(GANG/ORDER#)
             MONMSG     MSGID(CPF0000)
             DSPJOBLOG  OUTPUT(*PRINT)
             SIGNOFF
             MONMSG     MSGID(CPF0000)
             ENDPGM
