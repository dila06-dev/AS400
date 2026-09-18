/*    * PROGRAMMNAME.:STRQRY                                                 */
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
             PGM  PARM(&DLYTIMEC)

             DCL        VAR(&DLYTIMEC) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DLYTIME) TYPE(*DEC) LEN(6 0)
             CHGVAR     VAR(&DLYTIME) VALUE(&DLYTIMEC)
             DLYJOB     DLY(&DLYTIME)
             GOTO       ENDE
/*          ----------------------------------------------------------       */
ENDE:
             ENDPGM
