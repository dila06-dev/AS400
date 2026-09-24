/*RTVCLSRC PGM(QSYS/QSTRUP) SRCFILE(TVRELWAECO/QCLSRC) SRCMBR(QSTRUP)*/
/********************************************************************/
/*                                                                  */
/* 5761SS1 V6R1M0 080215 RTVCLSRC-Ausgabe        25.09.15 16:24:13  */
/*                                                                  */
/* Programmname . . . . . . . . . . . . . . :   QSTRUP            PN*/
/* Bibliotheksname  . . . . . . . . . . . . :   QSYS              PL*/
/* Ursprüngliche Quellendatei . . . . . . . :   S000028739        SN*/
/* Bibliotheksname  . . . . . . . . . . . . :   $BLDSS1           SL*/
/* Ursprüngliche Quellenteildatei . . . . . :   S000028739        SM*/
/* Änderung der Quellendatei                                        */
/*   Datum/Uhrzeit  . . . . . . . . . . . . :   30.09.07 16:27:39 SC*/
/* Korrekturangabe  . . . . . . . . . . . . :   *NOPATCH          PO*/
/* Benutzerprofil . . . . . . . . . . . . . :   *USER             UP*/
/* Text . . . :                                                   TX*/
/* Eigner . . . . . . . . . . . . . . . . . :   QSYS              OW*/
/* Benutzermodus  . . . . . . . . . . . . . :   *NO               UM*/
/* Retrieve include source  . . . . . . . . :   *NO               RI*/
/*                                                                ED*/
/********************************************************************/
     PGM
     DCL VAR(&STRWTRS) TYPE(*CHAR) LEN(1)
     DCL VAR(&CTLSBSD) TYPE(*CHAR) LEN(20)
     DCL VAR(&CPYR) TYPE(*CHAR) LEN(90) VALUE('5761-SS1 (C) COPYRIGHT-
 IBM CORP 1980, 2007. LICENSED MATERIAL - PROGRAM PROPERTY OF IBM')
     QSYS/STRSBS SBSD(QSERVER)
     MONMSG MSGID(CPF0000)
     QSYS/STRSBS SBSD(QUSRWRK)
     MONMSG MSGID(CPF0000)
     QSYS/RLSJOBQ JOBQ(QGPL/QS36MRT)
     MONMSG MSGID(CPF0000)
     QSYS/RLSJOBQ JOBQ(QGPL/QS36EVOKE)
     MONMSG MSGID(CPF0000)
     QSYS/STRCLNUP
     MONMSG MSGID(CPF0000)
     QSYS/RTVSYSVAL SYSVAL(QCTLSBSD) RTNVAR(&CTLSBSD)
     IF COND((&CTLSBSD *NE 'QCTL      QSYS      ') *AND (&CTLSBSD *NE-
 'QCTL      QGPL      ')) THEN(GOTO CMDLBL(DONE))
     QSYS/STRSBS SBSD(QINTER)
     MONMSG MSGID(CPF0000)
     QSYS/STRSBS SBSD(QBATCH)
     MONMSG MSGID(CPF0000)
     QSYS/STRSBS SBSD(QCMN)
     MONMSG MSGID(CPF0000)
DONE:
     QSYS/STRSBS SBSD(QSPL)
     MONMSG MSGID(CPF0000)
     QSYS/RTVSYSVAL SYSVAL(QSTRPRTWTR) RTNVAR(&STRWTRS)
     IF COND(&STRWTRS = '0') THEN(GOTO CMDLBL(NOWTRS))
     CALL PGM(QSYS/QWCSWTRS)
     MONMSG MSGID(CPF0000)
NOWTRS:
     RETURN
     CHGVAR VAR(&CPYR) VALUE(&CPYR)
     ENDPGM
