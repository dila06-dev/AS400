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

/*          MONMSG     MSGID(CPF0000)                                     */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('SNDMAILRHE')
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

                CHGVAR     VAR(&FORMTYPE) VALUE('SNDMAILRHE')
                OVRPRTF    FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) +
                           FORMTYPE(&FORMTYPE) OVRSCOPE(*JOB)
                MONMSG     MSGID(CPF0000)
/*                                                                            */
/*                                                                            */
                CALL    PGM(DUMMY512) PARM(&MD '#DC0001' ' ' 'PRT55' +
                             ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)
/*          case sensitive                                                */
                CVTSPLF    OBJ('/EINVOICE/test.HTM') +
                      FILE(QPQUPRFIL) +
                      JOB(884224/GANG/GANG_PC_S2) SPLNBR(6) +
                      FORMAT(*TXT) GREENBAR(*NO)
                MONMSG     MSGID(CPF0000)
/*                                                                            */
                DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
                MONMSG     MSGID(CPF0000)

/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('LOOP ')
             CHGVAR     VAR(%SST(&MD 46 64)) VALUE(&DIR)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

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
