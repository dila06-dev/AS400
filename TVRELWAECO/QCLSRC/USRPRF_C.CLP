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
             DCL        VAR(&AKTLIB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&$GANG)     TYPE(*CHAR) LEN(32)
             DCLF       FILE(TVRELWAECO/USRPRF)


 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))
             IF         COND(&UPINMN *EQ 'HPT0001   ') THEN(DO)
 /*          IF         COND(&UPUPRF *EQ 'BARENKAMP ') THEN(DO)   */
             CHGUSRPRF  USRPRF(&UPUPRF) CURLIB(*CRTDFT) +
                          INLPGM(MODWAO/STRACM) INLMNU(*SIGNOFF) +
                          SPCENV(*NONE)
             MONMSG     MSGID(CPF0000)
 /*          ENDDO                                                */
             ENDDO

             IF         COND(&UPINMN *NE 'HPT0001   ')  THEN(DO)
             IF         COND(&UPINMN *NE 'SFB       ')  THEN(DO)
 /*          IF         COND(&UPUPRF *EQ 'BARENKAMP ')  THEN(DO) */
                CHGUSRPRF  USRPRF(&UPUPRF) CURLIB(*CRTDFT) +
                            INLMNU(*SIGNOFF) SPCENV(*NONE)
                MONMSG     MSGID(CPF0000)
 /*          ENDDO                                               */
             ENDDO
             ENDDO

             GOTO LOOP

 ENDPGM:
             DSPJOBLOG  OUTPUT(*PRINT)

             ENDPGM
