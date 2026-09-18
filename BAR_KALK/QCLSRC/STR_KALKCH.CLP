/*    * PROGRAMMNAME.:STR_KALK                                               */
/*    * FUNKTION.....:KALKULATIONSVERARBEITUNG                               */
/*    *               PARM = 0 = AUFBAU DER KALKULATION NACH VERSION         */
/*    *                          DIE VERSION ERFOLGT ÜBER DIE DTAARA         */
/*    *                          UND NICHT ÜBER DEN PARAMETER.               */
/*    *                                                                      */
/*    *               PARM = # = INTEGRIEREN NEUE ARTIKEL IN PREIS-          */
/*    *                          DATEI                                       */
/*    *                          - ES WERDEN NUR SÄTZE VERARBEITET,          */
/*    *                            DIE JÜNGER/GLEICH SIND ALS DAS            */
/*    *                            VERGLEICHSDATUM DATUM_AB AUS              */
/*    *                            *DTAARA                                   */
/*    *                          - VERSION WIRD FIXIERT ##########           */
/*    *                                                                      */
/*    * DEZEMBER 2010                                                         */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&PARM)

             DCL        VAR(&PARM)     TYPE(*CHAR) LEN(01)
             DCL        VAR(&VERSION)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WAECOLCP) TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR3)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR4)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&DATUM_AB) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&D_AB)     TYPE(*CHAR) LEN(8)
             DCL        VAR(&VON) TYPE(*DEC) LEN(6 0) VALUE(010110)
             DCL        VAR(&BIS) TYPE(*DEC) LEN(6 0) VALUE(310311)
             DCL        VAR(&NBRCURRCD) TYPE(*DEC) LEN(10)

             RTVDTAARA  DTAARA(VERSION) RTNVAR(&VERSION)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDPGM))

             RTVDTAARA  DTAARA(VERSION) RTNVAR(&VERSION)
             IF         COND(&VERSION = '          ') THEN(DO)
                GOTO       CMDLBL(ENDPGM)
             ENDDO

             ADDLIBLE   LIB(BAR_KALK) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))
             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
             ADDLIBLE   LIB(DATENKWCH) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR3) +
                          VALUE('1'))
             ADDLIBLE   LIB(TVRELWAECO) POSITION(*AFTER TFXF)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR4) +
                          VALUE('1'))

             IF         COND(&PARM = '0' *OR &PARM = '#') THEN(DO)
/* Kalkulationsdateien leeren */
/*      ES EXISTIEREN UNTERSCHIEDLICHE VERSIONEN IN BAR_KALK/KALK_FILE       */
         /*     CLRPFM     FILE(BAR_KALK/KALK_FILE)    */
         /*     CLRPFM     FILE(BAR_KALK/KALK_FILES)   */

                CALL       PGM(DUMMY512) PARM(&MD '#KA0290' ' ' ' ' +
                             '#KA0290' 'BAR_KALK' '*REPLACE')
                CLRPFM     FILE(#KA0290)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(#KA0290L1)
                MONMSG     MSGID(CPF0000)
/*             INDEX LEGEN AUF UMSÄTZE/ABSÄTZE                               */
                CALL       PGM(DUMMY512) PARM(&MD '#KP0291' ' ' ' ' +
                             ' ' ' ' '*REPLACE')

/*             MENGEN AUS LAGER HOLEN                                        */
                CALL       PGM(DUMMY512) PARM(&MD '#KP0115' ' ' ' ' +
                             '#KP0105' 'GANG' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(#KP0105L1)
                MONMSG     MSGID(CPF0000)
/*             INDEX LEGEN AUF ARTIKEL UND LAGER                             */
                CALL       PGM(DUMMY512) PARM(&MD '#KP0107' ' ' ' ' +
                             ' ' ' ' '*REPLACE')

/* Kalkulation ausführen */
                IF         COND(&PARM = '0') THEN(DO)
                   CALL       PGM(BAR_KALK/KALKCH) PARM(&VERSION)
                enddo
                IF         COND(&PARM = '#') THEN(DO)
                   CALL       PGM(BAR_KALK/KALK) PARM('##########')
                enddo
             enddo


             IF         COND(&PARM = '#') THEN(DO)
/*             ABLEITUNG DER PREISE FÜR SBGPRS00 HIER EXN 70XXX              */
/*             ABLEITUNG DER PREISE FÜR SBGPRS00 HIER ICS 73XXX              */
/*             ABLEITUNG DER PREISE FÜR SBGPRS00 HIER EXS 74XXX              */
/*             ABLEITUNG DER PREISE FÜR SBGPRS00 HIER OEM 75XXX              */
                CHGVAR     VAR(%SST(&MD 11 06)) VALUE(&VON)
                CHGVAR     VAR(%SST(&MD 17 06)) VALUE(&BIS)
                CHGVAR     VAR(%SST(&MD 01 10)) VALUE('##########')
                CALL       PGM(DUMMY512) PARM(&MD '#PR0160' ' ' ' ' +
                             'E_PREIS' 'BAR_KALK' '*ADD')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(DUMMY512) PARM(&MD '#PR0162' ' ' ' ' +
                             'E_PREIS' 'BAR_KALK' '*ADD')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(DUMMY512) PARM(&MD '#PR0163' ' ' ' ' +
                             'E_PREIS' 'BAR_KALK' '*ADD')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(DUMMY512) PARM(&MD '#PR0164' ' ' ' ' +
                             'E_PREIS' 'BAR_KALK' '*ADD')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(SBGPRS00_P) PARM('          ' ' ')
                MONMSG     MSGID(CPF0000)
                RTVDTAARA  DTAARA(DATUM_AB) RTNVAR(&DATUM_AB)
                CHGVAR     VAR(&D_AB) VALUE(&DATUM_AB)
                CHGVAR     VAR(%SST(&MD 01 02)) VALUE('##')
                CHGVAR     VAR(%SST(&MD 03 08)) VALUE(&D_AB)
                CALL       PGM(DUMMY512) PARM(&MD '#KA0610' ' ' ' ' +
                             ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)
             ENDDO

 ENDPGM:
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(BAR_KALK)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO
             IF         COND(&ERROR3 = '0') THEN(DO)
                RMVLIBLE   LIB(DATENKWCH)
             ENDDO
             IF         COND(&ERROR4 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
             ENDDO

             ENDPGM
