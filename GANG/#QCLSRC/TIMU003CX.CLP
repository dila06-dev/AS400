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

               STRQMQRY   QMQRY(FMAPLIB/AKTBALLEN)  OUTPUT(*OUTFILE) +
                        OUTFILE(QTEMP/AKTBALLEN) OUTMBR(*FIRST *ADD)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDE))
/*----------------------------------------------------------------------------*/
/*          ----------------------------------------------------------       */
ENDE:
             RCLRSC
             ENDPGM
