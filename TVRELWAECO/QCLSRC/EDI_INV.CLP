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

             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&CODE)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&SC) TYPE(*DEC) LEN(07 0) VALUE(0000000)
             DCL        VAR(&K)         TYPE(*CHAR) LEN(5)
             DCL        VAR(&#)         TYPE(*CHAR) LEN(1)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&DAFEHL) TYPE(*CHAR) LEN(1)

             CALL       PGM(GANG/##SVRLDA) PARM('S')
             MONMSG     MSGID(CPF0000)

         /*  CALL       PGM(MODWAO/STRTRDSJ)  */
         /*  CALL       PGM(MODWAO/STRACM)    */
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(*LDA (1 2)) VALUE('01')
             CALL       PGM(TRDV00ST) PARM('EDI_INV')
             RTVDTAARA  DTAARA(*LDA (28 1)) RTNVAR(&DAFEHL)
             IF         COND(&DAFEHL = '1') THEN(GOTO CMDLBL(ENDPGM))

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*AFTER TFXF)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             CALL       PGM(TRED70SJ) PARM('006016')
             MONMSG     MSGID(CPF0000)



 ENDPGM:
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
                MONMSG     MSGID(CPF0000)
             ENDDO

     /*      DSPJOBLOG  OUTPUT(*PRINT)                */

             CALL       PGM(GANG/##SVRLDA) PARM('R')
             MONMSG     MSGID(CPF0000)

             ENDPGM
