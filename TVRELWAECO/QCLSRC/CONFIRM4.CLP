/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:DELIVERYC                                              */
/*    *               ...                                                    */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    * CPYF FROMFILE(QTEMP/XX) TOFILE(DIRMAIL/DMITMHDR) MBROPT(*ADD)         */
/*    *                                                                       */
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
             DCL        VAR(&NBR2)       TYPE(*DEC) LEN(10 0)
             DCL        VAR(&TOFILE)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&#APAFNR)    TYPE(*CHAR) LEN(06)
             DCL        VAR(&#APAFJJ) TYPE(*CHAR) LEN(04)

             DCL        VAR(&PGM)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)      TYPE(*CHAR) LEN(06)
             DCL        VAR(&DIR)      TYPE(*CHAR) LEN(64)
             DCL        VAR(&FORMTYPE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&TXT)      TYPE(*CHAR) LEN(50)
             DCL        VAR(&QDAYOFWEEK) TYPE(*CHAR) LEN(04)
             DCL        VAR(&QDAY)  TYPE(*CHAR) LEN(02)

/*          MONMSG     MSGID(CPF0000)                                     */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('CONFIRM4 ')
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
             CLRPFM     FILE(TVRELWAECO/#DC5210)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD '#DC5210' ' ' ' ' +
                           '#DC5210'  'TVRELWAECO' '*REPLACE')
             MONMSG     MSGID(CPF0000)

             RTVMBRD    FILE(TVRELWAECO/#DC5210) MBR(*FIRST) +
                          NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)
/*                                                                            */
/* *** DOMCHKBAS  FÜLLEN                                                     */
/*                                                                            */
             RTVSYSVAL  SYSVAL(QDAYOFWEEK) RTNVAR(&QDAYOFWEEK)
             MONMSG     MSGID(CPF0000)
             RTVSYSVAL  SYSVAL(QDAY) RTNVAR(&QDAY)
             MONMSG     MSGID(CPF0000)

             IF         COND(&NBRCURRCD *GT 0) THEN(DO)
