/*-------------------------------------------------------------------*/
/*    This is an example of a program, that can be used as the       */
/*    program to be called in Auto-Forms-Control function-8 -        */
/*    PROGRAM-CALL.                                                  */
/*-------------------------------------------------------------------*/

PGM          (&JOBNAME &USER &JOBNBR &FILNAM &FILNBR &OUTQ &OUTQLIB)

             DCL        &DOCID       *CHAR   8

             DCL        &JOBNAME     *CHAR  10
             DCL        &USER        *CHAR  10
             DCL        &JOBNBR      *CHAR   6
             DCL        &FILNAM      *CHAR  10
             DCL        &FILNBR      *CHAR   6
             DCL        &OUTQ        *CHAR  10
             DCL        &OUTQLIB     *CHAR  10

             DCL        &USRDTA      *CHAR  10
             DCL        &USRDFN      *CHAR 255

             DCL        &JOB         *CHAR  10
             DCL        &JUSER       *CHAR  10
             DCL        VAR(&JNBR) TYPE(*CHAR) LEN(6)

             DCL        &TOSTMF      *CHAR  50
             DCL        &FRMSTMF     *CHAR  50

             DCL        &KLICHE      *CHAR  11

/*          ---YC30150P   = RECHNUNGEN AUS TIM------------------------       */
/*          ---SCHABLONE IM INTERFORM: RECHNUNG-----------------------       */
             IF         COND(&FILNAM  *EQ 'YC30150P  ') THEN(DO)
             CHGVAR     VAR(&KLICHE) VALUE(RECHNUNG)
             GOTO       CMDLBL(LOOP)
             ENDDO

/*          ---YC30150PGS = GUTSCHRIFT AUS TIM------------------------       */
/*          ---SCHABLONE IM INTERFORM: GUTSCHRIFT---------------------       */
             IF         COND(&FILNAM  *EQ 'YC30150PGS') THEN(DO)
             CHGVAR     VAR(&KLICHE) VALUE(GUTSCHRIFT)
             GOTO       CMDLBL(LOOP)
             ENDDO

/*          ---YC30150PIR = 7IR-BELEG AUS TIM-------------------------       */
/*          ---SCHABLONE IM INTERFORM: BA_BELEG-----------------------       */
             IF         COND(&FILNAM  *EQ 'YC30150PIR') THEN(DO)
             CHGVAR     VAR(&KLICHE) VALUE(BA_BELEG)
             GOTO       CMDLBL(LOOP)
             ENDDO

/*          ---YC30150PSR = STORNORECHNUNG AUS TIM--------------------       */
/*          ---SCHABLONE IM INTERFORM: RECHNUNG-----------------------       */
             IF         COND(&FILNAM  *EQ 'YC30150PSR') THEN(DO)
             CHGVAR     VAR(&KLICHE) VALUE(RECHNUNG)
             GOTO       CMDLBL(LOOP)
             ENDDO

/*          ---YC30150PSG = STORNOGUTSCHRIFT AUS TIM------------------       */
/*          ---SCHABLONE IM INTERFORM: GUTSCHRIFT---------------------       */
             IF         COND(&FILNAM  *EQ 'YC30150PSG') THEN(DO)
             CHGVAR     VAR(&KLICHE) VALUE(GUTSCHRIFT)
             GOTO       CMDLBL(LOOP)
             ENDDO

/*          ---YC30340P   = PROFORMARECHNUNG AUS TIM------------------       */
/*          ---SCHABLONE IM INTERFORM: PROF_RECHN---------------------       */
             IF         COND(&FILNAM  *EQ 'YC30340P  ') THEN(DO)
             CHGVAR     VAR(&KLICHE) VALUE('PROF_RECHN')
             GOTO       CMDLBL(LOOP)
             ENDDO

/*          ---PACKLIST_P = PACKLISTE AUS TIM ------------------------       */
/*          ---SCHABLONE IM INTERFORM: PROF_RECHN---------------------       */
             IF         COND(&FILNAM  *EQ 'PACKLIST_P') THEN(DO)
             CHGVAR     VAR(&KLICHE) VALUE('PACKLISTE')
             GOTO       CMDLBL(LOOP)
             ENDDO

/*          ---PACKLIST_D = PACKLISTE DORMAGEN -----------------------       */
/*          ---SCHABLONE IM INTERFORM: PACKLISTE ---------------------       */
             IF         COND(&FILNAM  *EQ 'PACKLIST_D') THEN(DO)
             CHGVAR     VAR(&KLICHE) VALUE('PACKLISTE')
             SNDBRKMSG  MSG(PACKLISTE_D) TOMSGQ(GANGWS04C)
             MONMSG     MSGID(CPF0000)
             GOTO       CMDLBL(LOOP)
             ENDDO

/*          ---VERTRIEBSAUFTRAG AUS TIM       ------------------------       */
/*          ---SCHABLONE IM INTERFORM: VERTRIEBSA---------------------       */
             IF         COND(&FILNAM  *EQ 'DC21010P  ') THEN(DO)
             CHGVAR     VAR(&KLICHE) VALUE('VERTRIEBSA')
             GOTO       CMDLBL(LOOP)
             ENDDO

