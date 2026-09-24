/********************************************************************/
/*                                                                  */
/* 5722SS1 V5R2M0 020719    RTVCLSRC-Ausgabe     23.05.05 13:48:40  */
/*                                                                  */
/* Programmname . . . . . . . . . . . . . . :   DIS04C            PN*/
/* Bibliotheksname  . . . . . . . . . . . . :   UEBERNAHME        PL*/
/* Ursprüngliche Quellendatei . . . . . . . :   QRPGLESRC         SN*/
/* Bibliotheksname  . . . . . . . . . . . . :   UEBERNAHME        SL*/
/* Ursprüngliche Quellenteildatei . . . . . :   DIS04C            SM*/
/* Änderung der Quellendatei                                        */
/*   Datum/Uhrzeit  . . . . . . . . . . . . :   23.05.05 13:06:18 SC*/
/* Korrekturangabe  . . . . . . . . . . . . :   *NOPATCH          PO*/
/* Benutzerprofil . . . . . . . . . . . . . :   *OWNER            UP*/
/* Text . . . : Anzeige Produktionsaufträge                       TX*/
/* Eigner . . . . . . . . . . . . . . . . . :   GANG              OW*/
/* Korrekturänderungs-ID  . . . . . . . . . :                     PC*/
/* Korrektur-APAR-ID  . . . . . . . . . . . :                     PA*/
/* Benutzermodus  . . . . . . . . . . . . . :   *YES              UM*/
/*                                                                ED*/
/********************************************************************/
     PGM
     DCL VAR(&FIRM) TYPE(*CHAR) LEN(1)
     DCL VAR(&FILE) TYPE(*CHAR) LEN(10) VALUE('DISDT04L3')
     RTVDTAARA DTAARA(QTEMP/FWLFIRM (1 1)) RTNVAR(&FIRM)
     MONMSG MSGID(CPF0000)
             IF         COND(&FIRM *NE 'L') THEN(CHGVAR VAR(&FILE) +
                          VALUE('DISDT04L2'))
             OVRDBF     FILE(DISDT04LX) TOFILE(*LIBL/&FILE) MBR(*FIRST)
     MONMSG MSGID(CPF0000)
     CALL PGM(UEBERNAHME/#DISDT04R) PARM(&FIRM)
     MONMSG MSGID(CPF0000)
             DLTOVR     FILE(DISDT04LX)
     MONMSG MSGID(CPF0000)
     ENDPGM
