/*    * PROGRAMMNAME.:QM0001                                                 */
/*    * FUNKTION.....:SELEKTIONEN                                            */
/*    * 2010           MANFRED GANG                                           */
/*    *                                                                       */
/*    *                                                                       */
/*    *                                                                       */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    *                                                                       */
/******************************************************************************/
             PGM        PARM(&D3TEXT &XPOS &YPOS &DSPMOD +
                             &D3REFE &D3VSBD &D3KDGR &D3KMDA &D3LFDA)

/*ÜBERGABEPARAMETER                                                          */
/* &TEXT     BESCHREIBUNGSTEXT IN DDS-BESTIMMUNGEN                            */

/* &XPOS     X-WINDOW-POSITION (DSPMOD-ABHÄNGIG)               */
             DCL        VAR(&XPOS) TYPE(*CHAR) LEN(03)

/* &YPOS     Y-WINDOW-POSITION (DSPMOD-ABHÄNGIG)               */
             DCL        VAR(&YPOS)    TYPE(*CHAR)  LEN(02)

/* &DSPMOD  DSPMOD: 0 = DS3 ==>   24 *  80                     */
/*          DSPMOD: 1 = DS4 ==>   27 * 132                     */
             DCL        VAR(&DSPMOD) TYPE(*CHAR) LEN(01)

/* &IN85     DRUCKOPTION ZULÄSSIG JA / NEIN                    */
             DCL        VAR(&I85) TYPE(*CHAR) LEN(01) VALUE('1')

/*DEFINITIONEN                                                               */
             DCL        VAR(&KEY) TYPE(*CHAR) LEN(48) +
                          VALUE('000203000500000000100012001400000000+
                          000021000000')
             DCL        VAR(&NEUFNR) TYPE(*DEC) LEN(2 0) VALUE(0)
             DCL        VAR(&CTL29)  TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&NEUFKT) TYPE(*CHAR) LEN(20) VALUE(' ')
             DCL        VAR(&FKTRTN) TYPE(*CHAR) LEN(132) VALUE(' ')
             DCL        VAR(&FTLNG)  TYPE(*DEC) LEN(3 0) VALUE(55)
             DCL        VAR(&CTLARB) TYPE(*DEC) LEN(1 0) VALUE(9)
             DCL        VAR(&DATA)   TYPE(*CHAR) LEN(256)
             DCL        VAR(&MSGPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&XX)     TYPE(*CHAR) LEN(8)
             DCL        VAR(&LDAS)   TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&RC)     TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&ATR)    TYPE(*CHAR) LEN(63)
             DCL        VAR(&LFDA)   TYPE(*CHAR) LEN(04)
             DCL        VAR(&PARM)   TYPE(*CHAR) LEN(74)
             DCL        VAR(&PARMTXT) TYPE(*CHAR) LEN(80)
             DCL        VAR(&D3JNSP) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&CTL) TYPE(*CHAR) LEN(1) VALUE(' ')

/*DDS-FILE                                                                   */
             DCLF       FILE(QM0004D)

             CRTDTAARA  DTAARA(QTEMP/TASTATUR) TYPE(*CHAR) LEN(480)
             MONMSG     MSGID(CPF0000)
/*PROGRAMMAUFRUF FÜR FUNKTIONSTASTEN                                         */
/* INITIALISIERUNG                                                   */
             CHGDTAARA  DTAARA(*LDA (601 2)) VALUE('  ')
             CALL       PGM(##PGMFKT) PARM(&FTLNG &KEY &NEUFNR +
                            &NEUFKT &FKTRTN &CTL29 &CTLARB)
             CHGVAR     VAR(&CTLARB) VALUE(0)

/* PROGRAMMPARAMETER FÜR STEUERUNG WEITERVERARBEITEN                 */
             IF       COND((&XPOS *EQ '   ') *OR (&YPOS *EQ '  ')) +
                          THEN(DO)
                 CHGVAR     VAR(&XPOS) VALUE('010')
                 CHGVAR     VAR(&YPOS) VALUE('05')
             ENDDO
             CHGVAR     VAR(&§§XP) VALUE(&XPOS)
             CHGVAR     VAR(&§§YP) VALUE(&YPOS)
             CHGVAR     VAR(&§§XP) VALUE(&XPOS)
             CHGVAR     VAR(&§§YP) VALUE(&YPOS)
             IF         COND(&I85 *EQ '1') THEN(DO)
                 CHGVAR     VAR(&IN85) VALUE('1')
             ENDDO
             IF         COND(&I85 *EQ '0') THEN(DO)
                 CHGVAR     VAR(&IN85) VALUE('0')
             ENDDO
             IF       COND((&DSPMOD *NE '0') *AND (&DSPMOD *NE '1')) +
                          THEN(DO)
                 CHGVAR     VAR(&DSPMOD) VALUE('0')
             ENDDO
             IF         COND(&DSPMOD *EQ '1') THEN(DO)
                 CHGVAR     VAR(&IN33) VALUE('1')
             ENDDO

             CHGVAR     VAR(&§§§PGQ) VALUE('QM0004C')

             RMVMSG     CLEAR(*ALL)
             RTVJOBA    JOB(&§§§JOB)
             CHGVAR     VAR(&§§§PGM) VALUE('QM0004C')

             RTVDTAARA  DTAARA(*LDA (954 10)) RTNVAR(&MSGPGM)
             IF         COND(&MSGPGM= '          ') THEN(DO)
