/*    * PROGRAMMNAME.:TIMU003C                                               */
/*    * FUNKTION.....:CALL TIMU003C                                          */
/*    *               AKTUELLE DATEN VON DER MASCHINE FWLHOST                */
/*    *               PER FTP LADEN (LIB: FWLPD)                             */
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

/*       SONSTIGES                                          */
             DCL        VAR(&FWLFIRM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&ENV)     TYPE(*CHAR) LEN(01)
/*----------------------------------------------------------------------------*/
/*-ENVIRONMENT ANPASSEN BZW ERSTELLEN-----------------------------------------*/
             RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
             RTVDTAARA  DTAARA(FWLFIRM (2 1)) RTNVAR(&ENV)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
             IF         COND(&ENV *EQ '3') THEN(DO)
                STRQMQRY   QMQRY(FMAPLIB/LINGPRODUS) OUTPUT(*OUTFILE) +
                             OUTFILE(QTEMP/AKTBALLEN)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
             ENDDO
                CALL       PGM(#DEFLDA) PARM(' ')
                CALL TIMU003R
            GOTO       CMDLBL(ENDE)
                CALL       PGM(##SVRLDA) PARM('S')
/*              CALL       PGM(YS2001C)           */
/*                CALL       PGM(YS2001)          */
/*      BEI MANUELLEM AUFRUF VON TIMU003C  YS2001C ANSCHL. AUFRUFEN */
                CALL       PGM(##SVRLDA) PARM('R')
                GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
             ENDDO
/*----------------------------------------------------------------------------*/
             GOTO       CMDLBL(ENDE)
/*          ----------------------------------------------------------       */
ENDE:
             RCLRSC
             ENDPGM
