/*    * PROGRAMMNAME.:ORDERS                                                 */
/*    * FUNKTION.....:..                                                     */
/*    * SEPTEMBER 2010   GANG, MANFRED                                        */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX         PARM( '88505')                   PGMR.....           */
/******************************************************************************/
             PGM        PARM(&K)

             DCL        VAR(&K)    TYPE(*CHAR) LEN(05)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&SC) TYPE(*DEC) LEN(07 0)

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR3)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&GESTERN) TYPE(*CHAR) LEN(08)
             DCL        VAR(&TAG)   TYPE(*DEC) LEN(02 0)
             DCL        VAR(&MONAT) TYPE(*DEC) LEN(02 0)
             DCL        VAR(&JAHR)  TYPE(*DEC) LEN(04 0)
             DCL        VAR(&WOTAG) TYPE(*DEC) LEN(02 0)
             DCL        VAR(&OUTFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&QDATE)   TYPE(*CHAR) LEN(20)
             DCL        VAR(&QDATEV)  TYPE(*CHAR) LEN(20)
             DCL        VAR(&FILE)    TYPE(*CHAR) LEN(10)

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('ORDERSFTP ')
             RTVMBRD    FILE(TVRELWAECO/QCLSRC) MBR(&PGM) TEXT(&TXT)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('START')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CHGVAR     VAR(%SST(&MD 100 5)) VALUE(&K)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

             CHGVAR     VAR(&MD) VALUE('                          ')

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
             ADDLIBLE   LIB(TVRELWAECO) POSITION(*FIRST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))
   /*        CALL       PGM(INVOICESR) PARM(&K &D)      */
             IF      COND(&K *NE 'T8505' *AND &K *NE 'T0631' *AND +
                          &K *NE 'T8678' *AND &K *NE 'T8678' *AND +
                          &K *NE '88505' *AND &K *NE '40631' *AND +
                          &K *NE '55278' *AND &K *NE '62765' *AND +
                          &K *NE '15177' *AND &K *NE '78146' *AND +
                          &K *NE '08138' *AND &K *NE '42634' *AND +
                          &K *NE '01887' *AND &K *NE '91453' *AND +
                          &K *NE '02921' *AND &K *NE '98264' *AND +
                          &K *NE '52774' *AND &K *NE '52774' *AND +
                          &K *NE '02511' *AND &K *NE '96690' *AND +
                          &K *NE '05084' *AND &K *NE '96690' *AND +
                          &K *NE '40670' *AND &K *NE '40642' *AND +
                          &K *NE '35671' *AND                     +
                          &K *NE '78678' *AND &K *NE '54939' *AND +
                          &K *NE '00005' *AND &K *NE '78680') THEN(DO)
                GOTO ENDPGM
             ENDDO

     /*      GOTO ENDPGM    */

             OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                          MBR(ORDERCMD)
/*          FRANKREICH                                                       */
             IF         COND(&K = '88505') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0101' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0102' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO
/*          FRANKREICH TEST T8505                                            */
             IF         COND(&K = 'T8505') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DT0101' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DT0102' ' ' ' ' ' ' +
                          ' ' ' ')
/*             MONMSG     MSGID(CPF0000)                                     */
                RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
                CHGVAR     VAR(&PGM) VALUE('TEST88505')
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
                CHGVAR     VAR(&PGM) VALUE('ORDERSFTP ')
/*          PROTOKOLLIERUNG ---                                           */
             ENDDO
/*          ITALIEN ***                                                      */
             IF         COND(&K = '55278') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0103' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0104' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO
/*          SPANIEN ***                                                      */
             IF         COND(&K = '78146') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0105' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0106' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO
/*          SCHWEDEN ***                                                     */
             IF         COND(&K = '08138') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0107' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0108' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO
/*          NORWEGEN ***                                                     */
             IF         COND(&K = '42634') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0109' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0110' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO

/*          POLEN    ***                                                     */
             IF         COND(&K = '78678') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0111' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0112' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO

/*          POLEN    *** TEST T8678                                          */
             IF         COND(&K = 'T8678') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DT0111' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DT0112' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO

/*          ÖSTERREICH *                                                     */
             IF         COND(&K = '54939') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0113' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0114' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO

/*          DÄNEMARK   *                                                     */
             IF         COND(&K = '01887') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0115' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0116' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO

/*          ENGLAND    *                                                     */
             IF         COND(&K = '40631') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0117' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0118' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO

/*          UK         TEST T0631                                            */
             IF         COND(&K = 'T0631') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DT0117' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DT0118' ' ' ' ' ' ' +
                          ' ' ' ')
/*             MONMSG     MSGID(CPF0000)                                     */
                RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
                CHGVAR     VAR(&PGM) VALUE('TEST40631')
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
                CHGVAR     VAR(&PGM) VALUE('ORDERSFTP ')
/*          PROTOKOLLIERUNG ---                                           */
             ENDDO
