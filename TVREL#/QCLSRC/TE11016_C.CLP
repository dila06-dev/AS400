/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:IDCO                                                   */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    * RESTART:                                                              */
/*    * UPDATE #AFRK11016 SET STATUS = ' ' WHERE #CC = 4                      */
/*    *                                                                       */
/*    * CALL DIREKT AUF RPG ACHTUNG FREITAGKENNUNG                            */
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
             DCL        VAR(&TIMESTAMP) TYPE(*CHAR) LEN(11) VALUE(' ')
             DCL        VAR(&TOFILE) TYPE(*CHAR) LEN(32) VALUE('  ')

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))


             IF         COND(&PARM *EQ '1' ) THEN(DO)
                CALL       PGM(FTP_TIMEST) PARM(&TIMESTAMP)
                CHGVAR     VAR(&TOFILE) VALUE('TE'          *CAT +
                           &TIMESTAMP *CAT '.txt')
/*             GENERELLER AUFBAU                                             */
/*             ZIEHEN RELEVANTER DATEN AUS #LBLB                             */
         /*     CALL    PGM(DUMMY512) PARM(&MD '#TE0500' ' ' ' ' +*/
         /*                '#AFRK11016' 'TVRELWAECO' '*ADD')      */
         /*     MONMSG     MSGID(CPF0000)                         */
                CPYF       FROMFILE(EDI_TECHP) TOFILE(EDI_TECHPS) +
                            TOMBR(*FIRST) MBROPT(*ADD) CRTFILE(*NO)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(EDI_TECHP)
                MONMSG     MSGID(CPF0000)
                CALL       PGM(TE11016_R)
                MONMSG     MSGID(CPF0000)

                OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                          MBR(TECHNOCMD)
                MONMSG     MSGID(CPF0000)
                OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +
                          MBR(TECHNOLOG)
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(%SST(&MD 01 32)) VALUE(&TOFILE)
                CALL       PGM(DUMMY512) PARM(&MD '#TE0505' ' ' ' ' +
                           ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)
                FTP        RMTSYS('MY.EDIEXPERTS.DE')
                DLTOVR     FILE(INPUT)
                MONMSG     MSGID(CPF0000)
                DLTOVR     FILE(OUTPUT)
                MONMSG     MSGID(CPF0000)

             ENDDO
/*                                                                            */
 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO

             ENDPGM
