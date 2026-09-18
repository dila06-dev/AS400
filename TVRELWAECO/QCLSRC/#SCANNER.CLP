/*    * PROGRAMMNAME.:ALTE MASCHINE                                          */
/*    * FUNKTION.....:..                                                     */
/*    * SEPTEMBER 2010   GANG, MANFRED                                        */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                          PGMR.....           */
/******************************************************************************/
             PGM

   /*AKTIVIEREN                   */
             CHGUSRPRF  USRPRF(H1) STATUS(*ENABLED)
             MONMSG     MSGID(CPF0000)
             VRYCFG CFGOBJ(FUNK0002A) CFGTYPE(*DEV) STATUS(*ON)
             MONMSG     MSGID(CPF0000)

             ENDPGM
