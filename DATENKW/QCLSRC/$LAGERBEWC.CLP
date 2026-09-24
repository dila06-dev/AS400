/*    * PROGRAMMNAME.:$LAGERBEWC              0 1 SO MÜSSEN SIE STEHEN       */
/*    * FUNKTION.....:...                                                    */
/*    * JULI    2010   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *-DER JOB IST RESTARTFÄHIG                                             */
/*    * WENN NICHT '0' WIRD AKTUALISIERUNG DER KALKFILE NICHT DURCH-         */
/*    * GEFÜHRT, DAHER AUF NULL SETZEN.                                      */
/*    * $LAGERBEWC                                                           */
/*    *  CHGDTAARA DTAARA(DATENKW/$LAGERBEWC *ALL) VALUE('0')                 */
/*    *  DSPDTAARA DTAARA(DATENKW/$LAGERBEWC)                                 */
/*    *  0 BEDEUTET NICHT AKTIV 1 BEDEUTET BEREITS AKTIV                      */
/*    * LAGERBEWC                                                            */
/*    *  DSPDTAARA DTAARA(DATENKW/LAGERBEWC)                                  */
/*    *  CHGDTAARA DTAARA(DATENKW/LAGERBEWC) VALUE('1')                       */
/*    *  1 BEDEUTET KANN GESTARTET WERDEN, 0 WIRD NICHT GESTARTET             */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&CODE)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&LAGERBEWC) TYPE(*CHAR) LEN(32)
             DCL        VAR(&$LAGERBEWC) TYPE(*CHAR) LEN(01)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DLTF       FILE(SAVEFILE/EL_PS)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(SAVEFILE/SAVE_ELPS)
             MONMSG     MSGID(CPF0000)

             CRTSAVF    FILE(SAVEFILE/EL_PS) TEXT('Sicherung +
                          PRODWIN51')
             MONMSG     MSGID(CPF0000)
             RGZPFM     FILE(BAR_KALK/KALK_FILE)
             MONMSG     MSGID(CPF0000)

 /* GESAMTZAHL AN TEILDATEIEN  . . . . . . . . :                 1   */
 /* GESAMTZAHL NICHT VERFÜGBARER TEILDATEIEN . :                 0   */
 /* GESAMTZAHL DATENSÄTZE  . . . . . . . . . . :            301115   */
 /* GESAMTZAHL GELÖSCHTER SÄTZE  . . . . . . . :          11069776   */
 /* GESAMTGRÖßE DER TEILDATEIEN  . . . . . . . :       18544640000   */
 /*                                                                  */
       /*    SAVLIB     LIB(PRODWIN51) DEV(*SAVF) +                  */
       /*                 SAVF(SAVEFILE/EL_PS) SAVACT(*SYNCLIB) +    */
       /*                 SAVACTWAIT(120) ACCPTH(*YES) +             */
       /*                 OUTPUT(*OUTFILE) +                         */
       /*                 OUTFILE(SAVEFILE/SAVE_ELPS) OUTMBR(*FIRST +*/
       /*                 *ADD)                                      */
             MONMSG     MSGID(CPF0000)

 LOOP:       RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)

             IF         COND(&QTIME *GT '183000') THEN(GOTO +
                          CMDLBL(ENDPGM))

             RTVDTAARA  DTAARA(DATENKW/LAGERBEWC (1 1)) +
                          RTNVAR(&LAGERBEWC)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                 GOTO       CMDLBL(ENDPGM)
             ENDDO

/*   -AKTUALISIERUNG DER ARTIKELDATEN AKTIV(1), INAKTIV(0)                   */
             RTVDTAARA  DTAARA(DATENKW/$LAGERBEWC *ALL) +
                          RTNVAR(&$LAGERBEWC)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                 GOTO       CMDLBL(ENDPGM)
             ENDDO

/*   -MUSS AUF 1 STEHEN UM ZU LAUFEN HIER BREAKPOINT                         */
             IF         COND(&LAGERBEWC *NE '1') THEN(DO)
                 GOTO       CMDLBL(ENDPGM)
             ENDDO

