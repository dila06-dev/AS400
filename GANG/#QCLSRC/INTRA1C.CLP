/*    * PROGRAMMNAME.:INTRASTAT-AUFRUF                                       */
/*    * FUNKTION.....:AUFRUF INTRASTATMELDUNGEN                              */
/*    * FUNKTION.....:....                                                   */
/*    * AUGUST  2000                                                          */
/*    *                                                                       */
/*    * FASERWERKE-LINGEN GMBH                                                */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&PRT &RCODE &CTL &IN50 &ESCMSG &LEERZC +
                          &D3INDEX)

/* &PRT      DRUCKER FÜR AUSGABE                                              */
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
/* &RCODE    RETURNCODE WENN "O" DANN BAYMAPÜBERGABE                          */
             DCL        VAR(&RCODE) TYPE(*CHAR) LEN(1)
/*       PARMKARTE  CTL ==> 'B'= BILDSCHIRM, ELSE DRUCKER   */
             DCL        VAR(&CTL)   TYPE(*CHAR) LEN(1)
/*       PARMKARTE  IN50 ==> '0'=STANDARDKOPF, ELSE SONDERFORMAT */
             DCL        VAR(&IN50)   TYPE(*CHAR) LEN(1)
/*       PARMKARTE  ESCMSG ==> *BLANK = FWL-KOPF, KYROCERE ESCAPE-S*/
             DCL        VAR(&ESCMSG)   TYPE(*CHAR) LEN(7)
/*       PARMKARTE  LEERZ ==> ANZAHL LEERZEICHEN BEI FWL-KOPF */
             DCL        VAR(&LEERZC)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&LEERZ)   TYPE(*DEC) LEN(2 0)
/* &USER     USER FÜR PARAMETERLEISTE                           */
             DCL        VAR(&USER)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&D3INDEX)   TYPE(*DEC)  LEN(05)

             DCL        VAR(&TODOC)   TYPE(*CHAR) LEN(12)
             DCL        VAR(&DATMOD)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&RTNCOD)  TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&SYSGES)  TYPE(*CHAR) LEN(26)
             DCL        VAR(&SYSDAT)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYSZEI)  TYPE(*CHAR) LEN(8)

/*----------------------------------------------------------------------------*/
/*       BESCHREIBUNGEN IM KOPFFORMAT                       */
             DCL        VAR(&MSG1)  TYPE(*CHAR) LEN(95)
             DCL        VAR(&MSG2)  TYPE(*CHAR) LEN(95)
             DCL        VAR(&MSG3)  TYPE(*CHAR) LEN(95)
             DCL        VAR(&VTL)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYS)   TYPE(*CHAR) LEN(08)
             DCL        VAR(&DOK)   TYPE(*CHAR) LEN(08)
             DCL        VAR(&U1)    TYPE(*CHAR) LEN(132)
             DCL        VAR(&U2)    TYPE(*CHAR) LEN(132)
