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
             DCL        VAR(&LIB#) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LDAINH) TYPE(*CHAR) LEN(1024)
             DCLF       FILE(TVRELWAECO/#LIBLISTL1)

             CALL       PGM(GANG/##SVRLDA) PARM('S')
             MONMSG     MSGID(CPF0000)
             RTVDTAARA  DTAARA(*LDA (1 1024)) RTNVAR(&LDAINH)
             MONMSG     MSGID(CPF0000)
             IF         COND(&LDAINH = ' ') THEN(DO)
                CHGVAR     VAR(&ERROR1) VALUE('1')
                RTVDTAARA  DTAARA(TVRELWAECO/ABESTAND5W (1 1024)) +
                             RTNVAR(&LDAINH)
                MONMSG     MSGID(CPF0000)
                CHGDTAARA  DTAARA(*LDA (1 1024)) VALUE(&LDAINH)
                MONMSG     MSGID(CPF0000)
             ENDDO

 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(EPGM))

/*             LIBLIST                                                       */
                RMVLIBLE   LIB(&LIB)
                MONMSG     MSGID(CPF0000)
                ADDLIBLE   LIB(&LIB) POSITION(*AFTER &LIB#)
                MONMSG     MSGID(CPF0000) EXEC(DO)
                   ADDLIBLE   LIB(&LIB)
                   MONMSG     MSGID(CPF0000)
                ENDDO
                CHGVAR     VAR(&LIB#) VALUE(&LIB)
             GOTO LOOP


         /*  CALL       PGM(MODWAO/STRTRDSJ)  */
         /*  CALL       PGM(MODWAO/STRACM)    */
         /*  MONMSG     MSGID(CPF0000)        */
 EPGM:
             CHGDTAARA  DTAARA(*LDA (1 2)) VALUE('01')
             CALL       PGM(TRDV00ST) PARM('#LIBLIST')
             RTVDTAARA  DTAARA(*LDA (28 1)) RTNVAR(&DAFEHL)
             IF         COND(&DAFEHL = '1') THEN(GOTO CMDLBL(ENDPGM))

 ENDPGM:

             IF         COND(&ERROR1 = '0') THEN(DO)
                CALL       PGM(GANG/##SVRLDA) PARM('R')
                MONMSG     MSGID(CPF0000)
             ENDDO


             ENDPGM
