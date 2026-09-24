/*    * PROGRAMMNAME.:HAB218C                                                */
/*    * FUNKTION.....:....                                                   */
/*    *               ...                                                    */
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
             PGM

             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

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
/*-ENVIRONMENT ANPASSEN BZW ERSTELLEN-----------------------------------------*/
/*                                                */
             ADDLIBLE   LIB(FWLGSMLIB) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))
             ADDLIBLE   LIB(SFBF)      POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
             DLTF       FILE(TIM/HAB218)
             MONMSG     MSGID(CPF0000)
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
                CRTDDMF    FILE(TIM/HAB218) RMTFILE(FMAPLIB/HAB218) +
                            RMTLOCNAME('10.185.0.002' *IP) AUT(*ALL)
                MONMSG     MSGID(CPF0000)
                CPYF      FROMFILE(TIM/HAB218) TOFILE(FMAPLIB/HAB218) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
                MONMSG     MSGID(CPF0000)
                DLTF       FILE(TIM/HAB218)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
                CRTDDMF    FILE(TIM/HAB218) RMTFILE(DMAPLIB/HAB218) +
                            RMTLOCNAME('10.185.0.002' *IP) AUT(*ALL)
                MONMSG     MSGID(CPF0000)
                CPYF     FROMFILE(TIM/HAB218) TOFILE(DMAPLIB/HAB218) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
                MONMSG     MSGID(CPF0000)
                DLTF       FILE(TIM/HAB218)
                MONMSG     MSGID(CPF0000)
             ENDDO
             CALL       HAB218R
             MONMSG     MSGID(CPF0000)
/*           OVRDBF     FILE(HAB210) TOFILE(*LIBL/HAB218) +     */
/*                        OVRSCOPE(*CALLLVL)                    */
/*           MONMSG     MSGID(CPF0000)                          */
/*           CALL       HAB218R                                 */
/*           MONMSG     MSGID(CPF0000)                          */
             DLTOVR     FILE(*ALL) LVL(*)
             MONMSG     MSGID(CPF0000)
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
             CLRPFM     FILE(FMAPLIB/HAB218)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
                CLRPFM     FILE(DMAPLIB/HAB218)
                MONMSG     MSGID(CPF0000)
             ENDDO
/*          ----------------------------------------------------------       */
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(FWLGSMLIB)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(SFBF)
             ENDDO
             CALL       PGM(#DEFLDA) PARM(' ')
ENDE:
             RCLRSC
             ENDPGM
