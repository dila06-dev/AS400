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

             DCL        VAR(&SYSTEM) TYPE(*CHAR) LEN(01)
             RTVDTAARA  DTAARA(FWLFIRM (2 1)) RTNVAR(&SYSTEM)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&SYSTEM *EQ 'P') THEN(DO)
                   GOTO       CMDLBL(ENDE)
             ENDDO
/*----------------------------------------------------------------------------*/
             CHGDTAARA  DTAARA(STOIN00F#) VALUE(0)
             MONMSG     MSGID(CPF0000)
/*          LAGERBEWEGUNGEN SCHNITTSTELLE                                    */
             CLRPFM     FILE(STOIN00F)
             MONMSG     MSGID(CPF0000)
/*          ARTIKELDATEIEN                                                   */
             CLRPFM     FILE(ARTMS00F)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(ARTSK00F)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(ARTNM00F)
             MONMSG     MSGID(CPF0000)
/*          ÜBERGABEPROTOKOLLE RISK/POMS                                     */
             CLRPFM     FILE(BALLENPF)
             MONMSG     MSGID(CPF0000)
/*          ?                                                                */
             CLRPFM     FILE(STOTR00F)
             MONMSG     MSGID(CPF0000)
/*          EINZELBEWEGUNGEN ENTSPRECHEND DER BEWEGUNGSART                   */
             CLRPFM     FILE(STODT00F)
             MONMSG     MSGID(CPF0000)
/*          ELEMENTINFORMATIONEN                                             */
             CLRPFM     FILE(ELEMS00F)
             MONMSG     MSGID(CPF0000)
/*          VERFÜGBARE BALLEN UND ZUGEORDNETE BALLEN                         */
             CLRPFM     FILE(UNTBL00F)
             MONMSG     MSGID(CPF0000)
/*          LOTS GRUPPIERUNG ARTIKEL, LOTS                                   */
             CLRPFM     FILE(LOTBL00F)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(STOBL00F)
             MONMSG     MSGID(CPF0000)
/*          TECHNISCHE DATENFELDER AUF LOTEBENE                              */
/*           CLRPFM     FILE(TECDT00F)           */
/*           MONMSG     MSGID(CPF0000)           */
/*           CHGDTAARA  DTAARA(DTTDNR) VALUE(0)  */
/*           MONMSG     MSGID(CPF0000)           */
             CALL       PGM(DUMMY512) PARM(' ' 'UEB0004' ' ' ' ' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             DSPJOBLOG
             MONMSG     MSGID(CPF0000)
 ENDE:
             RCLRSC

             ENDPGM
