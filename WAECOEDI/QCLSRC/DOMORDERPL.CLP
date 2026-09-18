/*-------------------------------------------------*/
/* Dometic Order Schnittstellen abfragen           */
/*-------------------------------------------------*/
             PGM

             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')

             ADDLIBLE   LIB(WAECOEDI)
             MONMSG     MSGID(CPF2103)
             ADDLIBLE   LIB(BAR_FTP)
             MONMSG     MSGID(CPF2103)
             ADDLIBLE   LIB(TVRELWAECO) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

/* Dometic FR Aufträge per FTP holen */
             CALL       PGM(BAR_FTP/FTPORDERS) PARM('pl')

/* Dometic FR Aufträge einlesen */
             CALL       PGM(WAECOEDI/IFSORDERS) PARM('pl')

/* Dometic FR Aufträge in Übergabedateien stellen */
             CALL       PGM(WAECOEDI/EDI0101C) PARM('78678')

             RMVLIBLE   LIB(WAECOEDI)
             RMVLIBLE   LIB(BAR_FTP)
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
             ENDDO

/* Dometic FR Aufträge in BGFS generieren */
/* M.Gang 20101230 Ablösung Trend         */
  /*         STRS36PRC  PRC(WWWORDXM) PARM('XML,WAECOF,0')  */

             ENDPGM
