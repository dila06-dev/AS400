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

             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             CHGVAR     VAR(&LIB) VALUE('SAVEFILE')
/*----------------------------------------------------------------------------*/
/*          POMS_ÜBERNAHME                                                   */
             DLTF       FILE(UEBERNAHME/POMS_FAL)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(UEBERNAHME/POMS_GBL)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(UEBERNAHME/POMS_FASTL)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(UEBERNAHME/POMS_QUL)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(UEBERNAHME/POMS_SPMGL)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(UEBERNAHME/POMS_SPMG0)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(UEBERNAHME/POMS_ARTIL)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(UEBERNAHME/POMS_*)
             MONMSG     MSGID(CPF0000)
             MOVOBJ     OBJ(TIM/POMS_GB) OBJTYPE(*FILE) +
                          TOLIB(UEBERNAHME)
             MOVOBJ     OBJ(TIM/POMS_QU) OBJTYPE(*FILE) +
                          TOLIB(UEBERNAHME)
             MOVOBJ     OBJ(TIM/POMS_FAST) OBJTYPE(*FILE) +
                          TOLIB(UEBERNAHME)
             MOVOBJ     OBJ(TIM/POMS_SPMG) OBJTYPE(*FILE) +
                          TOLIB(UEBERNAHME)
             MOVOBJ     OBJ(TIM/POMS_ARTI) OBJTYPE(*FILE) +
                          TOLIB(UEBERNAHME)
             MOVOBJ     OBJ(TIM/POMS_FA) OBJTYPE(*FILE) +
                          TOLIB(UEBERNAHME)
             DLTF       FILE(TIM/POMS_GBL)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(TIM/POMS_FASTL)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(TIM/POMS_QUL)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(TIM/POMS_SPMGL)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(TIM/POMS_SPMG0)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(TIM/POMS_ARTIL)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(TIM/POMS_FAL)
             MONMSG     MSGID(CPF0000)
/*----------------------------------------------------------------------------*/
/*          OBJEKTE AUS LIB FWLPD                                            */
             MONMSG     MSGID(CPF0000)
             RSTOBJ     OBJ(*ALL) SAVLIB(FWLPD) DEV(*SAVF) +
                          SAVF(&LIB/SFWLPD) MBROPT(*ALL) +
                          ALWOBJDIF(*ALL) RSTLIB(FWLPD)
             MONMSG     MSGID(CPF0000)

/*          OBJEKTE AUS LIB TIM                                              */
             CLRLIB     LIB(TIM)
             MONMSG     MSGID(CPF0000)
             RSTOBJ     OBJ(*ALL) SAVLIB(TIM) DEV(*SAVF) +
                          SAVF(&LIB/STIM) MBROPT(*ALL) +
                          ALWOBJDIF(*ALL) RSTLIB(TIM)
             MONMSG     MSGID(CPF0000)

/*          ITEMAS IN LIBS ÜBERTRAGEN                    NEIN                */
             MOVOBJ     OBJ(TIM/ITEMAS_L) OBJTYPE(*FILE) TOLIB(AMFLIB)
             MONMSG     MSGID(CPF0000)
             RNMOBJ     OBJ(AMFLIB/ITEMAS_L) OBJTYPE(*FILE) +
                          NEWOBJ(ITEMAS)
             MONMSG     MSGID(CPF0000)
             MOVOBJ     OBJ(TIM/ITEMAS_D) OBJTYPE(*FILE) TOLIB(AMFLIBD)
             MONMSG     MSGID(CPF0000)
             RNMOBJ     OBJ(AMFLIBD/ITEMAS_D) OBJTYPE(*FILE) +
                          NEWOBJ(ITEMAS)
             MONMSG     MSGID(CPF0000)

/*          POMS-DATEN WIEDERHERSTELLEN                                      */
             CPYF       FROMFILE(UEBERNAHME/POMS_GB) +
                          TOFILE(TIM/POMS_GB) MBROPT(*ADD)
             CPYF       FROMFILE(UEBERNAHME/POMS_QU) +
                          TOFILE(TIM/POMS_QU) MBROPT(*ADD)
             CPYF       FROMFILE(UEBERNAHME/POMS_FAST) +
                          TOFILE(TIM/POMS_FAST) MBROPT(*ADD)
             CPYF       FROMFILE(UEBERNAHME/POMS_SPMG) +
                          TOFILE(TIM/POMS_SPMG) MBROPT(*ADD)
             CPYF       FROMFILE(UEBERNAHME/POMS_ARTI) +
                          TOFILE(TIM/POMS_ARTI) MBROPT(*ADD)
             CPYF       FROMFILE(UEBERNAHME/POMS_FA) +
                          TOFILE(TIM/POMS_FA) MBROPT(*ADD)

/*          LÖSCHEN DER SAVEFILES                                            */
             CLRSAVF    FILE(SAVEFILE/STIM)
             MONMSG     MSGID(CPF0000)
             RCLRSC

             ENDPGM
