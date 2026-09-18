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
             CHGVAR     VAR(&PGM) VALUE('CONFIRMFTP')
             RTVMBRD    FILE(TVRELWAECO/QCLSRC) MBR(&PGM) TEXT(&TXT)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('START')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CHGVAR     VAR(%SST(&MD 100 05)) VALUE(&K)
       /*    CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +  */
       /*                  'JOB_RUN   '  'TVRELWAECO' '*ADD')       */
       /*    MONMSG     MSGID(CPF0000)                              */
/*          PROTOKOLLIERUNG ---                                           */

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
                          &K *NE '96690' *AND &K *NE '52774' *AND +
                          &K *NE '02511' *AND &K *NE '52774' *AND +
                          &K *NE '02511' *AND &K *NE '00099' *AND +
                          &K *NE '78678' *AND &K *NE '54939') THEN(DO)
                GOTO ENDPGM
             ENDDO

             OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                          MBR(CONFIRMCMD)
/*          FRANKREICH                                                       */
             IF         COND(&K = '88505') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0201' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0202' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO
/*          ITALIEN ***                                                      */
             IF         COND(&K = '55278') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0203' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0204' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO
/*          SPANIEN ***                                                      */
             IF         COND(&K = '78146') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0205' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0206' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO
/*          SCHWEDEN ***                                                     */
             IF         COND(&K = '08138') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0207' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0208' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO
/*          SCHWEDEN ***                                                     */
             IF         COND(&K = '00099') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0238' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0237' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO
/*          NORWEGEN ***                                                     */
             IF         COND(&K = '42634') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0209' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0210' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO

/*          POLEN    ***                                                     */
             IF         COND(&K = '78678') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0211' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0212' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO

/*          ÖSTERREICH *                                                     */
             IF         COND(&K = '54939') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0213' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0214' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO

/*          DÄNEMARK   *                                                     */
             IF         COND(&K = '01887') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0215' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0216' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO

/*          ENGLAND    *                                                     */
             IF         COND(&K = '40631') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0217' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0218' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO

/*          RUSSLAND   *     ==> 191453                                      */
             IF         COND(&K = '91453') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0219' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0220' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO

/*          NIEDERLANDE                                                      */
             IF         COND(&K = '15177') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0221' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0222' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO

/*          BENELUX                                                          */
             IF         COND(&K = '62765') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0223' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0224' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO

/*          SCHWEIZ                                                          */
             IF         COND(&K = '02921') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0225' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0226' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO
/*          SIEGEN                                                           */
             IF         COND(&K = '98264') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0227' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0228' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO
/*          LUXEMBURG                                                        */
             IF         COND(&K = '52774') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0229' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0230' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO
/*          SLOWAKIA                                                         */
             IF         COND(&K = '02511') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0231' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0232' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO
/*          UNGARN                                                           */
             IF         COND(&K = '96690') THEN(DO)
                CALL     PGM(DUMMY512) PARM(&MD '#DC0233' ' ' ' ' ' ' +
                          ' ' ' ')
                CALL     PGM(DUMMY512) PARM(&MD '#DC0234' ' ' ' ' ' ' +
                          ' ' ' ')
             ENDDO
             CLRPFM     FILE(TVRELWAECO/QCLSRC) MBR(CONFIRMLOG)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(TVRELWAECO/CONFIRMOUT)
             MONMSG     MSGID(CPF0000)
         /*  CHGJOB     CCSID(1144)     */
         /*  MONMSG     MSGID(CPF0000)  */
         /*  CHGJOB     CCSID(65535)    */
         /*  CHGJOB     CCSID(280)      */
         /*  MONMSG     MSGID(CPF0000)  */
             OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +
                          MBR(CONFIRMLOG)
             FTP        RMTSYS('DOMETIC-GROUP.COM')
             CHGCURLIB  CURLIB(*CRTDFT)
             DLTOVR     FILE(INPUT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(OUTPUT)
             MONMSG     MSGID(CPF0000)
             CHGJOB     CCSID(65535)
             MONMSG     MSGID(CPF0000)

             IF         COND(&PARM = '1') THEN(DO)
             ENDDO
 ENDPGM:
/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('ENDE ')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CHGVAR     VAR(%SST(&MD 100 05)) VALUE(&K)
    /*       CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +     */
    /*                     'JOB_RUN   '  'TVRELWAECO' '*ADD')          */
    /*       MONMSG     MSGID(CPF0000)                                 */

/*          PROTOKOLLIERUNG ---                                           */

             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
             ENDDO

             ENDPGM
