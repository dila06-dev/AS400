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

             RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
             RTVDTAARA  DTAARA(FWLFIRM (2 1)) RTNVAR(&ENV)
             CALL       PGM(#MODATR) PARM(&ATR)
             RTVJOBA    USER(&USER)
             IF         COND(&USER *EQ 'GANGHHHHH ') THEN(DO)

/*          ------------------------DUPLIKATE ERZEUGEN----------------       */
START:

             CHGVAR     VAR(&MD) +
                          VALUE('                                     -
                                                                      -
                                                                      -
             ')
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
                CHGVAR     VAR(%SST(&MD 1 01)) VALUE(%SST(&ATR 19 01))
             ENDDO
             IF         COND(&FWLFIRM *EQ 'F') THEN(DO)
                CHGVAR     VAR(%SST(&MD 1 01)) VALUE(%SST(&ATR 25 01))
             ENDDO
             CHGVAR     VAR(%SST(&MD 2 01)) VALUE(&FWLFIRM)
             CHGVAR     VAR(%SST(&MD 5 01)) VALUE(&ENV)

             DLTF       FILE(QTEMP/DOCDS*)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/YGDSC*)
             MONMSG     MSGID(CPF0000)

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
             ENDDO
             GOTO       CMDLBL(ENDE)
/*          ----------------------------------------------------------       */
ENDE:
             RCLRSC
             ENDPGM
