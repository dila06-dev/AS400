/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:DELIVERYC                                              */
/*    *               ...                                                    */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    * SELECT KPFIRM, KPKDNR ,CHAR(' ', 60) NAME, CHAR(' ', 60) EMAIL,       */
/*    * CHAR(' ', 2) SHORTCUT, CHAR(' ', 4) DAYOFW1,CHAR(' ', 4)              */
/*    * DAYOFW2,                                                              */
/*    * CHAR(' ', 4) DAYOFW3,CHAR(' ', 4) DAYOFW4, CHAR(' ', 4)               */
/*    * DAYOFW5,CHAR(' ', 4) DAYOFW6, CHAR(' ', 4) DAYOFW7, CHAR(' ',         */
/*    * 2)                                                                    */
/*    * DAYUNTIL FROM KPIFTRANS GROUP BY KPFIRM, KPKDNR                       */
/*    * DATEI §§MSGSCC IN TVRELWAECO WURDE ERSTELLT.                          */
/*    *                                                                       */
/*    *                                                                       */
/*    * VERTEILER:                                                            */
/*    * SELECT DISTINCT DEC(ARID*0, 11, 0) ARID, DEC(ARSEQ*0, 11, 0)          */
/*    * ARSEQ                                                                 */
/*    * , ARNAM, AREML, ARTYP, ARLNK FROM DIRMAIL/DMATMRCV WHERE ARID         */
/*    * IN                                                                    */
/*    * (SELECT AHID FROM DIRMAIL/DMATMHDR1 WHERE AHDEF LIKE                  */
/*    * '%ITEMSERV%'                                                          */
/*    * AND AREML NOT LIKE '%GANG@%' )                                        */
/*    *                                                                       */
/*    * SELECT * FROM DIRMAIL/DMITMHDR WHERE IHMID ='A77NPFBEJIM7NKIT'        */
/*    * UPDATE DIRMAIL/DMITMHDR                                               */
/*    * SET IHREF='DOMETIC FILE TRANSFER ITEMSERV'                            */
/*    * WHERE IHMID ='A77NPFBEJIM7NKIT'                                       */
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

             DCLF       FILE(TVRELWAECO/§§MSGSCC)

/*          MONMSG     MSGID(CPF0000)                                     */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('§§MSGSCC ')
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

/*                                                                            */
/* *** ITEMSERV                                                              */
/*                                                                            */
/*          UPDATE MESSAGE FILE MIT GROUP INDICATOR                       */
             CALL       PGM(DUMMY512) PARM(&MD '#DC9191' ' ' ' ' +
                           ' '  ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(&MD '#DC9192' ' ' ' ' +
                           ' '  ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CHGJOB     CCSID(1252)
             MONMSG     MSGID(CPF0000)
             RTVSYSVAL  SYSVAL(QDAYOFWEEK) RTNVAR(&QDAYOFWEEK)
             MONMSG     MSGID(CPF0000)
             RTVSYSVAL  SYSVAL(QDAY) RTNVAR(&QDAY)
             MONMSG     MSGID(CPF0000)

             RTVMBRD    FILE(TVRELWAECO/§§MSGSCC) NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)

             CHGDTAARA  DTAARA(TVRELWAECO/ITEMSERV *ALL) +
                          VALUE('Please came back if you need for +
                          further items new current prices who been +
                          not in this report maybe for pre +
                          selection. Give also information if you +
                          are not a member of this distributen list +
                          or if you miss +
                          somebody.                                   -
     ')
             MONMSG     MSGID(CPF0000)






             IF         COND(&NBRCURRCD *GT 0) THEN(DO)
 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDLOOP))
             IF         COND(&CALLPGM    = &PGM  *AND                 +
                             &SHORTCUT *NE '  '  *AND                 +
                             &KPKDNR   *NE '00__00')                  +
                          THEN(DO)
             IF         COND(&QDAYOFWEEK = &DAYOFW1 *OR               +
                             &QDAYOFWEEK = &DAYOFW2 *OR               +
                             &QDAYOFWEEK = &DAYOFW3 *OR               +
                             &QDAYOFWEEK = &DAYOFW4 *OR               +
                             &QDAYOFWEEK = &DAYOFW5 *OR               +
                             &QDAYOFWEEK = &DAYOFW6 *OR               +
                             &QDAYOFWEEK = &DAYOFW7 )                 +
                          THEN(DO)
             IF         COND(&QDAY < &DAYUNTIL      *OR    +
                             &DAYUNTIL >   '00')           +
                          THEN(DO)

                CLRPFM     FILE(ITEMSERV)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(ITEMWRITE)
                MONMSG     MSGID(CPF0000)
