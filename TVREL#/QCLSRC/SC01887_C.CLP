/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:IDCO                                                   */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    * .                                                                     */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&PARM)

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*AFTER TFXF)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))


             IF         COND(&PARM *EQ '1' ) THEN(DO)
/*             GENERELLER AUFBAU                                             */
/*             ZIEHEN RELEVANTER DATEN AUS #LBLB                             */
            CALL       PGM(DUMMY512) PARM(&MD '#DC4010' ' ' ' ' +
                       '#AFRK01887' 'TVRELWAECO' '*ADD')
            MONMSG     MSGID(CPF0000)
      /*    CALL       PGM(DUMMY512) PARM(&MD '#CT0501' ' ' ' ' + */
      /*                '#AFRK01887' 'TVRELWAECO' '*ADD')         */
      /*     MONMSG     MSGID(CPF0000)                            */
             CPYF       FROMFILE(TVRELWAECO/DOMINV_DK) +
                           TOFILE(TVRELWAECO/DOMINV_DKS) +
                           TOMBR(*FIRST) MBROPT(*ADD) CRTFILE(*NO)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(TVRELWAECO/DOMINV_DK)
                MONMSG     MSGID(CPF0000)

                CALL       PGM(SC01887_R)
                MONMSG     MSGID(CPF0000)

                CPYF       FROMFILE(TVRELWAECO/DOMINV_DK) +
                             TOFILE(WAECOEDI/DOMINVCHCK) +
                             MBROPT(*REPLACE) CRTFILE(*NO)
                MONMSG     MSGID(CPF0000)

                CALL       PGM(GFTPINV) PARM('dk')

             ENDDO
/*                                                                            */
 ENDPGM:
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO

             ENDPGM
