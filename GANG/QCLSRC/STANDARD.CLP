/*    * PROGRAMMNAME.:#                                                      */
/*    * FUNKTION.....:#                                                      */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&PARM)

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)  TYPE(*CHAR) LEN(10)

             DCLF       FILE(*LIBL/P_LISTING)

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             IF         COND(&PARM = '0') THEN(DO)

                RUNQRY     QRY(GANG/KCJALL_0)
                RUNQRY     QRY(GANG/KCJALL_1)
                RUNQRY     QRY(GANG/KCJALL_2_1)
                RUNQRY     QRY(GANG/KCJALL_2_2)
                RUNQRY     QRY(GANG/KCJALL_3_3)
                RUNQRY     QRY(GANG/KCJALL_4)
                RUNQRY     QRY(GANG/KCJALL_6)
/*    * EINZELSÄTZE OHNE UMSATZSTATISTIK                                     */
                CALL       PGM(DUMMY512) PARM(&MD '#MG0020' ' ' ' ' +
                             '#MG0020' 'GANG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
/*    * UMSATZ LAUFENDES JAHR #MG0021                                        */
                CALL       PGM(DUMMY512) PARM(&MD '#MG0021' ' ' ' ' +
                             '#MG0021' 'GANG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
/*    * UMSATZ VORJAHR                                                       */
                CALL       PGM(DUMMY512) PARM(&MD '#MG0022' ' ' ' ' +
                             '#MG0022' 'GANG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
/*    * UMSATZ VORVORJAHR                                                    */
                CALL       PGM(DUMMY512) PARM(&MD '#MG0023' ' ' ' ' +
                             '#MG0023' 'GANG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
/*    * ERLEDIGTE AUFTRÄGE AUS SBGN.MON IN GANG/ORDER3S                      */
/*    * DATEI GANG/ORDER3S BEINHALTET NICHT ALLE FELDER (FEHLERCODE)         */
                RUNQRY     QRY(GANG/ORDER3S)
                MONMSG     MSGID(CPF0000)
             enddo

             IF         COND(&PARM = '1') THEN(DO)
 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))
             IF         COND(&FIRMA = '1' *AND &AKTIV = 'J') THEN(DO)
                CHGVAR     VAR(%SST(&OUTFILE 01 03)) VALUE('RT_')
                CHGVAR     VAR(%SST(&OUTFILE 04 07)) VALUE(&LISTE)
                CHGVAR     VAR(%SST(&MD 01 07)) VALUE(%SST(&LISTE +
                          01 05))
                CHGVAR     VAR(%SST(&MSGFKT 01 07)) VALUE(%SST(&LISTE +
                          01 07))
                CALL       PGM(DUMMY512) PARM(&MD &MSGFKT ' ' ' ' +
                             &OUTFILE  'GANG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
             ENDDO
             GOTO       CMDLBL(LOOP)

             ENDDO
 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO

             ENDPGM
