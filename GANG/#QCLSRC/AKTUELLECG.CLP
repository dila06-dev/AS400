/*    * PROGRAMMNAME.:ÜBERNAHME ARTIKELDATEN                                 */
/*    * FUNKTION.....:INITIALISIEREN DER BEREICHE                            */
/*    * 06.07.98                                                              */
/*    *                                                                       */
/*    * Manfred Gang                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FWLFIRM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
/*----------------------------------------------------------------------------*/
   /*        CHGDTAARA  DTAARA(STOIN00F#) VALUE(0)        */
   /*        MONMSG     MSGID(CPF0000)                    */
   /*        CHGDTAARA  DTAARA(STOIN00F#2) VALUE(0)       */
   /*        MONMSG     MSGID(CPF0000)                    */
             CHGVAR     VAR(&LIBL) VALUE('QTEMP')
             RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO

             CHKOBJ     OBJ(&LIBL) OBJTYPE(*LIB)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                GOTO       CMDLBL(ENDE)
             ENDDO

             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
             CHKOBJ     OBJ(TESDATFWLG/ARTMS00F) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                GOTO       CMDLBL(ENDE)
             ENDDO
             ENDDO

             CHKOBJ     OBJ(TESDATDORG/ARTMS00F) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                GOTO       CMDLBL(ENDE)
             ENDDO

             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
             CHKOBJ     OBJ(TESDATFWLG/ARTSK00F) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                GOTO       CMDLBL(ENDE)
             ENDDO
             ENDDO

             CHKOBJ     OBJ(TESDATDORG/ARTSK00F) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                GOTO       CMDLBL(ENDE)
             ENDDO

             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
             CHKOBJ     OBJ(TESDATFWLG/ARTNM00F) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                GOTO       CMDLBL(ENDE)
             ENDDO
             ENDDO

             CHKOBJ     OBJ(TESDATDORG/ARTNM00F) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                GOTO       CMDLBL(ENDE)
             ENDDO

             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
             CHKOBJ     OBJ(TESDATFWLG/ARTCM00F) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                GOTO       CMDLBL(ENDE)
             ENDDO
             ENDDO

             CHKOBJ     OBJ(TESDATDORG/ARTCM00F) OBJTYPE(*FILE)
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
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTSK01L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTSK02L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTSK03L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTSK04L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTSK05L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTSK06L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTSK07L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTSK08L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTSK09L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTSK10L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTSK11L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTSK12L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTSK51L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTSK52L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)

/*          ---------------------------                                      */
             DLTF       FILE(&LIBL/ARTMS00F)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&LIBL/ARTMS*)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ARTMS00F) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS01L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS02L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS03L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS04L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS05L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS06L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS07L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS08L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS09L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS10L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS12L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS13L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS14L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS15L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS21L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS30L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS36L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS37L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS38L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS39L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS41L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS42L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS43L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS44L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS45L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS46L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS47L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTMS51L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)

/*          ---------------------------                                      */
             DLTF       FILE(&LIBL/ARTNM00F)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&LIBL/ARTNM*)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ARTNM00F) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTNM01L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTNM02L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTNM03L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTNM51L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)

/*          ---------------------------                                      */
             DLTF       FILE(&LIBL/ARTCM00F)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&LIBL/ARTCM*)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ARTCM00F) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTCM01L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTCM02L) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&LIBL) DATA(*NO)
             MONMSG     MSGID(CPF0000)

/*          STOIN00F LÖSCHEN IN AKTUELLER UMGEBUNG                           */
     /*      CLRPFM     FILE(STOIN00F)          */
     /*      MONMSG     MSGID(CPF0000)          */
/*          STOBL00F LÖSCHEN IN AKTUELLER UMGEBUNG                           */
     /*      CLRPFM     FILE(STOBL00F)          */
     /*      MONMSG     MSGID(CPF0000)          */
/*          STOCS00F LÖSCHEN IN AKTUELLER UMGEBUNG                           */
     /*      CLRPFM     FILE(STOCS00F)          */
     /*      MONMSG     MSGID(CPF0000)          */

/*          VORLAUF                                                          */
             CALL       PGM(TIMU001C)
             MONMSG     MSGID(CPF0000)

/*          KTR110 KORREKTUR                                                 */
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
                CALL       KTR110C
             ENDDO

/*          ÜBERNAHME DER VERPACKUNGEN MIT BESTÄNDEN                         */
             CALL       PGM(TIMU001R) PARM('1' 'V')
             MONMSG     MSGID(CPF0000)

/*          ÜBERNAHME DER SPINNEREIARTIKEL MIT BESTÄNDEN                     */
             CALL       PGM(TIMU001R) PARM('1' 'S')
             MONMSG     MSGID(CPF0000)

/*          ÜBERNAHME DER ROHSTOFFE        MIT BESTÄNDEN                     */
             CALL       PGM(TIMU001R) PARM('1' 'R')
             MONMSG     MSGID(CPF0000)

