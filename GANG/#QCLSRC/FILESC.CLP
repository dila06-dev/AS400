/*    * PROGRAMMNAME.:ÜBERNAHME ARTIKELDATEN                                 */
/*    * FUNKTION.....:INITIALISIEREN DER BEREICHE                            */
/*    * 06.07.98                                                              */
/*    *                                                                       */
/*    * Manfred Gang                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&LIBL)

             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10)
/*----------------------------------------------------------------------------*/
             CHKOBJ     OBJ(&LIBL) OBJTYPE(*LIB)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                GOTO       CMDLBL(ENDE)
             ENDDO

             IF         COND(%SST(&LIBL 01 03) *EQ 'TES') THEN(DO)
                GOTO       CMDLBL(ENDE)
             ENDDO

/*          ---------------------------                                      */
             DLTF       FILE(&LIBL/ARTSK00F)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&LIBL/ARTSK*)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ARTSK00F) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTSK01L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTSK02L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTSK03L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTSK04L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTSK05L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTSK06L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTSK07L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTSK08L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTSK09L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTSK10L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTSK11L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTSK12L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTSK51L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTSK52L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)

/*          ---------------------------                                      */
             DLTF       FILE(&LIBL/ARTMS00F)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&LIBL/ARTMS*)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ARTMS00F) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS01L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS02L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS03L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS04L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS05L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS06L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS07L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS08L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS09L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS10L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS12L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS13L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS14L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS15L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS21L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS30L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS36L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS37L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS38L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS39L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS41L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS42L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS43L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS44L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS45L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS46L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS47L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS51L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)

/*          ---------------------------                                      */
             DLTF       FILE(&LIBL/ARTNM00F)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&LIBL/ARTNM*)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ARTNM00F) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTNM01L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTNM02L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTNM03L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTNM51L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)

/*          ---------------------------                                      */
             DLTF       FILE(&LIBL/LOTBL00F)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&LIBL/LOTBL*)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(LOTBL00F) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(LOTBL01L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(LOTBL02L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(LOTBL03L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(LOTBL04L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(LOTBL52L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(STOBL20L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(STOBL21L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(STOBL22L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(STOBL23L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
 ENDE:
             RCLRSC

             ENDPGM
