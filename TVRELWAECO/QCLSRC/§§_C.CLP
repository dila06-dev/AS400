/*    * PROGRAMMNAME.:...                                                    */
/*    * FUNKTION.....:.                                                      */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM
             CHGCURLIB  CURLIB(TVRELWAECO)
             OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                       MBR(§§CMD)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +
                       MBR(§§LOG)
             MONMSG     MSGID(CPF0000)

             FTP        RMTSYS('DOMETIC-GROUP.COM')
             MONMSG     MSGID(CPF0000)
             CHGCURLIB  CURLIB(*CRTDFT)
             ENDPGM
