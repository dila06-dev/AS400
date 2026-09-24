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
             CHGVAR     VAR(&PGM) VALUE('RPMIIFC   ')
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

         /* *** ABRUFDATEI PC UPLOAD.CSV, WIRD ÜBERSCHRIEBEN                 */
         /* *** REFERENZEN SC, PREISE DER SC, ARTIKEL DER SC USW.            */
             CPYFRMIMPF FROMFILE(TVRELWAECO/RPMII_FCSV)   +
                              TOFILE(TVRELWAECO/RPMII_F)   +
                              MBROPT(*REPLACE) FLDDLM(';')  +
                              RPLNULLVAL(*FLDDFT)
             MONMSG     MSGID(CPF0000)


/*          RPM_CALL (GENERIERT ALLE BESTANDTEILE AUS RPM)                   */
             CALL RPMIIR
             MONMSG     MSGID(CPF0000)
/*                                                                            */
       /*   *** NUR INHALTE, DIE ÜBERGEBEN WERDEN MÜSSEN PHASE2              */
             CALL    PGM(DUMMY512) PARM(&MD '#RP0505' ' ' ' ' +
                         '#RP0505' 'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)

       /*   *** PROTOKOLL SETZTEN PARAMETER AUF "2"      PHASE2              */
             CALL    PGM(DUMMY512) PARM(&MD '#RP0506' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)

       /*   *** ABRUFDATEI PC                            PHASE2              */
             QSYS/CPYTOIMPF FROMFILE(#RP0505) +
                          TOFILE(TVRELWAECO/RPMII2_OUT) +
                          MBROPT(*REPLACE) STRDLM(' ') +
                          RMVBLANK(*BOTH) FLDDLM(';') DECPNT(*COMMA)
             MONMSG     MSGID(CPF0000)

       /*   *** NUR INHALTE, DIE ÜBERGEBEN WERDEN MÜSSEN PHASE3              */
             CALL    PGM(DUMMY512) PARM(&MD '#RP0510' ' ' ' ' +
                         '#RP0510' 'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)

       /*   *** PROTOKOLL SETZTEN PARAMETER AUF "3"      PHASE3              */
             CALL    PGM(DUMMY512) PARM(&MD '#RP0511' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)

       /*   *** ABRUFDATEI PC                            PHASE3              */
             QSYS/CPYTOIMPF FROMFILE(#RP0510) +
                          TOFILE(TVRELWAECO/RPMII3_OUT) +
                          MBROPT(*REPLACE) STRDLM(' ') +
                          RMVBLANK(*BOTH) FLDDLM(';') DECPNT(*COMMA)
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

             ENDPGM