/*       SONSTIGES                                          */
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&MSGF)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGMQ)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&DEV)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&FORM)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&ERROR)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&LDAS)    TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&MSGPGM)  TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&FWLFIRM) TYPE(*CHAR) LEN(01)
/*----------------------------------------------------------------------------*/
/*           CHGVAR     VAR(&LEERZ) VALUE(&LEERZC)       */
             RTVDTAARA  DTAARA(*LDA (954 10)) RTNVAR(&MSGPGM)
             IF         COND(&MSGPGM= '          ') THEN(DO)
                CALL       PGM(##SVRLDA) PARM('S')
                CHGDTAARA  DTAARA(*LDA (954 10)) VALUE(SYS0005R)
                CHGVAR     VAR(&LDAS) VALUE('S')
                CALL       PGM(#DEFLDA) PARM(' ')
             ENDDO

             RTVDTAARA  DTAARA(*LDA (890 10)) RTNVAR(&MSGF)
             CHGVAR     VAR(&MSGF) VALUE(FWLMSGF)
             CHGVAR     VAR(&PGMQ) VALUE('BAB700C ')
             RMVMSG     CLEAR(*ALL)

             RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
/*----------------------------------------------------------------------------*/

/*-ENVIRONMENT ANPASSEN-------------------------------------------------------*/
/*------>   ÜBERSCHRIFT 1 ÜBER EINZELPOSITION   V A R I A B E L              */
/*------>   ÜBERSCHRIFT 2 ÜBER EINZELPOSITION   V A R I A B E L              */
/*------>   ÜBERSCHRIFT 1 IM KOPFBEREICH                                     */
             SNDPGMMSG  MSGID(INT9999) MSGF(&MSGF) TOPGMQ(*PRV)
             RCVMSG     PGMQ(*PRV (* &PGMQ)) MSGTYPE(*LAST) +
                          RMV(*YES) MSG(&MSG1)
/*------>   ÜBERSCHRIFT 2 IM KOPFBEREICH                                     */
             SNDPGMMSG  MSGID(AVI9998) MSGF(&MSGF) TOPGMQ(*PRV)
             RCVMSG     PGMQ(*PRV (* &PGMQ)) MSGTYPE(*LAST) +
                          RMV(*YES) MSG(&MSG2)
/*------>   ÜBERSCHRIFT 3 IM KOPFBEREICH                                     */
             SNDPGMMSG  MSGID(AVI9997) MSGF(&MSGF) TOPGMQ(*PRV)
             RCVMSG     PGMQ(*PRV (* &PGMQ)) MSGTYPE(*LAST) +
                          RMV(*YES) MSG(&MSG3)
/*------>   U2                                                               */
             SNDPGMMSG  MSGID(INT0001) MSGF(&MSGF) TOPGMQ(*PRV)
             RCVMSG     PGMQ(*PRV (* &PGMQ)) MSGTYPE(*LAST) +
                          RMV(*YES) MSG(&U2)
             RTVJOBA    JOB(&JOB) USER(&USER)
             CHGVAR     VAR(&VTL) VALUE(&USER)
             DLTF       FILE(INTRASTAT)
             MONMSG     MSGID(CPF0000)
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
                CHGVAR     VAR(%SST(&TODOC 01 04))   VALUE('INTD')
                CRTPF      FILE(DMAPLIB/INTRASTAT) +
                          SRCFILE(UEBERNAHME/QDDSSRC) +
                          SRCMBR(INTRASTAT) TEXT(INTRASTAT) +
                          OPTION(*NOLIST) AUT(*ALL)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
                CHGVAR     VAR(%SST(&TODOC 01 04))   VALUE('INTL')
                CRTPF      FILE(FMAPLIB/INTRASTAT) +
                          SRCFILE(UEBERNAHME/QDDSSRC) +
                          SRCMBR(INTRASTAT) TEXT(INTRASTAT) +
                          OPTION(*NOLIST) AUT(*ALL)
                MONMSG     MSGID(CPF0000)
             ENDDO
             CALL       PGM(DRUCK_R) PARM(&PRT)
             MONMSG     MSGID(CPF0000)
/*-CALL AUF DRUCKSTEUERPROGRAMM---==> START-----------------------------------*/
             CALL       PGM(PRTCTL) PARM(&PRT 'QM0001P   ' &CTL +
                          '*NO ' '1')
/*********************************************************************       */

/*********************************************************************       */
/*-CALL AUF PROGRAMME---------------------------------------------------------*/
             CALL       PGM(INTRA1R) PARM(&MSG1 &MSG2 &MSG3 &VTL +
                          &U1 &U2 &IN50 &ESCMSG &LEERZ &D3INDEX)
             MONMSG     MSGID(CPF0000)

/*    *     SYSGES: 20050322090226                                           */
/*    *     SYSDAT: 20050322                                                 */
/*    *     SYSZEI: 090226                                                   */
             CHGVAR     VAR(&DATMOD) VALUE('*JMT4')
             CALL       PGM(SUBR36/#DATAKTR) PARM(&DATMOD &RTNCOD +
                          &SYSGES &SYSDAT &SYSZEI)
             CHGVAR  %SST(&TODOC 5 4) %SST(&SYSDAT 3 4)
             CHGVAR     VAR(%SST(&TODOC 9 4)) VALUE('.ASC')
             CPYTOPCD   FROMFILE(INTRASTAT) TOFLR(INTRA) +
                          TODOC(&TODOC) REPLACE(*YES)
             MONMSG     MSGID(CPF0000)

             SNDPGMMSG  MSGID(FOR0010) MSGF(&MSGF) +
                          MSGDTA(&PGMQ) TOPGMQ(*PRV)
             RCVMSG     MSGTYPE(*LAST)
/*----------------------------------------------------------------------------*/
ENDE:
/*********************************************************************       */
/*-CALL AUF DRUCKSTEUERPROGRAMM---==> ENDE------------------------------------*/
             CALL       PGM(PRTCTL) PARM(&PRT 'QM0001P   ' &CTL +
                          '*NO ' '0')
/*********************************************************************       */
/*-ENVIRONMENT WIEDERHERSTELLUNG----------------------------------------------*/
             DLTOVR     FILE(*ALL) LVL(*)
             IF         COND(&LDAS= 'S') THEN(DO)
                CALL       PGM(##SVRLDA) PARM('R')
             ENDDO
             RCLRSC
             ENDPGM
