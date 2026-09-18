/*    * PROGRAMMNAME.:TIMU001C                                               */
/*    * FUNKTION.....:CALL TIMU001C                                          */
/*    *               ...                                                    */
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
/*----------------------------------------------------------------------------*/
/* EINKAUFSARTIKELDATEN LOGISCHE SICHT LÖSCHEN                  */
             DLTF       FILE(QTEMP/EINKAUFDOL)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/LAGER)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/EINKAUFLGL)
             MONMSG     MSGID(CPF0000)
/* INDEX LEGEN ARTIKELNUMMER FÜR EINKAUFDOR                 */
             CALL       PGM(DUMMY512) PARM(' ' 'UEB0001' ' ' ' ' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(' ' 'UEB0003' ' ' ' +
                          ' 'LAGER' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/* INDEX LEGEN ARTIKELNUMMER FÜR EINKAUF LAGER               */
             CALL       PGM(DUMMY512) PARM(' ' 'UEB0002' ' ' ' ' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
/* INDEX LEGEN DORMAGEN ERSATZARTIKEL ZUSATZ DATUM          */
             CALL       PGM(DUMMY512) PARM(' ' 'EKD0002' ' ' ' ' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/EY0000*)
             MONMSG     MSGID(CPF0000)
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
/* INDEX LEGEN DORMAGEN KTR110 HISTORIE                     */
                CALL       PGM(DUMMY512) PARM(' ' 'EY00001' ' ' ' ' +
                             ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
/* INDEX LEGEN LINGEN   KTR110 HISTORIE                     */
                CALL       PGM(DUMMY512) PARM(' ' 'EY00002' ' ' ' ' +
                             ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)
             ENDDO
             GOTO       CMDLBL(ENDE)
/*          ----------------------------------------------------------       */
ENDE:
             RCLRSC
             ENDPGM
