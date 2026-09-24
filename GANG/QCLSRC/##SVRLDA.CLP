/*    * PROGRAMMNAME.:##SVRLDA                                               */
/*    * FUNKTION.....:SAVE/RECOVER LDA                                       */
/*    * OKTOBER 2009   GANG                                                   */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/

             PGM        PARM(&CTLMOD)

             DCL        VAR(&CTLMOD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LDAINH) TYPE(*CHAR) LEN(1024)
             CHKOBJ     OBJ(QTEMP/#LDASAV) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                CRTDTAARA DTAARA(QTEMP/#LDASAV) TYPE(*CHAR) LEN(1024) +
                           VALUE(' ')
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&CTLMOD *EQ 'S') THEN(DO)
                RTVDTAARA DTAARA(*LDA (1 1024)) RTNVAR(&LDAINH)
                CHGDTAARA DTAARA(QTEMP/#LDASAV (1 1024)) VALUE(&LDAINH)
                GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&CTLMOD *EQ 'R') THEN(DO)
               RTVDTAARA DTAARA(QTEMP/#LDASAV (1 1024)) RTNVAR(&LDAINH)
                CHGDTAARA  DTAARA(*LDA (1 1024)) VALUE(&LDAINH)
                GOTO       CMDLBL(ENDE)
             ENDDO
 ENDE:       ENDPGM
