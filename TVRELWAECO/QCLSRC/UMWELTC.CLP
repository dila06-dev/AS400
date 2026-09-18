/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:UMWELTC                                                */
/*    *               ...                                                    */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR3)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)

         /*  DLTF       TVRELWAECO/RPMII_FCSV               */
         /*  MONMSG     MSGID(CPF0000)                      */

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*FIRST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*FIRST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             ADDLIBLE   LIB(TVPF) POSITION(*FIRST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR3) +
                          VALUE('1'))

         /* *** ABRUFDATEI PC UPLOAD.CSV, WIRD ÜBERSCHRIEBEN                 */
             CPYFRMIMPF FROMFILE(TVRELWAECO/ENVIRI5)      +
                         TOFILE(TVRELWAECO/UMWELT)         +
                         MBROPT(*REPLACE) FLDDLM(';')       +
                         RPLNULLVAL(*FLDDFT)
             MONMSG     MSGID(CPF0000)


/*          GEWICHTR (GENERIERT ALLE BESTANDTEILE AUS RPM)                   */
             CALL UMWELTR
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(TVRELWAECO/UMWELT) +
                          TOFILE(TVRELWAECO/UMWELTSAV) +
                          MBROPT(*ADD) CRTFILE(*NO)
             MONMSG     MSGID(CPF0000)
/*                                                                            */

 ENDPGM:
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&ERROR3 = '0') THEN(DO)
             ENDDO

             ENDPGM