/*          ---AUFTRAGSBESTAETIGUNG AUS TIM---------------------------       */
/*          ---SCHABLONE IM INTERFORM: AB_2---------------------------       */
             IF         COND(&FILNAM  *EQ 'YC21010P  ') THEN(DO)
             CHGVAR     VAR(&KLICHE) VALUE('AB_2      ')
             GOTO       CMDLBL(LOOP)
             ENDDO

/*          ---VERSANDLISTE LINGEN AUS TIM    ------------------------       */
/*          ---SCHABLONE IM INTERFORM: VERSANDL_L---------------------       */
             IF         COND(&FILNAM  *EQ 'YC14010P01') THEN(DO)
             CHGVAR     VAR(&KLICHE) VALUE('VERSANDL_L')
             GOTO       CMDLBL(LOOP)
             ENDDO

/*          ---VERSANDLISTE DORMAGEN AUS TIM  ------------------------       */
/*          ---SCHABLONE IM INTERFORM: VERSANDL_D---------------------       */
             IF         COND(&FILNAM  *EQ 'YC14010P02') THEN(DO)
             CHGVAR     VAR(&KLICHE) VALUE('VERSANDL_D')
             GOTO       CMDLBL(LOOP)
             ENDDO

/*          ---LIEFERSCHEIN AUS TIM-----------------------------------       */
/*          ---SCHABLONE IM INTERFORM: LIEFERSCH ---------------------       */
             IF         COND(&FILNAM  *EQ 'YC16020P  ') THEN(DO)
             CHGVAR     VAR(&KLICHE) VALUE('LIEFERSCH ')
             GOTO       CMDLBL(LOOP)
             ENDDO

/*          ---EK_BESTELLUNG AUS TIM----------------------------------       */
/*          ---SCHABLONE IM INTERFORM: BESTELLUNG---------------------       */
             IF         COND(&FILNAM  *EQ 'YO07020P  ') THEN(DO)
             CHGVAR     VAR(&KLICHE) VALUE('BESTELLUNG')
             GOTO       CMDLBL(LOOP)
             ENDDO

/*          ---EK_ANFRAGE AUS TIM-------------------------------------       */
/*          ---SCHABLONE IM INTERFORM: ANFRAGE------------------------       */
             IF         COND(&FILNAM  *EQ 'YR11020P  ') THEN(DO)
             CHGVAR     VAR(&KLICHE) VALUE('ANFRAGE   ')
             GOTO       CMDLBL(LOOP)
             ENDDO

             GOTO       CMDLBL(ENDE)

/*          ---BEREINIGUNG VON NUMERISCHEN WERTEN---------------------       */
LOOP:
             IF         (%SST(&FILNBR 6 1) *EQ ' ') DO
                        CHGVAR  %SST(&FILNBR 2 5) %SST(&FILNBR 1 5)
                        CHGVAR  %SST(&FILNBR 1 1) '0'
                        GOTO    LOOP
                        ENDDO

             ADDLIBLE   LIB(EFS)
             MONMSG     MSGID(CPF0000)

             ADDLIBLE   LIB(EFSDTA) POSITION(*AFTER EFS)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(APF3812/GETSPLFA02) PARM(&JOBNAME &USER +
                          &JOBNBR &FILNAM &FILNBR &USRDTA &USRDFN)
             CHGVAR     VAR(&TOSTMF) VALUE('//QDLS/APF3812/' *CAT +
                          &USRDTA *TCAT '.PDF')
             CHGVAR     VAR(&FRMSTMF) VALUE('\\QDLS\APF3812\' *CAT +
                          &USRDTA *TCAT '.PDF')
             DMPCLPGM

/*          ---MERGE SCHABLONE UND DORKUMENT--------------------------       */
             APF3812/MRGSPLFPDF KARTSET(FWL_LINGEN) KLICHE(&KLICHE) +
                          FILNVN(&FILNAM) +
                          JOB(&JOBNBR/&USER/&JOBNAME) +
                          SPLNBR(&FILNBR) TOSTMF(&TOSTMF) REPLACE(*YES)

             RTVJOBA    JOB(&JOB) USER(&JUSER) NBR(&JNBR)

/*          ---SPOOLS ARCHIVIEREN IM PDF-FORMAT-----------------------       */
             EFS/QRYSPLFE PRTF(&FILNAM) USER(*JOB) JOB(&JOBNAME +
                          &USER &JOBNBR) STMF(&FRMSTMF PDF) +
                          SPLNBR(&FILNBR) PRTDEV(*OUTQ) +
                          OUTQ(QUSRSYS/TESTARCHIV) ARCID(TEST)   +
                          TEXT('Spools archivieren mit PDF-Merge')

             EFS/ARCSPLF ARCID(TEST) ART(*IMPORT)

/*          ---SPOOLS LÖSCHEN NACH ARCHIVIERUNG AM ENDE---------------       */
    /*       EFS/RGZARC ARCID(TEST)      */

             GOTO       CMDLBL(ENDE)

ENDE:
             ENDPGM
