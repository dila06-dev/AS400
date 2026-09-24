/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:DATENBASIS FÜR RPMII                                   */
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
             DCL        VAR(&QDAYOFWEEK) TYPE(*CHAR) LEN(04)
             DCL        VAR(&QDAY)  TYPE(*CHAR) LEN(02)

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             ADDLIBLE   LIB(MODWAO) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR3) +
                          VALUE('1'))

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('RPMIIKALKC')
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

             CLRPFM     FILE(#RP0555)
             MONMSG     MSGID(CPF0000)

         /* *** LETZTE KALKULATION ERMITTELN ==> KALK AUS CURRENT JAHR       */
             CALL       PGM(DUMMY512) PARM(&MD '#RP0550' ' ' ' ' +
                           '#RP0550   '  'TVRELWAECO' '*REPLACE')
             MONMSG     MSGID(CPF0000)
         /* *** UND ABLEITEN DER WERTE                                       */
         /*  CALL       PGM(DUMMY512) PARM(&MD '#RP0551' ' ' ' ' +  */
         /*                '#RP0551   '  'TVRELWAECO' '*REPLACE')   */
         /*  MONMSG     MSGID(CPF0000)                              */
         /* *** UND ABLEITEN DER WERTE                                       */
             CALL       PGM(DUMMY512) PARM(&MD '#RP0555' ' ' ' ' +
                           '#RP0555   '  'TVRELWAECO' '*REPLACE')
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CLRPFM     FILE(RPMKALKUL)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
       /*    CALL RPMIIKALKR                 */
       /*    MONMSG     MSGID(CPF0000)       */
       /*   *** ACHTUNG NEUES PROGRANMM FÜR FTP ÜBERTRAGUNG AB 10/2015       */
       /*   *** NUR FÜR STK3   UND "EIGENE" ARTIKEL                          */
       /*   *** FÜHRT ALLE FUNKTIONEN SELBSTÄNDIG DURCH                      */
       /* ==>   UPLOADSTK                         */
                  CALL RPMIISTK3R
                  MONMSG     MSGID(CPF0000)

       /*   *** AUSGABE          ==> SERVICE                                 */
             RTVSYSVAL  SYSVAL(QDAYOFWEEK) RTNVAR(&QDAYOFWEEK)
             MONMSG     MSGID(CPF0000)
             RTVSYSVAL  SYSVAL(QDAY) RTNVAR(&QDAY)
             MONMSG     MSGID(CPF0000)

             IF        COND(&QDAYOFWEEK *NE '*XXX' *AND &QDAY < '99') +
                          THEN(DO)
/*                                                                            */

             RMVLNK     +
                          OBJLNK('/Controlling/KALKULATION/rpmkalkul.+
                          csv')
                MONMSG     MSGID(CPF0000)

                CVTDBF     +
                          OBJ('/Controlling/KALKULATION/rpmkalkul.CSV+
                          ') DBFILE(TVRELWAECO/RPMKALKUL) +
                          DBOUTFMT(*CSV) DBFLDDSC(*YES)
                MONMSG     MSGID(CPF0000)
             CVTDBF     +
                          OBJ('/Controlling/KALKULATION/rpmkalkul.TXT+
                          ') DBFILE(TVRELWAECO/RPMKALKUL) +
                          DBOUTFMT(*TXT) DBFLDDSC(*YES)
                MONMSG     MSGID(CPF0000)
                OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                          DEV(PRT55) FORMTYPE('RPMKALKUL') +
                          OVRSCOPE(*JOB)
                MONMSG     MSGID(CPF0000)
/*                                                                            */
                CALL    PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                             ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)
                DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
                MONMSG     MSGID(CPF0000)
             ENDDO
             DSPJOBLOG  OUTPUT(*PRINT)
             MONMSG     MSGID(CPF0000)

 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
             ENDDO

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
             DSPJOBLOG  OUTPUT(*PRINT)
             MONMSG     MSGID(CPF0000)
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ERROR3 = '0') THEN(DO)
                RMVLIBLE   LIB(MODWAO)
                MONMSG     MSGID(CPF0000)
             ENDDO

             ENDPGM
