             PGM        PARM(&FIRMA &RTNCOD &VZP &BZP &SW)
             DCL        VAR(&FIRMA) TYPE(*CHAR) LEN(9)
             DCL        VAR(&RTNCOD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&VZP) TYPE(*CHAR) LEN(15)
             DCL        VAR(&BZP) TYPE(*CHAR) LEN(15)
             DCL        VAR(&ZPV) TYPE(*CHAR) LEN(17)
             DCL        VAR(&ZPB) TYPE(*CHAR) LEN(17)
             DCL        VAR(&SW) TYPE(*CHAR) LEN(1)
             DCL        VAR(&USRNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RCDNBR) TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(10) VALUE('VPLDRUCK')
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10) +
                          VALUE('#VPL0006')
             IF         COND(&SW *NE ' ') THEN(DO)
             CHGVAR     VAR(&PGM) VALUE('VPLDRUCKA')
             CHGVAR     VAR(&FILE) VALUE('#VPL0006A')
             ENDDO
             DLTF       FILE(QTEMP/VPL0006W)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(&FILE) FROMLIB(SUBR36) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) NEWOBJ(VPL0006W)
             MONMSG     MSGID(CPF0000)
             RTVJOBA    USER(&USRNAM)
             CHGVAR     VAR(&RTNCOD) VALUE('0')
             CHGVAR     VAR(&ZPV) VALUE('''' *TCAT %SST(&VZP 7 4) +
                          *CAT %SST(&VZP 4 2) *CAT %SST(&VZP 1 2) +
                          *CAT %SST(&VZP 11 2) *CAT ':' *CAT +
                          %SST(&VZP 14 2) *TCAT '''')
             CHGVAR     VAR(&ZPB) VALUE('''' *TCAT %SST(&BZP 7 4) +
                          *CAT %SST(&BZP 4 2) *CAT %SST(&BZP 1 2) +
                          *CAT %SST(&BZP 11 2) *CAT ':' *CAT +
                          %SST(&BZP 14 2) *TCAT '''')
             CLRPFM     FILE(QTEMP/VPL0006W)
             MONMSG     MSGID(CPF0000)
             STRQMQRY   QMQRY(UEBERNAHME/VPLAUSWQ) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/VPL0006W) SETVAR((ZPV &ZPV) +
                          (ZPB &ZPB))
             MONMSG     MSGID(CPF0000)
             RTVMBRD    FILE(QTEMP/VPL0006W) NBRCURRCD(&RCDNBR)
             MONMSG     MSGID(CPF0000)
             IF         COND(&RCDNBR *LE 0) THEN(DO)
             CHGVAR     VAR(&RTNCOD) VALUE('1')
             GOTO       CMDLBL(ENDPGM)
             ENDDO
             OVRPRTF    FILE(VPLFWLP) TOFILE(UEBERNAHME/VPLFWLP) +
                          OUTQ(QUSRSYS/VPLFWL)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(UEBERNAHME/&PGM) PARM(&FIRMA &VZP +
                          &BZP &USRNAM)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(VPLFWLP)
             MONMSG     MSGID(CPF0000)
 ENDPGM:     ENDPGM
