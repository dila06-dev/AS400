/*    * PROGRAMMNAME.:#CHGPFM                                                */
/*    * FUNKTION.....:TEILDATEI ÄNDERN                                       */
/*    * JULI 1998      GANG, MANFRED                                          */
/*    *                                                                       */
/*    * FASERWERKE-LINGEN GMBH                                                */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&MBR &FILE &LIBL &ATTRC)

             DCL        VAR(&MBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&MSGPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TXT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&ATTRC)   TYPE(*CHAR) LEN(02)
             DCL        VAR(&ATTRN)   TYPE(*DEC) LEN(02 0)
/*                                                          */
/*----------------------------------------------------------------------------*/
             RTVDTAARA  DTAARA(*LDA (954 10)) RTNVAR(&MSGPGM)
/*----------------------------------------------------------------------------*/
             CHGVAR     VAR(&ATTRN) VALUE(&ATTRC)
             RTVMBRD    FILE(&LIBL/&FILE) MBR(&MBR) TEXT(&TXT)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                 CHGVAR     VAR(&ERROR) VALUE('1')
                 GOTO ENDE
             ENDDO
             CHGVAR     VAR(&TXT) VALUE('"X''"BB"''"')

             CALL       PGM(#CHGPFMR) PARM(&TXT &ATTRN)
             CHGPFM     FILE(&LIBL/&FILE) MBR(&MBR) TEXT(&TXT)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                 CHGVAR     VAR(&ERROR) VALUE('1')
             ENDDO

ENDE:
             IF         COND(&ERROR = '1') THEN(DO)
             SNDPGMMSG  MSG('Fehler aufgetreten, falsche Angaben +
                          über Sourcen') TOPGMQ(*SAME (&MSGPGM))
             MONMSG     MSGID(CPF0000)
             ENDDO
             RCLRSC
             RETURN
