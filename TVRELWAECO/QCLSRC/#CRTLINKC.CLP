/*    * PROGRAMMNAME.:...                                                    */
/*    * FUNKTION.....:.                                                      */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM
             DCL        VAR(&TIMESTAMP)      TYPE(*CHAR) LEN(26)
             CALL       PGM(TIMESTAMP) PARM(&TIMESTAMP)
             MONMSG     MSGID(CPF0000)
             ADDLNK     OBJ('/HOME/GANG/') NEWLNK(&TIMESTAMP)
             MONMSG     MSGID(CPF0000)
             ENDPGM
