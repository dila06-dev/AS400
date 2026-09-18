/*    * PROGRAMMNAME.:$GANG                                                  */
/*    * FUNKTION.....:...                                                    */
/*    * JULI    2010   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *-START SUBSTYSTEM                                                     */
/*    * SELECT TETENR, CHAR('001') LAGER FROM TEIL                            */
/*    *       .                                                               */
/*    *            .                                                          */
/*    *                .                                                      */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/

             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR6)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&CODE)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&SC) TYPE(*DEC) LEN(07 0) VALUE(0000000)
             DCL        VAR(&K)         TYPE(*CHAR) LEN(5)
             DCL        VAR(&#)         TYPE(*CHAR) LEN(1)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&DAFEHL) TYPE(*CHAR) LEN(1)

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

             DCLF       FILE(TVRELWAECO/BESTAND)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('ABESTAND_C')
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

             CALL       PGM(GANG/##SVRLDA) PARM('S')
             MONMSG     MSGID(CPF0000)

         /*  CALL       PGM(MODWAO/STRTRDSJ)  */
         /*  CALL       PGM(MODWAO/STRACM)    */
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(*LDA (1 2)) VALUE('01')
             CALL       PGM(TRDV00ST) PARM('ABESTAND_C')
             RTVDTAARA  DTAARA(*LDA (28 1)) RTNVAR(&DAFEHL)
             IF         COND(&DAFEHL = '1') THEN(GOTO CMDLBL(ENDPGM))

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*AFTER TFXF)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             CALL    PGM(DUMMY512) PARM(&MD '#DC2900' ' ' ' ' +
                         'BESTAND' 'TVRELWAECO' '*REPLACE')
             MONMSG     MSGID(CPF0000)
             DLCOBJ     OBJ((TVRELWAECO/ABESTAND *FILE *EXCLRD))
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(TVRELWAECO/ABESTAND)
             MONMSG     MSGID(CPF0000)

             ALCOBJ     OBJ((TVRELWAECO/ABESTAND *FILE *EXCLRD))
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDPGM))

             CLRPFM FILE(TVRELWAECO/FTP) MBR(GALAXUSL)
             MONMSG     MSGID(CPF0000)
             RGZPFM FILE(TVRELWAECO/FTP) MBR(GALAXUSL)
             MONMSG     MSGID(CPF0000)
             CLRPFM FILE(TVRELWAECO/FTP) MBR(GALAXUSDL)
             MONMSG     MSGID(CPF0000)
             RGZPFM FILE(TVRELWAECO/FTP) MBR(GALAXUSDL)
             MONMSG     MSGID(CPF0000)
             RGZPFM FILE(TVRELWAECO/FTP) MBR(GALAXUSIL)
             MONMSG     MSGID(CPF0000)


             CLRPFM FILE(TVRELWAECO/FTP) MBR(BRACKL)
             MONMSG     MSGID(CPF0000)
             RGZPFM FILE(TVRELWAECO/FTP) MBR(BRACKL)
             MONMSG     MSGID(CPF0000)

             CLRPFM FILE(TVRELWAECO/FTP) MBR(KOBERGERL)
             MONMSG     MSGID(CPF0000)
             RGZPFM FILE(TVRELWAECO/FTP) MBR(KOBERGERL)
             MONMSG     MSGID(CPF0000)

             CLRPFM FILE(TVRELWAECO/FTP) MBR(ZAMPETASL)
             MONMSG     MSGID(CPF0000)
             RGZPFM FILE(TVRELWAECO/FTP) MBR(ZAMPETASL)
             MONMSG     MSGID(CPF0000)

             CLRPFM FILE(TVRELWAECO/FTP) MBR(SCHLANSERL)
             MONMSG     MSGID(CPF0000)
             RGZPFM FILE(TVRELWAECO/FTP) MBR(SCHLANSERL)
             MONMSG     MSGID(CPF0000)

             CLRPFM FILE(TVRELWAECO/FTP) MBR(TRADEIFTPL)
             MONMSG     MSGID(CPF0000)
             RGZPFM FILE(TVRELWAECO/FTP) MBR(TRADEIFTPL)
             MONMSG     MSGID(CPF0000)

             CLRPFM FILE(TVRELWAECO/FTP) MBR(DEPORVILLL)
             MONMSG     MSGID(CPF0000)
             RGZPFM FILE(TVRELWAECO/FTP) MBR(DEPORVILLL)
             MONMSG     MSGID(CPF0000)

             CLRPFM FILE(TVRELWAECO/FTP) MBR(GLOBETFTPL)
             MONMSG     MSGID(CPF0000)
             RGZPFM FILE(TVRELWAECO/FTP) MBR(GLOBETFTPL)
             MONMSG     MSGID(CPF0000)

             CLRPFM FILE(TVRELWAECO/FTP) MBR(VARIOL)
             MONMSG     MSGID(CPF0000)
             RGZPFM FILE(TVRELWAECO/FTP) MBR(VARIOL)
             MONMSG     MSGID(CPF0000)

 LOOP:       RCVF
                MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))
