/*    * PROGRAMMNAME.:PERMANENT                                              */
/*    * FUNKTION.....:PERMANENTE SICHERUNG AUFRUFEN                          */
/*    *               AUFRUFROUTINEN:                                        */
/*    *                                                                       */
/*    * 01/2010        MANFRED GANG                                           */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM
             DCL        VAR(&##DAT)     TYPE(*CHAR) LEN(08)
             DCL        VAR(&##LND)     TYPE(*DEC)  LEN(1 0)
             DCL        VAR(&##ATAG)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&##FTAG)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&##WOTAG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&##FEIERT)  TYPE(*CHAR) LEN(25)
             DCL        VAR(&##WOCHE)   TYPE(*DEC)  LEN(2 0)
             DCL        VAR(&##LFDKTAG) TYPE(*DEC)  LEN(3 0)
             DCL        VAR(&##LFDATAG) TYPE(*DEC)  LEN(3 0)
             DCL        VAR(&CODE)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&CTL)       TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&DATMOD)    TYPE(*CHAR) LEN(5)
             DCL        VAR(&RTNCOD)    TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&SYSGES)    TYPE(*CHAR) LEN(26)
             DCL        VAR(&SYSDAT)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYSZEI)    TYPE(*CHAR) LEN(8)
             DCL        VAR(&NEWVOL)    TYPE(*CHAR) LEN(06)
             DCL        VAR(&NEWOWNID)  TYPE(*CHAR) LEN(14)
             DCL        VAR(&GSMMSG)    TYPE(*CHAR) LEN(160)
             DCL        VAR(&SWITCH)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&MONATENDE) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&ENDOPT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&SICHERPER) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&SAVESTATUS) TYPE(*CHAR) LEN(80)
             DCL        VAR(&TAS0001C)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&DLYJOB01)  TYPE(*DEC)  LEN(6 0)
             DCL        VAR(&#DLYJOB01)  TYPE(*CHAR)  LEN(6)
             CHGJOB     RUNPTY(19)
             CHGVAR     VAR(&SAVESTATUS) VALUE('permanenter +
                          Sicherungsjob ist aktiv:       ')
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(SUBR36/SAVESTATUS) VALUE(&SAVESTATUS)
             MONMSG     MSGID(CPF0000)
/*----------------------------------------------------------------------------*/
/*    *     SYSGES: 20050322090226                                           */
/*    *     SYSDAT: 20050322                                                 */
/*    *     SYSZEI: 090226                                                   */
             CHGVAR     VAR(&DATMOD) VALUE('*JMT4')
             CALL       PGM(SUBR36/#DATAKTR) PARM(&DATMOD &RTNCOD +
                          &SYSGES &SYSDAT &SYSZEI)
             CHGVAR     VAR(%SST(&NEWVOL 01 06)) VALUE(%SST(&SYSDAT +
                          03 06))
             CHGVAR     VAR(%SST(&GSMMSG 01 43)) VALUE('WAECO400 +
                          Sicherung abgebrochen, kein INZTAP ')
             CHGVAR     VAR(%SST(&GSMMSG 45 08)) VALUE(&SYSDAT)
/*    *     ##DAT    :                                                       */
/*    *     ##LND    :                                                       */
/*    *     ##ATAG   :                                                       */
/*    *     ##FTAG   :                                                       */
/*    *     ##WOTAG  :                                                       */
/*    *     ##FEIERT :                                                       */
/*    *     ##WOCHE  :                                                       */
/*    *     ##LFDKTAG:                                                       */
/*    *     ##LFDATAG:                                                       */
             CALL       PGM(#DRDATINF) PARM(&##DAT &##LND &##ATAG +
                          &##FTAG &##WOTAG &##FEIERT &##WOCHE +
                          &##LFDKTAG &##LFDATAG)

             CHGVAR     VAR(%SST(&NEWOWNID 01 03)) +
                          VALUE(%SST(&##WOTAG 01 03))
             CHGVAR     VAR(%SST(&NEWOWNID 05 08)) VALUE(&SYSDAT)

/*    *     STANDARD *UNLOAD AUSNAHMEN MIT *REWIND, DA FÜR DEN               */
/*    *     MONATSABSCHLUß AM FOLGETAG DAS BAND FÜR DIE MONATS-              */
/*    *     SICHERUNG BENÖTIGT WIRD                                          */
             CHGVAR     VAR(&ENDOPT) VALUE('*UNLOAD')
             IF         COND( %SST(&SYSDAT 1 8) *EQ '20070330'  +
                        *OR   %SST(&SYSDAT 1 8) *EQ '20070629'  +
                        *OR   %SST(&SYSDAT 1 8) *EQ '20070928'  +
                        *OR   %SST(&SYSDAT 1 8) *EQ '20071228') +
                          THEN(DO)
/*    *     BAND NICHT AUF UNLOAD SETZEN FÜR FOLGE TAG, WO                   */
/*    *     MONATSSICHERUNG ERFOLGT                                          */
                CHGVAR     VAR(&ENDOPT) VALUE('*REWIND')
             ENDDO

/*    *     MONATSSICHERUNGSTAGE                                             */
             IF         COND( %SST(&SYSDAT 5 4) *EQ '0131'  +
                        *OR   %SST(&SYSDAT 1 8) *EQ '20070228'  +
                        *OR   %SST(&SYSDAT 5 4) *EQ '0331'  +
                        *OR   %SST(&SYSDAT 5 4) *EQ '0430'  +
                        *OR   %SST(&SYSDAT 5 4) *EQ '0531'  +
                        *OR   %SST(&SYSDAT 5 4) *EQ '0630'  +
                        *OR   %SST(&SYSDAT 5 4) *EQ '0731'  +
                        *OR   %SST(&SYSDAT 5 4) *EQ '0830'  +
                        *OR   %SST(&SYSDAT 5 4) *EQ '0930'  +
                        *OR   %SST(&SYSDAT 5 4) *EQ '1031'  +
                        *OR   %SST(&SYSDAT 5 4) *EQ '1130'  +
                        *OR   %SST(&SYSDAT 5 4) *EQ '1231') +
                          THEN(DO)
                CHGVAR     VAR(&MONATENDE) VALUE('1')
                GOTO       CMDLBL(START)
             ENDDO
             IF         COND(&##WOTAG *EQ 'Samstag   ' *OR &##WOTAG +
                          *EQ 'Sonntag   ') THEN(DO)
                GOTO       CMDLBL(ENDPGM)
             ENDDO

 START:

/*----------------------------------------------------------------------------*/

             RTVDTAARA  DTAARA(SICHERPER) RTNVAR(&SICHERPER)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDPGM))

             IF         COND( %SST(&SYSZEI 1 4) *GT '0800'  +
                        *AND  %SST(&SYSZEI 1 4) *LT '1530'  +
                        *AND  &SICHERPER *NE '1'        ) +
                          THEN(DO)
                CHGVAR  VAR(&SAVESTATUS) VALUE('Sicherungsjob aktiv: +
                             -------- um ------ ')
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(%SST(&SAVESTATUS 22 08)) VALUE(&SYSDAT)
                MONMSG     MSGID(CPF0000)
                CHGVAR     VAR(%SST(&SAVESTATUS 34 06)) VALUE(&SYSZEI)
                MONMSG     MSGID(CPF0000)
                CHGDTAARA  DTAARA(SUBR36/SAVESTATUS) VALUE(&SAVESTATUS)
                MONMSG     MSGID(CPF0000)

                CHGVAR     VAR(%SST(&SAVESTATUS 41 40)) +
                             VALUE('Bandinitialisierung INZTAP +
                             gestartet    ')
                MONMSG     MSGID(CPF0000)
                CHGDTAARA  DTAARA(SUBR36/SAVESTATUS) VALUE(&SAVESTATUS)
                MONMSG     MSGID(CPF0000)
                INZTAP     DEV(TAP02) NEWVOL(&NEWVOL) +
                           NEWOWNID(&NEWOWNID) CHECK(*NO) +
                           DENSITY(*CTGTYPE) ENDOPT(*REWIND)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDPGM))
                CLRPFM     FILE(SUBR36/PERMANENT)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDPGM))
                GOTO       CMDLBL(LOOP)
             ENDDO

             GOTO       CMDLBL(ENDPGM)

   LOOP:
             RTVDTAARA  DTAARA(TAS0001C) RTNVAR(&TAS0001C)
             IF         COND(&TAS0001C = '1') THEN(DO)
                 DLYJOB     DLY(0060)
                 GOTO       CMDLBL(LOOP)
             ENDDO
             CHGVAR     VAR(%SST(&SAVESTATUS 41 40)) +
                          VALUE('permanente Sicherung SAVLIB +
                          aktiv        ')
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(SUBR36/SAVESTATUS) VALUE(&SAVESTATUS)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(SICHERPER) VALUE('1')
             MONMSG     MSGID(CPF0000)
             SAVCHGOBJ  OBJ(*ALL) LIB(*ALLUSR) DEV(TAP02) +
                          REFDATE(*SAVLIB) ENDOPT(*LEAVE) +
                          UPDHST(*NO) SAVACT(*SYNCLIB) +
                          SAVACTWAIT(010 010 010) ACCPTH(*NO) +
                          OMITLIB(SAVEFILE TESTLIB) +
                          OMITOBJ((SUBR36/PERMANENT *FILE) +
                          (SFBF/FHBUCHD *FILE) (SFBF/FHKORED *FILE) +
                          (QMPGDATA/*ALL *MGTCOL)) OUTPUT(*OUTFILE) +
                          OUTFILE(SUBR36/PERMANENT) OUTMBR(*FIRST *ADD)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(SICHERPER) VALUE('0')
             MONMSG     MSGID(CPF0000)

             CALL       PGM(SUBR36/#DATAKTR) PARM(&DATMOD &RTNCOD +
                          &SYSGES &SYSDAT &SYSZEI)
             CHGVAR     VAR(%SST(&SAVESTATUS 41 40)) +
                          VALUE('permanente Sicherung +
                          DLYJOB:            ')
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&SAVESTATUS 69 06)) VALUE(&SYSZEI)
             MONMSG     MSGID(CPF0000)
             RTVDTAARA  DTAARA(SICHERPER) RTNVAR(&SICHERPER)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDPGM))
             RTVDTAARA  DTAARA(DLYJOB01) RTNVAR(&DLYJOB01)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&DLYJOB01) +
                          VALUE(3600))
             CHGVAR     VAR(&#DLYJOB01) VALUE(&DLYJOB01)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&SAVESTATUS 75 06)) VALUE(&#DLYJOB01)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(SUBR36/SAVESTATUS) VALUE(&SAVESTATUS)
             MONMSG     MSGID(CPF0000)
             DLYJOB     DLY(&DLYJOB01)
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(&DATMOD) VALUE('*JMT4')
             CALL       PGM(SUBR36/#DATAKTR) PARM(&DATMOD &RTNCOD +
                          &SYSGES &SYSDAT &SYSZEI)
             IF         COND(%SST(&SYSZEI 1 4) *GT '1520') THEN(GOTO +
                          CMDLBL(ENDPGM))
             IF         COND(&SICHERPER *EQ '1') THEN(GOTO +
                          CMDLBL(ENDPGM))
             GOTO       CMDLBL(LOOP)

 ENDPGM:

             OVRPRTF    FILE(QPJOBLOG) USRDTA(&SYSDAT)
             MONMSG     MSGID(CPF0000)
             DSPJOBLOG  OUTPUT(*PRINT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&SAVESTATUS) VALUE('Sicherung +
                          inaktiv                                     -
                          ')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SUBR36/#DATAKTR) PARM(&DATMOD &RTNCOD +
                          &SYSGES &SYSDAT &SYSZEI)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&SAVESTATUS 60 08)) VALUE(&SYSDAT)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&SAVESTATUS 69 06)) VALUE(&SYSZEI)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(SUBR36/SAVESTATUS) VALUE(&SAVESTATUS)
             MONMSG     MSGID(CPF0000)
             ENDPGM
