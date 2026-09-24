/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:SKUTRANSFC                                             */
/*    *                                                                       */
/*    * CPYFRMIMPF    FROMFILE(TVRELWAECO/SKUTRANSF#)                        */
/*    *               TOFILE(TVRELWAECO/SKUDBF)                              */
/*    *               MBROPT(*REPLACE) FLDDLM(';')                           */
/*    *               RPLNULLVAL(*FLDDFT)                                    */
/*    *                                                                       */
/*    * AUSGABEDATEI                                                          */
/*    *                CPYFRMIMPF FROMFILE(TVRELWAECO/SKUTRANSF#)             */
/*    *                TOFILE(TVRELWAECO/FR_FB)                               */
/*    *                MBROPT(*REPLACE) FLDDLM(';')                           */
/*    *                RPLNULLVAL(*FLDDFT)                                    */
/*    *                                                                       */
/*    * WORKDATEI                                                             */
/*    *                CPYFRMIMPF FROMFILE(TVRELWAECO/SKUTRANSF#)             */
/*    *                TOFILE(TVRELWAECO/SKUDBF)                              */
/*    *                MBROPT(*REPLACE) FLDDLM(';')                           */
/*    *                RPLNULLVAL(*FLDDFT)                                    */
/*    *                                                                       */
/*    * UPDATE       FR_FB SET H1='UPDATE'                                    */
/*    * WHERE #ITEM IN ( SELECT ITEM FROM ITEMSERV)                           */
/*    * 2056 ZEILEN IN FR_FB IN TVRELWAECO AKTUALISIERT.                      */
/*    * DELETE FROM FR_FB                                                     */
/*    * WHERE #ITEM IN ( SELECT ITEM FROM ITEMSERV)                           */
/*    * 2056 ZEILEN AUS FR_FB IN TVRELWAECO GELÖSCHT.                         */
/*    *                                                                       */
/*    *                                                                       */
/*    * UPDATE       FR_FB SET H1='NON UPDATE'                                */
/*    * WHERE #ITEM NOT IN ( SELECT ITEM FROM ITEMSERV)                       */
/*    * SELECT * FROM SKUDBF, ITEMSERV                                        */
/*    * WHERE SKUDBF.#ITEM=ITEMSERV.ITEM                                      */
/*    * 3734 SÄTZE ZU TEILDATEI FR_FB IN DATEI FR_FB HINZUGEFÜGT.             */
/*    *                                                                       */
/*    *                                                                       */
/*    *                                                                       */
/*    * DELETE   FROM FR_FB WHERE #ITEM IN ( SELECT ITEM FROM ITEMSERV)       */
/*    * 2056 ZEILEN AUS FR_FB IN TVRELWAECO GELÖSCHT.                         */
/*    * INSERT INTO TVRELWAECO/FR_FB                                          */
/*    * SELECT * FROM SKUDBF , ITEMSERV WHERE SKUDBF.#ITEM=                   */
/*    * ITEMSERV.ITEM                                                         */
/*    * 3734 SÄTZE ZU TEILDATEI FR_FB IN DATEI FR_FB HINZUGEFÜGT.             */
/*    *                                                                       */
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

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('SKUTRANSFC')
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

             CLRPFM     FILE(TVRELWAECO/TRANSXLS)
             MONMSG     MSGID(CPF0000)

         /* *** ABRUFDATEI PC UPLOAD.CSV, WIRD ÜBERSCHRIEBEN                 */
         /* *** REFERENZEN SC, PREISE DER SC, ARTIKEL DER SC USW.            */
             CPYFRMIMPF FROMFILE(TVRELWAECO/TRTP#)   +
                     TOFILE(TVRELWAECO/TRANSXLS)     +
                     MBROPT(*REPLACE) FLDDLM(';')    +
                     RPLNULLVAL(*FLDDFT)
             MONMSG     MSGID(CPF0000)

             CPYFRMIMPF FROMFILE(TVRELWAECO/CH412RPM) +
                          TOFILE(TVRELWAECO/TRANSXLS) +
                          MBROPT(*REPLACE) FLDDLM(';') +
                          DECPNT(*COMMA) RPLNULLVAL(*FLDDFT)
             MONMSG     MSGID(CPF0000)

             CPYFRMIMPF FROMFILE(TVRELWAECO/VKGROUP)         +
                          TOFILE(TVRELWAECO/TRANSXLS2)       +
                          MBROPT(*REPLACE) FLDDLM(';')       +
                          DECPNT(*COMMA) RPLNULLVAL(*FLDDFT)
             MONMSG     MSGID(CPF0000)

             CPYFRMIMPF FROMFILE(TVRELWAECO/RPMKDNGRP)       +
                          TOFILE(TVRELWAECO/TRANSXLS3)       +
                          MBROPT(*REPLACE) FLDDLM(';')       +
                          DECPNT(*COMMA) RPLNULLVAL(*FLDDFT)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(DUMMY512) PARM(&MD 'SKU0014' ' ' ' ' +
                           'SKUTRANSF '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)

             RTVMBRD    FILE(TVRELWAECO/TRANSXLS) +
                          NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)

             IF         COND(&NBRCURRCD *GT 0) THEN(DO)
                CHGVAR     VAR(&RECORDS) VALUE(&NBRCURRCD)
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(%SST(&TXT50 33 10)) VALUE(&RECORDS)
                CALL       PGM(SKUTRANSFR)
                MONMSG     MSGID(CPF0000)
             ENDDO

 ENDPGM:

/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('ENDE ')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CHGVAR     VAR(%SST(&MD 100 10)) VALUE(&RECORDS)
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
