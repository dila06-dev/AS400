/*    * PROGRAMMNAME.:TIMU012C                                               */
/*    * FUNKTION.....:CALL TIMU012C                                          */
/*    *               ÜBERTRAGUNG DER KUNDEN                                 */
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
/*          LÖSCHEN DER ANCLI00F -------------------------------------       */
             CLRPFM     FILE(TESDATDORT/ANCLI00F)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
             CLRPFM     FILE(TESDATFWLT/ANCLI00F)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
/*          LÖSCHEN DER ANCLI10F -------------------------------------       */
             CLRPFM     FILE(TESDATDORT/ANCLI10F)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
             CLRPFM     FILE(TESDATFWLT/ANCLI10F)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
/*          LÖSCHEN DER ANCLI98F -------------------------------------       */
             CLRPFM     FILE(TESDATDORT/ANCLI98F)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
             CLRPFM     FILE(TESDATFWLT/ANCLI98F)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
/*          KOPIEREN DER ANCLI00F ------------------------------------       */
             CPYF       FROMFILE(TESDATFWL/ANCLI00F) +
                          TOFILE(TESDATFWLT/ANCLI00F) MBROPT(*ADD)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             ENDDO
             CPYF       FROMFILE(TESDATFWL/ANCLI00F) +
                          TOFILE(TESDATDORT/ANCLI00F) MBROPT(*ADD)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
/*          KOPIEREN DER ANCLI10F ------------------------------------       */
             CPYF       FROMFILE(TESDATFWL/ANCLI10F) +
                          TOFILE(TESDATFWLT/ANCLI10F) MBROPT(*ADD)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             ENDDO
             CPYF       FROMFILE(TESDATFWL/ANCLI10F) +
                          TOFILE(TESDATDORT/ANCLI10F) MBROPT(*ADD)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
/*          KOPIEREN DER ANCLI98F ------------------------------------       */
             CPYF       FROMFILE(TESDATFWL/ANCLI98F) +
                          TOFILE(TESDATFWLT/ANCLI98F) MBROPT(*ADD)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             ENDDO
             CPYF       FROMFILE(TESDATFWL/ANCLI98F) +
                          TOFILE(TESDATDORT/ANCLI98F) MBROPT(*ADD)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
/*          TECHNISCHER VERWEIS INITIALISIEREN------------------------       */
             CALL       PGM(DUMMY512) PARM(' ' 'ANC0002' ' ' ' ' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(' ' 'ANC0003' ' ' ' ' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)

             GOTO       CMDLBL(ENDE)
/*          ----------------------------------------------------------       */
ENDE:
             RCLRSC
             ENDPGM
