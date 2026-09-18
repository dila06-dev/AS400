/*    * PROGRAMMNAME.:ORDER_XC                                               */
/*    * FUNKTION.....:ORDER_XC                                               */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    * 13488 UNICODE                                                         */
/*    * 1141 ==>  819                                                         */
/*    * 1208 UTF-8 HAT DATEI                                                        */
/*    * CRTSRCPF FILE(TVRELWAECO/GXS_STREAM) RCDLEN(356) MBR(GXS_STREAM)      */
/*    * TEXT('DON''T TOUCH')                                                  */
/*    *                                                                       */
/*    *                                                                       */
/*    *                                                                       */
/*    *                                                                       */
/* QSYS/CPYTOIMPF FROMFILE(QTEMP/CONFIRMHDX)                                  */
/* TOSTMF('/HDX/RCV/FILEY.TXT') ST                                            */
/* MFCODPAG(819) RCDDLM(*LF) STRDLM('') RMVBLANK(*BOTH) FLDDLM(';')           */
/* DECPNT(*                                                                   */
/* COMMA)                                                                     */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(05)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR)      TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&TOFILE) TYPE(*CHAR) LEN(32) VALUE('  ')
             DCL        VAR(&SC) TYPE(*DEC) LEN(07 0) VALUE(0055278)
             DCL        VAR(&TIMESTAMP) TYPE(*CHAR) LEN(20)
             DCL        VAR(&RECORDS)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATETIME)   TYPE(*CHAR) LEN(20)
             DCL        VAR(&TXT50)      TYPE(*CHAR) LEN(50)
             DCL        VAR(&LINK)       TYPE(*CHAR) LEN(50)
             DCL        VAR(&FROMSTMF)   TYPE(*CHAR) LEN(60)
             DCL        VAR(&TOSTMF)     TYPE(*CHAR) LEN(60)
             DCL        VAR(&TOMBR)      TYPE(*CHAR) LEN(90)
             DCL        VAR(&NOW)        TYPE(*CHAR) LEN(1)
             DCL        VAR(&OBJ)        TYPE(*CHAR) LEN(35)
             DCL        VAR(&NEWOBJ)     TYPE(*CHAR) LEN(35)
             DCL        VAR(&RC) TYPE(*INT) LEN(4)
             DCL        VAR(&MSGDTA)       TYPE(*CHAR) LEN(4)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

             DCLF       FILE(TVRELWAECO/#GXSLNK)


             ADDLIBLE   LIB(TVRELWAECO) POSITION(*AFTER TFXF)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('GXS_000C  ')
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

             RTVSYSVAL SYSVAL(QDATETIME) RTNVAR(&TIMESTAMP)

             RTVJOBA    USER(&USER) DATETIME(&DATETIME)
             MONMSG     MSGID(CPF0000)

             CD         DIR('/EINVOICE/Out')
             MONMSG     MSGID(CPF0000)

             CHGAUT     OBJ('/EINVOICE/Out') USER(*PUBLIC) +
                          DTAAUT(*RWX) OBJAUT(*NONE)
             MONMSG     MSGID(CPF0000)

             DSPLNK     OBJ('*') OUTPUT(*PRINT) OBJTYPE(*ALL) +
                          DETAIL(*NAME) DSPOPT(*ALL)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/#GXSLNK)
             MONMSG     MSGID(CPF0000)

             QSYS/CPYSPLF FILE(QSYSPRT) TOFILE(TVRELWAECO/#GXSLNK) +
                          SPLNBR(*LAST) JOBSYSNAME(*CURRENT)       +
                          CRTDATE(*LAST) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)

             DLTSPLF    FILE(QSYSPRT) SPLNBR(*LAST) +
                          JOBSYSNAME(*CURRENT)
             MONMSG     MSGID(CPF0000)

             RTVMBRD    FILE(TVRELWAECO/#GXSLNK) MBR(*FIRST) +
                          NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)

             IF         COND(&NBRCURRCD *EQ 0) THEN(GOTO +
                          CMDLBL(LOOPENDE))
             CALL       PGM(DUMMY512) PARM(&MD 'GXS0001' ' ' ' ' +
                           '  '  '  ' ' ')
             MONMSG     MSGID(CPF0000)

 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(LOOPENDE))

             IF         COND(%SST(&#GXSLNK 02 10) *NE '          ' *AND +
                          %SST(&#GXSLNK 02 10) *NE '          ') THEN(DO)
                CHGVAR     VAR(&NOW) VALUE('1')
             ENDDO
                          /*SE411 _DE411 2016101522.XML  */
                          /*HK411 _US111A_166964.XML     */
             IF         COND(&NOW = '1' *AND (%SST(&#GXSLNK 02 30) +
                       *EQ 'SE411 _DE411 2016101522.XML   ')) THEN(DO)
            /*  CHGATR OBJ('/INVOICES/TO/MYFILE.TXT') ATR(*CCSID) VALUE(819) */
            /*  STRQSH CMD('SETCCSID 819 /INVOICES/TO/MYFILE.TXT')           */
                CHGJOB     CCSID(1141)
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(&LINK) VALUE(('/EINVOICE/Out') *TCAT '/')
                CHGVAR     VAR(&OBJ) VALUE(%SST(&#GXSLNK 02 35))
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(&NEWOBJ) VALUE(&OBJ)
                CHGVAR     VAR(&FROMSTMF) VALUE(&LINK *TCAT &OBJ)
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(&TOMBR) +
                          VALUE('/QSYS.LIB/TVRELWAECO.LIB/GXSSCAN.F+
                          ILE/' *TCAT 'GXSSCAN' *TCAT '.MBR')
                MONMSG     MSGID(CPF0000)

                CLRPFM     FILE(TVRELWAECO/TESTXML)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(TVRELWAECO/GXS_XMLIN)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(TVRELWAECO/GXS_XMLOUT)
                MONMSG     MSGID(CPF0000)


          /*    CPYFRMSTMF FROMSTMF(&FROMSTMF) TOMBR(&TOMBR) +      */
          /*              MBROPT(*REPLACE) CVTDTA(*AUTO) +          */
          /*              STMFCCSID(*STMF)         +                */
          /*       DBFCCSID(*FILE) ENDLINFMT(*CR) TABEXPN(*NO)      */
          /*    MONMSG     MSGID(CPF0000)                           */


             CPYFRMIMPF FROMSTMF(&FROMSTMF) +
                          TOFILE(TVRELWAECO/GXS_XMLIN) +
                          MBROPT(*REPLACE) TOCCSID(1208) RCDDLM(*CRLF)
                MONMSG     MSGID(CPF0000)


                CHGVAR     VAR(&LINK) VALUE(('/EINVOICE/GXSScan') *TCAT '/')
                CHGVAR     VAR(&TOSTMF) VALUE(&LINK *TCAT &OBJ)
                MONMSG     MSGID(CPF0000)

/*             UPDATE  GXSSCAN = ''%<PROCESS> />%''       */
/*             FILE:   GXS_XMLIN                          */
                CALL       PGM(DUMMY512) PARM(&MD 'GXS0002' ' ' ' ' +
                              '  '  '  ' ' ')
                MONMSG     MSGID(CPF0000)

/*             UPDATE  GXSSCAN = ''AB STELLE 256 INHALTE LÖSCHEN''   */
/*             RRN(3)                                                */
/*             FILE:   GXS_XMLIN                          */
                CALL       PGM(DUMMY512) PARM(&MD 'GXS0003' ' ' ' ' +
                              '  '  '  ' ' ')
                MONMSG     MSGID(CPF0000)

/*             UPDATE  GXSSCAN = 'LESEN BIS RRN < (5)           ''   */
/*             FILE:   GXS_XMLIN  ==> GXS_XMLOUT          */
                CALL       PGM(DUMMY512) PARM(&MD 'GXS0004' ' ' ' ' +
                              'GXS_XMLOUT'  'TVRELWAECO' '*ADD')
                MONMSG     MSGID(CPF0000)

/*             UPDATE  GXSSCAN = ''RRN 4 ÄNDERN AUF APPLICATIONAREA' */
/*             FILE:   GXS_XMLOUT                         */
                CALL       PGM(DUMMY512) PARM(&MD 'GXS0006' ' ' ' ' +
                              '  '  '  ' ' ')
                MONMSG     MSGID(CPF0000)

/*             UPDATE  GXSSCAN = 'LESEN BIS RRN > (3) UND       ''   */
/*             >(SELECT SEL1 FROM QTEMP/GXS_RRN)                ''   */
/*             FILE:   GXS_XMLIN  ==> GXS_XMLOUT          */
                CALL       PGM(DUMMY512) PARM(&MD 'GXS0007' ' ' ' ' +
                              'GXS_XMLOUT'  'TVRELWAECO' '*ADD')
                MONMSG     MSGID(CPF0000)

                CLRPFM     FILE(QTEMP/GXS_RRN)
                MONMSG     MSGID(CPF0000)
/*             UPDATE  GXSSCAN = '<CHARGE CHARGETYPE ERSTEN SATZ ERKENNEN' */
/*             .... UND                                         */
/*             FILE:   GXS_XMLIN  ==> GXS_RRN (RRN)=SEL1  */
                CALL       PGM(DUMMY512) PARM(&MD 'GXS0008' ' ' ' ' +
                              'GXS_RRN'  'QTEMP' '*REPLACE')
                MONMSG     MSGID(CPF0000)
/*             .... UND  AUSGABE IN GXS_XMLOUT                  */
                CALL       PGM(DUMMY512) PARM(&MD 'GXS0009' ' ' ' ' +
                              'GXS_XMLOUT'  'TVRELWAECO' '*ADD')
                MONMSG     MSGID(CPF0000)
/*             .... UND  2. SATZ EBENFALLS MIT KORREKTUR       */
                CALL       PGM(DUMMY512) PARM(&MD 'GXS0010' ' ' ' ' +
                              'GXS_XMLOUT'  'TVRELWAECO' '*ADD')
                MONMSG     MSGID(CPF0000)

/*             GESAMTEN REST IN AUSGABE                         ''   */
/*             > WHERE RRN(GXS_XMLIN) >(SELECT SEL1 FROM QTEMP/GXS_RRN) */
/*             FILE:   GXS_XMLIN  ==> GXS_XMLOUT          */
                CALL       PGM(DUMMY512) PARM(&MD 'GXS0011' ' ' ' ' +
                              'GXS_XMLOUT'  'TVRELWAECO' '*ADD')
                MONMSG     MSGID(CPF0000)
                OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/GXS_STREAM) +
                          MBR(GXS_STREAM) OVRSCOPE(*JOB)
                MONMSG     MSGID(CPF0000)
                CALL       PGM(DUMMY512) PARM(&MD 'GXS0012' ' ' ' ' +
                              'INPUT'  'TVRELWAECO' '*REPLACE')
                MONMSG     MSGID(CPF0000)



/*             ALT STMFCCSID(*STMF)                       */
/*             ORIGINALE HABEN 819                        */
       /*    QSYS/CPYTOIMPF FROMFILE(TVRELWAECO/GXS_XMLOUT) +    */
       /*                 TOSTMF(&TOSTMF) MBROPT(*REPLACE) +     */
       /*                 FROMCCSID(819) STMFCCSID(819) +        */
       /*                 RCDDLM(*CRLF) DTAFMT(*DLM) STRDLM('') +*/
       /*                 RMVBLANK(*NONE)                        */

             QSYS/CPYTOSTMF +
                          FROMMBR('/QSYS.LIB/TVRELWAECO.LIB/GXS_STREA+
                          M.FILE/GXS_STREAM.MBR') TOSTMF(&TOSTMF) +
                          STMFOPT(*REPLACE) CVTDTA(*AUTO) +
                          DBFCCSID(*FILE) STMFCODPAG(819)


                CHGJOB     CCSID(65535)
                MONMSG     MSGID(CPF0000)

             MONMSG     MSGID(CPF0000)

/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('ENDE ')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CHGVAR     VAR(%SST(&MD 100 05)) VALUE('GXS: ')
             CHGVAR     VAR(%SST(&MD 106 22)) VALUE(&OBJ)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

     /*         RNM        OBJ(&OBJ) NEWOBJ(&NEWOBJ)    */
     /*         MONMSG     MSGID(CPF0000)               */
     /*         RMVLNK     OBJLNK(&OBJ)                 */
     /*         MONMSG     MSGID(CPF0000)               */
             ENDDO

             GOTO LOOP
 LOOPENDE:

/*                                                                            */
 ENDPGM:
      /*     CHGVAR     VAR(&SC) VALUE(0000002)   */
      /*     CALL       PGM(ORDERR) PARM(&SC)     */

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
             CHGJOB     CCSID(65535)
             MONMSG     MSGID(CPF0000)

             ENDPGM
