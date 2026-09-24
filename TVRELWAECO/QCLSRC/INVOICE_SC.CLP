/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:IDCO                                                   */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    * .                                                                     */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&IFAKIFFI &IFAKMAAF &PARM)

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&IFAKIFFI)   TYPE(*CHAR) LEN(05)
             DCL        VAR(&IFAKMAAF)   TYPE(*CHAR) LEN(10)

             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)

             DCL        VAR(&D)         TYPE(*CHAR) LEN(8)
             DCL        VAR(&ABDATUM)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&QDATETIME) TYPE(*CHAR) LEN(20)

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)
             RTVSYSVAL  SYSVAL(QDATETIME) RTNVAR(&QDATETIME)
             CHGVAR     VAR(&D) VALUE(%SST(&QDATETIME 1 8))

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*AFTER TFXF)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
             CLRPFM     FILE(QTEMP/#DC2577)
             MONMSG     MSGID(CPF0000)

             IF         COND(&IFAKIFFI *NE '     ') THEN(DO)
/*             GENERELLER AUFBAU                                             */
/*             ZIEHEN RELEVANTER DATEN AUS #LBLB                             */

                IF         COND(&PARM *EQ '2') THEN(DO)
                   CHGVAR     VAR(%SST(&MD 01 05)) VALUE(&IFAKIFFI)
        /*         CHGVAR     VAR(&D) VALUE('20110121')    */
                   RTVDTAARA  DTAARA(ABDATUM) RTNVAR(&ABDATUM)
            /*     CHGVAR     VAR(&ABDATUM) VALUE('20111006') */
                   CHGVAR     VAR(&ABDATUM) VALUE('20140214')
                   IF         COND(&ABDATUM *NE '        ') THEN(DO)
                      CHGVAR     VAR(&D) VALUE(&ABDATUM)
                   ENDDO
                   CHGVAR     VAR(%SST(&MD 06 08)) VALUE(&D)
                   CALL      PGM(DUMMY512) PARM(&MD '#DC2577' ' ' ' ' +
                              '#DC2577' 'QTEMP' '*REPLACE')
                   MONMSG     MSGID(CPF0000)
                ENDDO

                RTVMBRD    FILE(QTEMP/#DC2577) NBRCURRCD(&NBRCURRCD)
                MONMSG     MSGID(CPF0000)
                IF         COND(&NBRCURRCD *GT 0) THEN(DO)
                   IF         COND(&IFAKIFFI *EQ '40631') THEN(DO)
                     OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                          PAGESIZE(200 220) FORMTYPE('UKTRENDIN') +
                          OVRSCOPE(*JOB)
                      MONMSG     MSGID(CPF0000)
                   ENDDO
                   IF         COND(&IFAKIFFI *EQ '15177') THEN(DO)
                     OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                          PAGESIZE(255 220) FORMTYPE('NLTRENDIN') +
                          OVRSCOPE(*JOB)
                      MONMSG     MSGID(CPF0000)
                   ENDDO
                   IF         COND(&IFAKIFFI *EQ '62765') THEN(DO)
                     OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                          PAGESIZE(200 220) FORMTYPE('BETRENDIN') +
                          OVRSCOPE(*JOB)
                      MONMSG     MSGID(CPF0000)
                   ENDDO
                   IF         COND(&IFAKIFFI *EQ '88505') THEN(DO)
                     OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                          PAGESIZE(200 220) FORMTYPE('FRTRENDIN') +
                          OVRSCOPE(*JOB)
                      MONMSG     MSGID(CPF0000)
                   ENDDO
                   IF         COND(&IFAKIFFI *EQ '55278') THEN(DO)
                     OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                          PAGESIZE(200 220) FORMTYPE('ITTRENDIN') +
                          OVRSCOPE(*JOB)
                      MONMSG     MSGID(CPF0000)
                   ENDDO
                   IF         COND(&IFAKIFFI *EQ '02921') THEN(DO)
                     OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                          PAGESIZE(200 220) FORMTYPE('CHTRENDIN') +
                          OVRSCOPE(*JOB)
                      MONMSG     MSGID(CPF0000)
                   ENDDO
                   IF         COND(&IFAKIFFI *EQ '54939') THEN(DO)
                     OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                          PAGESIZE(200 220) FORMTYPE('ATTRENDIN') +
                          OVRSCOPE(*JOB)
                      MONMSG     MSGID(CPF0000)
                   ENDDO
                   IF         COND(&IFAKIFFI *EQ '01887') THEN(DO)
                     OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                          PAGESIZE(200 220) FORMTYPE('DKTRENDIN') +
                          OVRSCOPE(*JOB)
                      MONMSG     MSGID(CPF0000)
                   ENDDO
                   IF         COND(&IFAKIFFI *EQ '78146') THEN(DO)
                     OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                          PAGESIZE(200 220) FORMTYPE('ESTRENDIN') +
                          OVRSCOPE(*JOB)
                      MONMSG     MSGID(CPF0000)
                   ENDDO
                   IF         COND(&IFAKIFFI *EQ '05084') THEN(DO)
                     OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                          PAGESIZE(200 220) FORMTYPE('FITRENDIN') +
                          OVRSCOPE(*JOB)
                      MONMSG     MSGID(CPF0000)
                   ENDDO
                   IF         COND(&IFAKIFFI *EQ '42634') THEN(DO)
                     OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                          PAGESIZE(200 220) FORMTYPE('NOTRENDIN') +
                          OVRSCOPE(*JOB)
                      MONMSG     MSGID(CPF0000)
                   ENDDO
                   IF         COND(&IFAKIFFI *EQ '08138') THEN(DO)
                     OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                          PAGESIZE(200 220) FORMTYPE('SETRENDIN') +
                          OVRSCOPE(*JOB)
                      MONMSG     MSGID(CPF0000)
                   ENDDO
/* KORREKTUR ADRESSEN          */
                   CALL  PGM(DUMMY512) PARM(&MD '#DC2576' ' ' ' ' ' ' +
                          ' ' ' ')
                   MONMSG     MSGID(CPF0000)
                   CALL  PGM(DUMMY512) PARM(&MD '#DC2576' ' ' ' ' ' ' +
                          ' ' ' ')
                   MONMSG     MSGID(CPF0000)
                   CALL      PGM(DUMMY512) PARM(&MD '#DC2575' ' ' ' ' +
                              '#DC2577' 'QTEMP' '*REPLACE')
                   MONMSG     MSGID(CPF0000)
                   CALL  PGM(DUMMY512) PARM(&MD '#DC2573' ' ' ' ' ' ' +
                          ' ' ' ')
                   MONMSG     MSGID(CPF0000)
                   CALL  PGM(DUMMY512) PARM(&MD '#DC2574' ' ' ' ' ' ' +
                          ' ' ' ')
                   MONMSG     MSGID(CPF0000)
/*                             */
                   CALL       #DC2577
                   MONMSG     MSGID(CPF0000)
/*                             */
            /*     RUNQRY     QRY(TVRELWAECO/#DC2705) RCDSLT(*NO)  */
            /*     MONMSG     MSGID(CPF0000)                       */
                   CLRPFM    (QTEMP/CSV)
                   MONMSG     MSGID(CPF0000)
                   CRTPF FILE(QTEMP/CSV) RCDLEN(250)
                   MONMSG     MSGID(CPF0000)
                   QSYS/CPYTOIMPF FROMFILE(#DC2577) +
                   TOFILE(QTEMP/CSV) MBROPT(*REPLACE) +
                   RMVBLANK(*BOTH) FLDDLM(';') DECPNT(*COMMA)
                   MONMSG     MSGID(CPF0000)
                   CALL       PGM(DUMMY512) PARM(&MD '#DC2706' ' ' +
                          'PRT55   ' ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
                   DLTOVR     FILE(QPQXPRTF) LVL(*JOB)
                   MONMSG     MSGID(CPF0000)
                ENDDO
             ENDDO
/*                                                                            */
 ENDPGM:

             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
                MONMSG     MSGID(CPF0000)
             ENDDO

             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO

             ENDPGM
