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

/*          DATEN WIEDERHERSTELLEN                                           */

             DLTF       FILE(BMFLIB/KTR110)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(BMFLIBD/KTR110)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(BMFLIB/KTR008)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(BMFLIBD/KTR008)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(BMFLIB/KTR061)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(BMFLIBD/KTR061)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(KTR110_L) FROMLIB(TIM) OBJTYPE(*FILE) +
                          TOLIB(BMFLIB) NEWOBJ(KTR110) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(KTR110_D) FROMLIB(TIM) OBJTYPE(*FILE) +
                          TOLIB(BMFLIBD) NEWOBJ(KTR110) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(KTR008_L) FROMLIB(TIM) OBJTYPE(*FILE) +
                          TOLIB(BMFLIB) NEWOBJ(KTR008) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(KTR008_D) FROMLIB(TIM) OBJTYPE(*FILE) +
                          TOLIB(BMFLIBD) NEWOBJ(KTR008) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(KTR061_L) FROMLIB(TIM) OBJTYPE(*FILE) +
                          TOLIB(BMFLIB) NEWOBJ(KTR061) DATA(*YES)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(KTR061_D) FROMLIB(TIM) OBJTYPE(*FILE) +
                          TOLIB(BMFLIBD) NEWOBJ(KTR061) DATA(*YES)
             MONMSG     MSGID(CPF0000)
/*          LÖSCHEN DER SAVEFILES                                            */
             CLRSAVF    FILE(SAVEFILE/STIM)
             MONMSG     MSGID(CPF0000)
             RCLRSC

             ENDPGM
