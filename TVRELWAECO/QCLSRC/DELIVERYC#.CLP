/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:DELIVERYC                                              */
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

/*          MONMSG     MSGID(CPF0000)                                     */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('DELIVERYC ')
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

       /*    GOTO       CMDLBL(ITSE)     */
       /*    GOTO       CMDLBL(ITIT)     */
       /*    GOTO       CMDLBL(REPEAT)   */
       /*    GOTO       CMDLBL(DB_OPT_JQ)*/

             CALL  TRACKINGR
             MONMSG     MSGID(CPF0000)

/*          DATA BASE ONE                                                    */
             CLRPFM     FILE(#DP0050)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(#DP0051)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(#DP0052)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(#DP0053)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(#DP0054)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(#DP0055)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(#WAO8)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(PURCHASING)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(PURCHWAE)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(B2BTRACKER)
             MONMSG     MSGID(CPF0000)

/*          DATA BASE TWO                                                    */
             CLRPFM     FILE(#DP0060)
             MONMSG     MSGID(CPF0000)

             CPYF       FROMFILE(TVRELWAECO/DB_TWO_PER) +
                          TOFILE(TVRELWAECO/DB_TWO_PE#) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(DB_TWO_PER)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(DB_INV_PER)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(#DP0060INV)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(TVRELWAECO/DB_SPED_SC)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(TVRELWAECO/DB_SPED)
             MONMSG     MSGID(CPF0000)

/*          PERFORMANCE-FILE                                                 */
  /*         CALL DELIVERYR                            */
  /*         MONMSG     MSGID(CPF0000)                 */
             CALL       #DP0050
             MONMSG     MSGID(CPF0000)
             CALL DELIVERYR2
             MONMSG     MSGID(CPF0000)
             DSPJOBLOG  OUTPUT(*PRINT)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
       /*   *** HISTORIE ABGLEICHEN NOTES AUF # SETZEN                       */
             CALL    PGM(DUMMY512) PARM(&MD '#DC6220' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CALL       PGM(DUMMY512) PARM(&MD '#DC6621' ' ' ' ' +
                           '#DC6621   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*                                                                            */
       /*   *** ÜBERGABE DB_TWO_PER                                          */
             RMVLNK     OBJLNK('/SALESCOMPANY/PER/DB_TWO_PER.CSV')
             MONMSG     MSGID(CPF0000)
          CVTDBF     OBJ('/SALESCOMPANY/PER/DB_TWO_PER.CSV') +
                       DBFILE(TVRELWAECO/DB_TWO_PER) DBOUTFMT(*CSV)
          MONMSG     MSGID(CPF0000)
             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                    FORMTYPE('DB_TWO_PER') OVRSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)

       /*   *** INVOICES CURRENT DATE -31 DAYS !!!!!!!!!!!!!                 */
             CALL DELIVERYR3
             MONMSG     MSGID(CPF0000)
             CALL DELIVERYR4
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             RMVLNK     OBJLNK('/SALESCOMPANY/PER/DB_INV_PER.CSV')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/SALESCOMPANY/PER/DB_INV_PER.CSV') +
                          DBFILE(TVRELWAECO/DB_INV_PER) DBOUTFMT(*CSV)
             MONMSG     MSGID(CPF0000)
             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                    FORMTYPE('DB_INV_PER') OVRSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)

/*                                                                            */
       /*   *** PURCHASING                                                   */
       /*   *** PURCHWAE                                                     */
             CALL DELIVERYR7
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             RMVLNK     OBJLNK('/SALESCOMPANY/PER/PURCHASING.CSV')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/SALESCOMPANY/PURCHASING.CSV') +
                          DBFILE(TVRELWAECO/PURCHASING) +
                          DBOUTFMT(*CSV) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             RMVLNK     OBJLNK('/SALESCOMPANY/PER/PURCHWAE.CSV')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/SALESCOMPANY/PURCHWAE.CSV') +
                          DBFILE(TVRELWAECO/PURCHWAE) +
                          DBOUTFMT(*CSV) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                    FORMTYPE('PURCHASING') OVRSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
 /* REPEAT: */
       /*   *** PACKAGES   UK                                                */
             CLRPFM     FILE(PACKAGES)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CALL       PGM(DELIVERYR5) PARM('040631')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DELIVERYR6)
             MONMSG     MSGID(CPF0000)
             RMVLNK     OBJLNK('/SALESCOMPANY/UK/PACKAGES.CSV')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/SALESCOMPANY/UK/PACKAGES.CSV') +
                          DBFILE(TVRELWAECO/PACKAGES) +
                          DBOUTFMT(*CSV) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                    FORMTYPE('DB_SPED_UK') OVRSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CALL       PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(PACKAGECMD)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(PACKAGELOG)
             MONMSG     MSGID(CPF0000)
             CD         DIR('.')
             MONMSG     MSGID(CPF0000)
             CD         DIR('.')
             MONMSG     MSGID(CPF0000)
             CALL     PGM(DUMMY512) PARM(&MD '#DC0117' ' ' ' ' ' ' +
                       ' ' ' ')
             CHGVAR     VAR(%SST(&MD 01 15)) VALUE('UK/PACKAGES.CSV')
             CHGVAR     VAR(%SST(&MD 16 15)) VALUE('               ')
             CALL     PGM(DUMMY512) PARM(&MD '#DC0150' ' ' ' ' ' ' +
                       ' ' ' ')
             CALL     PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +
                  'OUTPUT    '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)

             FTP        RMTSYS('DOMETIC-GROUP.COM')
             CHGCURLIB  CURLIB(*CRTDFT)
             DLTOVR     FILE(INPUT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(OUTPUT)
             MONMSG     MSGID(CPF0000)

       /*   *** PACKAGES   DK                                                */
             CLRPFM     FILE(PACKAGES)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CALL       PGM(DELIVERYR5) PARM('001887')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DELIVERYR6)
             MONMSG     MSGID(CPF0000)
             RMVLNK     OBJLNK('/SALESCOMPANY/DK/PACKAGES.CSV')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/SALESCOMPANY/DK/PACKAGES.CSV') +
                          DBFILE(TVRELWAECO/PACKAGES) +
                          DBOUTFMT(*CSV) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             RMVLNK     OBJLNK('/SALESCOMPANY/DK/PACKAGES.TXT')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/SALESCOMPANY/DK/PACKAGES.TXT') +
                          DBFILE(TVRELWAECO/PACKAGES) +
                          DBOUTFMT(*CSV) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/SALESCOMPANY/DK/PACKAGES.TXT') +
                          DBFILE(TVRELWAECO/PACKAGES) +
                          DBOUTFMT(*TXT) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                    FORMTYPE('DB_SPED_DK') OVRSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CALL       PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(PACKAGECM2)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(PACKAGELOG)
             MONMSG     MSGID(CPF0000)
             CD         DIR('.')
             MONMSG     MSGID(CPF0000)
             CD         DIR('.')
             MONMSG     MSGID(CPF0000)
             CALL     PGM(DUMMY512) PARM(&MD '#DC0115' ' ' ' ' ' ' +
                       ' ' ' ')
             CHGVAR     VAR(%SST(&MD 01 15)) VALUE('DK/PACKAGES.CSV')
             CHGVAR     VAR(%SST(&MD 16 15)) VALUE('               ')
             CALL     PGM(DUMMY512) PARM(&MD '#DC0151' ' ' ' ' ' ' +
                       ' ' ' ')
             CHGVAR     VAR(%SST(&MD 01 15)) VALUE('DK/PACKAGES.TXT')
             CHGVAR     VAR(%SST(&MD 16 15)) VALUE('               ')
             CALL     PGM(DUMMY512) PARM(&MD '#DC0151' ' ' ' ' ' ' +
                       ' ' ' ')
             CALL     PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +
                  'OUTPUT    '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
             FTP        RMTSYS('DOMETIC-GROUP.COM')
             CHGCURLIB  CURLIB(*CRTDFT)
             DLTOVR     FILE(INPUT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(OUTPUT)
             MONMSG     MSGID(CPF0000)


       /*   *** PACKAGES   ES                                                */
             CLRPFM     FILE(PACKAGES)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CALL       PGM(DELIVERYR5) PARM('078146')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DELIVERYR6)
             MONMSG     MSGID(CPF0000)
             RMVLNK     OBJLNK('/SALESCOMPANY/ES/PACKAGES.CSV')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/SALESCOMPANY/ES/PACKAGES.CSV') +
                          DBFILE(TVRELWAECO/PACKAGES) +
                          DBOUTFMT(*CSV) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                    FORMTYPE('DB_SPED_ES') OVRSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CALL       PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(PACKAGECMD)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(PACKAGELOG)
             MONMSG     MSGID(CPF0000)
             CD         DIR('.')
             MONMSG     MSGID(CPF0000)
             CD         DIR('.')
             MONMSG     MSGID(CPF0000)
             CALL     PGM(DUMMY512) PARM(&MD '#DC0105' ' ' ' ' ' ' +
                       ' ' ' ')
             CHGVAR     VAR(%SST(&MD 01 15)) VALUE('ES/PACKAGES.CSV')
             CHGVAR     VAR(%SST(&MD 16 15)) VALUE('               ')
             CALL     PGM(DUMMY512) PARM(&MD '#DC0150' ' ' ' ' ' ' +
                       ' ' ' ')

             CALL     PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +
                  'OUTPUT    '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
             FTP        RMTSYS('DOMETIC-GROUP.COM')
             CHGCURLIB  CURLIB(*CRTDFT)
             DLTOVR     FILE(INPUT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(OUTPUT)
             MONMSG     MSGID(CPF0000)


       /*   *** PACKAGES   IT                                                */
 /* ITIT: */
             CLRPFM     FILE(PACKAGES)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CALL       PGM(DELIVERYR5) PARM('055278')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DELIVERYR6)
             MONMSG     MSGID(CPF0000)
             RMVLNK     OBJLNK('/SALESCOMPANY/IT/PACKAGES.CSV')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/SALESCOMPANY/IT/PACKAGES.CSV') +
                          DBFILE(TVRELWAECO/PACKAGES) +
                          DBOUTFMT(*CSV) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                    FORMTYPE('DB_SPED_IT') OVRSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CALL       PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(PACKAGECMD)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(PACKAGELOG)
             MONMSG     MSGID(CPF0000)
             CD         DIR('.')
             MONMSG     MSGID(CPF0000)
             CD         DIR('.')
             MONMSG     MSGID(CPF0000)
             CALL     PGM(DUMMY512) PARM(&MD '#DC0103' ' ' ' ' ' ' +
                       ' ' ' ')
             CHGVAR     VAR(%SST(&MD 01 15)) VALUE('IT/PACKAGES.CSV')
             CHGVAR     VAR(%SST(&MD 16 15)) VALUE('               ')
             CALL     PGM(DUMMY512) PARM(&MD '#DC0150' ' ' ' ' ' ' +
                       ' ' ' ')
             CALL     PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +
                  'OUTPUT    '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
             FTP        RMTSYS('DOMETIC-GROUP.COM')
             CHGCURLIB  CURLIB(*CRTDFT)
             DLTOVR     FILE(INPUT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(OUTPUT)
             MONMSG     MSGID(CPF0000)

       /*   *** PACKAGES   NL                                                */
             CLRPFM     FILE(PACKAGES)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CALL       PGM(DELIVERYR5) PARM('015177')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DELIVERYR6)
             MONMSG     MSGID(CPF0000)
             RMVLNK     OBJLNK('/SALESCOMPANY/NL/PACKAGES.CSV')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/SALESCOMPANY/NL/PACKAGES.CSV') +
                          DBFILE(TVRELWAECO/PACKAGES) +
                          DBOUTFMT(*CSV) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                    FORMTYPE('DB_SPED_NL') OVRSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             RTVMBRD    FILE(TVRELWAECO/PACKAGES) NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)
             IF         COND(&NBRCURRCD *GT 0) THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)
             ENDDO
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(PACKAGECMD)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(PACKAGELOG)
             MONMSG     MSGID(CPF0000)
             CD         DIR('.')
             MONMSG     MSGID(CPF0000)
             CD         DIR('.')
             MONMSG     MSGID(CPF0000)
             CALL     PGM(DUMMY512) PARM(&MD '#DC0121' ' ' ' ' ' ' +
                       ' ' ' ')
             CHGVAR     VAR(%SST(&MD 01 15)) VALUE('NL/PACKAGES.CSV')
             CHGVAR     VAR(%SST(&MD 16 15)) VALUE('               ')
             CALL     PGM(DUMMY512) PARM(&MD '#DC0150' ' ' ' ' ' ' +
                       ' ' ' ')
             CALL     PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +
                  'OUTPUT    '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
             FTP        RMTSYS('DOMETIC-GROUP.COM')
             CHGCURLIB  CURLIB(*CRTDFT)
             DLTOVR     FILE(INPUT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(OUTPUT)
             MONMSG     MSGID(CPF0000)

       /*   *** PACKAGES   BE                                                */
             CLRPFM     FILE(PACKAGES)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CALL       PGM(DELIVERYR5) PARM('062765')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DELIVERYR6)
             MONMSG     MSGID(CPF0000)
             RMVLNK     OBJLNK('/SALESCOMPANY/BE/PACKAGES.CSV')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/SALESCOMPANY/BE/PACKAGES.CSV') +
                          DBFILE(TVRELWAECO/PACKAGES) +
                          DBOUTFMT(*CSV) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                    FORMTYPE('DB_SPED_BE') OVRSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             RTVMBRD    FILE(TVRELWAECO/PACKAGES) NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)
             IF         COND(&NBRCURRCD *GT 0) THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)
             ENDDO
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(PACKAGECMD)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(PACKAGELOG)
             MONMSG     MSGID(CPF0000)
             CD         DIR('.')
             MONMSG     MSGID(CPF0000)
             CD         DIR('.')
             MONMSG     MSGID(CPF0000)
             CALL     PGM(DUMMY512) PARM(&MD '#DC0123' ' ' ' ' ' ' +
                       ' ' ' ')
             CHGVAR     VAR(%SST(&MD 01 15)) VALUE('BE/PACKAGES.CSV')
             CHGVAR     VAR(%SST(&MD 16 15)) VALUE('               ')
             CALL     PGM(DUMMY512) PARM(&MD '#DC0150' ' ' ' ' ' ' +
                       ' ' ' ')
             CALL     PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +
                  'OUTPUT    '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
             FTP        RMTSYS('DOMETIC-GROUP.COM')
             CHGCURLIB  CURLIB(*CRTDFT)
             DLTOVR     FILE(INPUT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(OUTPUT)
             MONMSG     MSGID(CPF0000)

/*                                                                            */
       /*   *** PACKAGES   RU                                                */
             CLRPFM     FILE(PACKAGES)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CALL       PGM(DELIVERYR5) PARM('191453')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DELIVERYR6)
             MONMSG     MSGID(CPF0000)
             RMVLNK     OBJLNK('/SALESCOMPANY/RU/PACKAGES.CSV')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/SALESCOMPANY/RU/PACKAGES.CSV') +
                          DBFILE(TVRELWAECO/PACKAGES) +
                          DBOUTFMT(*CSV) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                    FORMTYPE('DB_SPED_RU') OVRSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             RTVMBRD    FILE(TVRELWAECO/PACKAGES) NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)
             IF         COND(&NBRCURRCD *GT 0) THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)
             ENDDO
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(PACKAGECMD)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(PACKAGELOG)
             MONMSG     MSGID(CPF0000)
             CD         DIR('.')
             MONMSG     MSGID(CPF0000)
             CD         DIR('.')
             MONMSG     MSGID(CPF0000)
             CALL     PGM(DUMMY512) PARM(&MD '#DC0119' ' ' ' ' ' ' +
                       ' ' ' ')
             CHGVAR     VAR(%SST(&MD 01 15)) VALUE('RU/PACKAGES.CSV')
             CHGVAR     VAR(%SST(&MD 16 15)) VALUE('               ')
             CALL     PGM(DUMMY512) PARM(&MD '#DC0150' ' ' ' ' ' ' +
                       ' ' ' ')
             CALL     PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +
                  'OUTPUT    '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
             FTP        RMTSYS('DOMETIC-GROUP.COM')
             CHGCURLIB  CURLIB(*CRTDFT)
             DLTOVR     FILE(INPUT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(OUTPUT)
             MONMSG     MSGID(CPF0000)

       /*   *** PACKAGES   AT                                                */
             CLRPFM     FILE(PACKAGES)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CALL       PGM(DELIVERYR5) PARM('054939')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DELIVERYR6)
             MONMSG     MSGID(CPF0000)
             RMVLNK     OBJLNK('/SALESCOMPANY/AT/PACKAGES.CSV')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/SALESCOMPANY/AT/PACKAGES.CSV') +
                          DBFILE(TVRELWAECO/PACKAGES) +
                          DBOUTFMT(*CSV) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                    FORMTYPE('DB_SPED_AT') OVRSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CALL       PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(PACKAGECMD)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(PACKAGELOG)
             MONMSG     MSGID(CPF0000)
             CD         DIR('.')
             MONMSG     MSGID(CPF0000)
             CD         DIR('.')
             MONMSG     MSGID(CPF0000)
             CALL     PGM(DUMMY512) PARM(&MD '#DC0113' ' ' ' ' ' ' +
                       ' ' ' ')
             CHGVAR     VAR(%SST(&MD 01 15)) VALUE('AT/PACKAGES.CSV')
             CHGVAR     VAR(%SST(&MD 16 15)) VALUE('               ')
             CALL     PGM(DUMMY512) PARM(&MD '#DC0150' ' ' ' ' ' ' +
                       ' ' ' ')
             CALL     PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +
                  'OUTPUT    '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
             FTP        RMTSYS('DOMETIC-GROUP.COM')
             CHGCURLIB  CURLIB(*CRTDFT)
             DLTOVR     FILE(INPUT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(OUTPUT)
             MONMSG     MSGID(CPF0000)



       /*   *** PACKAGES   IT 2                                              */
 /* ITIT2:*/
             CLRPFM     FILE(PACKAGES)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CALL       PGM(DELIVERYR5) PARM('035671')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DELIVERYR6)
             MONMSG     MSGID(CPF0000)
             RMVLNK     OBJLNK('/SALESCOMPANY/IT2/PACKAGES.CSV')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/SALESCOMPANY/IT2/PACKAGES.CSV') +
                          DBFILE(TVRELWAECO/PACKAGES) +
                          DBOUTFMT(*CSV) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                    FORMTYPE('DB_SPED_I2') OVRSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CALL       PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(PACKAGECMD)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(PACKAGELOG)
             MONMSG     MSGID(CPF0000)
             CD         DIR('.')
             MONMSG     MSGID(CPF0000)
             CD         DIR('.')
             MONMSG     MSGID(CPF0000)
             CALL     PGM(DUMMY512) PARM(&MD '#DC0141' ' ' ' ' ' ' +
                       ' ' ' ')
             CHGVAR     VAR(%SST(&MD 01 16)) VALUE('IT2/PACKAGES.CSV')
             CHGVAR     VAR(%SST(&MD 17 14)) VALUE('               ')
             CALL     PGM(DUMMY512) PARM(&MD '#DC0150' ' ' ' ' ' ' +
                       ' ' ' ')
             CALL     PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +
                  'OUTPUT    '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
             FTP        RMTSYS('DOMETIC-GROUP.COM')
             CHGCURLIB  CURLIB(*CRTDFT)
             DLTOVR     FILE(INPUT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(OUTPUT)
             MONMSG     MSGID(CPF0000)



       /*   *** PACKAGES   SCHWEDEN  008138                                  */
/*  ITSE: */
             CLRPFM     FILE(PACKAGES)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(PACKAGESII)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CALL       PGM(DELIVERYR5) PARM('008138')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DELIVERYR6)
             MONMSG     MSGID(CPF0000)
             RMVLNK     OBJLNK('/SALESCOMPANY/SE/PACKAGES.CSV')
             MONMSG     MSGID(CPF0000)
             RMVLNK     OBJLNK('/SALESCOMPANY/SE/PACKAGESII.CSV')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/SALESCOMPANY/SE/PACKAGES.CSV') +
                          DBFILE(TVRELWAECO/PACKAGES) +
                          DBOUTFMT(*CSV) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/SALESCOMPANY/SE/PACKAGESII.CSV') +
                          DBFILE(TVRELWAECO/PACKAGESII) +
                          DBOUTFMT(*CSV) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                    FORMTYPE('DB_SPED_SE')
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CALL       PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(PACKAGECMD)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(PACKAGELOG)
             MONMSG     MSGID(CPF0000)
             CD         DIR('.')
             MONMSG     MSGID(CPF0000)
             CD         DIR('.')
             MONMSG     MSGID(CPF0000)
             CALL     PGM(DUMMY512) PARM(&MD '#DC0143' ' ' ' ' ' ' +
                       ' ' ' ')
             CHGVAR     VAR(%SST(&MD 01 16)) VALUE('SE/PACKAGES.CSV')
             CHGVAR     VAR(%SST(&MD 17 14)) VALUE('               ')
             CALL     PGM(DUMMY512) PARM(&MD '#DC0150' ' ' ' ' ' ' +
                       ' ' ' ')
             CALL     PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +
                  'OUTPUT    '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
             FTP        RMTSYS('DOMETIC-GROUP.COM')
             CHGCURLIB  CURLIB(*CRTDFT)
             DLTOVR     FILE(INPUT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(OUTPUT)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(PACKAGECMD)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(PACKAGELOG)
             MONMSG     MSGID(CPF0000)
             CALL     PGM(DUMMY512) PARM(&MD '#DC0143' ' ' ' ' ' ' +
                       ' ' ' ')
             CHGVAR     VAR(%SST(&MD 01 18)) VALUE('SE/PACKAGESII.CSV')
             CHGVAR     VAR(%SST(&MD 19 12)) VALUE('               ')
             CALL     PGM(DUMMY512) PARM(&MD '#DC0150' ' ' ' ' ' ' +
                       ' ' ' ')
             CALL     PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +
                  'OUTPUT    '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
             FTP        RMTSYS('DOMETIC-GROUP.COM')
             CHGCURLIB  CURLIB(*CRTDFT)
             DLTOVR     FILE(INPUT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(OUTPUT)
             MONMSG     MSGID(CPF0000)


             DSPJOBLOG  OUTPUT(*PRINT)
       /*   *** PACKAGES   D365 TEST 005084  FINNLAND                       */


  /*         CLRPFM     FILE(DB_SPED_SC)          */
  /*         MONMSG     MSGID(CPF0000)            */
             CLRPFM     FILE(PACKAGES)
             MONMSG     MSGID(CPF0000)
   /*        CALL       DELIVERYR_                  */
   /*        CALL       DELIVERYR3                  */
   /*        MONMSG     MSGID(CPF0000)              */
/*                                                                            */
       /*    CALL       PGM(DELIVERYR5) PARM('900000')    */
             CALL       PGM(DELIVERYR5) PARM('005084')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DELIVERYR6)
             MONMSG     MSGID(CPF0000)
             RMVLNK     OBJLNK('/SALESCOMPANY/FI/PACKAGES.CSV')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/SALESCOMPANY/FI/PACKAGES.CSV') +
                          DBFILE(TVRELWAECO/PACKAGES) +
                          DBOUTFMT(*CSV) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                    FORMTYPE('DB_SPED_SE') OVRSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CALL       PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(PACKAGECMD)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(PACKAGELOG)
             MONMSG     MSGID(CPF0000)
             CD         DIR('.')
             MONMSG     MSGID(CPF0000)
             CD         DIR('.')
             MONMSG     MSGID(CPF0000)
             CALL     PGM(DUMMY512) PARM(&MD '#DC0135' ' ' ' ' ' ' +
                       ' ' ' ')
             CHGVAR     VAR(%SST(&MD 01 16)) VALUE('FI/PACKAGES.CSV')
             CHGVAR     VAR(%SST(&MD 17 14)) VALUE('               ')
             CALL     PGM(DUMMY512) PARM(&MD '#DC0150' ' ' ' ' ' ' +
                       ' ' ' ')
             CALL     PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +
                  'OUTPUT    '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
             FTP        RMTSYS('DOMETIC-GROUP.COM')
             CHGCURLIB  CURLIB(*CRTDFT)
             DLTOVR     FILE(INPUT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(OUTPUT)
             MONMSG     MSGID(CPF0000)

       /*   *** PACKAGES   D365 TEST 042634  NORWEGEN                       */

       /*    CALL       #DP0050                   */
       /*    MONMSG     MSGID(CPF0000)            */
     /*      CLRPFM     FILE(DB_SPED_SC)            */
     /*      MONMSG     MSGID(CPF0000)              */
             CLRPFM     FILE(PACKAGES)
             MONMSG     MSGID(CPF0000)
   /*        CALL       DELIVERYR_                  */
   /*        CALL       DELIVERYR3                  */
   /*        MONMSG     MSGID(CPF0000)              */
/*                                                                            */
       /*    CALL       PGM(DELIVERYR5) PARM('900000')    */
             CALL       PGM(DELIVERYR5) PARM('042634')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DELIVERYR6)
             MONMSG     MSGID(CPF0000)
             RMVLNK     OBJLNK('/SALESCOMPANY/NO/PACKAGES.CSV')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/SALESCOMPANY/NO/PACKAGES.CSV') +
                          DBFILE(TVRELWAECO/PACKAGES) +
                          DBOUTFMT(*CSV) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                    FORMTYPE('DB_SPED_SE') OVRSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             CALL       PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(PACKAGECMD)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +
                        MBR(PACKAGELOG)
             MONMSG     MSGID(CPF0000)
             CD         DIR('.')
             MONMSG     MSGID(CPF0000)
             CD         DIR('.')
             MONMSG     MSGID(CPF0000)
             CALL     PGM(DUMMY512) PARM(&MD '#DC0109' ' ' ' ' ' ' +
                       ' ' ' ')
             CHGVAR     VAR(%SST(&MD 01 16)) VALUE('NO/PACKAGES.CSV')
             CHGVAR     VAR(%SST(&MD 17 14)) VALUE('               ')
             CALL     PGM(DUMMY512) PARM(&MD '#DC0150' ' ' ' ' ' ' +
                       ' ' ' ')
             CALL     PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +
                  'OUTPUT    '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
             FTP        RMTSYS('DOMETIC-GROUP.COM')
             CHGCURLIB  CURLIB(*CRTDFT)
             DLTOVR     FILE(INPUT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(OUTPUT)
             MONMSG     MSGID(CPF0000)
/*                                                                            */


       /*   *** PACKAGES   D365 TEST 900000                                  */
 /* ITSE: */
   /*        CLRPFM     FILE(PACKAGES)                                       */
   /*        MONMSG     MSGID(CPF0000)                                       */
/* /*                                                                        */
   /*        CALL       PGM(DELIVERYR5) PARM('900000')                       */
   /*        MONMSG     MSGID(CPF0000)                                       */
   /*        CALL       PGM(DELIVERYR6)                                      */
   /*        MONMSG     MSGID(CPF0000)                                       */
   /*        RMVLNK     OBJLNK('/SALESCOMPANY/SE/PACKAGES.CSV')              */
   /*        MONMSG     MSGID(CPF0000)                                       */
   /*        CVTDBF     OBJ('/SALESCOMPANY/SE/PACKAGES.CSV') +               */
   /*                     DBFILE(TVRELWAECO/PACKAGES) +                      */
   /*                     DBOUTFMT(*CSV) DBFLDDSC(*YES)                      */
   /*        MONMSG     MSGID(CPF0000)                                       */
   /*        OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +              */
   /*               FORMTYPE('DB_SPED_SE') OVRSCOPE(*JOB)                    */
   /*        MONMSG     MSGID(CPF0000)                                       */
   /*                                                                        */
   /*        CALL       PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +       */
   /*                     ' ' ' ' ' ')                                       */
   /*        MONMSG     MSGID(CPF0000)                                       */
   /*        DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)                            */
   /*        MONMSG     MSGID(CPF0000)                                       */
   /*                                                                        */
   /*        OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +              */
   /*                   MBR(PACKAGECMD)                                      */
   /*        MONMSG     MSGID(CPF0000)                                       */
   /*        OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +             */
   /*                   MBR(PACKAGELOG)                                      */
   /*        MONMSG     MSGID(CPF0000)                                       */
   /*        CD         DIR('.')                                             */
   /*        MONMSG     MSGID(CPF0000)                                       */
   /*        CD         DIR('.')                                             */
   /*        MONMSG     MSGID(CPF0000)                                       */
   /*        CALL     PGM(DUMMY512) PARM(&MD '#DC0143' ' ' ' ' ' ' +         */
   /*                  ' ' ' ')                                              */
   /*        CHGVAR     VAR(%SST(&MD 01 16)) VALUE('SE/PACKAGES.CSV')        */
   /*        CHGVAR     VAR(%SST(&MD 17 14)) VALUE('               ')        */
   /*        CALL     PGM(DUMMY512) PARM(&MD '#DC0150' ' ' ' ' ' ' +         */
   /*                  ' ' ' ')                                              */
   /*        CALL     PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +             */
   /*             'OUTPUT    '  'TVRELWAECO' '*ADD')                         */
   /*        MONMSG     MSGID(CPF0000)                                       */
  /*         FTP        RMTSYS('DOMETIC-GROUP.COM')                          */
   /*        CHGCURLIB  CURLIB(*CRTDFT)                                      */
   /*        DLTOVR     FILE(INPUT)                                          */
   /*        MONMSG     MSGID(CPF0000)                                       */
   /*        DLTOVR     FILE(OUTPUT)                                         */
   /*        MONMSG     MSGID(CPF0000)                                       */

      /*     GOTO   ENDPGM   */
/*                                                                            */
       /*   *** DB_WAE130                                                    */
       /*   *** BUCHUNGEN  ERWEITERUNG DER PER- INVOICE DATEI                */
/*                                                                            */
 XF:
       /*    CLRPFM     FILE(DB_WAE130)                            */
       /*    MONMSG     MSGID(CPF0000)                             */
       /*    CALL DELIVERYR9                                       */
       /*    MONMSG     MSGID(CPF0000)                             */
/*                                                                            */
       /*    RMVLNK     OBJLNK('/SALESCOMPANY/PER/DB_WAE130.CSV')  */
       /*    MONMSG     MSGID(CPF0000)                             */
       /*    CVTDBF     OBJ('/SALESCOMPANY/PER/DB_WAE130.CSV') +   */
       /*                 DBFILE(TVRELWAECO/DB_WAE130) +           */
       /*                 DBOUTFMT(*CSV) DBFLDDSC(*YES)            */
       /*    MONMSG     MSGID(CPF0000)                             */
       /*    OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +    */
       /*           FORMTYPE('DB_WAE130') OVRSCOPE(*JOB)           */
       /*    MONMSG     MSGID(CPF0000)                             */
       /*    CALL   PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' + */
       /*                 ' ' ' ' ' ')                             */
       /*    MONMSG     MSGID(CPF0000)                             */
       /*                                                          */
       /*    DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)                  */
       /*    MONMSG     MSGID(CPF0000)                             */
/*                                                                            */
       /*   *** PATRIK LUNDQUIST                                             */
       /*   *** TVRELWAECO/SIEVOII                                           */

             CALL       PGM(DUMMY512) PARM(&MD '#DB0010' ' ' ' ' +
                           '##_OPTIMUM'  'TVRELWAECO' '*REPLACE')
             MONMSG     MSGID(CPF0000)

             CLRPFM TVRELWAECO/DB_OPTLFR2
             MONMSG     MSGID(CPF0000)

             CLRPFM TVRELWAECO/DB_OPTLFR3
             MONMSG     MSGID(CPF0000)

             CLRPFM TVRELWAECO/DB_OPTLFR6
             MONMSG     MSGID(CPF0000)

             CLRPFM TVRELWAECO/DB_OPTWEEK
             MONMSG     MSGID(CPF0000)

             CLRPFM TVRELWAECO/DB_OPTWEE2
             MONMSG     MSGID(CPF0000)

             CLRPFM TVRELWAECO/DB_OPTWEE3
             MONMSG     MSGID(CPF0000)

             CLRPFM TVRELWAECO/DB_OPTWEE4
             MONMSG     MSGID(CPF0000)

             CLRPFM TVRELWAECO/DB_OPTWEE5
             MONMSG     MSGID(CPF0000)

             CLRPFM TVRELWAECO/DB_OPTWEE6
             MONMSG     MSGID(CPF0000)

             CLRPFM TVRELWAECO/DB_OPTWEE7
             MONMSG     MSGID(CPF0000)

             CLRPFM TVRELWAECO/DB_OPTWEE8
             MONMSG     MSGID(CPF0000)

             CLRPFM TVRELWAECO/DB_OPTWEE9
             MONMSG     MSGID(CPF0000)

             CLRPFM TVRELWAECO/DB_OPTIMUM
             MONMSG     MSGID(CPF0000)

             CLRPFM TVRELWAECO/SIEVOIILAG
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/SIEVOII)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
/*           CALL       PGM(SIEVOII)            RAUS 28.09.2021              */
/*           MONMSG     MSGID(CPF0000)          RAUS 28.09.2021              */
/*                                                                            */
             CPYF       FROMFILE(TVRELWAECO/##_OPTIMUM) +
                          TOFILE(TVRELWAECO/DB_OPTIMUM) +
                          MBROPT(*ADD) CRTFILE(*NO)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             RGZPFM     FILE(TVRELWAECO/##_OPTIMUM)
             MONMSG     MSGID(CPF0000)

             RMVLNK     OBJLNK('/B2B/LINDQVIST/SIEVOII.CSV')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/B2B/LINDQVIST/SIEVOII.CSV')   +
                          DBFILE(TVRELWAECO/SIEVOII)        +
                          DBOUTFMT(*CSV) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                    FORMTYPE('SIEVOII  ') OVRSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
/*                                                                            */
             RMVLNK     OBJLNK('/B2B/LINDQVIST/DB_OPTIMUM.CSV')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/B2B/LINDQVIST/DB_OPTIMUM.CSV') +
                          DBFILE(TVRELWAECO/DB_OPTIMUM)      +
                          DBOUTFMT(*CSV) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                    FORMTYPE('DB_OPTIMUM') OVRSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)

/*                                                                            */
   DB_OPT_JQ:
       /*   *** TVRELWAECO/SIEVOIII     DB_OPT_JQ                            */
       /*   ***                     +   DB_OPTLFR3                           */

             CLRPFM     FILE(TVRELWAECO/DB_OPT_LAG)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD '#JQ0007' ' ' ' ' +
                           'DB_OPT_LAG'  'TVRELWAECO' '*REPLACE')
       /* HIER KEINE EINSCHRÄNKUNGEN ALLE LAGER GRUPPE SPERRKZ */
             CLRPFM     FILE(TVRELWAECO/DB_OPT_LG)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD '#JQ0008' ' ' ' ' +
                           'DB_OPT_LG '  'TVRELWAECO' '*REPLACE')
             CALL       PGM(DUMMY512) PARM(&MD '#JQ0009' ' ' ' ' +
                           'DB_OPT_LG '  'TVRELWAECO' '*ADD    ')
             CLRPFM TVRELWAECO/DB_OPT_JQ
             MONMSG     MSGID(CPF0000)

             CLRPFM TVRELWAECO/DBOPPRODST
             MONMSG     MSGID(CPF0000)

             CLRPFM TVRELWAECO/DB_OPTLBCD
             MONMSG     MSGID(CPF0000)

             CLRPFM TVRELWAECO/DB_OPTLBC2
             MONMSG     MSGID(CPF0000)

             CLRPFM TVRELWAECO/DB_OPTLBC3
             MONMSG     MSGID(CPF0000)

             CLRPFM TVRELWAECO/DB_OPTLBC4
             MONMSG     MSGID(CPF0000)

             CLRPFM TVRELWAECO/DB_OPTLBC5
             MONMSG     MSGID(CPF0000)

             CLRPFM TVRELWAECO/DB_OPTREP1
             MONMSG     MSGID(CPF0000)

             CLRPFM TVRELWAECO/DB_OPTREP2
             MONMSG     MSGID(CPF0000)

             CLRPFM TVRELWAECO/DB_OPTREP3
             MONMSG     MSGID(CPF0000)

             CLRPFM TVRELWAECO/DB_OBT_WAE
             MONMSG     MSGID(CPF0000)

             CALL       PGM(SIEVOIII)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SIEVOIVR)
             MONMSG     MSGID(CPF0000)
    /*       GOTO ENDPGM                        */