/*              CALL       PGM(##SVRLDA) PARM('S')                 */
                CHGDTAARA  DTAARA(*LDA (954 10)) VALUE(&§§§PGM)
                CHGVAR     VAR(&MSGPGM) VALUE(&§§§PGM)
                CHGVAR     VAR(&LDAS) VALUE('S')
             ENDDO
             CALL       PGM(#DEFLDA)
             CHGVAR     VAR(&IN82) VALUE('1')
             CHGVAR     VAR(&IN83) VALUE('1')
             CHGVAR     VAR(&IN84) VALUE('1')

             CALL       PGM(##PGMFKT) PARM(&FTLNG &KEY &NEUFNR +
                        &NEUFKT &FKTRTN &CTL29 &CTLARB)
             CHGVAR     VAR(&D2FT01) VALUE(%SST(&FKTRTN 1 54))
             CHGVAR     VAR(&D2FT01) VALUE(%SST(&FKTRTN 1 54))

             RTVDTAARA  DTAARA(*LDA (1017 8)) RTNVAR(&XX)
             CHGVAR     VAR(&LDADTD) VALUE(&XX)
             RTVJOBA    USER(&USER)

             CALL       PGM(#MODATR) PARM(&ATR)
             CHGVAR     VAR(&§§AUSGABE)  VALUE(%SST(&ATR 07 01))
             CHGVAR     VAR(&§§O)        VALUE(%SST(&ATR 33 01))


/******************************************************************************/
/* MENÜ                                                                       */
/******************************************************************************/
             SNDF       RCDFMT(QM0001D1)
   /*        SNDF       RCDFMT(QM0001D2)     */
   /*        SNDF       RCDFMT(QM0001D3)     */
             CHGVAR     VAR(&D3AUSGABE)   VALUE('B')
             CHGVAR     VAR(&D3JNSP)      VALUE('N')
 MENUE:      CHGVAR     VAR(&D2FT01)      VALUE(%SST(&FKTRTN 1 54))

 MENUE01:
             SNDF       RCDFMT(MSGSFLC)
             IF         COND(&CTL29 *EQ '1') THEN(DO)
                        CHGVAR     VAR(&IN29)    VALUE('1')
             ENDDO
             CHGVAR     VAR(&RC) VALUE('0')
             SNDF       RCDFMT(QM0001D2)
             SNDRCVF    RCDFMT(QM0001D3)
             RMVMSG     CLEAR(*ALL)

/*FUNKTIONSTASTEN                                                            */
/* PF02                                                              */
             IF         COND(&IN02 = '1') THEN(DO)
                 CHGDTAARA DTAARA(*LDA (950 02)) VALUE('02')
                 GOTO CMDLBL(ENDE)
             ENDDO
/* PF03                                                              */
             IF         COND(&IN03 = '1') THEN(DO)
                 CHGDTAARA  DTAARA(*LDA (950 02)) VALUE('03')
                 GOTO CMDLBL(ENDE)
             ENDDO
/* PF05 ODER PF14                                                    */
             IF         COND((&IN05 = '1') *OR (&IN14 = '1')) THEN(DO)
                 CHGVAR     VAR(&D3AUSGABE) VALUE('D')
                 GOTO CMDLBL(MENUE01)
             ENDDO
/* PF10                                                              */
             IF         COND(&IN10 = '1') THEN(DO)
                 CALL       PGM(QUSCMDLN)
                 GOTO       CMDLBL(MENUE01)
             ENDDO
/* PF12                                                              */
             IF         COND(&IN12 = '1') THEN(DO)
                 CHGDTAARA  DTAARA(*LDA (950 02)) VALUE('12')
                 GOTO CMDLBL(ENDE)
             ENDDO
/* PF24                                                              */
             IF         COND(&IN24 = '1') THEN(DO)
                 CALL       PGM(##PGMFKT) PARM(&FTLNG &KEY &NEUFNR +
                            &NEUFKT &FKTRTN &CTL29 &CTLARB)
                 CHGVAR     VAR(&D2FT01) VALUE(%SST(&FKTRTN 1 54))
                 GOTO       CMDLBL(MENUE)
             ENDDO

/*EINGABEN                                                                   */
/* PRÜFEN RANGEBEREICH(VARIABEL)                                     */
             CHGVAR     VAR(&§§AUSGABE)  VALUE(%SST(&ATR 07 01))
             CHGVAR     VAR(&§§O)        VALUE(%SST(&ATR 33 01))
/*          AUFBEREITUNG                                                     */
/*          START DER DRUCKOPTION ÜBER F21                                   */
             IF         COND(&IN21 = '1') THEN(DO)
                 IF       COND(&D3REFE *EQ '                       ') +
                          THEN(DO)
                       CHGVAR     VAR(&MSGPGM) VALUE('QM0004C    ')
                       CHGVAR     VAR(&PARMTXT) +
                       VALUE('Referenz1 als Selektion fehlt!')
                       SNDPGMMSG MSG(&PARMTXT) TOPGMQ(*SAME (&MSGPGM))
                       CHGVAR     VAR(&IN66)    VALUE('1')
                       MONMSG     MSGID(CPF0000)
                 ENDDO
                 IF       COND(&D3VSBD *EQ '   ') +
                          THEN(DO)
                       CHGVAR     VAR(&MSGPGM) VALUE('QM0004C    ')
                       CHGVAR     VAR(&PARMTXT) +
                       VALUE('Versandbedingung als Selektion fehlt!')
                       SNDPGMMSG MSG(&PARMTXT) TOPGMQ(*SAME (&MSGPGM))
                       CHGVAR     VAR(&IN66)    VALUE('1')
                       MONMSG     MSGID(CPF0000)
                 ENDDO
                 IF       COND(&D3KDGR *EQ '   ') +
                          THEN(DO)
                       CHGVAR     VAR(&MSGPGM) VALUE('QM0004C    ')
                       CHGVAR     VAR(&PARMTXT) +
                       VALUE('Kundengruppe als Selektion fehlt!')
                       SNDPGMMSG MSG(&PARMTXT) TOPGMQ(*SAME (&MSGPGM))
                       CHGVAR     VAR(&IN66)    VALUE('1')
                       MONMSG     MSGID(CPF0000)
                 ENDDO
                 IF       COND(&D3KMDA *LT 20150000) +
                          THEN(DO)
                       CHGVAR     VAR(&MSGPGM) VALUE('QM0004C    ')
                       CHGVAR     VAR(&PARMTXT) +
                       VALUE('KommDatum ungültig!')
                       SNDPGMMSG MSG(&PARMTXT) TOPGMQ(*SAME (&MSGPGM))
                       CHGVAR     VAR(&IN66)    VALUE('1')
                       MONMSG     MSGID(CPF0000)
                 ENDDO
                 IF       COND(&D3LFDA *LT 20150000) +
                          THEN(DO)
                       CHGVAR     VAR(&MSGPGM) VALUE('QM0004C    ')
                       CHGVAR     VAR(&PARMTXT) +
                       VALUE('Lieferdatum ungültig!')
                       SNDPGMMSG MSG(&PARMTXT) TOPGMQ(*SAME (&MSGPGM))
                       CHGVAR     VAR(&IN66)    VALUE('1')
                       MONMSG     MSGID(CPF0000)
                 ENDDO
                 IF       COND(&IN66   *EQ '1') THEN(DO)
                       GOTO      CMDLBL(MENUE)
                 ENDDO
                 IF       COND(&IN66   *EQ '0') THEN(DO)
                       GOTO      CMDLBL(ENDE)
                 ENDDO
                 IF         COND(&RC *NE '0') THEN(DO)
                       CHGVAR     VAR(&RC) VALUE('1')
                       CHGVAR     VAR(&MSGPGM) VALUE('QM0004C    ')
                       SNDPGMMSG MSG(&PARMTXT) TOPGMQ(*SAME (&MSGPGM))
                       MONMSG     MSGID(CPF0000)
                       GOTO      CMDLBL(MENUE)
                 ENDDO
                 IF         COND(&RC *EQ '0') THEN(DO)
                      CHGVAR     VAR(&RC) VALUE('1')
                      CHGVAR     VAR(&MSGPGM) VALUE('QM0004C    ')
                      SNDPGMMSG MSG(&PARMTXT) TOPGMQ(*SAME (&MSGPGM))
                      MONMSG     MSGID(CPF0000)
/*-CALL AUF DRUCKSTEUERPROGRAMM---==> START-----------------------------------*/
                      CHGVAR     VAR(&PRT) VALUE('          ')
                      IF COND(&D3AUSGABE *EQ 'D') THEN(DO)
                /*       CALL       PGM(DRUCK_R) PARM(&PRT)    */
                /*       MONMSG     MSGID(CPF0000)             */
                      ENDDO
                /*       CHGVAR     VAR(&CTL) VALUE(&D3AUSGABE)         */
                /*       CALL PGM(PRTCTL) PARM(&PRT 'QM0004P   ' &CTL + */
                /*           '*NO ' '1')                                */
                   GOTO      CMDLBL(ENDE)
                   GOTO      CMDLBL(MENUE)
                 ENDDO
             ENDDO
             CHGVAR     VAR(&IN66)    VALUE('0')
             CHGVAR     VAR(&IN66)    VALUE('0')

             GOTO       CMDLBL(MENUE)

/******************************************************************************/

ENDE:        IF         COND(&LDAS= 'S') THEN(DO)
 /*             CALL       PGM(##SVRLDA) PARM('R')              */
             ENDDO
/*           RCLRSC        */

             ENDPGM
