/*    * PROGRAMMNAME.:DOCDSC                                                 */
/*    * FUNKTION.....:::::                                                   */
/*    * 2004                                                                  */
/*    *                                                                       */
/*    * FASERWERKE-LINGEN GMBH                                                */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/*    * 21.06.2005                                            GANG            */
/*                                                                           */
/******************************************************************************/
             PGM
             DCL        VAR(&FWLFIRM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&ENV)     TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD)      TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&ATR)     TYPE(*CHAR) LEN(46) VALUE(' ')
             DCL        VAR(&ATTRN)   TYPE(*DEC) LEN(02 0)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)

             CALL       PGM(#MODATR) PARM(&ATR)

/*          ------------------------DUPLIKATE ERZEUGEN----------------       */
STARTP:

             CHGVAR     VAR(&MD) +
                          VALUE('                                     -
                                                                      -
                                                                      -
             ')

/*          ------DORMAGEN  P-----------------------------------------       */
             DLTF       FILE(QTEMP/DOCDS*)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/YGDSC*)
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(%SST(&MD 1 01)) VALUE(%SST(&ATR 19 01))
             CHGVAR     VAR(%SST(&MD 2 01)) VALUE('D')
             CHGVAR     VAR(%SST(&MD 5 01)) VALUE('P')

             CRTDUPOBJ  OBJ(DOCDS*) FROMLIB(TESAGG2929) +
                          OBJTYPE(*FILE) TOLIB(QTEMP) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(YGDSC*) FROMLIB(MNUG) +
                          OBJTYPE(*FILE) TOLIB(QTEMP) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD 'DOC0001' ' ' ' ' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD 'DOC0002' ' ' ' ' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(PD/DOCDS*)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(PD/YGDSC*)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(DOCDS*) FROMLIB(QTEMP) OBJTYPE(*FILE) +
                          TOLIB(PD) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(YGDSC*) FROMLIB(QTEMP) OBJTYPE(*FILE) +
                          TOLIB(PD) DATA(*YES)
             MONMSG     MSGID(CPF0000)
/*          ------DORMAGEN  T-----------------------------------------       */
             DLTF       FILE(QTEMP/DOCDS*)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/YGDSC*)
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(%SST(&MD 1 01)) VALUE(%SST(&ATR 19 01))
             CHGVAR     VAR(%SST(&MD 2 01)) VALUE('D')
             CHGVAR     VAR(%SST(&MD 5 01)) VALUE('T')

             CRTDUPOBJ  OBJ(DOCDS*) FROMLIB(TESAGG2929) +
                          OBJTYPE(*FILE) TOLIB(QTEMP) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(YGDSC*) FROMLIB(MNUG) +
                          OBJTYPE(*FILE) TOLIB(QTEMP) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD 'DOC0001' ' ' ' ' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD 'DOC0002' ' ' ' ' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(TD/DOCDS*)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(TD/YGDSC*)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(DOCDS*) FROMLIB(QTEMP) OBJTYPE(*FILE) +
                          TOLIB(TD) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(YGDSC*) FROMLIB(QTEMP) OBJTYPE(*FILE) +
                          TOLIB(TD) DATA(*YES)
             MONMSG     MSGID(CPF0000)

/*          ------LINGEN    P-----------------------------------------       */
             DLTF       FILE(QTEMP/DOCDS*)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/YGDSC*)
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(%SST(&MD 1 01)) VALUE(%SST(&ATR 25 01))
             CHGVAR     VAR(%SST(&MD 2 01)) VALUE('L')
             CHGVAR     VAR(%SST(&MD 5 01)) VALUE('P')

             CRTDUPOBJ  OBJ(DOCDS*) FROMLIB(TESAGG2929) +
                          OBJTYPE(*FILE) TOLIB(QTEMP) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(YGDSC*) FROMLIB(MNUG) +
                          OBJTYPE(*FILE) TOLIB(QTEMP) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD 'DOC0001' ' ' ' ' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD 'DOC0002' ' ' ' ' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(PL/DOCDS*)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(PL/YGDSC*)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(DOCDS*) FROMLIB(QTEMP) OBJTYPE(*FILE) +
                          TOLIB(PL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(YGDSC*) FROMLIB(QTEMP) OBJTYPE(*FILE) +
                          TOLIB(PL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
/*          ------LINGEN    T-----------------------------------------       */
             DLTF       FILE(QTEMP/DOCDS*)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/YGDSC*)
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(%SST(&MD 1 01)) VALUE(%SST(&ATR 25 01))
             CHGVAR     VAR(%SST(&MD 2 01)) VALUE('L')
             CHGVAR     VAR(%SST(&MD 5 01)) VALUE('T')

             CRTDUPOBJ  OBJ(DOCDS*) FROMLIB(TESAGG2929) +
                          OBJTYPE(*FILE) TOLIB(QTEMP) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(YGDSC*) FROMLIB(MNUG) +
                          OBJTYPE(*FILE) TOLIB(QTEMP) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD 'DOC0001' ' ' ' ' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD 'DOC0002' ' ' ' ' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(TL/DOCDS*)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(TL/YGDSC*)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(DOCDS*) FROMLIB(QTEMP) OBJTYPE(*FILE) +
                          TOLIB(TL) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(YGDSC*) FROMLIB(QTEMP) OBJTYPE(*FILE) +
                          TOLIB(TL) DATA(*YES)
             MONMSG     MSGID(CPF0000)

             GOTO       CMDLBL(ENDE)
/*          ----------------------------------------------------------       */
ENDE:
             RCLRSC
             ENDPGM