/*             BESTAND ERMITTELN                                             */
                CALL       PGM(ABESTAND3R) PARM(&TETENR &LAGER)
                MONMSG     MSGID(CPF0000)
             GOTO LOOP

 ENDPGM:
/*          SPERRE TECCOM BASISDATENBANK FÜR BESTAND                         */
/*          UND KOPIEREN                                                     */
             ALCOBJ     OBJ((TVRELWAECO/ABESTANDT *FILE *EXCLRD))
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDPGM))
             CPYF       FROMFILE(TVRELWAECO/ABESTAND)       +
                          TOFILE(TVRELWAECO/ABESTANDT)      +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(DUMMY512) PARM(&MD '#DC4820' ' ' ' ' +
                           'ABESTAND  '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)

/*          FREIGABEN                                                        */
             DLCOBJ     OBJ((TVRELWAECO/ABESTANDT *FILE *EXCLRD))
             MONMSG     MSGID(CPF0000)
             DLCOBJ     OBJ((TVRELWAECO/ABESTAND *FILE *EXCLRD))
             MONMSG     MSGID(CPF0000)

             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
                MONMSG     MSGID(CPF0000)
             ENDDO

        /*   RUNQRY     QRY(BAR_FRA/LAGERB_NAV)    */
        /*   MONMSG     MSGID(CPF0000)             */

             CALL  PGM(DUMMY512) PARM(&MD '#DC0000' ' ' ' ' +
                       '#DC0000' 'TVRELWAECO' '*REPLACE')
             MONMSG     MSGID(CPF0000)

             CPYTOIMPF  FROMFILE(TVRELWAECO/#DC0000 #DC0000) +
                          TOFILE(TVRELWAECO/#DC0000E #DC0000E) +
                          MBROPT(*REPLACE) DTAFMT(*FIXED) +
                          FLDDLM(';') NUMFLDPAD(*BLANK) DECPNT(*COMMA)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/QCLSRC) +
                          MBR(STOCKCMD)
             CLRPFM     FILE(TVRELWAECO/QCLSRC) MBR(STOCKLOG)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/QCLSRC) +
                          MBR(STOCKLOG)

/*          FRANKREICH                                                       */
             CALL     PGM(DUMMY512) PARM(&MD '#DC0201' ' ' ' ' ' ' +
                          ' ' ' ')
             FTP        RMTSYS('DOMETIC-GROUP.COM')

/*          ITALIEN ***                                                      */
             CALL     PGM(DUMMY512) PARM(&MD '#DC0203' ' ' ' ' ' ' +
                          ' ' ' ')
             FTP        RMTSYS('DOMETIC-GROUP.COM')

/*          SPANIEN ***                                                      */
             CALL     PGM(DUMMY512) PARM(&MD '#DC0205' ' ' ' ' ' ' +
                          ' ' ' ')
             FTP        RMTSYS('DOMETIC-GROUP.COM')

/*          SCHWEDEN ***                                                     */
             CALL     PGM(DUMMY512) PARM(&MD '#DC0207' ' ' ' ' ' ' +
                          ' ' ' ')
             FTP        RMTSYS('DOMETIC-GROUP.COM')

/*          NORWEGEN ***                                                     */
             CALL     PGM(DUMMY512) PARM(&MD '#DC0209' ' ' ' ' ' ' +
                          ' ' ' ')
             FTP        RMTSYS('DOMETIC-GROUP.COM')

/*          POLEN    ***                                                     */
             CALL     PGM(DUMMY512) PARM(&MD '#DC0211' ' ' ' ' ' ' +
                          ' ' ' ')
             FTP        RMTSYS('DOMETIC-GROUP.COM')

/*          ÖSTERREICH *                                                     */
             CALL     PGM(DUMMY512) PARM(&MD '#DC0213' ' ' ' ' ' ' +
                          ' ' ' ')
             FTP        RMTSYS('DOMETIC-GROUP.COM')

/*          DÄNEMARK   *                                                     */
             CALL     PGM(DUMMY512) PARM(&MD '#DC0215' ' ' ' ' ' ' +
                          ' ' ' ')
             FTP        RMTSYS('DOMETIC-GROUP.COM')

/*          ENGLAND    *                                                     */
             CALL     PGM(DUMMY512) PARM(&MD '#DC0217' ' ' ' ' ' ' +
                          ' ' ' ')
             FTP        RMTSYS('DOMETIC-GROUP.COM')

/*          RUSSLAND   *     ==> 191453                                      */
             CALL     PGM(DUMMY512) PARM(&MD '#DC0219' ' ' ' ' ' ' +
                          ' ' ' ')
             FTP        RMTSYS('DOMETIC-GROUP.COM')

/*          NIEDERLANDE                                                      */
             CALL     PGM(DUMMY512) PARM(&MD '#DC0221' ' ' ' ' ' ' +
                          ' ' ' ')
             FTP        RMTSYS('DOMETIC-GROUP.COM')

