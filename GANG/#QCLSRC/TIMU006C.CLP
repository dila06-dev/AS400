/*    * PROGRAMMNAME.:TIMU006C                                               */
/*    * FUNKTION.....:CALL TIMU006C                                          */
/*    *               AKTUELLE DATEN VON DER MASCHINE FWLHOST                */
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
             CALL       PGM(#DEFLDA) PARM(' ')
       /*    DER JOB ERSTELLT DIE DATEI LAGER_TIMK */
             CALL       LAGERT01C
             CALL       PGM(TIMU006R)
             CALL       PGM(##SVRLDA) PARM('S')
/*           CALL       PGM(YS2001C)      */
       /*      CALL       PGM(YS2001)     */
             CALL       PGM(##SVRLDA) PARM('R')
/*          ------------------------AUF LOTEBENE TECHN.FELDER---------       */
             CALL       PGM(TIMU007R)
/*----------------------------------------------------------------------------*/
             GOTO       CMDLBL(ENDE)
/*          ----------------------------------------------------------       */
ENDE:
             RCLRSC
             ENDPGM
