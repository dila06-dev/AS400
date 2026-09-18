/*    * PROGRAMMNAME.:INVENTUR                                               */
/*    * FUNKTION.....:INVENTURLISTE/BESTANDLISTE                             */
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
             DLTF       FILE(QTEMP/INV0003)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/INV0004)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/INV0005)
             MONMSG     MSGID(CPF0000)
/*                                                          */
             RUNQRY     QRY(FWLFR/INV0003)
             MONMSG     MSGID(CPF0000)
/*           CLRPFM     FILE(QTEMP/INV0003)                 */
/*           MONMSG     MSGID(CPF0000)                      */
             DLTF       FILE(QTEMP/INV0004)
/*           CLRPFM     FILE(QTEMP/INV0004)         */
             MONMSG     MSGID(CPF0000)
             CALL       PGM(INV0003R)
             MONMSG     MSGID(CPF0000)
             RUNQRY     QRY(FWLFR/INV0004)
             MONMSG     MSGID(CPF0000)
             RUNQRY     QRY(FWLFR/INV0005)
             MONMSG     MSGID(CPF0000)
             RUNQRY     QRY(FWLFR/INV0006)
             MONMSG     MSGID(CPF0000)
/*                                                          */
ENDE:
             ENDPGM
