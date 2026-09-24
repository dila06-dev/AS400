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

   /*TESTUMGEBUNG AKTIV           */
             ADDLIBLE   LIB(TVRELWAECO) POSITION(*FIRST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(TVRELWAECO/WORKSHOPS)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(TVRELWAECO/#WORKSHOPS)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(TVRELWAECO/PRODUCTS)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(TVRELWAECO/#PRODUCTS)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(TVRELWAECO/VEHICLES)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(TVRELWAECO/#VEHICLES)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(TVRELWAECO/CUSTOMERS)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(TVRELWAECO/#CUSTOMERS)
             MONMSG     MSGID(CPF0000)

/*             ZIEHEN RELEVANTER DATEN                                       */
                CALL       PGM(DUMMY512) PARM(&MD '#MI0100' ' ' ' ' +
                          '#WORKSHOPS' 'TVRELWAECO' '*ADD')
                MONMSG     MSGID(CPF0000)

                CALL       PGM(DUMMY512) PARM(&MD '#MI0110' ' ' ' ' +
                          '#PRODUCTS' 'TVRELWAECO' '*ADD')
                MONMSG     MSGID(CPF0000)

                CALL       PGM(DUMMY512) PARM(&MD '#MI0120' ' ' ' ' +
                          '#VEHICLES' 'TVRELWAECO' '*ADD')
                MONMSG     MSGID(CPF0000)

                CALL       PGM(DUMMY512) PARM(&MD '#MI0130' ' ' ' ' +
                          '#CUSTOMERS' 'TVRELWAECO' '*ADD')
                MONMSG     MSGID(CPF0000)

/*             KEYS                                                          */
                CALL       PGM(DUMMY512) PARM(&MD '#MI0200' ' ' ' ' +
                          ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)

                CALL       PGM(DUMMY512) PARM(&MD '#MI0210' ' ' ' ' +
                          ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)

                CALL       PGM(DUMMY512) PARM(&MD '#MI0220' ' ' ' ' +
                          ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)

                CALL       PGM(DUMMY512) PARM(&MD '#MI0230' ' ' ' ' +
                          ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)

 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
    /*          RMVLIBLE   LIB(GANG)                       */
             ENDDO
             IF         COND(&ERROR1 = '0') THEN(DO)
    /*          RMVLIBLE   LIB(TVRELWAECO)                 */
             ENDDO

             ENDPGM