/* CHGDTAARA DTAARA(DIRMAIL/DMDTAARA (842 1)) VALUE(',')                      */
             RMVLNK     OBJLNK('/B2B/LINDQVIST/DB_OPT_JQ.CSV')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/B2B/LINDQVIST/DB_OPT_JQ.CSV') +
                          DBFILE(TVRELWAECO/DB_OPT_JQ)      +
                          DBOUTFMT(*CSV) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                    FORMTYPE('DB_OPT_JQ') OVRSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(DUMMY512) PARM(&MD '#JQ0010' ' ' ' ' +
                           '#JQ0010'  'TVRELWAECO' '*REPLACE')
             MONMSG     MSGID(CPF0000)

             DSPJOBLOG  OUTPUT(*PRINT)
             MONMSG     MSGID(CPF0000)
     /****   CALL       PGM(DB_OPTLFR6)       ****/
     /****   MONMSG     MSGID(CPF0000)        ****/
             DSPJOBLOG  OUTPUT(*OUTFILE)                +
                          OUTFILE(TVRELWAECO/DELIVERYC) +
                          OUTMBR(*FIRST *REPLACE)
             MONMSG     MSGID(CPF0000)
             RMVLNK     OBJLNK('/B2B/LINDQVIST/DB_OPTLFR3.CSV')
             MONMSG     MSGID(CPF0000)
             RMVLNK     OBJLNK('/B2B/LINDQVIST/DB_OPTLFR6.CSV')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/B2B/LINDQVIST/DB_OPTLFR3.CSV') +
                          DBFILE(TVRELWAECO/DB_OPTLFR3)      +
                          DBOUTFMT(*CSV) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/B2B/LINDQVIST/DB_OPTLFR6.CSV') +
                          DBFILE(TVRELWAECO/DB_OPTLFR6)      +
                          DBOUTFMT(*CSV) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
             OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                    FORMTYPE('DB_OPTLFR3') OVRSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)

     /*      GOTO ENDPGM       */
/*                                                                            */
/*                                                                            */
/* *** ITEMSERV                                                              */
             CALL       PGM(§§MSGSCC)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
             ENDDO
     /*      DSPJOBLOG  OUTPUT(*PRINT)        */

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

             ENDPGM
