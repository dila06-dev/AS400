/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:ABRECHNUNG FORDRECHNUNGEN                              */
/*    *               PARM = '1' AUFBAU DER ÜBERTRAGUNGSSÄTZE                */
/*    *               - NUR WENN ALTE ÜBERTRAGUNGSDATEI LEER IST             */
/*    *               - KONTROLLE UND ANZEIGE, WENN "C" - SÄTZE              */
/*    *                 VORHANDEN SIND                                       */
/*    *                                                                       */
/*    *               JETZT SÄZTE ÜBERTRAGEN ZWECKS FTP-SERVER               */
/*    *                                                                       */
/*    *               PARM = '2' SICHERUNG DER ÜBERTRAGUNGSDATEI             */
/*    *                          UND LÖSCHEN DER ÜBERTRAGUNGSDATEI           */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&PARM)

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))


             IF         COND(&PARM *NE '2' ) THEN(DO)
/*             GENERELLER AUFBAU                                             */
                DLTF       FILE(GANG/SBGNMON)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(GANG/#AR0500)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(GANG/#AR0501)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(GANG/#AR0502)
                MONMSG     MSGID(CPF0000)
                CRTPF      FILE(GANG/SBGNMON) RCDLEN(256)
                MONMSG     MSGID(CPF0000)
/*             ZWISCHENDATEI RECHNUNGEN                                      */
                CPYF       FROMFILE(SBGN.MON) TOFILE(GANG/SBGNMON) +
                             MBROPT(*ADD) FMTOPT(*NOCHK)
                MONMSG     MSGID(CPF0000)
/*             OP-DATEI FORDKONTO                                            */
                CALL       PGM(DUMMY512) PARM(&MD '#AR0500' ' ' ' ' +
                             '#AR0500' 'GANG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
/*             OP-DATEI VERGLEICH MIT RECHNUNGSLAUF UND ÜBERGABEDATEN        */
/*             (WAEFSND10)                                                   */
                CALL       PGM(DUMMY512) PARM(&MD '#AR0501' ' ' ' ' +
                             '#AR0501' 'GANG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
/*             FESTSTELLEN, OB SÄTZE IN ÜBERTRAGUNGSDATEI SIND               */
                RTVMBRD    FILE(WAEFSEND) NBRCURRCD(&NBRCURRCD)
                MONMSG     MSGID(CPF0000)
/*             DEALER AKTUALISIEREN                                          */
                CALL POHL/FORDDEALER
                MONMSG     MSGID(CPF0000)
             ENDDO
/*                                                                            */
             IF         COND(&PARM = '1' *AND &NBRCURRCD = 0) THEN(DO)
/*             ERSTELLUNG DER RELEVANTEN RECHNUNGSPOSITIONEN                 */
/*             STELLE 14 *NE 11 BEREITS BERÜCKSICHTIGT                       */
                CALL       PGM(DUMMY512) PARM(&MD '#AR0502' ' ' ' ' +
                             '#AR0502' 'GANG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
/*             KOPIEREN D. RELEVANTEN RECHNUNGSPOSITIONEN N. COPY.FORD       */
                CPYF       FROMFILE(GANG/#AR0502) TOFILE(COPY.FORD) +
                            MBROPT(*REPLACE) FMTOPT(*NOCHK)
                MONMSG     MSGID(CPF0000)
/*             ERSTELLEN DER ÜBERTRAGUNGSDATEI WAEFSEND                      */
/*             HIER WIRD AUCH DIE UNIQUE # MITGEGEBEN                        */
/*             SUBSTR( WAE010, 20, 6)                                        */
                RTVMBRD    FILE(GANG/#AR0502) NBRCURRCD(&NBRCURRCD)
                IF         COND(&NBRCURRCD > 0) THEN(DO)
                   STRS36PRC PRC(FORD20) CURLIB(WAE_FORD)
                ENDDO
             ENDDO

             IF         COND(&PARM = '1' ) THEN(DO)
/*             ZWISCHENDATEI, SIND "C" RECHNUNGSSÄTZE VORHANDEN?             */
                CALL       PGM(DUMMY512) PARM(&MD '#AR0503' ' ' ' ' +
                             '#AR0503' 'GANG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                RTVMBRD    FILE(#AR0503) NBRCURRCD(&NBRCURRCD2)
                MONMSG     MSGID(CPF0000)
/*             PRÜFUNG, OB SÄTZE MIT UNIQUE# VERSEHEN WERDEN MÜSSEN          */
/*             WENN "C" FÜR GUTSCHRIFT VORLIEGEN                             */
                IF         COND(&NBRCURRCD2 > 0) THEN(DO)
                   DSPPFM     FILE(WAEFSEND)
                   MONMSG     MSGID(CPF0000)
                   UPDDTA     FILE(WAEFSEND)
                   MONMSG     MSGID(CPF0000)
                ENDDO
             ENDDO

             IF         COND(&PARM = '2') THEN(DO)
                RTVMBRD    FILE(WAEFSEND) NBRCURRCD(&NBRCURRCD)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&PARM = '2' *AND &NBRCURRCD > 0) THEN(DO)
                CPYF       FROMFILE(WAEFSEND) TOFILE(WAEFSD09) +
                           MBROPT(*ADD)
                MONMSG     MSGID(CPF0000) EXEC(DO)
                   GOTO ENDPGM
                ENDDO
                CLRPFM     WAEFSEND
                MONMSG     MSGID(CPF0000)
             ENDDO
 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO

             ENDPGM
