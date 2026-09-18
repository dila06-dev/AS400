/*    * PROGRAMMNAME.:BAB700C                                                */
/*    * FUNKTION.....:AUFRUF PROGRAMM BAB700                                 */
/*    * FUNKTION.....:Ausgabe der Tassolisten                                */
/*    *               (Tassolistenentwurf vom 14.12.00 Fax vom 14.12.00      */
/*    *               12:32 Uhr und nach Rücksprache mit Fachabteilungen     */
/*    *               Bandt u. Wirtz Dormagen sowie Gespräch vom 29.12.00    */
/*    *               Herren Müller/Kraft und Wirtz)                         */
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
                          &D3KUNDE &D3AUFTRAG &D3RECHNUNG +
                          &D3ARTIKEL &D3PACKLIST &D3AB &D3BIS +
                          &D3BALLEN# &D3MASCHINE)

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
             DCL        VAR(&USER)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&D3KUNDE)    TYPE(*DEC)  LEN(06)
             DCL        VAR(&D3AUFTRAG)  TYPE(*DEC)  LEN(06)
             DCL        VAR(&D3RECHNUNG) TYPE(*DEC)  LEN(06)
             DCL        VAR(&D3PACKLIST) TYPE(*DEC)  LEN(08)
             DCL        VAR(&D3ARTIKEL)  TYPE(*CHAR)  LEN(08)
             DCL        VAR(&D3AB)       TYPE(*DEC)  LEN(08)
             DCL        VAR(&D3BIS)      TYPE(*DEC)  LEN(08)
             DCL        VAR(&D3BALLEN#)  TYPE(*CHAR)  LEN(09)
             DCL        VAR(&D3MASCHINE) TYPE(*DEC)  LEN(01)

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

/*----------------------------------------------------------------------------*/

/*-ENVIRONMENT ANPASSEN-------------------------------------------------------*/
/*------>   ÜBERSCHRIFT 1 ÜBER EINZELPOSITION   V A R I A B E L              */
/*------>   ÜBERSCHRIFT 2 ÜBER EINZELPOSITION   V A R I A B E L              */
/*------>   ÜBERSCHRIFT 1 IM KOPFBEREICH                                     */
             SNDPGMMSG  MSGID(AVI9999) MSGF(&MSGF) TOPGMQ(*PRV)
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
             SNDPGMMSG  MSGID(QM00001) MSGF(&MSGF) TOPGMQ(*PRV)
             RCVMSG     PGMQ(*PRV (* &PGMQ)) MSGTYPE(*LAST) +
                          RMV(*YES) MSG(&U2)
             RTVJOBA    JOB(&JOB) USER(&USER)
             CHGVAR     VAR(&VTL) VALUE(&USER)

/*********************************************************************       */
/*-CALL AUF PROGRAMME---------------------------------------------------------*/
             CALL       PGM(QM0001R) PARM(&MSG1 &MSG2 &MSG3 &VTL &U1 +
                          &U2 &IN50 &ESCMSG &LEERZ &D3KUNDE +
                          &D3AUFTRAG &D3RECHNUNG &D3ARTIKEL +
                          &D3PACKLIST &D3AB &D3BIS &D3BALLEN# +
                          &D3MASCHINE)
             MONMSG     MSGID(CPF0000)

             SNDPGMMSG  MSGID(FOR0010) MSGF(&MSGF) +
                          MSGDTA(&PGMQ) TOPGMQ(*PRV)
             RCVMSG     MSGTYPE(*LAST)
/*----------------------------------------------------------------------------*/
ENDE:
/*-ENVIRONMENT WIEDERHERSTELLUNG----------------------------------------------*/
             DLTOVR     FILE(*ALL) LVL(*)
             IF         COND(&LDAS= 'S') THEN(DO)
                CALL       PGM(##SVRLDA) PARM('R')
             ENDDO
             RCLRSC
             ENDPGM
