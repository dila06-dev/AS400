/*    * PROGRAMMNAME.:##SYS0005R                                             */
/*    * FUNKTION.....:USERSTANDARD FÜR MENÜANZEIGE IN                        */
/*    *               SYS0005R                                               */
/*    * OKTOBER 2009   MANFRED GANG                                           */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&USER &MENU &FKT)

/*----------------------------------------------------------------------------*/
/* &USER                                                                      */
             DCL        VAR(&MSGUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MENU)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&FKT)     TYPE(*CHAR) LEN(01)
             DCL        VAR(&FIRM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&ERROR)   TYPE(*CHAR) LEN(01) VALUE(' ')
             DCL        VAR(&TEXT)    TYPE(*CHAR) LEN(50) VALUE(' ')
             DCL        VAR(&TEXT80)  TYPE(*CHAR) LEN(80) VALUE(' ')
             DCL        VAR(&LIBLIB)  TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&COUNT)   TYPE(*CHAR) LEN(05)
             DCL        VAR(&COUNTN)  TYPE(*DEC) LEN(05 0)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(256)
             DCL        VAR(&MD)      TYPE(*CHAR) LEN(512)
             DCL        VAR(&ATTRC)   TYPE(*CHAR) LEN(02) VALUE('07')
             DCL        VAR(&ATTRN)   TYPE(*DEC) LEN(02 0)
/*----------------------------------------------------------------------------*/
             CHGVAR     VAR(&ATTRN) VALUE(&ATTRC)
             CHGVAR     VAR(%SST(&MSGUSER 01 01)) VALUE('§')
             CHGVAR     VAR(%SST(&MSGUSER 02 09)) VALUE(%SST(&USER +
                          01 09))
             RTVDTAARA  DTAARA(QTEMP/FIRMA (1 1)) RTNVAR(&FIRM)
                IF         COND(&FIRM = 'D') THEN(DO)
                   CHGVAR     VAR(&LIBLIB) VALUE('GANG   ')
                   GOTO       CMDLBL(START)
                ENDDO
                IF         COND(&FIRM = 'L') THEN(DO)
                   CHGVAR     VAR(&LIBLIB) VALUE('GANG   ')
                   GOTO       CMDLBL(START)
                ENDDO
                IF         COND(&FIRM = 'P') THEN(DO)
                   CHGVAR     VAR(&LIBLIB) VALUE('GANG   ')
                   GOTO       CMDLBL(START)
                ENDDO
                GOTO       CMDLBL(ENDE)
