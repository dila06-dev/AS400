/*    * PROGRAMMNAME.:DIS0003C                                               */
/*    * FUNKTION.....:INVENTURLISTE/BESTANDSLISTE                            */
/*                                                                            */
/*                    CTLLD = 0 NEUAUFBAU  MIT ARTIKEL                       */
/*                    CTLLD = 2 AUFBAU ARTIKEL MIT *ADD                      */
/*                    CTLLD = 9 AUFBAU OHNE ARTIKEL                          */
/*                    CTLLD = I AUFBAU OHNE ARTIKEL  + AUSGABE               */
/*                              EINER EXCEL-DATEI FÜR INVENTUR               */
/*    * NOVEMBER 2000                                                         */
/*    *                                                                       */
/*    * FASERWERKE-LINGEN GMBH                                                */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&KEYV3 &CTLLD)
/************                &CDORD &LNNUM &CDODL &PRNBR)    ********/

             DCL        VAR(&KEYV3) TYPE(*CHAR) LEN(08)
/* &CTLLD    *REPLACE = '0', *ADD = '1'                           */
             DCL        VAR(&CTLLD) TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&CDORD)   TYPE(*CHAR) LEN(06)
             DCL        VAR(&LNNUM)   TYPE(*CHAR) LEN(03)
             DCL        VAR(&CDODL)   TYPE(*CHAR) LEN(02)
             DCL        VAR(&PRNBR)   TYPE(*CHAR) LEN(03)
             DCL        VAR(&FWLFIRM)   TYPE(*CHAR) LEN(01)
             DCL        VAR(&ENV)       TYPE(*CHAR) LEN(01)
             RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
             RTVDTAARA  DTAARA(FWLFIRM (2 1)) RTNVAR(&ENV)
/*----------------------------------------------------------------------------*/
/*          SELEKTION ARTIKEL MIT *REPLACE DIS0002                           */
/*          FÜR NEUAUFBAU DER DATEI DIS0002                                  */
             IF         COND(&CTLLD = '0')         THEN(DO)
                CHGVAR     VAR(%SST(&MD 1 08)) VALUE(&KEYV3)
                CALL       PGM(DUMMY512) PARM(&MD 'DIS0002' ' ' ' ' +
                          'DIS0002' 'QTEMP' '*REPLACE')
                MONMSG     MSGID(CPF0000)
             ENDDO
/*          SELEKTION ARTIKEL MIT *REPLACE DIS0002                           */
/*          FÜR NEUAUFBAU DER DATEI DIS0002                                  */
/*          CTLLD = 9 AUFBAU OHNE ARTIKEL                                    */
             IF         COND(&CTLLD = '9' *OR &CTLLD = 'I') THEN(DO)
                CHGVAR     VAR(%SST(&MD 1 08)) VALUE(&KEYV3)
                CALL       PGM(DUMMY512) PARM(&MD 'DIS0010' ' ' ' ' +
                          'DIS0002' 'QTEMP' '*REPLACE')
                MONMSG     MSGID(CPF0000)
             ENDDO
/*          SELEKTION ARTIKEL MIT *ADD     DIS0002                           */
/*          FÜR WEITERE ARTIKEL                                              */
             IF         COND(&CTLLD = '1')         THEN(DO)
                CHGVAR     VAR(%SST(&MD 1 08)) VALUE(&KEYV3)
                CALL       PGM(DUMMY512) PARM(&MD 'DIS0002' ' ' ' ' +
                          'DIS0002' 'QTEMP' '*ADD')
                MONMSG     MSGID(CPF0000)
             ENDDO
/*          SELEKTION ARTIKEL MIT ZUWEISUNGEN ZU EINEM AUFTRAG               */
             IF         COND(&CTLLD = '2') THEN(DO)
                CALL       PGM(DUMMY512) PARM(&MD 'DIS0006' ' ' ' ' +
                          'DIS0002' 'QTEMP' '*REPLACE')
                MONMSG     MSGID(CPF0000)
             ENDDO
/*          ERMITTLUNG DER AUFTRÄGE ZU DEN VERBLIEBENEN SÄTZEN               */
             IF         COND(&CTLLD = '2' *OR &CTLLD = '9' *OR +
                          &CTLLD = 'I') THEN(DO)
                CALL DIS0002
                MONMSG     MSGID(CPF0000)
             ENDDO
/*          DATEIERWEITERUNG: AB JETZT DIS0010 IN QTEMP                      */
/*          ZUSÄTZLICH WERDEN FELDER AUFGENOMMEN                             */
/*          LETZTER STAND IN LIB: EDV                                        */
/*          INDEX(DIS0010L1) WIRD ÜBER DIS0010  GELEGT  MIT                  */
/*          KEYFELDERN UTECU6 UND UCOMM0 (AUFTRAG,ZEILE,DELIVERYLINE         */
/*          UND FREIGABEZEILE)                                               */
/*          ERMITTLUNG DER HANDELSGEWICHTE, BRUTTOGEWICHTETZEN               */
             IF         COND(&CTLLD = '2' *OR &CTLLD = '9' *OR +
                          &CTLLD = 'I') THEN(DO)
                CRTDUPOBJ  OBJ(DIS0010) FROMLIB(EDV) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
                MONMSG     MSGID(CPF0000)
                CPYF       FROMFILE(QTEMP/DIS0002) +
                          TOFILE(QTEMP/DIS0010) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)
                MONMSG     MSGID(CPF0000)
                DLTF       FILE(QTEMP/DIS0010L*)
                MONMSG     MSGID(CPF0000)
                CALL       PGM(DUMMY512) PARM(&MD 'DIS0007' ' ' ' ' +
                          ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(DIS0010)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&CTLLD = 'I')         THEN(DO)
                CALL       PGM(DUMMY512) PARM(&MD 'DIS0011' ' ' ' ' +
                          'INVENTUR' 'UEBERNAHME' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(DUMMY512) PARM(&MD 'DIS0012' ' ' ' ' +
                          'INVENTUR' 'UEBERNAHME' '*ADD')
                MONMSG     MSGID(CPF0000)
             ENDDO
/*          ACHTUNG! JE NACH BEDARFSFALL                                     */
/*          IN DER FOLGE WERDEN NUR UNKLASSIERTE/GESPERRTE ODER              */
/*          BALLEN OHNE LOCATION GEZEIGT                                     */
             GOTO       CMDLBL(ENDE)
/*          -----------------------                                          */
             IF         COND(&ENV *EQ 'T') THEN(DO)
                CALL       PGM(DUMMY512) PARM(&MD 'DIS0013' ' ' ' ' +
                          'INVENTUR' 'UEBERNAHME' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(DUMMY512) PARM(&MD 'DIS0014' ' ' ' ' +
                          'INVENTUR' 'UEBERNAHME' '*ADD')
                MONMSG     MSGID(CPF0000)
             ENDDO
             GOTO       CMDLBL(ENDE)
/*********************************************************************       */
/*                                                          */
ENDE:
             ENDPGM