/*          RUSSLAND   *     ==> 191453                                      */
             IF         COND(&K = '91453') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0119' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0120' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO

/*          NIEDERLANDE*     ==> 015177                                      */
             IF         COND(&K = '15177') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0121' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0122' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO

/*          BENELUX    *     ==> 062765                                      */
             IF         COND(&K = '62765') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0123' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0124' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO

/*          SCHWEIZ    *     ==> 002921                                      */
             IF         COND(&K = '02921') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0125' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0126' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO
/*          SIEGEN     *     ==> 098264                                      */
             IF         COND(&K = '98264') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0127' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0128' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO
/*          LUXEMBURG  *     ==> 052774 / 752774                             */
             IF         COND(&K = '52774') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0129' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0130' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO
/*          SLOWAKIA   *     ==> 002511 / 702511                             */
             IF         COND(&K = '02511') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0131' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0132' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO
/*          UNGARN     *     ==> 096690 / 796690                             */
             IF         COND(&K = '96690') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0133' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0134' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO
/*          FINNLAND   *     ==> 005084                                      */
             IF         COND(&K = '05084') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0135' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0136' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO
/*          DCS        *     ==> 000005                                      */
             IF         COND(&K = '00005') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0137' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0138' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO
/*          ITALIEN2 **                                                      */
             IF         COND(&K = '35671') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0139' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0140' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO
/*          UK2 CWL  **                                                      */
             IF         COND(&K = '40670') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0144' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0145' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO
