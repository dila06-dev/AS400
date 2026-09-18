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
             DCL        VAR(&ERROR3)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBR)        TYPE(*CHAR) LEN(12)
             DCL        VAR(&MNT)        TYPE(*CHAR) LEN(01)
             DCL        VAR(&VMNT)       TYPE(*CHAR) LEN(01)
             DCL        VAR(&ALFD)       TYPE(*CHAR) LEN(03)
             DCL        VAR(&NLFD)       TYPE(*DEC)  LEN(03 0)
             DCL        VAR(&MSGFKT)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&FROMMBR)    TYPE(*CHAR) LEN(60)
             DCL        VAR(&TOSTMF)     TYPE(*CHAR) LEN(60)
             DCL        VAR(&TIMESTAMP) TYPE(*CHAR)  LEN(11) VALUE(' ')
             DCL        VAR(&OBJ)        TYPE(*CHAR) LEN(15)
             DCL        VAR(&#OBJEKT)    TYPE(*CHAR) LEN(25)
             DCL        VAR(&NEWOBJ)     TYPE(*CHAR) LEN(15)
             DCLF       FILE(TVRELWAECO/KSBA_SEND)

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

             IF         COND(&PARM *EQ '1' ) THEN(DO)
/*             LOOP LESEN DER KSBA_SEND (GESENDETEN DATEIEN MIT              */
/*             STATUS 10                                                     */
 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))

             IF  COND(&STATUS = '10        ') THEN(DO)
                CRTPF      FILE(TVRELWAECO/RECVKSBA) RCDLEN(512)  +
                           TEXT('RECV KSBA') MAXMBRS(*NOMAX)      +
                           CCSID(65535)
                MONMSG     MSGID(CPF0000)
                CHGCURDIR  DIR('/HOME/GERWAE/KSBA/RECV')
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDPGM))
                CPYFRMSTMF FROMSTMF('/HOME/GERWAE/KSBA/CMDRECV.TXT') +
                          TOMBR('/QSYS.LIB/TVRELWAECO.LIB/RECVKSBA.FI+
                          LE/RECVKSBA.MBR') MBROPT(*REPLACE)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDPGM))

                CHGVAR    VAR(%SST(&MD 01 04)) VALUE('get ')
                CHGVAR    VAR(%SST(&MD 05 25)) VALUE(&OBJEKT)
                CHGVAR    VAR(%SST(&MD 14 01)) VALUE('F')
                CALL      PGM(DUMMY512) PARM(&MD '#MP0210' ' ' ' ' +
                           ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)

                QSYS/CPYTOSTMF +
                          FROMMBR('/QSYS.LIB/TVRELWAECO.LIB/RECVKSBA.+
                          FILE/RECVKSBA.MBR') +
                          TOSTMF('/HOME/GERWAE/KSBA/CMDRECV.TXT') +
                          STMFOPT(*REPLACE) CVTDTA(*AUTO) +
                          DBFCCSID(*FILE) STMFCODPAG(819)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDPGM))

       /*   *** HOLEN der Rechnungsdaten                                     */
                   CHGJOB     LOG(4 00 *SECLVL) LOGCLPGM(*YES) +
                              JOBMSGQFL(*WRAP)
                   CD         DIR('/home/gerwae/')
                   MONMSG     MSGID(CPF0000)
                   CHGAUT     OBJ('/home/gerwae') USER(*PUBLIC) +
                              DTAAUT(*RWX) OBJAUT(*NONE)
                   MONMSG     MSGID(CPF0000)
                   CHGPGP     OBJ('/home/gerwae/KSBA') NEWPGP(*NONE) +
                              DTAAUT(*RX)
                   MONMSG     MSGID(CPF0000)
                   CHGCURLIB  CURLIB(TVRELWAECO)
                   MONMSG     MSGID(CPF0000)

                   QSH        CMD('/QOpenSys/usr/bin/sftp -vvv -b +
                              /home/gerwae/KSBA/cmdrecv.txt   +
                              gerwae@194.8.210.149 > +
                              /home/gerwae/KSBA/logrecv.txt   2>&1')

                   CHGCURDIR  DIR('/home/gerwae/KSBA/recv')
                   MONMSG     MSGID(CPF0000)

                   CHGVAR     VAR(&#OBJEKT) VALUE(&OBJEKT)
                   CHGVAR    VAR(%SST(&#OBJEKT 10 01)) VALUE('F')
                   DSPLNK     OBJ(&#OBJEKT) OUTPUT(*PRINT)
                   MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR3) +
                          VALUE('1'))
                   IF         COND(&ERROR3 = '0') THEN(DO)
                      CALL       PGM(KSBA_SENDR) PARM(&OBJEKT)
                      MONMSG     MSGID(CPF0000)
                   ENDDO

             ENDDO

             GOTO LOOP

             ENDDO

/*                                                                            */
 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO

             ENDPGM
