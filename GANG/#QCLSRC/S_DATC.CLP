/*    * PROGRAMMNAME.:#DSPFILES                                              */
/*    * FUNKTION.....:ALLE DATEIEN EINER LIB ANZEIGEN                        */
/*    * 06.07.98       MANFRED GANG                                           */
/*    *                                                                       */
/*    * FASER-WERKE-LINGEN GMBH                                               */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * 18.11.99  LDA WIRD NICHT GESICHERT                    GANG            */
/******************************************************************************/
             PGM
             CPYF       FROMFILE(*LIBL/S_200604) +
                          TOFILE(SFBKORE/SPPREISE1) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(*LIBL/H_200604) +
                          TOFILE(SFBKORE/HFPREISE1) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)
 EOF:
             GOTO       CMDLBL(ENDE)

/******************************************************************************/

ENDE:

             ENDPGM