/*          ÜBERNAHME DER HANDELSWARE      MIT BESTÄNDEN                     */
             CALL       PGM(TIMU001R) PARM('1' 'H')
             MONMSG     MSGID(CPF0000)

/*          ÜBERNAHME DER HALBFERTIGWARE   MIT BESTÄNDEN                     */
             CALL       PGM(TIMU001R) PARM('1' 'B')
             MONMSG     MSGID(CPF0000)

/*          ÜBERNAHME DER ERSATZTEILE      MIT BESTÄNDEN                     */
             CALL       PGM(TIMU001R) PARM('1' 'E')
             MONMSG     MSGID(CPF0000)

/*          ÜBERNAHME DER DIREKTARTIKEL    OHNE BESTÄNDEN                    */
             CALL       PGM(TIMU001R) PARM('0' 'D')
             MONMSG     MSGID(CPF0000)

/*          ÜBERNAHME DER FERTIGWAREN      OHNE BESTÄNDEN                    */
             CALL       PGM(TIMU001R) PARM('1' 'F')
             MONMSG     MSGID(CPF0000)

/*          ÜBERNAHME DER FERTIGWAREN      NUR  BESTÄNDE LINGEN              */
     /*/     CALL       PGM(TIMU003C)     */
     /*      MONMSG     MSGID(CPF0000)    */

/*          ÜBERNAHME DER FERTIGWAREN      NUR  BESTÄNDE DORMAGEN            */
/*                                              UND QUALITÄTEN               */
     /*      CALL       PGM(TIMU006C)     */
     /*      MONMSG     MSGID(CPF0000)    */
/*          ---------------------------                                      */
/*          IN PRODUKTIVER UMGEBUNG JEDOCH NICHT MEHR BEI ÜBERNAHME          */
/*          DIESE SÄTZE KÖNNEN IN PRODUKTION GELÖSCHT WERDEN                 */
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
                CALL       PGM(DUMMY512) PARM(&MD 'UEB0066' ' ' ' ' +
                             'UEB0066' 'TESDATDORG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
                CALL       PGM(DUMMY512) PARM(&MD 'UEB0088' ' ' ' ' +
                             'UEB0088' 'TESDATFWLG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
             ENDDO
/*          ---------------------------                                      */
/*          FEHLEN IN PRODUKTIVER UMGEBUNG                                   */
/*          DIESE SÄTZE MÜSSEN ANGELEGT WERDEN (KOPIEREN)                    */
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
                CALL       PGM(DUMMY512) PARM(&MD 'UEB0067' ' ' ' ' +
                             'UEB0067' 'TESDATDORG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
                CALL       PGM(DUMMY512) PARM(&MD 'UEB0089' ' ' ' ' +
                             'UEB0089' 'TESDATFWLG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
             ENDDO
/*          ---------------------------                                      */
/*          ÄNDERN DER PREISE (AKTUALISIERUNG DER ZPUAR1 IN ARTMS00F)        */
             OVRDBF     FILE(QTEMP00F) TOFILE(QTEMP/ARTMS00F) +
                          OVRSCOPE(*CALLLVL)
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
                OVRDBF     FILE(LIBEL01L) TOFILE(TESDATDORG/ARTMS01L) +
                             OVRSCOPE(*CALLLVL)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
                OVRDBF     FILE(LIBEL01L) TOFILE(TESDATFWLG/ARTMS01L) +
                             OVRSCOPE(*CALLLVL)
             ENDDO
/*          AKTUALISIERUNG DER DATEIEN (ARTIKELSTÄMME)                       */
             CALL       PGM(AKTUELLER)
             MONMSG     MSGID(CPF0000)
/*          ---------------------------                                      */
             DLTOVR     FILE(*ALL) LVL(*)
             MONMSG     MSGID(CPF0000)
/*          ---------------------------                                      */
/*          QTEMP SÄUBERN                                                    */
             DLTF       FILE(&LIBL/ARTSK00F)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&LIBL/ARTSK*)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&LIBL/ARTMS00F)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&LIBL/ARTMS*)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&LIBL/ARTNM00F)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&LIBL/ARTNM*)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&LIBL/ARTCM00F)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&LIBL/ARTCM*)
             MONMSG     MSGID(CPF0000)
/*          ACHTUNG   MUSS MANUELL AUFGERUFEN WERDEN (YS2001C)               */
      /*     CALL       PGM(YS3003)     */
      /*     GOTO ENDE                  */
/*          ---------------------------                                      */
/*          STOIN00F VERBUCHEN                                               */
/*           CALL       PGM(YS2001C)       */

 ENDE:
             DLTOVR     FILE(*ALL) LVL(*)
             MONMSG     MSGID(CPF0000)
             RCLRSC
/*           SIGNOFF                       */
             ENDPGM
