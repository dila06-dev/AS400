/*    * PROGRAMMNAME.:CALL ........                                          */
/*    * FUNKTION.....:EINLESEPROZESS                                         */
/*    *               UPDATEFUNKTION                                         */
/*    *               AUSGABE                                                */
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
             DCL        VAR(&OUTFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)

/*                                                                            */
       /*   *** NUR INHALTE, DIE ÜBERGEBEN WERDEN MÜSSEN                     */
       /*    CALL    PGM(DUMMY512) PARM(&MD '#RP0500' ' ' ' ' +    */
       /*                '#RP0500' 'TVRELWAECO' '*ADD')            */
       /*    MONMSG     MSGID(CPF0000)                             */

       /*   *** PROTOKOLL SETZTEN (CURRENT DATE) AUF TVRELWAECO/RPMII        */
       /*    CALL    PGM(DUMMY512) PARM(&MD '#RP0501' ' ' ' ' +    */
       /*                ' ' ' ' ' ')                              */
       /*    MONMSG     MSGID(CPF0000)                             */

       /*   *** ABRUFDATEI PC                                                */

             ADDLIBLE   LIB(BAR_KALK) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             CALL       PGM(MANFTP) PARM('1')
             MONMSG     MSGID(CPF0000)

             CPYFRMIMPF FROMFILE(TVRELWAECO/MAN_UPLOAD)   +
                              TOFILE(TVRELWAECO/MAN_INPUT)   +
                              MBROPT(*REPLACE) FLDDLM(';')  +
                              RPLNULLVAL(*FLDDFT)
             MONMSG     MSGID(CPF0000)

             CALL    PGM(DUMMY512) PARM(&MD '#IN0650' ' ' ' ' +
                         ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             CLRPFM     MAN_DOCUM
             MONMSG     MSGID(CPF0000)
             CALL       PGM(MANR)
             MONMSG     MSGID(CPF0000)

             QSYS/CPYTOIMPF FROMFILE(TVRELWAECO/MAN_INPUT *FIRST) +
                          TOFILE(TVRELWAECO/MAN_EXPORT) +
                          MBROPT(*REPLACE) STRDLM(*NONE) +
                          RMVBLANK(*BOTH) FLDDLM(';') DECPNT(*COMMA)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(MANFTP) PARM('2')
             MONMSG     MSGID(CPF0000)


 ENDPGM:
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(BAR_KALK)
                MONMSG     MSGID(CPF0000)
             ENDDO

             IF         COND(&ERROR2 = '0') THEN(DO)
             ENDDO

             ENDPGM
