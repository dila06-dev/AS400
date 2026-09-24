/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:ABRECHNUNG FORDRECHNUNGEN                              */
/*    *               PARM = '1' AUFBAU DER ÜBERTRAGUNGSSÄTZE                */
/*    *               - NUR WENN ALTE ÜBERTRAGUNGSDATEI LEER IST             */
/*    *               - KONTROLLE UND ANZEIGE, WENN "C" - SÄTZE              */
/*    *                 VORHANDEN SIND                                       */
/*    *                                                                       */
/*    *               JETZT SÄZTE ÜBERTRAGEN ZWECKS FTP-SERVER               */
/*    *                                                                       */
/*    *               PARM = '3' ERNEUT RECHNUNGEN HOLEN AUFGRUND            */
/*    *                          DES RECHNUNGSDATUM UND VERSENDEN            */
/*    *                          PARAMETER RECHNUNGSDATEN                    */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&PARM &RDAT)

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&RDAT)    TYPE(*CHAR) LEN(08)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&USER)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)

             RTVJOBA    USER(&USER)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             IF         COND(&PARM *NE '3') THEN(DO)
/*             GENERELLER AUFBAU                                             */
                DLTF       FILE(GANG/SBGNMON)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(GANG/#AR0590)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(GANG/#AR0591)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(GANG/#AR0592)
                MONMSG     MSGID(CPF0000)
                CRTPF      FILE(GANG/SBGNMON) RCDLEN(256)
                MONMSG     MSGID(CPF0000)
/*             ZWISCHENDATEI RECHNUNGEN                                      */
                CPYF       FROMFILE(SBGN.MON) TOFILE(GANG/SBGNMON) +
                             MBROPT(*ADD) FMTOPT(*NOCHK)
                MONMSG     MSGID(CPF0000)
/*             OP-DATEI TECHNOKONTO                                          */
                CALL       PGM(DUMMY512) PARM(&MD '#AR0590' ' ' ' ' +
                             '#AR0590' 'GANG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
/*             OP-DATEI VERGLEICH MIT RECHNUNGSLAUF UND ÜBERGABEDATEN        */
/*             (WAETECHS)                                                    */
                CALL       PGM(DUMMY512) PARM(&MD '#AR0591' ' ' ' ' +
                             '#AR0591' 'GANG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
/*             FESTSTELLEN, OB SÄTZE IN ÜBERTRAGUNGSDATEI SIND               */
                RTVMBRD    FILE(WAETECHP) NBRCURRCD(&NBRCURRCD)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&PARM = '1' *AND &NBRCURRCD > 0) THEN(DO)
                CLRPFM     FILE(WAETECHP)
                MONMSG     MSGID(CPF0000) EXEC(DO)
                   GOTO   ENDPGM
                ENDDO
                CHGVAR     VAR(&NBRCURRCD) VALUE(0)
             ENDDO

             IF         COND(&PARM = '1' *AND &NBRCURRCD = 0) THEN(DO)
/*             ERSTELLUNG DER RELEVANTEN RECHNUNGSPOSITIONEN                 */
/*             STELLE 14 *NE 11 BEREITS BERÜCKSICHTIGT                       */
                CALL       PGM(DUMMY512) PARM(&MD '#AR0592' ' ' ' ' +
                             '#AR0592' 'GANG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
/*             KORREKTUR KENNUNG '5' + TECHNOKUNDENNUMMER 11016              */
                CALL       PGM(DUMMY512) PARM(&MD '#AR0596' ' ' ' ' +
                             ' ' ' ' '*REPLACE')
                MONMSG     MSGID(CPF0000)
/*             KOPIEREN D. RELEVANTEN RECHNUNGSPOSITIONEN  COPY.TECH         */
                CPYF       FROMFILE(GANG/#AR0592) TOFILE(COPY.TECH) +
                            MBROPT(*REPLACE) FMTOPT(*NOCHK)
                MONMSG     MSGID(CPF0000)
/*             ERSTELLEN DER ÜBERTRAGUNGSDATEI WAETECHP                      */
/*             HIER WIRD AUCH DIE UNIQUE # MITGEGEBEN                        */
/*             SUBSTR( WAE010, 20, 6) UND AN SERVER SENDEN                   */
                RTVMBRD    FILE(#AR0592) NBRCURRCD(&NBRCURRCD)
                IF         COND(&NBRCURRCD > 0) THEN(DO)
                   CLRPFM     WAETECHP
                   MONMSG     MSGID(CPF0000)
                   STRS36PRC PRC(TECH20D) CURLIB(WAE_TECH)
/*                ÄNDERUNG: ÜBERGABE DER MITGLIEDSNUMMER ANSTELLE            */
/*                UNSERER KUNDEN#                                            */
 SPERRE:  /*       ALCOBJ     OBJ((SBGKDS00 *FILE *EXCLRD))   */
          /*       MONMSG     MSGID(CPF0000) EXEC(DO)         */
          /*  SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('JOB + */
          /*              TECHNOC, Datei SBGKDS00 kann nicht +      */
          /*              zugeordnet werden. JOB IN VERZÖGERUNG +   */
          /*              60 SEC.') TOUSR(&USER) MSGTYPE(*NOTIFY)   */
          /*          DLYJOB     DLY(60)                            */
          /*          GOTO       CMDLBL(SPERRE)                     */
          /*       ENDDO                                            */
             CPYF       FROMFILE(WAETECHP) TOFILE(*LIBL/#WAETECHP) +
                          MBROPT(*REPLACE)
                   MONMSG     MSGID(CPF0000)
                   CALL      PGM(DUMMY512) PARM(&MD '#AR0597' ' ' ' ' +
                                ' ' ' ' '*REPLACE')
          /*          DLYJOB     DLY(60)                            */
          /*       DLCOBJ     OBJ((SBGKDS00 *FILE *EXCLRD))         */
/*                LÖSCHEN ALTER #,                                           */
                   CALL      PGM(DUMMY512) PARM(&MD '#AR0588' ' ' ' ' +
                               ' ' ' ' '*REPLACE')
                   MONMSG     MSGID(CPF0000)
/*                ÄNDERUNG: ANPASSUNG FORMAT MITGLIEDSNUMMER AN TECHNO       */
                   CALL      PGM(DUMMY512) PARM(&MD '#AR0598' ' ' ' ' +
                               ' ' ' ' '*REPLACE')
                   MONMSG     MSGID(CPF0000)
                   STRS36PRC PRC(TECH20U) CURLIB(WAE_TECH)
                ENDDO
             ENDDO

             IF         COND(&PARM = '3') THEN(DO)
/*             ERSTELLUNG DER ÜBERTRAGUNGSDATEI AUS DER SICHERUNG            */
/*             WAETECHS ÜBER RECHNUNGSDATUM FAK018 ='TTMMJHJJ'               */
                CLRPFM     WAETECHP
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(%SST(&MD 01 08)) VALUE(&RDAT)
                CALL       PGM(DUMMY512) PARM(&MD '#AR0595' ' ' ' ' +
                             'WAETECHP' 'QS36F' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                RTVMBRD    FILE(WAETECHP) NBRCURRCD(&NBRCURRCD)
/*             ÜBERTRAGUNG WENN SÄTZE VORHANDEN                              */
                IF         COND(&NBRCURRCD > 0) THEN(DO)
                   STRS36PRC PRC(TECH20U) CURLIB(WAE_TECH)
                   CALL       PGM(TECHNOC2)
                ENDDO
             ENDDO

 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO

             ENDPGM
