/*    * PROGRAMMNAME.:$GANG                                                  */
/*    * FUNKTION.....:...                                                    */
/*    * JULI    2010   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *-START SUBSTYSTEM                                                     */
/*    * SELECT CHAR(DIGITS(KDS020)) FROM SBGKDS00                             */
/*    * WHERE KDS200 = '46' OR                                                */
/*    * KDS200 = '51' OR KDS200 = '42' OR KDS200 = '47'                       */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/

             DCL        VAR(&CODE)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&SC) TYPE(*DEC) LEN(07 0) VALUE(0000000)
             DCL        VAR(&K)         TYPE(*CHAR) LEN(5)
             DCL        VAR(&#)         TYPE(*CHAR) LEN(1)
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&$GANG)     TYPE(*CHAR) LEN(32)
             DCLF       FILE(TVRELWAECO/ALTAUFTRAG)


 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))

                CALL       PGM(ORDERIN_AR) PARM(&SEL0001)
                MONMSG     MSGID(CPF0000)
/*          BGFS ÜBERNAHME                                                   */
        /*      CHGVAR     VAR(&SC) VALUE(0099999)          */
        /*      CALL       PGM(ORDERR2) PARM(&SC)           */

             GOTO LOOP

 ENDPGM:
                CHGVAR     VAR(&SC) VALUE(0099999)
                CALL       PGM(ORDERR2) PARM(&SC)
             CALL       PGM(DUMMY512) PARM(' ' '#DC2620' ' ' ' ' ' ' +
                          ' ' ' ')
                SIGNOFF
     /*      DSPJOBLOG  OUTPUT(*PRINT)                */

             ENDPGM
