/*    * PROGRAMMNAME.:DISPO02CC                                              */
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
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

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
/*                                                */
             DLTF       FILE(QTEMP/DIS0002L1)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&MD 1 06)) VALUE('NA5050')
             CALL       PGM(DUMMY512) PARM(&MD 'DIS0002' ' ' ' ' +
                          'DIS0002' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(' ' 'DIS0003' ' ' ' ' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
/*                                                */
             OVRDBF     FILE(§000PHY1) TOFILE(*LIBL/DIS0002) +
                          MBR(*FIRST) OVRSCOPE(*CALLLVL)
             OVRDBF     FILE(§000LOG1) TOFILE(*LIBL/DIS0002L1) +
                          MBR(*FIRST) OVRSCOPE(*CALLLVL)
             CRTBNDRPG  PGM(UEBERNAHME/DISPO07R) +
                          SRCFILE(UEBERNAHME/QRPGLESRC)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                          VALUE('1'))
             IF         COND(&ERROR = '0') THEN(DO)
             SNDPGMMSG  MSG('Programm DISPO07R fehlerfrei übersetzt') +
                          TOPGMQ(*SAME (&MSGPGM))
                  GOTO ENDE
             ENDDO
             IF         COND(&ERROR = '1') THEN(DO)
             SNDPGMMSG  MSG('Fehler bei der Übersetzung des +
                          Programms DISPO07R aufgetreten') +
                          TOPGMQ(*SAME (&MSGPGM))
                  GOTO ENDE
             ENDDO
ENDE:        IF         COND(&LDAS= 'S') THEN(DO)
                CALL       PGM(##SVRLDA) PARM('R')
             ENDDO
             DLTOVR     FILE(*ALL) LVL(*)
             RCLRSC

             ENDPGM
