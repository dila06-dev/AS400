/*    * PROGRAMMNAME.:TREND ENVIRONMENT AUFBAUEN                             */
/*    * FUNKTION.....:..                                                     */
/*    * SEPTEMBER 2010   GANG, MANFRED                                        */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                          PGMR.....           */
/******************************************************************************/
             PGM        PARM(&PARM)

             DCL        VAR(&PARM) TYPE(*CHAR) LEN(04)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&CALL) TYPE(*CHAR) LEN(10) VALUE(' ')

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')

             CALL       PGM(TE)

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*FIRST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
             MONMSG     MSGID(CPF0000)

             CHGDTAARA  DTAARA(TVRELWAECO/$AFRK88505 *ALL) VALUE(0)
             CLRPFM     FILE(TVRELWAECO/#AFRK88505)
             CLRPFM     FILE(TVRELWAECO/DOMINV_FRS)
             CLRPFM     FILE(TVRELWAECO/DOMINV_FR)

             CHGDTAARA  DTAARA(TVRELWAECO/$AFRK40631 *ALL) VALUE(0)
             CLRPFM     FILE(TVRELWAECO/#AFRK40631)
             CLRPFM     FILE(TVRELWAECO/DOMINV_UKS)
             CLRPFM     FILE(TVRELWAECO/DOMINV_UK)

             CHGDTAARA  DTAARA(TVRELWAECO/$AFRK01887 *ALL) VALUE(0)
             CLRPFM     FILE(TVRELWAECO/#AFRK01887)
             CLRPFM     FILE(TVRELWAECO/DOMINV_DKS)
             CLRPFM     FILE(TVRELWAECO/DOMINV_DK)

             CHGDTAARA  DTAARA(TVRELWAECO/$AFRK15177 *ALL) VALUE(0)
             CLRPFM     FILE(TVRELWAECO/#AFRK15177)
             CLRPFM     FILE(TVRELWAECO/DOM004)
             CLRPFM     FILE(TVRELWAECO/DOM004S)

             CHGDTAARA  DTAARA(TVRELWAECO/$AFRK62765 *ALL) VALUE(0)
             CLRPFM     FILE(TVRELWAECO/#AFRK62765)
             CLRPFM     FILE(TVRELWAECO/DOM005)
             CLRPFM     FILE(TVRELWAECO/DOM005S)

             CHGDTAARA  DTAARA(TVRELWAECO/$AFRK11016 *ALL) VALUE(0)
             CLRPFM     FILE(TVRELWAECO/#AFRK11016)
             CLRPFM     FILE(TVRELWAECO/EDI_TECHP)
             CLRPFM     FILE(TVRELWAECO/EDI_TECHPS)

             CHGDTAARA  DTAARA(TVRELWAECO/$AFRK_FORD *ALL) VALUE(0)
             CLRPFM     FILE(TVRELWAECO/#AFRK_F)
             CLRPFM     FILE(TVRELWAECO/CT_FORD)
             CLRPFM     FILE(TVRELWAECO/CT_FORDS)



 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
    /*          RMVLIBLE   LIB(GANG)                       */
             ENDDO
             IF         COND(&ERROR1 = '0') THEN(DO)
    /*          RMVLIBLE   LIB(TVRELWAECO)                 */
             ENDDO

             ENDPGM
