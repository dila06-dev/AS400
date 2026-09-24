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
/*          OBJEKTE AUS LIB GANG                         OK                  */
             CLRLIB     LIB(GANG)
             MONMSG     MSGID(CPF0000)
             RSTOBJ     OBJ(*ALL) SAVLIB(QS36F) DEV(*SAVF) +
                          SAVF(&LIB/SGANG) MBROPT(*ALL) +
                          ALWOBJDIF(*ALL) RSTLIB(GANG)
             MONMSG     MSGID(CPF0000)

/*          OBJEKTE AUS LIB BMAP0475L                    NOCH OK             */
             CLRLIB     LIB(BMAPKTRL)
             MONMSG     MSGID(CPF0000)
             RSTOBJ     OBJ(*ALL) SAVLIB(BMAP0475L) DEV(*SAVF) +
                          SAVF(&LIB/SBMAP0475L) MBROPT(*ALL) +
                          ALWOBJDIF(*ALL) RSTLIB(BMAPKTRL)
             MONMSG     MSGID(CPF0000)

/*          OBJEKTE AUS LIB BMAP0476L                    NOCH OK             */
             CLRLIB     LIB(BMAPKTRD)
             MONMSG     MSGID(CPF0000)
             RSTOBJ     OBJ(*ALL) SAVLIB(BMAP0476L) DEV(*SAVF) +
                          SAVF(&LIB/SBMAP0476L) MBROPT(*ALL) +
                          ALWOBJDIF(*ALL) RSTLIB(BMAPKTRD)
             MONMSG     MSGID(CPF0000)

/*          OBJEKTE AUS LIB FWLPD                        OK                  */
             CLRLIB     LIB(FWLPD)
             MONMSG     MSGID(CPF0000)
             RSTOBJ     OBJ(*ALL) SAVLIB(FWLPD) DEV(*SAVF) +
                          SAVF(&LIB/SFWLPD) MBROPT(*ALL) +
                          ALWOBJDIF(*ALL) RSTLIB(FWLPD)
             MONMSG     MSGID(CPF0000)

/*          OBJEKTE AUS LIB TIM                          OK                  */
             CLRLIB     LIB(TIM)
             MONMSG     MSGID(CPF0000)
             RSTOBJ     OBJ(*ALL) SAVLIB(TIM) DEV(*SAVF) +
                          SAVF(&LIB/STIM) MBROPT(*ALL) +
                          ALWOBJDIF(*ALL) RSTLIB(TIM)
             MONMSG     MSGID(CPF0000)

/*          OBJEKTE AUS LIB AMFLIB                       NEIN                */
             CLRLIB     LIB(AMFLIB)
             MONMSG     MSGID(CPF0000)
             RSTOBJ     OBJ(*ALL) SAVLIB(AMFLIB) DEV(*SAVF) +
                          SAVF(&LIB/SAMFLIB) MBROPT(*ALL) +
                          ALWOBJDIF(*ALL) RSTLIB(AMFLIB)
             MONMSG     MSGID(CPF0000)

/*          OBJEKTE AUS LIB AMFLIBD                      NEIN                */
             CLRLIB     LIB(AMFLIBD)
             MONMSG     MSGID(CPF0000)
             RSTOBJ     OBJ(*ALL) SAVLIB(AMFLIBD) DEV(*SAVF) +
                          SAVF(&LIB/SAMFLIBD) MBROPT(*ALL) +
                          ALWOBJDIF(*ALL) RSTLIB(AMFLIBD)
             MONMSG     MSGID(CPF0000)

/*          OBJEKTE AUS LIB LMFLIB                       NEIN                */
             CLRLIB     LIB(LMFLIB)
             MONMSG     MSGID(CPF0000)
             RSTOBJ     OBJ(*ALL) SAVLIB(LMFLIB) DEV(*SAVF) +
                          SAVF(&LIB/SLMFLIB) MBROPT(*ALL) +
                          ALWOBJDIF(*ALL) RSTLIB(LMFLIB)
             MONMSG     MSGID(CPF0000)

/*          OBJEKTE AUS LIB LMFLIBD                      NEIN                */
             CLRLIB     LIB(LMFLIBD)
             MONMSG     MSGID(CPF0000)
             RSTOBJ     OBJ(*ALL) SAVLIB(LMFLIBD) DEV(*SAVF) +
                          SAVF(&LIB/SLMFLIBD) MBROPT(*ALL) +
                          ALWOBJDIF(*ALL) RSTLIB(LMFLIBD)
             MONMSG     MSGID(CPF0000)

/*          OBJEKTE AUS LIB BMFLIB                       NEIN                */
             CLRLIB     LIB(BMFLIB)
             MONMSG     MSGID(CPF0000)
             RSTOBJ     OBJ(*ALL) SAVLIB(BMFLIB) DEV(*SAVF) +
                          SAVF(&LIB/SBMFLIB) MBROPT(*ALL) +
                          ALWOBJDIF(*ALL) RSTLIB(BMFLIB)
             MONMSG     MSGID(CPF0000)

/*          OBJEKTE AUS LIB BMFLIBD                      NEIN                */
             CLRLIB     LIB(BMFLIBD)
             MONMSG     MSGID(CPF0000)
             RSTOBJ     OBJ(*ALL) SAVLIB(BMFLIBD) DEV(*SAVF) +
                          SAVF(&LIB/SBMFLIBD) MBROPT(*ALL) +
                          ALWOBJDIF(*ALL) RSTLIB(BMFLIBD)
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

             DLTF       FILE(FMAPLIB_T/KTR110)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(DMAPLIB_T/KTR110)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(KTR110) FROMLIB(BMAPKTRL) OBJTYPE(*FILE) +
                          TOLIB(FMAPLIB_T) NEWOBJ(KTR110) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(KTR110) FROMLIB(BMAPKTRD) OBJTYPE(*FILE) +
                          TOLIB(DMAPLIB_T) NEWOBJ(KTR110) DATA(*YES)
             MONMSG     MSGID(CPF0000)
/*          LÖSCHEN DER SAVEFILES                                            */
             CLRSAVF    FILE(SAVEFILE/STIM)
             MONMSG     MSGID(CPF0000)
             RCLRSC

             ENDPGM
