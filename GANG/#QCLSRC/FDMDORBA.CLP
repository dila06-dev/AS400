/*    * PROGRAMMNAME.:ÜBERNAHME ARTIKELDATEN                                 */
/*    * FUNKTION.....:INITIALISIEREN DER BEREICHE                            */
/*    * 06.07.98                                                              */
/*    *                                                                       */
/*    * Manfred Gang                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

/*          FDMDORBA                                                         */
 LOOP:       ALCOBJ     OBJ((TIM/FDMDORBA *FILE *EXCL *FIRST))
                MONMSG     MSGID(CPF0000) EXEC(DO)
                 DLYJOB     DLY(10)
             GOTO       CMDLBL(LOOP)
             ENDDO
             CPYF       FROMFILE(QTEMP/FDMDORBA) +
                          TOFILE(TIM/FDMDORBA) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
             DLCOBJ     OBJ((TIM/FDMDORBA *FILE *EXCL *FIRST))
             MONMSG     MSGID(CPF0000)
             RCLRSC

             ENDPGM