/*          BENELUX                                                          */
             CALL     PGM(DUMMY512) PARM(&MD '#DC0223' ' ' ' ' ' ' +
                          ' ' ' ')
             FTP        RMTSYS('DOMETIC-GROUP.COM')

/*          SCHWEIZ                                                          */
             CALL     PGM(DUMMY512) PARM(&MD '#DC0225' ' ' ' ' ' ' +
                          ' ' ' ')
             FTP        RMTSYS('DOMETIC-GROUP.COM')

             CALL       PGM(TVRELWAECO/GALAXUSR)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(TVRELWAECO/SCHLANSERR)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(TVRELWAECO/BRACKR)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(TVRELWAECO/KOBERGERR)
             MONMSG     MSGID(CPF0000)

/*          FREIGABE ERBETEN!!!! 30.02.23                                    */
             CALL       PGM(TVRELWAECO/TRADEINNS)
             MONMSG     MSGID(CPF0000)

/*          FREIGABE ERBETEN!!!! 30.02.23                                    */
             CALL       PGM(TVRELWAECO/DEPORVILL)
             MONMSG     MSGID(CPF0000)

/*          FREIGABE ERBETEN!!!! 14.02.23  RELEASED 27.02.2023               */
             CALL       PGM(TVRELWAECO/GALAXUSDR)
             MONMSG     MSGID(CPF0000)

/*          GALAXUS FOR IGLOO  RELEASED 04.03.2024                           */
             CALL       PGM(TVRELWAECO/GALAXUSIR)
             MONMSG     MSGID(CPF0000)

/*          GLOBETROTT  RELEASED 04.08.2024                                 */
/*           CALL       PGM(TVRELWAECO/GLOBETROTT)                           */
/*           MONMSG     MSGID(CPF0000)                                       */


/*          VARIO       RELEASED 28.05.2025                                 */
             CALL       PGM(TVRELWAECO/VARIOR)
             MONMSG     MSGID(CPF0000)

/*          WAGNER      RELEASED 15.04.2025 / WARTE AUF NIEMEIER            */
             CALL       PGM(TVRELWAECO/WAGNERR)
             MONMSG     MSGID(CPF0000)

/*          SIEGEN                                                           */
             CALL     PGM(DUMMY512) PARM(&MD '#DC0227' ' ' ' ' ' ' +
                          ' ' ' ')
             FTP        RMTSYS('DOMETIC-GROUP.COM')

/*          LUXEMBURG                                                        */
             CALL     PGM(DUMMY512) PARM(&MD '#DC0229' ' ' ' ' ' ' +
                          ' ' ' ')
             FTP        RMTSYS('DOMETIC-GROUP.COM')

/*          SLOWAKIA                                                         */
             CALL     PGM(DUMMY512) PARM(&MD '#DC0231' ' ' ' ' ' ' +
                          ' ' ' ')
             FTP        RMTSYS('DOMETIC-GROUP.COM')

/*          UNGARN                                                           */
             CALL     PGM(DUMMY512) PARM(&MD '#DC0233' ' ' ' ' ' ' +
                          ' ' ' ')
             FTP        RMTSYS('DOMETIC-GROUP.COM')

/*          FINLAND                                                         */
             CALL     PGM(DUMMY512) PARM(&MD '#DC0235' ' ' ' ' ' ' +
                          ' ' ' ')
             FTP        RMTSYS('DOMETIC-GROUP.COM')

             DLTOVR     FILE(INPUT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(OUTPUT)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(INPUT) TOFILE(TVRELWAECO/FTP) +
                          MBR(ASPNETCMD)
             MONMSG     MSGID(CPF0000)
       /*/   CLRPFM     FILE(TVRELWAECO/FTP) MBR(ASPNETLOG) */
       /*    MONMSG     MSGID(CPF0000)                      */
             OVRDBF     FILE(OUTPUT) TOFILE(TVRELWAECO/FTP) +
                          MBR(ASPNETLOG)
             MONMSG     MSGID(CPF0000)
             CALL     PGM(DUMMY512) PARM(&MD '#DC0010' ' ' ' ' +
                  'OUTPUT    '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
             FTP        RMTSYS('172.16.100.51') PORT(22)
             CHGCURLIB  CURLIB(*CRTDFT)
             DLTOVR     FILE(INPUT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(OUTPUT)
             MONMSG     MSGID(CPF0000)
             RMVLNK     OBJLNK('/SALESCOMPANY/B2B/winartnav.txt')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/SALESCOMPANY/B2B/winartnav.txt') +
                          DBFILE(TVRELWAECO/#DC0000E) +
                          DBOUTFMT(*TXT) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)
     /*      DSPJOBLOG  OUTPUT(*PRINT)                */

             CALL       PGM(GANG/##SVRLDA) PARM('R')
             MONMSG     MSGID(CPF0000)

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