/*---AUFBAU UND START---------------------------------------------------------*/
START:
             IF         COND(&FKT = '1') THEN(DO)
                CHGVAR     VAR(&MENU) VALUE(&USER)
                RTVDTAARA DTAARA(&LIBLIB/&USER (1 10)) RTNVAR(&MENU)
                MONMSG     MSGID(CPF0000) EXEC(DO)
                   CRTDTAARA  DTAARA(&LIBLIB/&USER) TYPE(*CHAR)  +
                   LEN(80)  VALUE(' ') TEXT('SYS0005R     ')
                   CHGDTAARA DTAARA(&LIBLIB/&USER (1 10)) VALUE(&USER)
                   CHGDTAARA DTAARA(&LIBLIB/&USER (21 5)) +
                                                   VALUE('00000')
                   CHGDTAARA DTAARA(&LIBLIB/&USER (27 04)) +
                                     VALUE('EIN:')
                   CHGDTAARA DTAARA(&LIBLIB/&USER (31 08)) +
                                     VALUE(%SST(*LDA 1017 08))
                   CHGDTAARA DTAARA(&LIBLIB/&USER (40 04)) +
                                     VALUE('AUS:')
                ENDDO
                RTVDTAARA  DTAARA(&LIBLIB/&MSGUSER (1 512)) RTNVAR(&MD)
                   MONMSG     MSGID(CPF0000) EXEC(DO)
                   CRTDTAARA  DTAARA(&LIBLIB/&MSGUSER) TYPE(*CHAR) +
                          LEN(512) VALUE(' ') TEXT('SYS0005R     ')
                ENDDO
                DLTDTAARA  DTAARA(QTEMP/MSGUSER)
                MONMSG     MSGID(CPF0000)
                CRTDTAARA  DTAARA(QTEMP/MSGUSER) TYPE(*CHAR) LEN(512) +
                          VALUE(&MD) TEXT('SYS0005R     ')
                MONMSG     MSGID(CPF0000)
                RTVOBJD    OBJ(&LIBLIB/&USER) OBJTYPE(*DTAARA) +
                                     TEXT(&TEXT)
                CHGVAR     VAR(%SST(&TEXT 22 12)) VALUE('aktiv       ')
                CHGVAR     VAR(%SST(&TXT 01 50)) VALUE(&TEXT)
                CALL       PGM(#CHGPFMR) PARM(&TXT &ATTRN)
                CHGVAR     VAR(%SST(&TEXT 01 50)) VALUE(%SST(&TXT +
                          01 50))
                CHGOBJD OBJ(&LIBLIB/&USER) OBJTYPE(*DTAARA) +
                                               TEXT(&TEXT)
                GOTO       CMDLBL(ENDE)
             ENDDO
/*---ABSCHLUß-----------------------------------------------------------------*/
             IF         COND(&FKT = '0') THEN(DO)
                 RTVDTAARA  DTAARA(&LIBLIB/&USER (21 05)) +
                            RTNVAR(&COUNT)
                 MONMSG     MSGID(CPF0000) EXEC(DO)
                    CHGVAR     VAR(&ERROR) VALUE('1')
                 ENDDO
                 IF         COND(&ERROR = ' ') THEN(DO)
                    CHGVAR     VAR(&COUNTN) VALUE(&COUNT)
                    CHGVAR     VAR(&COUNTN) VALUE(&COUNTN + 1)
                    CHGVAR     VAR(&COUNT)  VALUE(&COUNTN)
                    CHGDTAARA DTAARA(&LIBLIB/&USER (21 5)) +
                                       VALUE(&COUNT)
                    MONMSG     MSGID(CPF0000)
                    CHGDTAARA DTAARA(&LIBLIB/&USER (44 08)) +
                                     VALUE(%SST(*LDA 1017 08))
                    MONMSG     MSGID(CPF0000)
                    RTVOBJD    OBJ(&LIBLIB/&USER) OBJTYPE(*DTAARA) +
                                     TEXT(&TEXT)
                    RTVDTAARA  DTAARA(&LIBLIB/&USER) RTNVAR(&TEXT80)
                    CHGVAR VAR(%SST(&TEXT 16 35)) VALUE(%SST(&TEXT80 +
                          21 35))
                    CHGOBJD OBJ(&LIBLIB/&USER) OBJTYPE(*DTAARA) +
                                               TEXT(&TEXT)
                 ENDDO
                 CHGDTAARA DTAARA(&LIBLIB/&USER (1 10)) VALUE(&MENU)
                 MONMSG     MSGID(CPF0000) EXEC(DO)
                    CRTDTAARA  DTAARA(&LIBLIB/&USER) TYPE(*CHAR)  +
                    LEN(80)  VALUE(' ') TEXT('SYS0005R     ')
                    CHGDTAARA DTAARA(&LIBLIB/&USER (1 10)) +
                                       VALUE(&USER)
                    CHGDTAARA DTAARA(&LIBLIB/&USER (21 5)) +
                                       VALUE('00001')
                    CHGDTAARA DTAARA(&LIBLIB/&USER (27 04)) +
                                     VALUE('EIN:')
                    CHGDTAARA DTAARA(&LIBLIB/&USER (31 08)) +
                                     VALUE(%SST(*LDA 1017 08))
                    CHGDTAARA DTAARA(&LIBLIB/&USER (40 04)) +
                                     VALUE('AUS:')
                    ENDDO
                GOTO       CMDLBL(ENDE)
             ENDDO
/*----HINTERLEGTE NACHRICHTEN LÖSCHEN ----------------------------------------*/
             IF         COND(&FKT = '9') THEN(DO)
                CHGVAR     VAR(&MD) VALUE(' ')
                CHGDTAARA  DTAARA(&LIBLIB/&MSGUSER (1 512)) VALUE(' ')
                   MONMSG     MSGID(CPF0000) EXEC(DO)
                   CRTDTAARA  DTAARA(&LIBLIB/&MSGUSER) TYPE(*CHAR) +
                          LEN(512) VALUE(' ') TEXT('SYS0005R     ')
                ENDDO
                DLTDTAARA  DTAARA(QTEMP/MSGUSER)
                MONMSG     MSGID(CPF0000)
                CRTDTAARA  DTAARA(QTEMP/MSGUSER) TYPE(*CHAR) LEN(512) +
                          VALUE(&MD) TEXT('SYS0005R     ')
                MONMSG     MSGID(CPF0000)
                GOTO       CMDLBL(ENDE)
             ENDDO
ENDE:
             ENDPGM
