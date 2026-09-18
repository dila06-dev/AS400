/*    * PROGRAMMNAME.:TREND ENVIRONMENT AUFBAUEN                             */
/*    * FUNKTION.....:..                                                     */
/*    * SEPTEMBER 2010   GANG, MANFRED                                        */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                          PGMR.....           */
/******************************************************************************/
             PGM

             DCL        VAR(&SC) TYPE(*DEC) LEN(07 0) VALUE(0055278)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             RTVJOBA    JOB(&USER)

             IF         COND(&USER *NE 'GANG1') THEN(DO)
 /****       GOTO       CMDLBL(ENDPGM)        ****/
             ENDDO

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

/*          ITALIEN                                                          */
             CHGVAR     VAR(&SC) VALUE(0055278)
             CALL       PGM(ORDERR) PARM(&SC)

/*          DÄNEMARK                                                         */
             CHGVAR     VAR(&SC) VALUE(0001887)
             CALL       PGM(ORDERR) PARM(&SC)

/*          SPANIEN                                                          */
             CHGVAR     VAR(&SC) VALUE(0078146)
             CALL       PGM(ORDERR) PARM(&SC)

/*          SCHWEDEN                                                         */
             CHGVAR     VAR(&SC) VALUE(0008138)
             CALL       PGM(ORDERR) PARM(&SC)

/*          SCHWEIZ                                                          */
             CHGVAR     VAR(&SC) VALUE(0002921)
             CALL       PGM(ORDERR) PARM(&SC)

/*          FRANKREICH                                                       */
             CHGVAR     VAR(&SC) VALUE(0088505)
             CALL       PGM(ORDERR) PARM(&SC)

/*          UK                                                               */
             CHGVAR     VAR(&SC) VALUE(0040631)
             CALL       PGM(ORDERR) PARM(&SC)

/*          TECCOM                                                           */
             CHGVAR     VAR(&SC) VALUE(0000003)
             CALL       PGM(ORDERR) PARM(&SC)

/*          HDX                                                              */
             CHGVAR     VAR(&SC) VALUE(0000002)
             CALL       PGM(ORDERR) PARM(&SC)

/*          TESTKUNDE                                                        */
             CHGVAR     VAR(&SC) VALUE(0044444)
             CALL       PGM(ORDERR) PARM(&SC)

/*          BENELUX                                                          */
             CHGVAR     VAR(&SC) VALUE(0015177)
             CALL       PGM(ORDERR) PARM(&SC)

/*          BENELUX                                                          */
             CHGVAR     VAR(&SC) VALUE(0062765)
             CALL       PGM(ORDERR) PARM(&SC)

/*          DOMETIC SIEGEN                                                   */
             CHGVAR     VAR(&SC) VALUE(0098264)
             CALL       PGM(ORDERR) PARM(&SC)

/*          DOMETIC POLEN                                                    */
             CHGVAR     VAR(&SC) VALUE(0078678)
             CALL       PGM(ORDERR) PARM(&SC)

/*          ELTESAN                                                          */
             CHGVAR     VAR(&SC) VALUE(0032691)
             CALL       PGM(ORDERR) PARM(&SC)
             CHGVAR     VAR(&SC) VALUE(0023038)
             CALL       PGM(ORDERR) PARM(&SC)
             CHGVAR     VAR(&SC) VALUE(0078688)
             CALL       PGM(ORDERR) PARM(&SC)
             CHGVAR     VAR(&SC) VALUE(0078677)
             CALL       PGM(ORDERR) PARM(&SC)

/*          BGFS ÜBERNAHME                                                   */
        /*   CHGVAR     VAR(&SC) VALUE(0099999)       */
        /*   CALL       PGM(ORDERR2) PARM(&SC)        */

             IF         COND(&PARM = '1') THEN(DO)
             ENDDO
 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO

             ENDPGM
