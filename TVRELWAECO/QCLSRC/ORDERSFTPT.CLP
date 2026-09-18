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

             ADDLIBLE   LIB(TVRELWAECT) POSITION(*BEFORE TVRELWAECO)
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(&MD) VALUE('                          ')

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
             ADDLIBLE   LIB(TVRELWAECO) POSITION(*FIRST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))
   /*        CALL       PGM(INVOICESR) PARM(&K &D)      */
             IF      COND(&K *NE '88505' *AND &K *NE '40631' *AND +
                          &K *NE '55278' *AND &K *NE '62765' *AND +
                          &K *NE '15177' *AND &K *NE '78146' *AND +
                          &K *NE '08138' *AND &K *NE '42634' *AND +
                          &K *NE '01887' *AND &K *NE '91453' *AND +
                          &K *NE '02921' *AND &K *NE '98264' *AND +
                          &K *NE '52774' *AND &K *NE '52774' *AND +
                          &K *NE '02511' *AND &K *NE '96690' *AND +
                          &K *NE '05084' *AND &K *NE '96690' *AND +
                          &K *NE '78678' *AND &K *NE '54939') THEN(DO)
                GOTO ENDPGM
             ENDDO

/*          FRANKREICH ***                                                   */
/*           IF         COND(&K = '88505') THEN(DO)  */
                CHGVAR     VAR(&SC) VALUE(0088505)
                CALL       PGM(ORDERR_T) PARM(&SC)
/*           ENDDO                                   */

/*          ITALIEN ***                                                      */
/*           IF         COND(&K = '55278') THEN(DO)  */
                CHGVAR     VAR(&SC) VALUE(0055278)
                CALL       PGM(ORDERR_T) PARM(&SC)
/*           ENDDO                                   */

/*          SPANIEN ***                                                      */
/*           IF         COND(&K = '78146') THEN(DO)  */
                CHGVAR     VAR(&SC) VALUE(0078146)
                CALL       PGM(ORDERR_T) PARM(&SC)
/*           ENDDO                                   */

/*          SCHWEDEN ***                                                     */
/*           IF         COND(&K = '08138') THEN(DO)  */
                CHGVAR     VAR(&SC) VALUE(0008138)
                CALL       PGM(ORDERR_T) PARM(&SC)
/*           ENDDO                                   */

/*          NORWEGEN ***                                                     */
/*           IF         COND(&K = '42634') THEN(DO)  */
                CHGVAR     VAR(&SC) VALUE(0042634)
                CALL       PGM(ORDERR_T) PARM(&SC)
/*           ENDDO                                   */

/*          POLEN    ***                                                     */
/*           IF         COND(&K = '78678') THEN(DO)  */
                CHGVAR     VAR(&SC) VALUE(0078678)
                CALL       PGM(ORDERR_T) PARM(&SC)
/*           ENDDO                                   */

/*          ÖSTERREICH *                                                     */
/*           IF         COND(&K = '54939') THEN(DO)  */
                CHGVAR     VAR(&SC) VALUE(0054939)
                CALL       PGM(ORDERR_T) PARM(&SC)
/*           ENDDO                                   */

/*          DÄNEMARK   *                                                     */
/*           IF         COND(&K = '01887') THEN(DO)  */
                CHGVAR     VAR(&SC) VALUE(0001887)
                CALL       PGM(ORDERR_T) PARM(&SC)
/*           ENDDO                                   */

/*          ENGLAND    *                                                     */
/*           IF         COND(&K = '40631') THEN(DO)  */
                CHGVAR     VAR(&SC) VALUE(0040631)
                CALL       PGM(ORDERR_T) PARM(&SC)
/*           ENDDO                                   */

/*          RUSSLAND   *     ==> 191453                                      */
/*           IF         COND(&K = '91453') THEN(DO)  */
                CHGVAR     VAR(&SC) VALUE(0191453)
                CALL       PGM(ORDERR_T) PARM(&SC)
/*           ENDDO                                   */

/*          NIEDERLANDE*                                                     */
/*           IF         COND(&K = '15177') THEN(DO)  */
                CHGVAR     VAR(&SC) VALUE(0015177)
                CALL       PGM(ORDERR_T) PARM(&SC)
/*           ENDDO                                   */

/*          BENELUX    *                                                     */
/*           IF         COND(&K = '62765') THEN(DO)  */
                CHGVAR     VAR(&SC) VALUE(0062765)
                CALL       PGM(ORDERR_T) PARM(&SC)
/*           ENDDO                                   */

/*          SCHWEIZ    *                                                     */
/*           IF         COND(&K = '02921') THEN(DO)  */
                CHGVAR     VAR(&SC) VALUE(0002921)
                CALL       PGM(ORDERR_T) PARM(&SC)
/*           ENDDO                                   */

/*          SIEGEN     *                                                     */
/*           IF         COND(&K = '98264') THEN(DO)  */
                CHGVAR     VAR(&SC) VALUE(0098264)
                CALL       PGM(ORDERR_T) PARM(&SC)
/*           ENDDO                                   */

/*          LUXEMBURG  *                                                     */
/*           IF         COND(&K = '52774') THEN(DO)  */
                CHGVAR     VAR(&SC) VALUE(0052774)
                CALL       PGM(ORDERR_T) PARM(&SC)
                CHGVAR     VAR(&SC) VALUE(0752774)
                CALL       PGM(ORDERR_T) PARM(&SC)
/*           ENDDO                                   */

/*          SLOWAKIA   *                                                     */
/*           IF         COND(&K = '02511') THEN(DO)  */
                CHGVAR     VAR(&SC) VALUE(0002511)
                CALL       PGM(ORDERR_T) PARM(&SC)
                CHGVAR     VAR(&SC) VALUE(0772511)
                CALL       PGM(ORDERR_T) PARM(&SC)
/*           ENDDO                                   */

/*          UNGARN     *                                                     */
/*           IF         COND(&K = '96690') THEN(DO)  */
                CHGVAR     VAR(&SC) VALUE(0096690)
                CALL       PGM(ORDERR_T) PARM(&SC)
                CHGVAR     VAR(&SC) VALUE(0796690)
                CALL       PGM(ORDERR_T) PARM(&SC)
/*           ENDDO                                   */

/*          FINNLAND   *                                                     */
/*           IF         COND(&K = '05084') THEN(DO)  */
                CHGVAR     VAR(&SC) VALUE(0005084)
                CALL       PGM(ORDERR_T) PARM(&SC)
/*           ENDDO                                   */

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
