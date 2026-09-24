/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:GEWICHTC                                               */
/*    *               ...                                                    */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR3)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('GEWICHTC  ')
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

         /*  DLTF       TVRELWAECO/RPMII_FCSV               */
         /*  MONMSG     MSGID(CPF0000)                      */

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*FIRST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*FIRST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             ADDLIBLE   LIB(TVPF) POSITION(*FIRST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR3) +
                          VALUE('1'))

         /* *** ABRUFDATEI PC UPLOAD.CSV, WIRD ÜBERSCHRIEBEN                 */
             CPYFRMIMPF FROMFILE(TVRELWAECO/GEWICHTEI5)   +
                         TOFILE(TVRELWAECO/GEWICHT)        +
                         MBROPT(*REPLACE) FLDDLM(';')       +
                         RPLNULLVAL(*FLDDFT)
             MONMSG     MSGID(CPF0000)

       /*   *** UPDATE AUF PROTOKOLLA = '1' VERWERTBARKEIT ARTIKEL           */
             CALL    PGM(DUMMY512) PARM(&MD '#GE0200' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)

       /*   *** UPDATE AUF PROTOKOLLA = '2' VERWERTBARKEIT ARTIKEL           */
             CALL    PGM(DUMMY512) PARM(&MD '#GE0201' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)

       /*   *** UPDATE AUF PROTOKOLLA = '3' VERWERTBARKEIT ARTIKEL           */
             CALL    PGM(DUMMY512) PARM(&MD '#GE0202' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)

       /*   *** UPDATE AUF PROTOKOLLA = '4' VERWERTBARKEIT ARTIKEL           */
             CALL    PGM(DUMMY512) PARM(&MD '#GE0203' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)

       /*   *** UPDATE AUF PROTOKOLLA = '5' VERWERTBARKEIT ARTIKEL           */
             CALL    PGM(DUMMY512) PARM(&MD '#GE0204' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)

       /*   *** UPDATE AUF PROTOKOLLA = '6' VERWERTBARKEIT ARTIKEL           */
             CALL    PGM(DUMMY512) PARM(&MD '#GE0205' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)

       /*   *** UPDATE AUF PROTOKOLLA = '7' VERWERTBARKEIT ARTIKEL           */
             CALL    PGM(DUMMY512) PARM(&MD '#GE0206' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)

       /*   *** UPDATE AUF PROTOKOLLA = '8' VERWERTBARKEIT ARTIKEL           */
             CALL    PGM(DUMMY512) PARM(&MD '#GE0207' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)

       /*   *** UPDATE AUF PROTOKOLLA = '9' VERWERTBARKEIT ARTIKEL           */
             CALL    PGM(DUMMY512) PARM(&MD '#GE0208' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)

       /*   *** UPDATE AUF PROTOKOLLA = 'A' VERWERTBARKEIT ARTIKEL           */
             CALL    PGM(DUMMY512) PARM(&MD '#GE0209' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)

       /*   *** UPDATE AUF PROTOKOLLA = 'B' VERWERTBARKEIT ARTIKEL           */
             CALL    PGM(DUMMY512) PARM(&MD '#GE0210' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)

       /*   *** UPDATE AUF PROTOKOLLA = 'C' VERWERTBARKEIT ARTIKEL           */
             CALL    PGM(DUMMY512) PARM(&MD '#GE0211' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)

       /*   *** UPDATE AUF PROTOKOLLA = 'D' VERWERTBARKEIT ARTIKEL           */
             CALL    PGM(DUMMY512) PARM(&MD '#GE0212' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)

       /*   *** UPDATE AUF PROTOKOLLA = '?' VERWERTBARKEIT ARTIKEL           */
             CALL    PGM(DUMMY512) PARM(&MD '#GE0215' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)


/*          GEWICHTR (GENERIERT ALLE BESTANDTEILE AUS RPM)                   */
             CALL GEWICHTR
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(TVRELWAECO/GEWICHT) +
                          TOFILE(TVRELWAECO/GEWICHTSAV) +
                          MBROPT(*ADD) CRTFILE(*NO)
             MONMSG     MSGID(CPF0000)

/*                                                                            */
       /*   *** MAIL RAUS                                                    */
             RMVLNK     OBJLNK('/LOGISTIC/ITEMCHECK/GEWICHTE.CSV')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/LOGISTIC/ITEMCHECK/GEWICHTE.CSV') +
                          DBFILE(TVRELWAECO/GEWICHT) +
                          DBOUTFMT(*CSV) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                    FORMTYPE('GEWICHTE') OVRSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)

 ENDPGM:

/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('ENDE ')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ERROR3 = '0') THEN(DO)
             ENDDO

             ENDPGM
