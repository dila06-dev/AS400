/*    * PROGRAMMNAME.:STATISTIK                                              */
/*    * FUNKTION.....:.                                                      */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&PARM)

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&STATISTIK) TYPE(*CHAR) LEN(20)
             DCL        VAR(&QDATE)   TYPE(*CHAR) LEN(20)
             DCL        VAR(&QDATEV)  TYPE(*CHAR) LEN(20)
             DCL        VAR(&MSGFKT)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FTP_DC) TYPE(*CHAR) LEN(10)

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             RTVSYSVAL  SYSVAL(QDATETIME) RTNVAR(&QDATE)
             CHGVAR     VAR(%SST(&QDATEV 1 2)) VALUE(%SST(&QDATE 7 2))
             CHGVAR     VAR(%SST(&QDATEV 3 2)) VALUE(%SST(&QDATE 5 2))
             CHGVAR     VAR(%SST(&QDATEV 5 4)) VALUE(%SST(&QDATE 1 4))

             RTVDTAARA  DTAARA(GANG/STATISTIK) RTNVAR(&STATISTIK)

    /*       GOTO       FTPDC                           */
             IF         COND(&QDATEV = &STATISTIK) THEN(DO)
                GOTO       ENDPGM
             ENDDO
    /*                                                  */
    /*      BESTELLUNG/BESTELLDATEN                                          */

             CALL       PGM(DUMMY512) PARM(&MD '#ST0010' ' ' ' ' +
                             '#ST0010' 'QTEMP' '*ADD')
             MONMSG     MSGID(CPF0000)

/*          VERBINDUNG BESTELLDATEN ARTIKELDATEN                             */
             CALL       PGM(DUMMY512) PARM(&MD '#ST0011' ' ' ' ' +
                        '#ST0011' 'BAR_VERT' '*REPLACE')

/*          INTEGRATION FEHLENDE ARTIKEL                                     */
             CALL       PGM(DUMMY512) PARM(&MD '#ST0012' ' ' ' ' +
                        '#ST0011' 'BAR_VERT' '*ADD')

             DLTOVR     FILE(*ALL)

             CHGDTAARA  DTAARA(GANG/STATISTIK) VALUE(&QDATEV)
             MONMSG     MSGID(CPF0000)

             IF         COND(&PARM = '1') THEN(DO)
             ENDDO

 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO

             ENDPGM
