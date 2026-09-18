/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:IDCO                                                   */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    * .                                                                     */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&PARM)

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURR##)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&VERSION)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&VON) TYPE(*DEC) LEN(6 0) VALUE(010110)
             DCL        VAR(&BIS) TYPE(*DEC) LEN(6 0) VALUE(310311)

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('PREISE4_C ')
             RTVMBRD    FILE(TVRELWAECO/QCLSRC) MBR(&PGM) TEXT(&TXT)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('START')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */
             GOTO ENDPGM

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))


             IF         COND(&PARM *EQ '1' ) THEN(DO)
               CLRPFM    #PR2500
               MONMSG     MSGID(CPF0000)
               CLRPFM    #PR2510
               MONMSG     MSGID(CPF0000)
               CLRPFM    #PR2520
               MONMSG     MSGID(CPF0000)
/*                                                                            */
               CALL      PGM(DUMMY512) PARM(&MD '#PR2500' ' ' ' ' +
                          '#PR2500' 'TVRELWAECO' '*REPLACE')
               MONMSG     MSGID(CPF0000)
               CALL      PGM(DUMMY512) PARM(&MD '#PR2510' ' ' ' ' +
                          '#PR2510' 'TVRELWAECO' '*REPLACE')
               MONMSG     MSGID(CPF0000)
               CALL      PGM(DUMMY512) PARM(&MD '#PR2520' ' ' ' ' +
                          '#PR2520' 'TVRELWAECO' '*REPLACE')
               MONMSG     MSGID(CPF0000)
               CALL       PGM(PREISE4_R)
               MONMSG     MSGID(CPF0000)

/*             ABLEITUNG DER PREISE FÜR SBGPRS00 HIER GANG/E_PREISE#1        */
               QSYS/RTVMBRD FILE(TVRELWAECO/E_PREIS) +
                          NBRCURRCD(&NBRCURRCD)
               MONMSG     MSGID(CPF0000)
                IF         COND(&NBRCURRCD *NE 0) THEN(DO)
                   RTVDTAARA  DTAARA(VERSION) RTNVAR(&VERSION)
                   MONMSG     MSGID(CPF0000)
                   CHGVAR     VAR(%SST(&MD 11 06)) VALUE(&VON)
                   CHGVAR     VAR(%SST(&MD 17 06)) VALUE(&BIS)
                   CHGVAR     VAR(%SST(&MD 01 10)) VALUE('          ')
                   CALL       PGM(PREISE_R) PARM('1')
                   MONMSG     MSGID(CPF0000)
                   CPYF       FROMFILE(TVRELWAECO/E_PREIS) +
                             TOFILE(TVRELWAECO/E_PREISS) MBROPT(*ADD) +
                              FMTOPT(*MAP *DROP)
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(TVRELWAECO/E_PREIS)
                   MONMSG     MSGID(CPF0000)
                ENDDO
             ENDDO
/*                                                                            */
 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO

/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('ENDE ')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CHGVAR     VAR(%SST(&MD 100 14)) VALUE('Sätze verarb.')
             CHGVAR     VAR(&NBRCURR##) VALUE(&NBRCURRCD)
             CHGVAR     VAR(%SST(&MD 115 10)) VALUE(&NBRCURR##)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

             ENDPGM