/*          UK3 BLANDFORD **                                                 */
             IF         COND(&K = '40642') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0146' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0147' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO
             CLRPFM     FILE(TVRELWAECO/QCLSRC) MBR(ORDERLOG)
             MONMSG     MSGID(CPF0000)
         /*  CHGJOB     CCSID(1144)     */
         /*  MONMSG     MSGID(CPF0000)  */
         /*  CHGJOB     CCSID(65535)    */
         /*  CHGJOB     CCSID(280)      */
         /*  MONMSG     MSGID(CPF0000)  */
             OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +
                          MBR(ORDERLOG)
             FTP        RMTSYS('DOMETIC-GROUP.COM')
         /*  FTP        RMTSYS('193.84.54.32')      */
             CHGCURLIB  CURLIB(*CRTDFT)
             DLTOVR     FILE(INPUT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(OUTPUT)
             MONMSG     MSGID(CPF0000)
             CHGJOB     CCSID(65535)
             MONMSG     MSGID(CPF0000)

/*          FRANKREICH ***                                                   */
             IF         COND(&K = '88505') THEN(DO)
                CHGVAR     VAR(&SC) VALUE(0088505)
                CALL       PGM(ORDERR) PARM(&SC)
             ENDDO

/*          FRANKREICH *** TEST &K = 'T8505'                                 */
/*          HAT INTERN DIE NUMMER 88505 !!!!!!!!                             */
             IF         COND(&K = 'T8505') THEN(DO)
                CHGVAR     VAR(&SC) VALUE(0088505)
                CALL       PGM(ORDERR) PARM(&SC)
             ENDDO

/*          ITALIEN ***                                                      */
             IF         COND(&K = '55278') THEN(DO)
                CHGVAR     VAR(&SC) VALUE(0055278)
                CALL       PGM(ORDERR) PARM(&SC)
             ENDDO

/*          SPANIEN ***                                                      */
             IF         COND(&K = '78146') THEN(DO)
                CHGVAR     VAR(&SC) VALUE(0078146)
                CALL       PGM(ORDERR) PARM(&SC)
             ENDDO

/*          SCHWEDEN ***                                                     */
             IF         COND(&K = '08138') THEN(DO)
                CHGVAR     VAR(&SC) VALUE(0008138)
                CALL       PGM(ORDERR) PARM(&SC)
             ENDDO

/*          NORWEGEN ***                                                     */
             IF         COND(&K = '42634') THEN(DO)
                CHGVAR     VAR(&SC) VALUE(0042634)
                CALL       PGM(ORDERR) PARM(&SC)
             ENDDO

/*          POLEN    ***                                                     */
             IF         COND(&K = '78678') THEN(DO)
                CHGVAR     VAR(&SC) VALUE(0078678)
                CALL       PGM(ORDERR) PARM(&SC)
             ENDDO

/*          POLEN    *** T8678 TEST                                          */
/*          HAT INTERN DIE NUMMER 78678 !!!!!!!!                             */
             IF         COND(&K = 'T8678') THEN(DO)
                CHGVAR     VAR(&SC) VALUE(0078678)
                CALL       PGM(ORDERR) PARM(&SC)
             ENDDO

/*          POLEN DIS***                                                     */
             IF         COND(&K = '78680') THEN(DO)
                CHGVAR     VAR(&SC) VALUE(0078680)
                CALL       PGM(ORDERR) PARM(&SC)
             ENDDO

/*          ÖSTERREICH *                                                     */
             IF         COND(&K = '54939') THEN(DO)
                CHGVAR     VAR(&SC) VALUE(0054939)
                CALL       PGM(ORDERR) PARM(&SC)
             ENDDO

/*          DÄNEMARK   *                                                     */
             IF         COND(&K = '01887') THEN(DO)
                CHGVAR     VAR(&SC) VALUE(0001887)
                CALL       PGM(ORDERR) PARM(&SC)
             ENDDO

/*          ENGLAND    *                                                     */
             IF         COND(&K = '40631') THEN(DO)
                CHGVAR     VAR(&SC) VALUE(0040631)
                CALL       PGM(ORDERR) PARM(&SC)
             ENDDO

/*          ENGLAND    *** TEST &K = 'T0631'                                 */
/*          HAT INTERN DIE NUMMER 40631 !!!!!!!!                             */
             IF         COND(&K = 'T0631') THEN(DO)
                CHGVAR     VAR(&SC) VALUE(0040631)
                CALL       PGM(ORDERR) PARM(&SC)
             ENDDO

/*          RUSSLAND   *     ==> 191453                                      */
             IF         COND(&K = '91453') THEN(DO)
                CHGVAR     VAR(&SC) VALUE(0191453)
                CALL       PGM(ORDERR) PARM(&SC)
             ENDDO

/*          NIEDERLANDE*                                                     */
             IF         COND(&K = '15177') THEN(DO)
                CHGVAR     VAR(&SC) VALUE(0015177)
                CALL       PGM(ORDERR) PARM(&SC)
             ENDDO

/*          BENELUX    *                                                     */
             IF         COND(&K = '62765') THEN(DO)
                CHGVAR     VAR(&SC) VALUE(0062765)
                CALL       PGM(ORDERR) PARM(&SC)
             ENDDO

/*          SCHWEIZ    *                                                     */
             IF         COND(&K = '02921') THEN(DO)
                CHGVAR     VAR(&SC) VALUE(0002921)
                CALL       PGM(ORDERR) PARM(&SC)
             ENDDO

/*          SIEGEN     *                                                     */
             IF         COND(&K = '98264') THEN(DO)
                CHGVAR     VAR(&SC) VALUE(0098264)
                CALL       PGM(ORDERR) PARM(&SC)
             ENDDO

/*          LUXEMBURG  *                                                     */
             IF         COND(&K = '52774') THEN(DO)
                CHGVAR     VAR(&SC) VALUE(0052774)
                CALL       PGM(ORDERR) PARM(&SC)
                CHGVAR     VAR(&SC) VALUE(0752774)
                CALL       PGM(ORDERR) PARM(&SC)
             ENDDO

/*          SLOWAKIA   *                                                     */
             IF         COND(&K = '02511') THEN(DO)
                CHGVAR     VAR(&SC) VALUE(0002511)
                CALL       PGM(ORDERR) PARM(&SC)
                CHGVAR     VAR(&SC) VALUE(0772511)
                CALL       PGM(ORDERR) PARM(&SC)
             ENDDO

/*          UNGARN     *                                                     */
             IF         COND(&K = '96690') THEN(DO)
                CHGVAR     VAR(&SC) VALUE(0096690)
                CALL       PGM(ORDERR) PARM(&SC)
                CHGVAR     VAR(&SC) VALUE(0796690)
                CALL       PGM(ORDERR) PARM(&SC)
             ENDDO

/*          FINNLAND   *                                                     */
             IF         COND(&K = '05084') THEN(DO)
                CHGVAR     VAR(&SC) VALUE(0005084)
                CALL       PGM(ORDERR) PARM(&SC)
             ENDDO

/*          DCS        *                                                     */
             IF         COND(&K = '00005') THEN(DO)
                CHGVAR     VAR(&SC) VALUE(0000005)
/*          DCS SPÄTER   JETZT ERST PER HAND                                 */
/*              CALL       PGM(ORDERR) PARM(&SC)                              */
             ENDDO

/*          ITALIEN2***                                                      */
             IF         COND(&K = '35671') THEN(DO)
                CHGVAR     VAR(&SC) VALUE(0035671)
                CALL       PGM(ORDERR) PARM(&SC)
             ENDDO

/*          UK2 CWL ***                                                      */
             IF         COND(&K = '40670') THEN(DO)
                CHGVAR     VAR(&SC) VALUE(0040670)
                CALL       PGM(ORDERR) PARM(&SC)
             ENDDO

/*          UK3 BLANDFORD ST MARY                                            */
             IF         COND(&K = '40642') THEN(DO)
                CHGVAR     VAR(&SC) VALUE(0040642)
                CALL       PGM(ORDERR) PARM(&SC)
             ENDDO

             IF         COND(&PARM = '1') THEN(DO)
             ENDDO
 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
             ENDDO

/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('ENDE ')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CHGVAR     VAR(%SST(&MD 100 5)) VALUE(&K)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

             ENDPGM
