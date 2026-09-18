/*    * PROGRAMMNAME.:AVISUSR01C                                             */
/*    * FUNKTION.....:AVLÖSUNG SRS-SYSTEM                                    */
/*    *               BESTANDENTWICKLUNG                                     */
/*    * MAI 2002 GANG/CUCCHI                                                  */
/*    *                                                                       */
/*    * FASERWERKE-LINGEN GMBH                                                */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM
             DCL        VAR(&BASISJA) TYPE(*DEC) LEN(07) VALUE(9999999)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&X) TYPE(*CHAR) LEN(7)
             DCL        VAR(&KKT) TYPE(*CHAR) LEN(04) VALUE(' ')
             DCL        VAR(&VGL) TYPE(*CHAR) LEN(4)  VALUE(' ')
             DCL        VAR(&FIRMA) TYPE(*CHAR) LEN(1)
             RTVDTAARA  DTAARA(QTEMP/FWLFIRM (1 1)) RTNVAR(&FIRMA)
             RTVDTAARA  DTAARA(BASISJA)          RTNVAR(&BASISJA)
             CHGVAR     VAR(&X) VALUE(&BASISJA)
/******************************************************************************/
             DLTF       FILE(QTEMP/PAR*)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/PROV_BUCH)
             MONMSG     MSGID(CPF0000)
/******************************************************************************/
/*HOLEN ARGENTENGRUPPE ***********************************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'PAR0100' ' ' ' +
                          ' 'PAR0100' 'QTEMP' '*ADD')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/******************************************************************************/
/*HOLEN ARGENTEN *****************************************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'PAR0200' ' ' ' +
                          ' 'PAR0200' 'QTEMP' '*ADD')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*ERMITTELN GÜLTIGE RECHNUNGEN AUS CUSED *****************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'PAR0300' ' ' ' +
                          ' 'PAR0300' 'QTEMP' '*ADD')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*PROVISION FÜR AGEN1/2/3 ********************************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'PAR0400' ' ' ' +
                          ' 'PAR0400' 'QTEMP' '*ADD')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD 'PAR0401' ' ' ' +
                          ' 'PAR0401' 'QTEMP' '*ADD')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD 'PAR0402' ' ' ' +
                          ' 'PAR0402' 'QTEMP' '*ADD')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*PROVISIONDATEI GESAMT AUS PAR0400/1/3*******************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'PAR0403' ' ' ' +
                          ' 'PAR0403' 'QTEMP' '*ADD')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD 'PAR0404' ' ' ' +
                          ' 'PAR0404' 'QTEMP' '*ADD')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*PROVISION FÜR ARGENTEN IN PAR0500 **********************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'PAR0500' ' ' ' +
                          ' 'PAR0500' 'QTEMP' '*ADD')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD 'PAR0600' ' ' ' +
                          ' 'PAR0500' 'QTEMP' '*ADD')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD 'PAR0700' ' ' ' +
                          ' 'PAR0500' 'QTEMP' '*ADD')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*ERSTELLEN DRUCKSTEUERUNGSDATEI AUF LR ******************************       */
/*    *                                                                      */
             CALL       PGM(DUMMY512) PARM(&MD 'PAR0800' ' ' ' +
                          ' 'PAR0800' 'QTEMP' '*ADD')
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*ERSTELLEN PROVISIONSDATEI (PROV_BUCHD)******************************       */
/*    *                                                                      */
             RUNQRY     QRY(FWLFR/PAR0000100) RCDSLT(*YES)
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*ERSTELLEN PROVISIONSDATEI (PROV_BUCHK)******************************       */
/*    *                                                                      */
             RUNQRY     QRY(FWLFR/PAR0000101)
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*DRUCKAUSGABE DER PROVISIONSDATEI ***********************************       */
/*    *                                                                      */
             RUNQRY     QRY(FWLFR/PAR0000200)
             MONMSG     MSGID(CPF0000)
/*    *+++++++++++++++++++++++++8                                            */
/*********************************************************************       */
             IF         COND(&FIRMA *EQ 'L') THEN(DO)
             ENDDO
             IF         COND(&FIRMA *EQ 'D') THEN(DO)
             ENDDO
/*********************************************************************       */
             CHGVAR     VAR(&VGL)             VALUE(%SST(&X 2 04))
             CHGVAR     VAR(%SST(&MD 1 01))   VALUE('A')
             CHGVAR     VAR(%SST(&MD 1 07))   VALUE(&X)
/******************************************************************************/
 ENDPGM:     ENDPGM
