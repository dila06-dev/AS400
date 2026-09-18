/*    * PROGRAMMNAME.:#PRTDEV                                                */
/*    * FUNKTION.....:ANZEIGEN DRUCKERDEVICES                                */
/*    *               ..                                                     */
/*    * 30.10.00       MANFRED GANG                                           */
/*    *                                                                       */
/*    * FASER-WERKE-LINGEN GMBH                                               */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

/*----------------------------------------------------------------------------*/
/* &OUTQ   OUTQ                                                               */
             DCL        VAR(&OUTQ)   TYPE(*CHAR) LEN(10)
/* &LIB    LIB                                                                */
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERROR3)  TYPE(*CHAR) LEN(01) VALUE('0')
/*----------------------------------------------------------------------------*/
             RTVJOBA    USER(&USER)
             DLTF       FILE(QTEMP/OFFENEP)
             MONMSG     MSGID(CPF0000)
             CRTPF      FILE(QTEMP/OFFENEP) RCDLEN(132)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO ENDE
             ENDDO
             CPYSPLF    FILE(SPRT) TOFILE(QTEMP/OFFENEP) +
                          JOB(&USER/F5205J) SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)
             DLTSPLF    FILE(SPRT) JOB(&USER/F5205J) SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)

             ADDLIBLE   LIB(SASF)      POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR3) +
                          VALUE('1'))
             CALL       PGM(OFFENEPR)

             IF         COND(&ERROR3 = '0') THEN(DO)
                RMVLIBLE   LIB(SASF)
             ENDDO
/*----------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------*/

ENDE:
             ENDPGM
