/*    * PROGRAMMNAME.:TIMU012C                                               */
/*    * FUNKTION.....:CALL TIMU012C                                          */
/*                    1) PRODUKTIONSAUFTRÄGE POMS FAST                       */
/*                    2) DISDT00F/DISHD00F VERBUCHEN                         */
/*    * 2004                                                                  */
/*    *                                                                       */
/*    * FASERWERKE-LINGEN GMBH                                                */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/*    * 04.07.2001                                            GANG            */
/******************************************************************************/
             PGM

/*       SONSTIGES                                          */
             DCL        VAR(&FWLFIRM) TYPE(*CHAR) LEN(01)
/*----------------------------------------------------------------------------*/
/*-ENVIRONMENT ANPASSEN BZW ERSTELLEN-----------------------------------------*/
             RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
                   GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
             ENDDO
/*          ----------------------FAST PRODUKTIONSAUFTRÄGE VERBUCHEN--       */
             CALL       PGM(TIMU012R)
/*----------------------------------------------------------------------------*/
             GOTO       CMDLBL(ENDE)
/*          ----------------------------------------------------------       */
ENDE:
             RCLRSC
             ENDPGM
