PGM
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')

         /*  CALL       PGM(         ) PARM('0' '0')   */
             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
             ADDLIBLE   LIB(TVRELWAECO) POSITION(*AFTER TFXF)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))
             CALL       PGM(GANG/SYS0005C)
         /*  MONMSG     MSGID(CPF0000)                 */
             RTVJOBA    USER(&USER)
             IF         COND(&USER = 'GANG' *OR +
                          &USER = 'BARENKAMP') +
                          THEN(DO)
                GOTO ENDE
             ENDDO
/*SIGNOFF     */
/*MONMSG     MSGID(CPF0000)  */
 ENDE:
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO
             ENDPGM
