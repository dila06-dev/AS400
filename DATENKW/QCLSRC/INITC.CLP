/*    * PROGRAMMNAME.:INITC                                                  */
/*    * FUNKTION.....:INITIALISIERUNG                                        */
/*    * JULI    2010   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&MODUS)   TYPE(*CHAR) LEN(01)

             CLRPFM     FILE(DATENKW/#LBLB)
      /*     MONMSG     MSGID(CPF0000)       */

             CLRPFM     FILE(PRODTST88/PRJ535P)
      /*     MONMSG     MSGID(CPF0000)       */
             CLRPFM     FILE(PRODTST88/PRJ537P)
      /*     MONMSG     MSGID(CPF0000)       */
             CLRPFM     FILE(PRODTST88/PRJ538P)
      /*     MONMSG     MSGID(CPF0000)       */
             CLRPFM     FILE(PRODTST88/PRJ615PAL0)
      /*     MONMSG     MSGID(CPF0000)       */

             CLRPFM     FILE(PRODWIN51/PRJ535P)
      /*     MONMSG     MSGID(CPF0000)       */
             CLRPFM     FILE(PRODWIN51/PRJ537P)
      /*     MONMSG     MSGID(CPF0000)       */
             CLRPFM     FILE(PRODWIN51/PRJ538P)
      /*     MONMSG     MSGID(CPF0000)       */
             CLRPFM     FILE(PRODWIN51/PRJ615PAL0)
      /*     MONMSG     MSGID(CPF0000)       */

             CHGDTAARA  DTAARA(DATENKW/#SKU) VALUE(0010000000)
      /*     MONMSG     MSGID(CPF0000)       */
             CHGDTAARA DTAARA(DATENKW/LAGERBEWC) VALUE('1')
      /*     MONMSG     MSGID(CPF0000)       */

      /*     DELETE FROM SBGFAN00 WHERE FAN020 ='998'    */
      /*     AND SUBSTR(FAN030, 1, 3) = '001'            */

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)
             CALL PGM(DUMMY512) PARM(' ' '#DE1212' ' ' ' ' ' ' ' ' ' ')

      /*     MONMSG     MSGID(CPF0000)       */

 ENDPGM:

             ENDPGM
