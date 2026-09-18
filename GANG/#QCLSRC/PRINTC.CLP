/*    * PROGRAMMNAME.:A0001C                                                 */
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
             PGM        PARM(&ORDER &INVOICE &V)

             DCL        VAR(&ORDER)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&INVOICE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&V)       TYPE(*CHAR) LEN(132)

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
       /*    CHGVAR     VAR(%SST(&V 1 5)) VALUE(%SST(&FILNBR 1 5)) */
       /*    CHGVAR     VAR(%SST(&V 1 5)) VALUE('V ok ')     */
             CALL       PGM(UEBERNAHME/PRINTR) PARM(&ORDER &INVOICE &V)
             GOTO       CMDLBL(ENDE)
/*----------------------------------------------------------------------------*/
/*          ----------------------------------------------------------       */
ENDE:

             DLTOVR     FILE(*ALL) LVL(*)
             MONMSG     MSGID(CPF0000)
             RCLRSC
             ENDPGM
