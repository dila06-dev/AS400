/*    * PROGRAMMNAME.:ZUGRIFF AUF DOKUMENTE                                  */
/*    * FUNKTION.....:ZUGRIFF AUF DOKUMENTE                                  */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&PARM)

             DCL        VAR(&COMMAND)  TYPE(*CHAR) LEN(512) VALUE(' ')
             DCL        VAR(&BEFEHL)   TYPE(*CHAR) LEN(126) VALUE(' ')
             DCL        VAR(&PARM)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&DOKUMENT) TYPE(*CHAR) LEN(512) VALUE(' ')
             DCL        VAR(&ERROR1)   TYPE(*CHAR) LEN(01)  VALUE('0')
             DCL        VAR(&ERROR2)   TYPE(*CHAR) LEN(01)  VALUE('0')

             RTVDTAARA  DTAARA(COMMAND) RTNVAR(&COMMAND)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
             CHGDTAARA  DTAARA(DOKUMENT) +
                          VALUE('E,C:\WINDOWS                        -
           ')
/*          ENGLAND                                                          */
             CHGDTAARA  DTAARA(ENGLAND) +
                          VALUE('E,/n,ftp://winadmin:3veKhCMZ@ftp.dom+
                          etic-group.com/domains/dometic-group.com/pu+
                          blic_ftp/dwuk/snd/')

/*          FRANKREICH                                                       */
             CHGDTAARA  DTAARA(FRANKREICH) +
                          VALUE('E,/n,ftp://dwfr:RkEAU31x@ftp.dom+
                          etic-group.com/domains/dometic-group.com/pu+
                          blic_ftp/dwfr/snd/')

             CHGDTAARA  DTAARA(FRANKREICH) +
                          VALUE('E,/n,ftp://winadmin:3veKhCMZ@ftp.dom+
                          etic-group.com/domains/dometic-group.com/pu+
                          blic_ftp/dwfr/snd/')

/*          SPANIEN                                                          */
             CHGDTAARA  DTAARA(SPANIEN) +
                          VALUE('E,/n,ftp://winadmin:3veKhCMZ@ftp.dom+
                          etic-group.com/domains/dometic-group.com/pu+
                          blic_ftp/dwes/snd/')

             CHGDTAARA  DTAARA(SPANIEN) +
                          VALUE('E,/n,ftp://dwes@dometic-group.com:Tw+
                          1BIwrg@ftp.dometic-group.com/')
                  /*      1234567890123456789012345678901234567890123*/

/*          ELSE                                                             */
             CHGDTAARA  DTAARA(TECHNO) +
                          VALUE('E,/n,ftp://waeco:X1X31535@ftp.213.20+
                          9.110.98/qs36f/')

             CHGDTAARA  DTAARA(WAECOF) +
                          VALUE('E,/n,ftp://gang:Nf07ng09@ftp.172.16.+
                          100.1/qdls/')

             IF         COND(&PARM = 'E') THEN(DO)
                RTVDTAARA  DTAARA(ENGLAND)    RTNVAR(&DOKUMENT)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                             VALUE('1'))
             ENDDO
             IF         COND(&PARM = 'F') THEN(DO)
                RTVDTAARA  DTAARA(FRANKREICH) RTNVAR(&DOKUMENT)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                             VALUE('1'))
             ENDDO
             IF         COND(&PARM = 'S') THEN(DO)
                RTVDTAARA  DTAARA(SPANIEN) RTNVAR(&DOKUMENT)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                             VALUE('1'))
             ENDDO
             IF         COND(&PARM = 'T') THEN(DO)
                RTVDTAARA  DTAARA(TECHNO) RTNVAR(&DOKUMENT)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                             VALUE('1'))
             ENDDO
             IF         COND(&PARM = 'W') THEN(DO)
                RTVDTAARA  DTAARA(WAECOF) RTNVAR(&DOKUMENT)
                MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                             VALUE('1'))
             ENDDO

             IF         COND(&ERROR2 = '0') THEN(DO)
               CHGVAR     VAR(&BEFEHL) VALUE('"' *TCAT &COMMAND *TCAT +
                          ' /' *CAT &DOKUMENT *TCAT '"')
               STRPCO     PCTA(*NO)
               MONMSG     MSGID(CPF0000)
               STRPCCMD   PCCMD(&BEFEHL) PAUSE(*NO)
               MONMSG     MSGID(CPF0000)
             ENDDO

 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
             ENDDO

             ENDPGM
