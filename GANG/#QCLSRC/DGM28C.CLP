/*    * PROGRAMMNAME.:AVISUSR01C                                             */
/*    * FUNKTION.....:AVLÖSUNG SRS-SYSTEM                                    */
/*    *               BESTANDENTWICKLUNG                                     */
/*    * MAI 2002 GANG/CUCCHI                                                  */
/*    *                                                                       */
/*    * FASERWERKE-LINGEN GMBH                                                */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM
             DCL        VAR(&BASISJA) TYPE(*DEC) LEN(07) VALUE(9999999)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&X) TYPE(*CHAR) LEN(7)
             DCL        VAR(&KKT) TYPE(*CHAR) LEN(04) VALUE(' ')
             DCL        VAR(&VGL) TYPE(*CHAR) LEN(4)  VALUE(' ')
             DCL        VAR(&FIRMA) TYPE(*CHAR) LEN(1)
             RTVDTAARA  DTAARA(QTEMP/FWLFIRM (1 1)) RTNVAR(&FIRMA)
             RTVDTAARA  DTAARA(BASISJA)          RTNVAR(&BASISJA)
             CHGVAR     VAR(&X) VALUE(&BASISJA)
/******************************************************************************/
/*CALL AUF DGM26C FÜR ERSTELLEN FRACHTENDATEI ************************       */
/*    *                                                                      */
             CALL       PGM(UEBERNAHME/DGM26C)
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*CALL DGM0028 *******************************************************       */
/*    *                                                                      */
             RUNQRY     QRY(FWLFR/DGM0028) RCDSLT(*YES)
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*********************************************************************       */
             IF         COND(&FIRMA *EQ 'L') THEN(DO)
             ENDDO
             IF         COND(&FIRMA *EQ 'D') THEN(DO)
             ENDDO
/*********************************************************************       */
             CHGVAR     VAR(&VGL)             VALUE(%SST(&X 2 04))
             CHGVAR     VAR(%SST(&MD 1 01))   VALUE('A')
             CHGVAR     VAR(%SST(&MD 1 07))   VALUE(&X)
/******************************************************************************/
 ENDPGM:     ENDPGM