/*                                                                            */
                CHGVAR     VAR(%SST(&MD 01 07)) VALUE('0078678')
                CALL       PGM(DUMMY512) PARM(&MD '#DC5220' ' ' ' ' +
                              '#DC5220'  'TVRELWAECO' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                RTVMBRD    FILE(TVRELWAECO/#DC5220) MBR(*FIRST) +
                           NBRCURRCD(&NBRCURRCD2)
                IF         COND(&NBRCURRCD2 *GT 0) THEN(DO)
                   RMVLNK     OBJLNK('/SALESCOMPANY/PL/#DC5210.TXT')
                   MONMSG     MSGID(CPF0000)
                   RMVLNK     OBJLNK('/SALESCOMPANY/PL/#DC5210.CSV')
                   MONMSG     MSGID(CPF0000)
                   CVTDBF     OBJ('/SALESCOMPANY/PL/#DC5210.CSV')  +
                              DBFILE(TVRELWAECO/#DC5220)         +
                              DBOUTFMT(*CSV) DBFLDDSC(*YES)
                   MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/SALESCOMPANY/PL/#DC5210.TXT') +
                          DBFILE(TVRELWAECO/#DC5220) DBOUTFMT(*TXT) +
                          DBFLDDSC(*YES)
                   MONMSG     MSGID(CPF0000)
                   OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                          FORMTYPE('#DC5210_PL') OVRSCOPE(*JOB)
                   MONMSG     MSGID(CPF0000)
                   CALL  PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
                ENDDO
             ENDDO
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)

             IF         COND(&NBRCURRCD *GT 0) THEN(DO)
/*                                                                            */
                CHGVAR     VAR(%SST(&MD 01 07)) VALUE('0001887')
                CALL       PGM(DUMMY512) PARM(&MD '#DC5220' ' ' ' ' +
                              '#DC5220'  'TVRELWAECO' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                RTVMBRD    FILE(TVRELWAECO/#DC5220) MBR(*FIRST) +
                           NBRCURRCD(&NBRCURRCD2)
                IF         COND(&NBRCURRCD2 *GT 0) THEN(DO)
                   RMVLNK     OBJLNK('/SALESCOMPANY/DK/#DC5210.CSV')
                   MONMSG     MSGID(CPF0000)
                   CVTDBF     OBJ('/SALESCOMPANY/DK/#DC5210.CSV')  +
                              DBFILE(TVRELWAECO/#DC5220)         +
                              DBOUTFMT(*CSV) DBFLDDSC(*YES)
                   MONMSG     MSGID(CPF0000)
                   OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                          FORMTYPE('#DC5210_DK') OVRSCOPE(*JOB)
                   MONMSG     MSGID(CPF0000)
                   CALL  PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
                ENDDO
             ENDDO
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)

             IF         COND(&NBRCURRCD *GT 0) THEN(DO)
/*                                                                            */
                CHGVAR     VAR(%SST(&MD 01 07)) VALUE('0008138')
                CALL       PGM(DUMMY512) PARM(&MD '#DC5220' ' ' ' ' +
                              '#DC5220'  'TVRELWAECO' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                RTVMBRD    FILE(TVRELWAECO/#DC5220) MBR(*FIRST) +
                           NBRCURRCD(&NBRCURRCD2)
                IF         COND(&NBRCURRCD2 *GT 0) THEN(DO)
                   RMVLNK     OBJLNK('/SALESCOMPANY/SE/#DC5210.CSV')
                   MONMSG     MSGID(CPF0000)
                   CVTDBF     OBJ('/SALESCOMPANY/SE/#DC5210.CSV')  +
                              DBFILE(TVRELWAECO/#DC5220)           +
                              DBOUTFMT(*CSV) DBFLDDSC(*YES)
                   MONMSG     MSGID(CPF0000)
                   OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                          FORMTYPE('#DC5210_SE') OVRSCOPE(*JOB)
                   MONMSG     MSGID(CPF0000)
                   CALL  PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
                ENDDO
             ENDDO
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)


             IF         COND(&NBRCURRCD *GT 0) THEN(DO)
/*                                                                            */
                CHGVAR     VAR(%SST(&MD 01 07)) VALUE('0040631')
                CALL       PGM(DUMMY512) PARM(&MD '#DC5220' ' ' ' ' +
                              '#DC5220'  'TVRELWAECO' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                RTVMBRD    FILE(TVRELWAECO/#DC5220) MBR(*FIRST) +
                           NBRCURRCD(&NBRCURRCD2)
                IF         COND(&NBRCURRCD2 *GT 0) THEN(DO)
                   RMVLNK     OBJLNK('/SALESCOMPANY/UK/#DC5210.CSV')
                   MONMSG     MSGID(CPF0000)
                   CVTDBF     OBJ('/SALESCOMPANY/UK/#DC5210.CSV')  +
                              DBFILE(TVRELWAECO/#DC5220)         +
                              DBOUTFMT(*CSV) DBFLDDSC(*YES)
                   MONMSG     MSGID(CPF0000)
                   OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                          FORMTYPE('#DC5210_UK') OVRSCOPE(*JOB)
                   MONMSG     MSGID(CPF0000)
                   CALL  PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
                ENDDO
             ENDDO
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)


             IF         COND(&NBRCURRCD *GT 0) THEN(DO)
/*                                                                            */
                CHGVAR     VAR(%SST(&MD 01 07)) VALUE('0005084')
                CALL       PGM(DUMMY512) PARM(&MD '#DC5220' ' ' ' ' +
                              '#DC5220'  'TVRELWAECO' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                RTVMBRD    FILE(TVRELWAECO/#DC5220) MBR(*FIRST) +
                           NBRCURRCD(&NBRCURRCD2)
                IF         COND(&NBRCURRCD2 *GT 0) THEN(DO)
                   RMVLNK     OBJLNK('/SALESCOMPANY/FI/#DC5210.CSV')
                   MONMSG     MSGID(CPF0000)
                   CVTDBF     OBJ('/SALESCOMPANY/FI/#DC5210.CSV')  +
                              DBFILE(TVRELWAECO/#DC5220)         +
                              DBOUTFMT(*CSV) DBFLDDSC(*YES)
                   MONMSG     MSGID(CPF0000)
                   OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                          FORMTYPE('#DC5210_FI') OVRSCOPE(*JOB)
                   MONMSG     MSGID(CPF0000)
                   CALL  PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
                ENDDO
             ENDDO
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)



             IF         COND(&NBRCURRCD *GT 0) THEN(DO)
/*                                                                            */
                CHGVAR     VAR(%SST(&MD 01 07)) VALUE('0042634')
                CALL       PGM(DUMMY512) PARM(&MD '#DC5220' ' ' ' ' +
                              '#DC5220'  'TVRELWAECO' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                RTVMBRD    FILE(TVRELWAECO/#DC5220) MBR(*FIRST) +
                           NBRCURRCD(&NBRCURRCD2)
                IF         COND(&NBRCURRCD2 *GT 0) THEN(DO)
                   RMVLNK     OBJLNK('/SALESCOMPANY/FI/#DC5210.CSV')
                   MONMSG     MSGID(CPF0000)
                   CVTDBF     OBJ('/SALESCOMPANY/FI/#DC5210.CSV')  +
                              DBFILE(TVRELWAECO/#DC5220)         +
                              DBOUTFMT(*CSV) DBFLDDSC(*YES)
                   MONMSG     MSGID(CPF0000)
                   OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                          FORMTYPE('#DC5210_FI') OVRSCOPE(*JOB)
                   MONMSG     MSGID(CPF0000)
                   CALL  PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                          ' ' ' ' ' ')
                   MONMSG     MSGID(CPF0000)
                ENDDO
             ENDDO
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             MONMSG     MSGID(CPF0000)

/*                                                                            */
 ENDPGM:

/*          GELUWE PROTOKOLL SPÄTER WIEDER RAUS                           */
        /*   CALL       PGM(GELUWE)               */
        /*   MONMSG     MSGID(CPF0000)            */

/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(&MD)             VALUE(' ')
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
