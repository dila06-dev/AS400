/*    * PROGRAMMNAME.:A00042C                                                */
/*    * FUNKTION.....:CALL       A00042R    &PGMCALL                         */
/*    *               CALL       A00043R    &PGMCALL                         */
/*    * 2004                                                                  */
/*    *                                                                       */
/*    * FASERWERKE-LINGEN GMBH                                                */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/*    * 04.07.2001                                            GANG            */
/******************************************************************************/
             PGM        PARM(&PGMCALL)

             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&PGMCALL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LDAS)   TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
/*                                                              */
             DCL        VAR(&MODUS)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATMOD)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&RTNCOD)  TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&SYSGES)  TYPE(*CHAR) LEN(26)
             DCL        VAR(&SYSDAT)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYSZEI)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FWLFIRM) TYPE(*CHAR) LEN(01)
/*----------------------------------------------------------------------------*/
             RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
             ENDDO
/*----------------------------------------------------------------------------*/
/*                                                */
/*          ---UPDATE DER DMAPLIB                                            */
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
                OVRDBF     FILE(YARCHIV) TOFILE(DMAPLIB/ARCHIVL1) +
                            MBR(*FIRST) OVRSCOPE(*CALLLVL)
             ENDDO
/*                                                */
/*          ---UPDATE DER FMAPLIB                                            */
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
                OVRDBF     FILE(YARCHIV) TOFILE(FMAPLIB/ARCHIVL1) +
                            MBR(*FIRST) OVRSCOPE(*CALLLVL)
             ENDDO
/*                                                */
             OVRDBF     FILE(XARCHIV) TOFILE(FWLGSMLIB/ARCHIVL1) +
                          MBR(*FIRST) OVRSCOPE(*CALLLVL)
/*                                                */
/*          LIBLIST ÄNDERN                                                   */
             ADDLIBLE   LIB(FWLGSMLIB) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))
             ADDLIBLE   LIB(SFBF)      POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
/*                                                */
/*          LIBLIST ÄNDERN                                                   */
             IF         COND(&PGMCALL *EQ 'A00042R') THEN(DO)
                CALL       A00042R
                MONMSG     MSGID(CPF0000)
             ENDDO
/*          ----------------------------------------------------------       */
             OVRDBF     FILE(XARCHIV) TOFILE(FWLGSMLIB/ARCHIVL1) +
                          MBR(*FIRST) OVRSCOPE(*CALLLVL)
/*          ---UPDATE DER FMAPLIB                                            */
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
                OVRDBF     FILE(YARCHIV) TOFILE(FMAPLIB/ARCHIVL4) +
                           MBR(*FIRST) OVRSCOPE(*CALLLVL)
             ENDDO
/*          ---UPDATE DER DMAPLIB                                            */
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
                OVRDBF     FILE(YARCHIV) TOFILE(DMAPLIB/ARCHIVL4) +
                           MBR(*FIRST) OVRSCOPE(*CALLLVL)
             ENDDO
             IF         COND(&PGMCALL *EQ 'A00043R') THEN(DO)
                CALL       A00043R
                MONMSG     MSGID(CPF0000)
             ENDDO
/*          ----------------------------------------------------------       */
ENDE:

             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(FWLGSMLIB)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(SFBF)
             ENDDO
/*                                                */
             DLTOVR     FILE(*ALL) LVL(*)
             MONMSG     MSGID(CPF0000)
             RCLRSC
             ENDPGM
