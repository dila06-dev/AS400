/********************************************************************/
/*                                                                  */
/* 5761SS1 V6R1M0 080215 RTVCLSRC-Ausgabe        07.10.11 10:12:04  */
/*                                                                  */
/* Programmname . . . . . . . . . . . . . . :   GJPRJSFBCL        PN*/
/* Bibliotheksname  . . . . . . . . . . . . :   GANG              PL*/
/* Ursprüngliche Quellendatei . . . . . . . :   SRCPRJ2           SN*/
/* Bibliotheksname  . . . . . . . . . . . . :   TEST              SL*/
/* Ursprüngliche Quellenteildatei . . . . . :   GJPRJSFBCL        SM*/
/* Änderung der Quellendatei                                        */
/*   Datum/Uhrzeit  . . . . . . . . . . . . :   02.09.10 12:02:46 SC*/
/* Korrekturangabe  . . . . . . . . . . . . :   *NOPATCH          PO*/
/* Benutzerprofil . . . . . . . . . . . . . :   *OWNER            UP*/
/* Text . . . : ZV List                                           TX*/
/* Eigner . . . . . . . . . . . . . . . . . :   GANG              OW*/
/* Benutzermodus  . . . . . . . . . . . . . :   *YES              UM*/
/* Retrieve include source  . . . . . . . . :   *NO               RI*/
/*                                                                ED*/
/********************************************************************/
     PGM
     DCL VAR(&ERROR1) TYPE(*CHAR) LEN(01) VALUE('0')
     DCL VAR(&ERROR2) TYPE(*CHAR) LEN(01) VALUE('0')
     ADDLIBLE LIB(IBSSC) POSITION(*LAST)
     MONMSG MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) VALUE('1'))
     MONMSG MSGID(CFP0000)
     CALL PGM(PRJSFB)
     IF COND(&ERROR2 = '0') THEN(DO)
     RMVLIBLE LIB(IBSSC)
     ENDDO
     RETURN
     ENDPGM
