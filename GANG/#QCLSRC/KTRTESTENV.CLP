/*    * PROGRAMMNAME.:KTRTESTENV                                             */
/*    * FUNKTION.....:...                                                    */
/*    *               ...                                                    */
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

/*----------------------------------------------------------------------------*/
             CRTDUPOBJ  OBJ(FQKORE) FROMLIB(SFBF) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(FQBATCH) FROMLIB(SFBF) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(STOIN00F) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ARTYA00F) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) DATA(*YES)
             MONMSG     MSGID(CPF0000)

ENDE:
             RCLRSC
             ENDPGM