/*                                                                            */
                CHGVAR     VAR(&DIR) VALUE('/SALESCOMPANY/' *TCAT +
                           &SHORTCUT *TCAT '/')
                CRTDIR DIR(&DIR)
                MONMSG     MSGID(CPF0000)
/*                                                                            */
                CALL       PGM(DELIVERYRA) PARM(&KPKDNR)
                MONMSG     MSGID(CPF0000)
                CHGVAR   VAR(&TOFILE) VALUE('ITEMSERV' *TCAT &SHORTCUT)
                MONMSG     MSGID(CPF0000)
                CPYF       FROMFILE(TVRELWAECO/ITEMSERV) +
                           TOFILE(TVRELWAECO/&TOFILE) MBROPT(*ADD) +
                           CRTFILE(*NO)
                MONMSG     MSGID(CPF0000)
                CLRPFM     SKU_CHANGE
                MONMSG     MSGID(CPF0000)
                CALL       PGM(DUMMY512) PARM(&MD '#DC9997' ' ' ' ' +
                              'SKU_CHANGE'  'TVRELWAECO' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(DUMMY512) PARM(&MD '#DC9996' ' ' ' ' +
                              ' '  ' ' ' ')
                MONMSG     MSGID(CPF0000)

                CHGVAR     VAR(&DIR) VALUE('/SALESCOMPANY/' *TCAT +
                           &SHORTCUT *TCAT '/' *TCAT 'ITEMSERV.CSV')
                RMVLNK     OBJLNK(&DIR)
                MONMSG     MSGID(CPF0000)
                CVTDBF     OBJ(&DIR) DBFILE(TVRELWAECO/ITEMSERV) +
                           DBOUTFMT(*CSV) DBFLDDSC(*YES)
                MONMSG     MSGID(CPF0000)


                RTVMBRD    FILE(TVRELWAECO/§§MSGSCC) NBRCURRCD(&NBR2)
                MONMSG     MSGID(CPF0000)
              IF         COND(&NBR2 *GT 0) THEN(DO)
                CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&KPKDNR)
                CHGVAR     VAR(%SST(&MD 11 60)) VALUE(&NAME)
                CALL       PGM(DUMMY512) PARM(&MD '#DC9190' ' ' ' ' +
                              ' '  ' ' ' ')
                CHGVAR     VAR(%SST(&MD 01 70)) VALUE(' ')
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(&DIR) VALUE('/SALESCOMPANY/' *TCAT +
                           &SHORTCUT *TCAT '/' *TCAT 'SKU_CHANGE.CSV')
                RMVLNK     OBJLNK(&DIR)
                MONMSG     MSGID(CPF0000)
                CVTDBF     OBJ(&DIR) DBFILE(TVRELWAECO/SKU_CHANGE) +
                           DBOUTFMT(*CSV) DBFLDDSC(*YES)
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(&DIR) VALUE('/SALESCOMPANY/' *TCAT +
                           &SHORTCUT *TCAT '/' *TCAT 'ITEMWRITE.CSV')
                RMVLNK     OBJLNK(&DIR)
                MONMSG     MSGID(CPF0000)
                CVTDBF     OBJ(&DIR) DBFILE(TVRELWAECO/ITEMWRITE) +
                           DBOUTFMT(*CSV) DBFLDDSC(*YES)
                MONMSG     MSGID(CPF0000)
              ENDDO

                CHGVAR     VAR(&FORMTYPE) VALUE('ITEMSERV' *TCAT +
                           &SHORTCUT)
                OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                           FORMTYPE(&FORMTYPE) OVRSCOPE(*JOB)
                MONMSG     MSGID(CPF0000)
/*                                                                            */
                CALL    PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                             ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)
                DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
                MONMSG     MSGID(CPF0000)

/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 256)) VALUE(' ')
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('LOOP ')
             CHGVAR     VAR(%SST(&MD 46 64)) VALUE(&DIR)
             CHGVAR     VAR(%SST(&MD 111 10)) VALUE(&KPKDNR)
             CHGVAR     VAR(%SST(&MD 121 60)) VALUE(&NAME)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

             DLYJOB     DLY(110)
             MONMSG     MSGID(CPF0000)

             ENDDO
             ENDDO
             ENDDO
             GOTO LOOP
             ENDDO
 ENDLOOP:
/*                                                                            */
 ENDPGM:
/*          65535 HAT JOB HIER BEI DOMETIC (WARUM?)                       */
             CHGJOB     CCSID(65535)
             MONMSG     MSGID(CPF0000)
             IF         COND(&ERROR2 = '0') THEN(DO)
             ENDDO
     /*      DSPJOBLOG  OUTPUT(*PRINT)        */

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