/*   -AKTUALISIERUNG DER ARTIKELDATEN ÜBER STAMMDATEN AUSSER BEI '1'         */
/*           CHGVAR     VAR(&$LAGERBEWC) VALUE('1')                           */
             IF         COND(&$LAGERBEWC *NE '1') THEN(DO)
                CHGVAR     VAR(&COUNT) VALUE(&COUNT +1)
                IF         COND(&COUNT *EQ 1 ) THEN(DO)
                   CHGDTAARA DTAARA(DATENKW/$LAGERBEWC *ALL) VALUE('1')
                   ADDLIBLE   LIB(BAR_KALK) POSITION(*LAST)
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(BAR_KALK/KALK_FILES)

                   CALL      PGM(DUMMY512) PARM(&MD '#KA0290' ' ' ' ' +
                                '#KA0290' 'BAR_KALK' '*REPLACE')
                   CLRPFM     FILE(#KA0290L1)
                   MONMSG     MSGID(CPF0000)
/*                INDEX LEGEN AUF UMSÄTZE/ABSÄTZE                            */
                   CALL      PGM(DUMMY512) PARM(&MD '#KP0291' ' ' ' ' +
                             ' ' ' ' '*REPLACE')

/*                MENGEN AUS LAGER HOLEN                                     */
                   CALL      PGM(DUMMY512) PARM(&MD '#KP0105' ' ' ' ' +
                              '#KP0105' 'GANG' '*REPLACE')
                   CLRPFM     FILE(#KP0105L1)
                   MONMSG     MSGID(CPF0000)
/*                INDEX LEGEN AUF ARTIKEL UND LAGER                          */
                   CALL      PGM(DUMMY512) PARM(&MD '#KP0107' ' ' ' ' +
                              ' ' ' ' '*REPLACE')
/*                KALKULATION DURCHFÜHREN                                    */
                   CALL       PGM(BAR_KALK/KALK) PARM('$$EL_PS_DB')
                   MONMSG     MSGID(CPF0000) EXEC(DO)
                       GOTO       CMDLBL(ENDPGM)
                   ENDDO
/*                -ARTIKELDATEN AUFBAUEN                                     */
                   CALL PGM(ARTIKELC) PARM('$$EL_PS_DB')
                   MONMSG     MSGID(CPF0000) EXEC(DO)
                       GOTO       CMDLBL(ENDPGM)
                   ENDDO
/*                -UPDATE STK        INAKTIV KORDEL 6.12.2011                */
           /*      CALL       PGM(STKKOR_C)     */
           /*      MONMSG     MSGID(CPF0000)    */

/*            PROTOKOLL IN SBGFAN00                                          */
           /*  CALL      PGM(DUMMY512) PARM(&MD 'SKU0001' ' ' ' ' +*/
           /*            'SBGFAN00' 'QS36F' '*ADD')                */
           /*  MONMSG     MSGID(CPF0000)                           */
               CHGDTAARA DTAARA(DATENKW/$LAGERBEWC *ALL) VALUE('0')
                ENDDO
                IF         COND(&COUNT *GT 900) THEN(DO)
                   CHGVAR     VAR(&COUNT) VALUE(0)
                ENDDO
             ENDDO

/*   -AUFRUF VERBUCHUNG DER LAGERBEWEGUNGEN                                  */
             CALL PGM(LAGERBEWC) PARM('$$EL_PS_DB')
             MONMSG     MSGID(CPF0000)

             DLYJOB     DLY(300)
             GOTO       CMDLBL(LOOP)

 ENDPGM:
/*   -AUF STANDARD SETZTEN 04.10.2018                                        */
             CHGDTAARA DTAARA(DATENKW/$LAGERBEWC *ALL) VALUE('0')
             MONMSG     MSGID(CPF0000)

/*   -ABRÄUMEN HISTORIE                                                      */
             CALL PGM(DATENKW/RESTARTKW) PARM()
             MONMSG     MSGID(CPF0000)

             DSPJOBLOG  OUTPUT(*PRINT)

             ENDPGM
