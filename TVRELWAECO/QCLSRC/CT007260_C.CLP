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
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)

             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBR)        TYPE(*CHAR) LEN(12)
             DCL        VAR(&MNT)        TYPE(*CHAR) LEN(01)
             DCL        VAR(&VMNT)       TYPE(*CHAR) LEN(01)
             DCL        VAR(&ALFD)       TYPE(*CHAR) LEN(03)
             DCL        VAR(&NLFD)       TYPE(*DEC)  LEN(03 0)
             DCL        VAR(&MSGFKT)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&NBRCURR##)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&FROMMBR)    TYPE(*CHAR) LEN(60)
             DCL        VAR(&TOSTMF)     TYPE(*CHAR) LEN(60)
             DCL        VAR(&TIMESTAMP) TYPE(*CHAR)  LEN(11) VALUE(' ')
             DCL        VAR(&OBJ)        TYPE(*CHAR) LEN(15)
             DCL        VAR(&NEWOBJ)     TYPE(*CHAR) LEN(15)

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('CT007260_C')
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

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))


             IF         COND(&PARM *EQ '1' ) THEN(DO)
/*             GENERELLER AUFBAU                                             */
/*             ZIEHEN RELEVANTER DATEN AUS #LBLB                             */
      /*        GOTO       CMDLBL(START)                 */
                CALL       PGM(DUMMY512) PARM(&MD '#CT0501' ' ' ' ' +
                           '#AFRK_F' 'TVRELWAECO' '*ADD')
                MONMSG     MSGID(CPF0000)
                CPYF       FROMFILE(CT_FORD) TOFILE(CT_FORDS) +
                            TOMBR(*FIRST) MBROPT(*ADD) CRTFILE(*NO)
                MONMSG     MSGID(CPF0000)
                CLRPFM     FILE(CT_FORD)
                MONMSG     MSGID(CPF0000)
                CALL       PGM(CT007260_R)
                MONMSG     MSGID(CPF0000)
             GOTO       CMDLBL(ENDPGM)
 START:
                RTVMBRD FILE(TVRELWAECO/CT_FORD) NBRCURRCD(&NBRCURRCD)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDPGM))
                IF         COND( &NBRCURRCD *NE 0) THEN(DO)
                   CALL       PGM(FTP_TIMEST) PARM(&TIMESTAMP)
                   MONMSG     MSGID(CPF0000)
                   CHGVAR     VAR(&MNT) VALUE(%SST(&TIMESTAMP 4 1))
                   IF      COND(%SST(&TIMESTAMP 3 2) = '10') THEN(DO)
                      CHGVAR     VAR(&MNT) VALUE('A')
                   ENDDO
                   IF      COND(%SST(&TIMESTAMP 3 2) = '11') THEN(DO)
                      CHGVAR     VAR(&MNT) VALUE('B')
                   ENDDO
                   IF      COND(%SST(&TIMESTAMP 3 2) = '12') THEN(DO)
                      CHGVAR     VAR(&MNT) VALUE('C')
                   ENDDO

                   RTVDTAARA  DTAARA(CT_FORD (10 3)) RTNVAR(&ALFD)
                   MONMSG     MSGID(CPF0000)
                   RTVDTAARA  DTAARA(CT_FORD (6 1)) RTNVAR(&VMNT)
                   MONMSG     MSGID(CPF0000)
                   CHGVAR     VAR(&NLFD) VALUE(1)
                   IF         COND(&VMNT *EQ &MNT) THEN(DO)
                      CHGVAR     VAR(&NLFD) VALUE(&ALFD)
                      CHGVAR     VAR(&NLFD) VALUE(&NLFD + 1)
                   ENDDO
                   CHGVAR     VAR(&ALFD) VALUE(&NLFD)
                   CHGVAR VAR(&MBR) VALUE('40308' *TCAT &MNT *TCAT +
                          %SST(&TIMESTAMP 01 02) *TCAT '.' *TCAT &ALFD)
                   MONMSG     MSGID(CPF0000)
                   CHGDTAARA  DTAARA(CT_FORD *ALL) VALUE(&MBR)
                   MONMSG     MSGID(CPF0000)
                   CHGVAR     VAR(&FROMMBR) +
                          VALUE('/QSYS.LIB/TVRELWAECO.LIB/CT_FORD.FIL+
                          E/CT_FORD.MBR')
                   MONMSG     MSGID(CPF0000)
                  CHGVAR VAR(&TOSTMF) VALUE('/HOME/GERWAE/KSBA/SEND/' +
                          *TCAT &MBR)
                   MONMSG     MSGID(CPF0000)
                   QSYS/CPYTOSTMF FROMMBR(&FROMMBR) TOSTMF(&TOSTMF) +
                          STMFOPT(*REPLACE) CVTDTA(*AUTO) +
                          DBFCCSID(*FILE) STMFCODPAG(*PCASCII)
                   MONMSG     MSGID(CPF0000)

       /*   *** senden der Rechnungsdaten                                    */
                   CHGJOB     LOG(4 00 *SECLVL) LOGCLPGM(*YES) +
                              JOBMSGQFL(*WRAP)
                   CD         DIR('/home/gerwae/')
                   MONMSG     MSGID(CPF0000)
                   CHGAUT     OBJ('/home/gerwae') USER(*PUBLIC) +
                              DTAAUT(*RWX) OBJAUT(*NONE)
                   MONMSG     MSGID(CPF0000)
                   CHGAUT     OBJ(&OBJ) USER(*PUBLIC) DTAAUT(*R)
                   MONMSG     MSGID(CPF0000)
                   CHGPGP     OBJ('/home/gerwae/KSBA') NEWPGP(*NONE) +
                              DTAAUT(*RX)
                   MONMSG     MSGID(CPF0000)
                   CHGCURLIB  CURLIB(TVRELWAECO)
                   MONMSG     MSGID(CPF0000)

                   QSH        CMD('/QOpenSys/usr/bin/sftp -vvv -b +
                              /home/gerwae/KSBA/cmdsend.txt   +
                              gerwae@194.8.210.149 > +
                              /home/gerwae/KSBA/logsend.txt   2>&1')

                   CHGCURDIR  DIR('/home/gerwae/KSBA/send')
                   MONMSG     MSGID(CPF0000)
                   CHGVAR     VAR(&OBJ) VALUE(&MBR)
                   MONMSG     MSGID(CPF0000)
                   CHGVAR     VAR(&NEWOBJ) VALUE('#' *TCAT &OBJ)
                   RNM        OBJ(&OBJ) NEWOBJ(&NEWOBJ)
                   MONMSG     MSGID(CPF0000)
                ENDDO
             ENDDO
/*                                                                            */
 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO

/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('ENDE ')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CHGVAR     VAR(%SST(&MD 100 14)) VALUE('Sätze verarb.')
             CHGVAR     VAR(&NBRCURR##) VALUE(&NBRCURRCD)
             CHGVAR     VAR(%SST(&MD 115 10)) VALUE(&NBRCURR##)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

             ENDPGM
