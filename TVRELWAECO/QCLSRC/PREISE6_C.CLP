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
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&VERSION)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&VON) TYPE(*DEC) LEN(6 0) VALUE(010110)
             DCL        VAR(&BIS) TYPE(*DEC) LEN(6 0) VALUE(310311)

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))


             IF         COND(&PARM *EQ '1' ) THEN(DO)
/*             GENERELLER AUFBAU                                             */

/*             ABLEITUNG DER PREISE FÜR SBGPRS00 HIER GANG/E_PREISE#1        */
               QSYS/RTVMBRD FILE(GANG/E_PREISE#1) NBRCURRCD(&NBRCURRCD)
               MONMSG     MSGID(CPF0000)
                IF         COND(&NBRCURRCD *NE 0) THEN(DO)
                   RTVDTAARA  DTAARA(VERSION) RTNVAR(&VERSION)
                   MONMSG     MSGID(CPF0000)
                   CHGVAR     VAR(%SST(&MD 11 06)) VALUE(&VON)
                   CHGVAR     VAR(%SST(&MD 17 06)) VALUE(&BIS)
                   CHGVAR     VAR(%SST(&MD 01 10)) VALUE('          ')
                   DLTF       FILE(QTEMP/ACCESS)
                   MONMSG     MSGID(CPF0000)
                   CALL      PGM(DUMMY512) PARM(&MD '#PR0100' ' ' ' ' +
                                'ACCESS' 'QTEMP' '*REPLACE')
                   MONMSG     MSGID(CPF0000)
                   CPYF       FROMFILE(QTEMP/ACCESS) TOFILE(E_PREIS) +
                              MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
                   MONMSG     MSGID(CPF0000)
                   CALL       PGM(PREISE6_R)
                   MONMSG     MSGID(CPF0000)
                   CPYF       FROMFILE(TVRELWAECO/E_PREIS) +
                            TOFILE(TVRELWAECO/E_PREISEK) MBROPT(*ADD) +
                              CRTFILE(*YES) FMTOPT(*MAP *DROP)
                   MONMSG     MSGID(CPF0000)
                   CLRPFM     FILE(TVRELWAECO/E_PREIS)
                   MONMSG     MSGID(CPF0000)
                   DLTF       FILE(GANG/E_PREISE#1)
                   MONMSG     MSGID(CPF0000)
                ENDDO
             ENDDO
/*                                                                            */
 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO

             ENDPGM
