/*    * PROGRAMMNAME.:ABSATZZAHLEN ERMITTELN                                 */
/*    * FUNKTION.....:..                                                     */
/*    * SEPTEMBER 2010   GANG, MANFRED                                        */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                          PGMR.....           */
/******************************************************************************/
             PGM

             DCL        VAR(&PARM) TYPE(*CHAR) LEN(04)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&CALL) TYPE(*CHAR) LEN(10) VALUE(' ')

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ABSATZR) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('ABSATZC   ')
             RTVMBRD    FILE(TVRELWAECO/QCLSRC) MBR(&PGM) TEXT(&TXT)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('START')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*FIRST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
             MONMSG     MSGID(CPF0000)
             RTVDTAARA  DTAARA(ABSATZR) RTNVAR(&ABSATZR)
             MONMSG     MSGID(CPF0000)

             IF         COND(&ABSATZR = 'SR40631') THEN(DO)
                GOTO    SR40631
             ENDDO
             IF         COND(&ABSATZR = 'SR08138') THEN(DO)
                GOTO    SR08138
             ENDDO
             IF         COND(&ABSATZR = 'SR55278') THEN(DO)
                GOTO    SR55278
             ENDDO

             CLRPFM     FILE(TVRELWAECO/STATISTIK)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/ABSATZ)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/ABSATZA1)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/ABSATZA2)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/ABSATZB)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/ABSATZB2)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/ABSATZB2II)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/ABSATZBVJ)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/ABSATZBAJ)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/ABSATZB3)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/ABSATZB4)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/ABSATZC)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/ABSATZCII)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/ABSATZCVJ)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/ABSATZCAJ)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/STATISTIK2)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/LFBEW)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/LFBEW2)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(EKBESTANDC)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/BOOKA1)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/BOOKA2)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/BOOKA3)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/ALBERS)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/KAPPEN1)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/KAPPEN2)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/#QUALITY)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/#QUALITYC)
             MONMSG     MSGID(CPF0000)

/*          ______________________________________________                   */
 SR40631:
/*          ENGLAND                                                          */
             CLRPFM     FILE(TVRELWAECO/#DC4501)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/BOWLER)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/#HELPUK)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/DELIV_UK_A)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/DELIV_UK)
             MONMSG     MSGID(CPF0000)
             IF         COND(&ABSATZR = 'SR40631') THEN(DO)
       /***     I N A K T I V                    ***/
    /*          CALL       PGM(ABSATZR)         */
    /*          MONMSG     MSGID(CPF0000)       */
                GOTO    ENDPGM
             ENDDO
/*          ______________________________________________                   */

/*          ______________________________________________                   */
 SR08138:
/*          SCHWEDEN                                                         */
             CLRPFM     FILE(TVRELWAECO/#DC4511)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/INGEMAR)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/#HELPSE)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/DELIV_SE_A)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/DELIV_SE)
             MONMSG     MSGID(CPF0000)
             IF         COND(&ABSATZR = 'SR08138') THEN(DO)
       /***     I N A K T I V                    ***/
       /***     CALL       PGM(ABSATZR)          ***/
       /***     MONMSG     MSGID(CPF0000)        ***/
                GOTO    ENDPGM
             ENDDO
/*          ______________________________________________                   */

/*          ______________________________________________                   */
 SR55278:
/*          ITALIEN                                                          */
             CLRPFM     FILE(TVRELWAECO/#DC4512)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/SCAIRO)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/#HELPIT)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/DELIV_IT_A)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(TVRELWAECO/DELIV_IT)
             MONMSG     MSGID(CPF0000)
             IF         COND(&ABSATZR = 'SR55278') THEN(DO)
       /***     I N A K T I V                    ***/
       /***     CALL       PGM(ABSATZR)          ***/
       /***     MONMSG     MSGID(CPF0000)        ***/
                GOTO    ENDPGM
             ENDDO
/*          ______________________________________________                   */

             CALL       PGM(ABSATZR)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(CHECKUPC)
             MONMSG     MSGID(CPF0000)

/*    WANN DIE ZUGESICHTE BESTELLUNG EINTRIFFT ERMITTLUNG                    */
             CALL       PGM(GANG/STATISTIK) PARM('1')
             MONMSG     MSGID(CPF0000)

             RUNQRY QRY(HAUSE/KALK2011)
             MONMSG     MSGID(CPF0000)

/*    RPM2 BASISDATEN AUS STATISTIK                                          */
/*    SEIT 10.05.2013 AUSGELAGERT                                            */
      /*     CALL       PGM(TVRELWAECO/RPMIIRC2) PARM('1') */
      /*     MONMSG     MSGID(CPF0000)                     */

/*    SQL BASIERTE DATENBANKEN                                               */
             CALL       PGM(TVRELWAECO/ABSATZSQLC)
             MONMSG     MSGID(CPF0000)

 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
    /*          RMVLIBLE   LIB(GANG)                       */
             ENDDO
             IF         COND(&ERROR1 = '0') THEN(DO)
    /*          RMVLIBLE   LIB(TVRELWAECO)                 */
             ENDDO
             DSPJOBLOG  OUTPUT(*PRINT)
/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('ENDE ')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

             ENDPGM
