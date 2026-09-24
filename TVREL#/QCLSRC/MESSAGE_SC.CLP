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
             CLRPFM     FILE(QTEMP/#DC2580)
             MONMSG     MSGID(CPF0000)

             IF         COND(&IFAKIFFI *NE '     ') THEN(DO)
/*             GENERELLER AUFBAU                                             */
/*             ZIEHEN RELEVANTER DATEN AUS #LBLB                             */
                IF         COND(&PARM *EQ '1') THEN(DO)
                   CHGVAR     VAR(%SST(&MD 01 05)) VALUE(&IFAKIFFI)
                   CHGVAR     VAR(%SST(&MD 06 10)) VALUE(&IFAKMAAF)
                   CALL      PGM(DUMMY512) PARM(&MD '#DC2579' ' ' ' ' +
                              '#DC2580' 'QTEMP' '*REPLACE')
                   MONMSG     MSGID(CPF0000)
                ENDDO

                IF         COND(&PARM *EQ '2') THEN(DO)
                   CHGVAR     VAR(%SST(&MD 01 05)) VALUE(&IFAKIFFI)
         /*        CHGVAR     VAR(&D) VALUE('20110124')       */
                   CHGVAR     VAR(%SST(&MD 06 08)) VALUE(&D)
                   CALL      PGM(DUMMY512) PARM(&MD '#DC2578' ' ' ' ' +
                              '#DC2580' 'QTEMP' '*REPLACE')
                   MONMSG     MSGID(CPF0000)
                ENDDO

                RTVMBRD    FILE(QTEMP/#DC2580) NBRCURRCD(&NBRCURRCD)
                MONMSG     MSGID(CPF0000)
                IF         COND(&NBRCURRCD *GT 0) THEN(DO)
                   CALL    PGM(DUMMY512) PARM(&MD '#DC2581' ' ' ' ' +
                              '#DC2581' 'QTEMP' '*REPLACE')
                   MONMSG     MSGID(CPF0000)
            /*RÜCKSTANDSKENNUNG SETZEN                       */
                   CALL      PGM(DUMMY512) PARM(&MD '#DC2582' ' ' ' ' +
                             ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
            /*ARTICLE IS PROTECTED BY SUPERVISOR             */
                   CALL      PGM(DUMMY512) PARM(&MD '#DC2583' ' ' ' ' +
                             ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
            /*ARTICLE IS NOT ANYMORE VALID REPLACED BY:      */
                   CALL      PGM(DUMMY512) PARM(&MD '#DC2584' ' ' ' ' +
                             ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
            /*SELLING UNIT ARE NOT CONFORM                   */
                   CALL      PGM(DUMMY512) PARM(&MD '#DC2585' ' ' ' ' +
                             ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
            /*NO PRICE FOR THIS ARTICLE AVAILABLE            */
                   CALL      PGM(DUMMY512) PARM(&MD '#DC2586' ' ' ' ' +
                             ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
                   IF         COND(&IFAKIFFI *EQ '40631') THEN(DO)
                   OVRPRTF    FILE(QPQUPRFIL) TOFILE(*LIBL/QPQUPRFIL) +
                          FORMTYPE('UKTREND') OVRSCOPE(*JOB)
                      MONMSG     MSGID(CPF0000)
                   ENDDO
                   IF         COND(&IFAKIFFI *EQ '15177') THEN(DO)
                   OVRPRTF    FILE(QPQUPRFIL) TOFILE(*LIBL/QPQUPRFIL) +
                          FORMTYPE('NLTREND') OVRSCOPE(*JOB)
                      MONMSG     MSGID(CPF0000)
                   ENDDO
                   IF         COND(&IFAKIFFI *EQ '62765') THEN(DO)
                   OVRPRTF    FILE(QPQUPRFIL) TOFILE(*LIBL/QPQUPRFIL) +
                          FORMTYPE('BETREND') OVRSCOPE(*JOB)
                      MONMSG     MSGID(CPF0000)
                   ENDDO
                   IF         COND(&IFAKIFFI *EQ '88505') THEN(DO)
                   OVRPRTF    FILE(QPQUPRFIL) TOFILE(*LIBL/QPQUPRFIL) +
                          FORMTYPE('FRTREND') OVRSCOPE(*JOB)
                      MONMSG     MSGID(CPF0000)
                   ENDDO
                   IF         COND(&IFAKIFFI *EQ '55278') THEN(DO)
                   OVRPRTF    FILE(QPQUPRFIL) TOFILE(*LIBL/QPQUPRFIL) +
                          FORMTYPE('ITTREND') OVRSCOPE(*JOB)
                      MONMSG     MSGID(CPF0000)
                   ENDDO
                   IF         COND(&IFAKIFFI *EQ '02921') THEN(DO)
                   OVRPRTF    FILE(QPQUPRFIL) TOFILE(*LIBL/QPQUPRFIL) +
                          FORMTYPE('SCTREND') OVRSCOPE(*JOB)
                      MONMSG     MSGID(CPF0000)
                   ENDDO
                   RUNQRY     QRY(TVRELWAECO/#DC2580) RCDSLT(*NO)
                   MONMSG     MSGID(CPF0000)
                   DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
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
