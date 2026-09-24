/*    * PROGRAMMNAME.:DISPO01CC                                              */
/*    * FUNKTION.....:OVRDBF AUF FILES                                       */
/*    * 06.07.98                                                              */
/*    *                                                                       */
/*    * Manfred Gang                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

/*----------------------------------------------------------------------------*/
             DCL        VAR(&MSGPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LDAS)   TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&ERROR)  TYPE(*CHAR) LEN(01) VALUE('0')
             RTVDTAARA  DTAARA(*LDA (954 10)) RTNVAR(&MSGPGM)
             CHGVAR     VAR(&MSGPGM) VALUE('SYS0005R')
             IF         COND(&MSGPGM= '          ') THEN(DO)
                CALL       PGM(##SVRLDA) PARM('S')
                CHGDTAARA  DTAARA(*LDA (954 10)) VALUE(&MSGPGM)
                CHGVAR     VAR(&LDAS) VALUE('S')
                CALL       PGM(#DEFLDA) PARM(' ')
             ENDDO
             DLTOVR     FILE(*ALL) LVL(*)
             CRTDTAARA  DTAARA(QTEMP/TASTATUR) TYPE(*CHAR) LEN(480)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(§000PHY1) TOFILE(*LIBL/STOIN00F) +
                          MBR(*FIRST) OVRSCOPE(*CALLLVL)
             OVRDBF     FILE(§000LOG1) TOFILE(*LIBL/STOIN05L) +
                          MBR(*FIRST) OVRSCOPE(*CALLLVL)
             CRTBNDRPG  PGM(UEBERNAHME/DISPO01R) +
                          SRCFILE(UEBERNAHME/QRPGLESRC)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                          VALUE('1'))
             IF         COND(&ERROR = '0') THEN(DO)
             SNDPGMMSG  MSG('Programm DISPO01R fehlerfrei übersetzt') +
                          TOPGMQ(*SAME (&MSGPGM))
                  GOTO ENDE
             ENDDO
             IF         COND(&ERROR = '1') THEN(DO)
             SNDPGMMSG  MSG('Fehler bei der Übersetzung des +
                          Programms DISPO01R aufgetreten') +
                          TOPGMQ(*SAME (&MSGPGM))
                  GOTO ENDE
             ENDDO
ENDE:        IF         COND(&LDAS= 'S') THEN(DO)
                CALL       PGM(##SVRLDA) PARM('R')
             ENDDO
             DLTOVR     FILE(*ALL) LVL(*)
             RCLRSC

             ENDPGM
