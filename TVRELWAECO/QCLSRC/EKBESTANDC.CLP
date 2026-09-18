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
             DCLF       FILE(TVRELWAECO/EKBESTANDI)

             CALL       PGM(GANG/##SVRLDA) PARM('S')
             MONMSG     MSGID(CPF0000)

         /*  CALL       PGM(MODWAO/STRTRDSJ)  */
         /*  CALL       PGM(MODWAO/STRACM)    */
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(*LDA (1 2)) VALUE('01')
             CALL       PGM(TRDV00ST) PARM('LGBESTANDC')
             RTVDTAARA  DTAARA(*LDA (28 1)) RTNVAR(&DAFEHL)
             IF         COND(&DAFEHL = '1') THEN(GOTO CMDLBL(ENDPGM))

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*AFTER TFXF)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             CALL    PGM(DUMMY512) PARM(&MD '#EK2900' ' ' ' ' +
                         'EKBESTANDI' 'TVRELWAECO' '*REPLACE')
             MONMSG     MSGID(CPF0000)
             CALL    PGM(DUMMY512) PARM(&MD '#EK2901' ' ' ' ' +
                         'EKBESTANDI' 'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
             CALL    PGM(DUMMY512) PARM(&MD '#EK2902' ' ' ' ' +
                         'EKBESTANDI' 'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(TVRELWAECO/EKBESTAND)


 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))

/*             BESTAND ERMITTELN                                             */
                CALL       PGM(EKBESTANDR) PARM(&TETENR &LAGER)
                MONMSG     MSGID(CPF0000)

             GOTO LOOP

 ENDPGM:
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
                MONMSG     MSGID(CPF0000)
             ENDDO


     /*      DSPJOBLOG  OUTPUT(*PRINT)                */

             CALL       PGM(GANG/##SVRLDA) PARM('R')
             MONMSG     MSGID(CPF0000)

             ENDPGM
