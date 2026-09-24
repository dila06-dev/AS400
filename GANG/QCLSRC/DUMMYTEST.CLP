/*-------------------------------------------------*/
/* Kalkulation starten                             */
/*-------------------------------------------------*/
             PGM

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
    /*       RTVDTAARA  DTAARA(VERSION) RTNVAR(&VERSION)       */
             CHGVAR     VAR(%SST(&MD 01 01)) VALUE(&PARM)
/*                ÄNDERUNG: ÜBERGABE DER MITGLIEDSNUMMER ANSTELLE            */
/*                UNSERER KUNDEN#                                            */
                   CALL      PGM(DUMMY512) PARM(&MD '#AR0597' ' ' ' ' +
                                ' ' ' ' '*REPLACE')
/*                ÄNDERUNG: ANPASSUNG FORMAT MITGLIEDSNUMMER AN TECHNO       */
                   CALL      PGM(DUMMY512) PARM(&MD '#AR0598' ' ' ' ' +
                               ' ' ' ' '*REPLACE')
                   MONMSG     MSGID(CPF0000)

             ENDPGM
