PGM

/* SEKTION DATEN FÜR ROLOFF MIN MAX BERECHNUNGEN           */
             ADDLIBLE   LIB(BAR_VERT)
             MONMSG     MSGID(CPF0000)
             RUNQRY     QRY(BAR_VERT/ROLOFF_A1)
   /*        RUNQRY     QRY(BAR_VERT/ROLOFF_A2)            */
   /*        RUNQRY     QRY(BAR_VERT/ROLOFF_A3)            */
   /*        RUNQRY     QRY(BAR_VERT/ROLOFF_A4)            */
   /*        RUNQRY     QRY(BAR_VERT/ROLOFF_A5)            */
   /*        RUNQRY     QRY(BAR_VERT/ROLOFF_A6)            */
   /*        RUNQRY     QRY(BAR_VERT/ROLOFF_A7)            */
   /*        RUNQRY     QRY(BAR_VERT/ROLOFF_A8)            */
             RMVLIBLE   LIB(BAR_VERT)
             MONMSG     MSGID(CPF0000)
/* SEKTION DATEN FÜR XML CLIENT TREND LAGERINVENTUR 010111 */
             RUNQRY     QRY(BAR_QLIK/LAGINVMTR1)
             RUNQRY     QRY(BAR_QLIK/LAGINVMTR2)
             RUNQRY     QRY(BAR_QLIK/LAGINVMTR3)
             CPYF       FROMFILE(MODWAOQRY/DOMINVA) +
                          TOFILE(TVRELWAECO/DOMINVA2) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)




/* SEKTION DATEN FÜR QLIKVIEW TREND                        */
             RUNQRY     QRY(TVRELWAECO/QLIK_001)
             RUNQRY     QRY(TVRELWAECO/QLIK_002)
             RUNQRY     QRY(TVRELWAECO/QLIK_003)
             RUNQRY     QRY(TVRELWAECO/QLIK_005) /* Ausgabedatei für +
                          QlikView */
/*           RUNQRY     QRY(TVRELWAECO/QLIK_005B)    Ausgabedatei +  */
             RUNQRY     QRY(TVRELWAECO/QLIK_006) /* Ausgabedatei +
                          für QlikView */




/* SEKTION DATEN FÜR NAV LAGERBESTAND TREND VERDICHTEN     */
             RUNQRY     QRY(BAR_VERT/LAGTRD)

/* SEKTION DATEN FÜR QLICKVIEW LAGERBESTAND VERDICHTEN     */
/*           RUNQRY     QRY(BAR_QLIK/LAGINVM_01)           */
/*           RUNQRY     QRY(BAR_QLIK/LAGINVM_02)           */
/*           RUNQRY     QRY(BAR_QLIK/LAGINVM_03)           */
/*           CPYF       FROMFILE(BAR_QLIK/DOMINVA2) +                */
/*                        TOFILE(MODWAOQRY/DOMINVA2) MBROPT(*REPLACE)*/
/*           CPYF       FROMFILE(BAR_QLIK/DOMINVA2) +                */
/*                        TOFILE(TVRELWAECO/DOMINVA2)MBROPT(*REPLACE)*/

/* SEKTION DATEN FÜR THOMAS ROLOFF - LIEFERANTENLAGERBEST. */
   /*        RUNQRY     QRY(STATISTIK/DOMLIEFLM) STOP MANFRED */

/* SEKTION DATEN FÜR CONRAD BEREITSTELLEN TÄGLICH          */
             RUNQRY     QRY(BAR_VERT/CONR_A2013)
             RUNQRY     QRY(BAR_VERT/CONR_B2013)
             RUNQRY     QRY(BAR_VERT/CONR_C2013)

/* DATEN FÜR DOMETIC RÜCKRUFAKTION ABRUFEN */
  /*         CALL       PGM(BAR_FTP/FTPDOMRR_C)   STOP MANFRED*/

/* SEKTION DATEN FÜR HERRN RECH BBEP BESTELL-DISPODATEN    */
             RUNQRY     QRY(BAR_QLIK/QV_BBEP)

/* SEKTION DATEN FÜR HERRN HEMESATH TÄGLICHER LAGERBEST.   */
      /*     RUNQRY     QRY(WAECOQRY/TREND9937)   STOP MANFRED */
      /*     RUNQRY     QRY(WAECOQRY/TREND9937A)  STOP MANFRED */

/* SEKTION DATEN FÜR HERRN AHLUND CSV PER MAIL 16.04.2012  */
      /*     CALL       PGM(BAR_VERT/AHLUND)  STOP MANFRED*/

