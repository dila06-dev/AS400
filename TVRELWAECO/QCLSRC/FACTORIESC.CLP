/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:FACTORIESC                                             */
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
             DCL        VAR(&ERROR4)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBR)        TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&TXT50)      TYPE(*CHAR) LEN(50)
             DCL        VAR(&DATETIME)   TYPE(*CHAR) LEN(20)
             DCL        VAR(&RECORDS)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)       TYPE(*CHAR) LEN(10)

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&CLIENT)     TYPE(*CHAR) LEN(07)

             DCLF       FILE(TVRELWAECO/#DC4900)
         /*  DLTF       TVRELWAECO/RPMII_FCSV               */
         /*  MONMSG     MSGID(CPF0000)                      */

             ADDLIBLE   LIB(BAR_KALK) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG)       POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR3) +
                          VALUE('1'))

             ADDLIBLE   LIB(TVPF)       POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR4) +
                          VALUE('1'))

             CALL PGM(TVRELWAECO/#LIBLIST)
             MONMSG     MSGID(CPF0000)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('FACTORIESC')
             RTVMBRD    FILE(TVRELWAECO/QCLSRC) MBR(&PGM) TEXT(&TXT)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('START')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CHGVAR     VAR(%SST(&MD 100 7)) VALUE(&CLIENT)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

      /*     GOTO       CMDLBL(ENDPGM)           */
      /*     CLRPFM     TVRELWAECO/FACTORIES#    */
      /*     MONMSG     MSGID(CPF0000)           */
         /* *** ABRUFDATEI PC UPLOAD.CSV, WIRD ÜBERSCHRIEBEN                 */
         /* *** REFERENZEN SC, PREISE DER SC, ARTIKEL DER SC USW.            */
             CPYFRMIMPF FROMFILE(TVRELWAECO/FACTORIES#) +
                          TOFILE(TVRELWAECO/FACTORIES) +
                          MBROPT(*REPLACE) FLDDLM(';') +
                          RPLNULLVAL(*FLDDFT)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/PORDB2BV4)
             MONMSG     MSGID(CPF0000)

/*          DATEI UPDATEN                                                    */
             CALL       PGM(FACTORIESR)
             MONMSG     MSGID(CPF0000)

             CPYF       FROMFILE(BBSC) TOFILE(TVRELWAECO/BBSC_INPUT) +
                          MBROPT(*ADD) CRTFILE(*NO)
             MONMSG     MSGID(CPF0000)

       /*   *** CALL AUF TREND AUFTRÄGE GENERIEREN                           */
       /*   *** FILE AKTUALISIEREN MIT TREND DATEN                           */
             CALL       PGM(#TRBBSCST)
             MONMSG     MSGID(CPF0000)
       /*    DLYJOB     DLY(120)             */
/*          DATEI UPDATEN                                                    */
             CLRPFM TVRELWAECO/#DC4900
             MONMSG     MSGID(CPF0000)
             CALL      PGM(DUMMY512) PARM(&MD '#DC4900' ' ' ' ' +
                         '#DC4900' 'TVRELWAECO' '*REPLACE')
             MONMSG     MSGID(CPF0000)
             RTVMBRD    FILE(TVRELWAECO/#DC4900) NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)

             IF         COND(&NBRCURRCD *GT 0) THEN(DO)
 LOOP:          RCVF
                MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))
                CHGVAR     VAR(&MBR) VALUE(%SST(&ORDEMPF 1 10))
                RMVM       FILE(TVRELWAECO/PORDB2BV4) MBR(&MBR)
                MONMSG     MSGID(CPF0000)
                CPYF       FROMFILE(TVRELWAECO/PORDB2BV4) +
                          TOFILE(TVRELWAECO/PORDB2BV4) TOMBR(&MBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF ORDEMPF *EQ &ORDEMPF))
                MONMSG     MSGID(CPF0000)
   /*           CHGVAR     VAR(%SST(&MBR 01 02)) VALUE('$$')  */
                RTVJOBA    USER(&USER) DATETIME(&DATETIME)
                MONMSG     MSGID(CPF0000)
                QSYS/CPYTOIMPF FROMFILE(TVRELWAECO/PORDB2BV4 &MBR) +
                          TOFILE(TVRELWAECO/PORDB2BV4 &MBR) +
                          MBROPT(*REPLACE) STRDLM(*NONE) +
                          RMVBLANK(*BOTH) FLDDLM(';') DECPNT(*COMMA)
                MONMSG     MSGID(CPF0000)
                QSYS/CPYTOIMPF FROMFILE(TVRELWAECO/PORDB2BV4 &MBR) +
                          TOFILE(TVRELWAECO/#PORDB2BV4 *FIRST) +
                          MBROPT(*REPLACE) STRDLM(*NONE) +
                          RMVBLANK(*BOTH) FLDDLM(';') DECPNT(*COMMA)
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(%SST(&TXT50 1 20)) VALUE(&DATETIME)
                CHGVAR     VAR(%SST(&TXT50 22 10)) VALUE(&USER)
                CHGVAR     VAR(&RECORDS) VALUE(&NBRCURRCD)
                CHGVAR     VAR(%SST(&TXT50 33 10)) VALUE(&RECORDS)
                CHGPFM    FILE(TVRELWAECO/PORDB2BV4) MBR(&MBR) +
                          TEXT(&TXT50)
                MONMSG    MSGID(CPF0000)
                CALL       PGM(FACTOR_FTP) PARM(&MBR)
                MONMSG     MSGID(CPF0000)
       /*   *** PURCHASING                                                   */
/*                                                                            */
                RMVLNK     OBJLNK('/B2B/POSCHMANN/PORDB2BV4.CSV')
                MONMSG     MSGID(CPF0000)
                CVTDBF     OBJ('/B2B/POSCHMANN/PORDB2BV4.CSV') +
                           DBFILE(TVRELWAECO/PORDB2BV4) DBMBR(&MBR) +
                           DBOUTFMT(*CSV) DBFLDDSC(*YES)
                MONMSG     MSGID(CPF0000)
                OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                           DEV(PRT55) FORMTYPE('PORDB2BV4') +
                           OVRSCOPE(*JOB)
       /*       OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) + */
       /*              FORMTYPE('B2B') OVRSCOPE(*JOB)              */
                MONMSG     MSGID(CPF0000)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)
                DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(BBSC)
                MONMSG     MSGID(CPF0000)
                GOTO LOOP
             ENDDO

 ENDPGM:

/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('ENDE ')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CHGVAR     VAR(%SST(&MD 100 7)) VALUE(&CLIENT)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(BAR_KALK)
                MONMSG     MSGID(CPF0000)
             ENDDO

             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
                MONMSG     MSGID(CPF0000)
             ENDDO

             IF         COND(&ERROR3 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
                MONMSG     MSGID(CPF0000)
             ENDDO

             IF         COND(&ERROR4 = '0') THEN(DO)
                RMVLIBLE   LIB(TVPF)
                MONMSG     MSGID(CPF0000)
             ENDDO

             ENDPGM
