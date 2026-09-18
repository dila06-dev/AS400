/*    * PROGRAMMNAME.:DIS0003RC                                              */
/*    * FUNKTION.....:INVENTURLISTE/BESTANDSLISTE ÜBER REMOTE                */
/*    * NOVEMBER 2000                                                         */
/*    *                                                                       */
/*    * FASERWERKE-LINGEN GMBH                                                */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM
             DCL        VAR(&FWLFIRM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&LDAS)   TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&MSGPGM) TYPE(*CHAR) LEN(10)

             RTVDTAARA  DTAARA(*LDA (954 10)) RTNVAR(&MSGPGM)
             RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                CRTDTAARA  DTAARA(QTEMP/FWLFIRM) TYPE(*CHAR) LEN(2)
                CALL       PGM(#LIBNEUC) PARM('L' 'P')
                RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
             ENDDO
/*           IF         COND(&MSGPGM= '          ') THEN(DO)     */
                CALL       PGM(##SVRLDA) PARM('S')
                CHGDTAARA  DTAARA(*LDA (954 10)) VALUE(DIS0003RC)
                CHGVAR     VAR(&LDAS) VALUE('S')
                CALL       PGM(#DEFLDA) PARM(' ')
/*           ENDDO                                               */
/*          LIBLISTÄNDERUNG UND T *REPLACE DIS0002                           */
/*                                                          */
             CALL       PGM(UEBERNAHME/DIS0003C) PARM(' ' '9')
             MONMSG     MSGID(CPF0000)
/*                                                          */
/*********************************************************************       */
             CALL       PGM(#LIBALTC)
             GOTO       CMDLBL(ENDE)
/*                                                          */
ENDE:
             ENDPGM