/* SEKTION DATEN NUMMERNKREISE IN #NUMKR SCHIEBEN 08.2012  */
             RUNQRY     QRY(TVRELWAECO/#NUMKR1)
             RUNQRY     QRY(TVRELWAECO/#NUMKR)

/* SEKTION DATEN MARKISEN AUSWERTUNG FR.SCHWARZER 02.2013  */
     /*      RUNQRY     QRY(TVRELWAECO/MARKIESEN1) STOP MANFRED*/

/* SEKTION DATEN RÜCKSTÄNDER TREND STATUS 17      02.2014  */
             RUNQRY     QRY(BAR_VERT/RUECKST001)


/* SEKTION DATEN SANKTIONSMONITROR STATUS 17      02.2014  */
/* UPDATE AUSGANGSVERZEICHNIS                     07.2020  */
             RUNQRY     QRY(BAR_VERT/SANKTION1)
/*           RUNQRY     QRY(BAR_VERT/SANKTION1A)           */

             RUNQRY     QRY(BAR_VERT/SANKTION2)
/*           RUNQRY     QRY(BAR_VERT/SANKTION2A)           */

             RUNQRY     QRY(BAR_VERT/SANKTION3)

             CVTDBF     OBJ('IVEAS/SAM/CUSTOMER.csv') +
                          DBFILE(BAR_VERT/SANKTION1) DBMBR(*FIRST) +
                          DBOUTFMT(*CSV) DBFLDDSC(*NO) +
                          CSVSEPCHR(*SYSVAL) COMPRESS(*NO)
             CVTDBF     OBJ('IVEAS/SAM/SUPPLIER.csv') +
                          DBFILE(BAR_VERT/SANKTION2) DBMBR(*FIRST) +
                          DBOUTFMT(*CSV) DBFLDDSC(*NO) +
                          CSVSEPCHR(*SYSVAL) COMPRESS(*NO)
             CVTDBF     OBJ('IVEAS/SAM/BANKEN.csv') +
                          DBFILE(BAR_VERT/SANKTION3) DBMBR(*FIRST) +
                          DBOUTFMT(*CSV) DBFLDDSC(*NO) +
                          CSVSEPCHR(*SYSVAL) COMPRESS(*NO)

/*           ADDLIBLE   LIB(BAR_FTP)                        */
/*           CALL       PGM(BAR_FTP/SANKFTP)                */
/*           RMVLIBLE   LIB(BAR_FTP)                        */

/* SEKTION DATEN LAGERBESTAND OE TEILE KATALOG TECDOC  02.2014  */
             RUNQRY     QRY(BAR_VERT/SHOP1)

             CVTDBF     OBJ('Barenkamp/DE411SHOP.csv') +
                          DBFILE(BAR_VERT/SHOP1) DBMBR(*FIRST) +
                          DBOUTFMT(*CSV) DBFLDDSC(*NO) +
                          CSVSEPCHR(*SYSVAL) COMPRESS(*NO)
             ADDLIBLE   LIB(BAR_FTP)
             CALL       PGM(BAR_FTP/SHOP1FTP)
             RMVLIBLE   LIB(BAR_FTP)


/* SEKTION DATEN FÜR CRM NOTES - TREND           03.2014  */
    /*       RUNQRY     QRY(LOTUS/CRMLOTUS) STOP MANFRED */


             STRSBS     SBSD(PMQSL/PMDOC)
             MONMSG     MSGID(CPF0000)
             PMQSL/PMDOCSTART
             MONMSG     MSGID(CPF0000)

/* SEKTION DATEN FÜR OP SPED   - FIBU            03.2014  */
             RUNQRY     QRY(BAR_VERT/OPSPED)


/* SEKTION INVENTUR CH DATEN FÜR TREND           08.2014  */
             RUNQRY     QRY(BAR_QLIK/LAGINVMTC1)

/* SEKTION LFS                                   08.2014  */
             RUNQRY     QRY(BAR_VERT/LFS01)
             RUNQRY     QRY(BAR_VERT/LFS02)

/* ORDERS ALS CVS AN SC SENDEN                             */
             RUNQRY     QRY(BAR_VERT/DOM_IT)
             CVTDBF     OBJ('BARENKAMP/DOM_IT.CSV') +
                          DBFILE(BAR_VERT/DOM_IT) DBOUTFMT(*CSV) +
                          DBFLDDSC(*YES) CSVSEPCHR(';')
             RUNQRY     QRY(BAR_VERT/DOM_ES)
             CVTDBF     OBJ('BARENKAMP/DOM_ES.CSV') +
                          DBFILE(BAR_VERT/DOM_ES) DBOUTFMT(*CSV) +
                          DBFLDDSC(*YES) CSVSEPCHR(';')
             RUNQRY     QRY(BAR_VERT/DOM_PL)
             CVTDBF     OBJ('BARENKAMP/DOM_PL.CSV') +
                          DBFILE(BAR_VERT/DOM_PL) DBOUTFMT(*CSV) +
                          DBFLDDSC(*YES) CSVSEPCHR(';')

             RUNQRY     QRY(BAR_VERT/DOM_NL)
             CVTDBF     OBJ('BARENKAMP/DOM_NL.CSV') +
                          DBFILE(BAR_VERT/DOM_NL) DBOUTFMT(*CSV) +
                          DBFLDDSC(*YES) CSVSEPCHR(';')

             RUNQRY     QRY(BAR_VERT/DOM_SE)
             CVTDBF     OBJ('BARENKAMP/DOM_SE.CSV') +
                          DBFILE(BAR_VERT/DOM_SE) DBOUTFMT(*CSV) +
                          DBFLDDSC(*YES) CSVSEPCHR(';')

             RUNQRY     QRY(BAR_VERT/DOM_FR)
             CVTDBF     OBJ('BARENKAMP/DOM_FR.CSV') +
                          DBFILE(BAR_VERT/DOM_FR) DBOUTFMT(*CSV) +
                          DBFLDDSC(*YES) CSVSEPCHR(';')

             RUNQRY     QRY(BAR_VERT/DOM_BE)
             CVTDBF     OBJ('BARENKAMP/DOM_BE.CSV') +
                          DBFILE(BAR_VERT/DOM_BE) DBOUTFMT(*CSV) +
                          DBFLDDSC(*YES) CSVSEPCHR(';')

             RUNQRY     QRY(BAR_VERT/DOM_DK)
             CVTDBF     OBJ('BARENKAMP/DOM_DK.CSV') +
                          DBFILE(BAR_VERT/DOM_DK) DBOUTFMT(*CSV) +
                          DBFLDDSC(*YES) CSVSEPCHR(';')

             RUNQRY     QRY(BAR_VERT/DOM_TO)
             RUNQRY     QRY(BAR_VERT/DOM_TO2)
             CVTDBF     OBJ('BARENKAMP/DOM_TO.CSV') +
                          DBFILE(BAR_VERT/DOM_TO) DBOUTFMT(*CSV) +
                          DBFLDDSC(*YES) CSVSEPCHR(';')











             RUNQRY     QRY(BAR_VERT/DOM_TO_M) /* Mail Transfer +
                          Auslösen */

             RUNQRY     QRY(BAR_VERT/DOM_ES_M) /* Mail Transfer +
                          Auslösen */
             RUNQRY     QRY(BAR_VERT/DOM_PL_M) /* Mail Transfer +
                          Auslösen */
             RUNQRY     QRY(BAR_VERT/DOM_NL_M) /* Mail Transfer +
                          Auslösen */
             RUNQRY     QRY(BAR_VERT/DOM_IT_M) /* Mail Transfer +
                          Auslösen */
             RUNQRY     QRY(BAR_VERT/DOM_DK_M) /* Mail Transfer +
                          Auslösen */
             RUNQRY     QRY(BAR_VERT/DOM_FR_M) /* Mail Transfer +
                          Auslösen */
             RUNQRY     QRY(BAR_VERT/DOM_BE_M) /* Mail Transfer +
                          Auslösen */

/* BACKORDER STATUS 17 AUFBAUEN +++ HENK 3.11.2017 BA.    */

             RUNQRY     QRY(BAR_VERT/DOM_TO_17A)
             RUNQRY     QRY(BAR_VERT/DOM_TO_17B)
             RUNQRY     QRY(BAR_VERT/DOM_TO_17C)
             RUNQRY     QRY(BAR_VERT/DOM_TO_17D)
             RUNQRY     QRY(BAR_VERT/DOM_TO_17E)
             RUNQRY     QRY(BAR_VERT/DOM_TO_17G)
             RUNQRY     QRY(BAR_VERT/DOM_TO_17M)
/* -------------------------------------------------------*/

/* SA1 SCHNITTSTELLE IVEAS FÜLLEN-------------------------*/
             RUNQRY     QRY(BAR_EXP/SA1)
             RUNQRY     QRY(BAR_EXP/SA2)

             CVTDBF     OBJ('Iveas/SA1.SA1') DBFILE(BAR_VERT/SA1) +
                          CSVSEPCHR(';')

/* SA1 SCHNITTSTELLE STELLT FILE IM IFS BEREIT------------*/

/* OEM LAGERBESTAND NACH HU SENDEN                        */
             RUNQRY     QRY(BAR_VERT/HUTEIL01)

/* STOCK, 500 510, ON HAND, RES, FREE - BERGMANS 04/2018  */
             RUNQRY     QRY(BAR_VERT/RESMNG01)
             RUNQRY     QRY(BAR_VERT/RESMNG02)
             RUNQRY     QRY(BAR_VERT/RESMNG03)
             RUNQRY     QRY(BAR_VERT/RESMNG04)

/* TCT 11 STELLIG AUFBAUEN UND BEREITSTELLEN     05/2018  */
             RUNQRY     QRY(BAR_VERT/TCT01)
             CVTDBF     OBJ('IVEAS/TCT01.csv') +
                          DBFILE(BAR_VERT/TCT01) DBOUTFMT(*CSV) +
                          CSVSEPCHR('µ')
             CVTDBF     OBJ('IVEAS/TCT/Trend2TCT/TCT01.csv') +
                          DBFILE(BAR_VERT/TCT01) DBOUTFMT(*CSV) +
                          CSVSEPCHR('µ')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('/IVEAS/TCT/TREND2TCT/TCT02.CSV') +
                        DBFILE(BAR_VERT/TCT01)  +
                        DBOUTFMT(*CSV) DBFLDDSC(*YES)
             MONMSG     MSGID(CPF0000)




/* WUP SALES DATEN BEREITSTELLEN                 05/2018  */
             RUNQRY     QRY(TVRELWAECO/QLIK_003TC)
             MONMSG     MSGID(CPF0000)
             RUNQRY     QRY(TVRELWAECO/QLIK_003T2)
             MONMSG     MSGID(CPF0000)
             RUNQRY     QRY(BAR_VERT/TEIL_URSPL)
             RUNQRY     QRY(BAR_VERT/TEIL_BEWA2)
             CPYF FROMFILE(BAR_VERT/TEILURS) +
                    TOFILE(BAR_VERT/TEILURST) MBROPT(*REPLACE) +
                           CRTFILE(*NO)
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('IVEAS/WUP/Trend2WUP/WUP01.csv') +
                          DBFILE(TVRELWAECO/WUPOUTPUT) +
                          DBOUTFMT(*CSV) CSVSEPCHR('µ')
             MONMSG     MSGID(CPF0000)
             CVTDBF     OBJ('IVEAS/WUP_TEST/Trend2WUP/WUP01.csv') +
                          DBFILE(TVRELWAECO/WUPOUTPUT) +
                          DBOUTFMT(*CSV) CSVSEPCHR('µ')
             MONMSG     MSGID(CPF0000)

/* BANKDATEN HOLEN UND FÜR SCHILLING BEREITSTELL.07/2018  */
/* JOB_R   28.06.2022                                     */
/*           ADDLIBLE   LIB(BAR_FTP)           */
/*           CALL       PGM(BAR_FTP/BANKFTP)   */
/*           RMVLIBLE   LIB(BAR_FTP)           */

/* HYMER DATEN PER FTP HOCHLADEN              03.01/2019  */
             ADDLIBLE   LIB(BAR_FTP)
             CALL       PGM(BAR_FTP/HYMERFTP)
             RMVLIBLE   LIB(BAR_FTP)

/* DETLEFFS DATEN PER FTP HOCHLADEN           04.12/2019  */
             ADDLIBLE   LIB(BAR_FTP)
             CALL       PGM(BAR_FTP/DETHFTP)
             RMVLIBLE   LIB(BAR_FTP)

/* JOHNDEERE RE FÜR HDX BEREITSTELLEN         12.02/2019  */
/*                                                                     */
/*           RUNQRY     QRY(BAR_EDI/JOHNDEERE1)                        */
/*           CVTDBF     OBJ('HDX/SND/JOHNDEERERE.CSV') +               */
/*                        DBFILE(BAR_EDI/JOHNDEERE1) DBOUTFMT(*CSV) +  */
/*                        DBFLDDSC(*YES) CSVSEPCHR(';')                */


/* B2B SHOP INVENTORY FÜR CONSID SERVER B2BFTP                         */
             ADDLIBLE   LIB(BAR_FTP)
             CALL       PGM(BAR_FTP/B2BFTP)
             RMVLIBLE   LIB(BAR_FTP)

/* EDI ACCESS INTERFACE FÜLLEN   -------------------------*/
             RUNQRY     QRY(BAR_VERT/EDI_RE_WE)













ENDPGM
