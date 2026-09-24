/*    * PROGRAMMNAME.:KHT001                                                 */
/*    * FUNKTION.....:SELEKTIONEN                                            */
/*    * 2010           MANFRED GANG                                           */
/* CALL PGM(GANG/KHT004C) PARM( 'ERFASSUNG DER MESSDATEN FÜR ANHÄNGENDE       */
/* SYSTE                                                                      */
/* ME' '003' '02' '0' '000.721.982.51' '0' '0' '0')                           */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    *                                                                       */
/******************************************************************************/
             PGM        PARM(&D3TEXT &XPOS &YPOS &DSPMOD +
                             &D3TENR &D3LANG &D3BREI &D3HOHE)

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

             DCL        VAR(&D3FIRM)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&D3CC)    TYPE(*CHAR) LEN(1)

/*DDS-FILE                                                                   */
             DCLF       FILE(KHT004D)

             CRTDTAARA  DTAARA(QTEMP/TASTATUR) TYPE(*CHAR) LEN(480)
             MONMSG     MSGID(CPF0000)
/*PROGRAMMAUFRUF FÜR FUNKTIONSTASTEN                                         */
/* INITIALISIERUNG                                                   */
             CHGDTAARA  DTAARA(*LDA (601 2)) VALUE('  ')
             CALL       PGM(##PGMFKT) PARM(&FTLNG &KEY &NEUFNR +
                            &NEUFKT &FKTRTN &CTL29 &CTLARB)
             CHGVAR     VAR(&CTLARB) VALUE(0)
/*INIT!!!!!!!!!!                                                             */
             CHGVAR     VAR(&D3FKT)  VALUE('II ')
             CHGVAR     VAR(&D3FKTHID) VALUE('II ')
             CHGVAR     VAR(&D3FKTB) VALUE('Einzel-Me/Stck-Eingabe +
                          Verkaufseinheit')
             CHGVAR     VAR(&D3EANR) VALUE('   ')
             CHGVAR     VAR(&D3QUAN) VALUE(0)
             CHGVAR     VAR(&D3LANG) VALUE(0)
             CHGVAR     VAR(&D3BREI) VALUE(0)
             CHGVAR     VAR(&D3HOHE) VALUE(0)
             CHGVAR     VAR(&D3GWBR) VALUE(0)
             CHGVAR     VAR(&D3GWNT) VALUE(0)
             CHGVAR     VAR(&D3LM)   VALUE('   ')
/*                                                               */
             CHGVAR     VAR(&TEEANR) VALUE('   ')
             CHGVAR     VAR(&TELANG) VALUE(0)
             CHGVAR     VAR(&TEBREI) VALUE(0)
             CHGVAR     VAR(&TEHOHE) VALUE(0)
             CHGVAR     VAR(&TEGWBR) VALUE(0)
             CHGVAR     VAR(&TEGWNT) VALUE(0)
             CHGVAR     VAR(&TELM)   VALUE('   ')
/*                                                               */
             CHGVAR     VAR(&TZEAN)  VALUE('   ')
             CHGVAR     VAR(&TZVLL)  VALUE(0)
             CHGVAR     VAR(&TZVLB)  VALUE(0)
             CHGVAR     VAR(&TZVLH)  VALUE(0)
             CHGVAR     VAR(&TZBRUT) VALUE(0)
             CHGVAR     VAR(&TZNETT) VALUE(0)
             CHGVAR     VAR(&TZLM)   VALUE('   ')

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

             CHGVAR     VAR(&§§§PGQ) VALUE('KHT004C')

             RMVMSG     CLEAR(*ALL)
             RTVJOBA    JOB(&§§§JOB)
             CHGVAR     VAR(&§§§PGM) VALUE('KHT004C')

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
  /*         CHGVAR     VAR(&§§AUSGABE)  VALUE(%SST(&ATR 07 01))   */
             CHGVAR     VAR(&§§O)        VALUE(%SST(&ATR 33 01))


/******************************************************************************/
/* MENÜ                                                                       */
/******************************************************************************/
             SNDF       RCDFMT(KHT001D1)
   /*        SNDF       RCDFMT(KHT001D2)     */
   /*        SNDF       RCDFMT(KHT001D3)     */
             CHGVAR     VAR(&D3AUSGABE)   VALUE('B')
             CHGVAR     VAR(&D3JNSP)      VALUE('N')
 MENUE:      CHGVAR     VAR(&D2FT01)      VALUE(%SST(&FKTRTN 1 54))

 MENUE01:
             SNDF       RCDFMT(MSGSFLC)
             IF         COND(&CTL29 *EQ '1') THEN(DO)
                        CHGVAR     VAR(&IN29)    VALUE('1')
             ENDDO
             CHGVAR     VAR(&RC) VALUE('0')
             SNDF       RCDFMT(KHT001D2)
             SNDRCVF    RCDFMT(KHT001D3)
             RMVMSG     CLEAR(*ALL)

/*FUNKTIONSTASTEN                    D3FKTHID                                */
/* PF03                                                              */
             IF         COND(&IN03 = '1') THEN(DO)
                 CHGDTAARA  DTAARA(*LDA (950 02)) VALUE('03')
                 GOTO CMDLBL(ENDE)
             ENDDO
/* DATFRG                                                            */
             CHGVAR     VAR(&IN64)    VALUE('1')
             CHGVAR     VAR(&IN65)    VALUE('1')
             IF COND(&D3FKT  *EQ 'I ') THEN(DO)
                CHGVAR     VAR(&D3FKTB) VALUE('Erfassung Rohartikel')
                       CHGVAR     VAR(&MSGPGM) VALUE('KHT004C    ')
                       SNDPGMMSG MSG(&PARMTXT) TOPGMQ(*SAME (&MSGPGM))
                       CHGVAR     VAR(&IN65)    VALUE('0')
                       MONMSG     MSGID(CPF0000)
             ENDDO
             IF COND(&D3FKT  *EQ 'II ') THEN(DO)
             CHGVAR     VAR(&D3FKTB) VALUE('Einzel-Me/Stck-Eingabe +
                          Verkaufseinheit')
                       CHGVAR     VAR(&MSGPGM) VALUE('KHT004C    ')
                       SNDPGMMSG MSG(&PARMTXT) TOPGMQ(*SAME (&MSGPGM))
                       CHGVAR     VAR(&IN65)    VALUE('0')
                       MONMSG     MSGID(CPF0000)
             ENDDO
             IF COND(&D3FKT  *EQ 'III ') THEN(DO)
             CHGVAR     VAR(&D3FKTB) VALUE('Verp-Einheit als weitere +
                          Verkaufseinheit')
                       CHGVAR     VAR(&MSGPGM) VALUE('KHT004C    ')
                       SNDPGMMSG MSG(&PARMTXT) TOPGMQ(*SAME (&MSGPGM))
                       CHGVAR     VAR(&IN65)    VALUE('0')
                       MONMSG     MSGID(CPF0000)
             ENDDO
             IF COND(&D3FKT  *EQ 'IV ') THEN(DO)
             CHGVAR     VAR(&D3FKTB) VALUE('Umverpackung als weitere +
                          Verkaufseinheit')
                       CHGVAR     VAR(&MSGPGM) VALUE('KHT004C    ')
                       SNDPGMMSG MSG(&PARMTXT) TOPGMQ(*SAME (&MSGPGM))
                       CHGVAR     VAR(&IN65)    VALUE('0')
                       MONMSG     MSGID(CPF0000)
             ENDDO
             IF COND(&D3FKT  *EQ 'V  ') THEN(DO)
             CHGVAR     VAR(&D3FKTB) VALUE('Lademittel ')
                       CHGVAR     VAR(&MSGPGM) VALUE('KHT004C    ')
                       SNDPGMMSG MSG(&PARMTXT) TOPGMQ(*SAME (&MSGPGM))
                       CHGVAR     VAR(&IN65)    VALUE('0')
                       MONMSG     MSGID(CPF0000)
             ENDDO
             IF COND(&IN65   *EQ '1') THEN(DO)
             CHGVAR     VAR(&D3FKTB) VALUE('keine gültige Auswahl')
                       CHGVAR     VAR(&MSGPGM) VALUE('KHT004C    ')
                       SNDPGMMSG MSG(&PARMTXT) TOPGMQ(*SAME (&MSGPGM))
                       CHGVAR     VAR(&IN65)    VALUE('1')
                       MONMSG     MSGID(CPF0000)
                       GOTO CMDLBL(MENUE01)
             ENDDO
             IF COND(&D3FKT  *NE &D3FKTHID) THEN(DO)
                CHGVAR     VAR(&D3TENRHID) VALUE('          ')
                CHGVAR     VAR(&D3FKTHID) VALUE(&D3FKT)
                CHGVAR     VAR(&MSGPGM) VALUE('KHT004C    ')
                SNDPGMMSG MSG(&PARMTXT) TOPGMQ(*SAME (&MSGPGM))
                CHGVAR     VAR(&IN65)    VALUE('0')
                MONMSG     MSGID(CPF0000)
                GOTO CMDLBL(MENUE01)
             ENDDO
             IF COND(&D3TENR *NE &D3TENRHID) THEN(DO)
                CALL    PGM(KHT_ITEMR) PARM(&D3FIRM &D3FKT &D3TENR +
                        &TZEAN  &TZVLL  &TZVLB  &TZVLH  &TZBRUT &TZNETT +
                        &TZLM                               +
                        &TEEANR &TELANG &TEBREI &TEHOHE &TEGWBR &TEGWNT +
                        &TELM &D3CC)
                CHGVAR     VAR(&D3TENRHID) VALUE(&D3TENR)
                CHGVAR     VAR(&MSGPGM) VALUE('KHT004C    ')
                SNDPGMMSG MSG(&PARMTXT) TOPGMQ(*SAME (&MSGPGM))
                CHGVAR     VAR(&IN66)    VALUE('1')
                MONMSG     MSGID(CPF0000)
                GOTO CMDLBL(MENUE01)
             ENDDO
/* PF21                                                              */
             IF         COND(&IN21 = '1') THEN(DO)
                 CHGDTAARA DTAARA(*LDA (950 02)) VALUE('02')
      /*         GOTO CMDLBL(ENDE)            */
                 GOTO CMDLBL(MENUE01)
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
  /*         CHGVAR     VAR(&§§AUSGABE)  VALUE(%SST(&ATR 07 01))        */
             CHGVAR     VAR(&§§O)        VALUE(%SST(&ATR 33 01))
/*          AUFBEREITUNG                                                     */
/*          START DER DRUCKOPTION ÜBER F21                                   */
             IF         COND(&IN02 = '1') THEN(DO)
                 CHGVAR     VAR(&IN65)    VALUE('0')
                 CHGVAR     VAR(&IN66)    VALUE('0')
                 IF       COND(&D3TENR *EQ '                       ') +
                          THEN(DO)
                       CHGVAR     VAR(&MSGPGM) VALUE('KHT004C    ')
                       CHGVAR     VAR(&PARMTXT) +
                       VALUE('Artikel als Selektion fehlt! ')
                       SNDPGMMSG MSG(&PARMTXT) TOPGMQ(*SAME (&MSGPGM))
                       CHGVAR     VAR(&IN66)    VALUE('1')
                       MONMSG     MSGID(CPF0000)
                       CHGVAR     VAR(&TEEANR) VALUE('   ')
                       CHGVAR     VAR(&TELANG) VALUE(0)
                       CHGVAR     VAR(&TEBREI) VALUE(0)
                       CHGVAR     VAR(&TEHOHE) VALUE(0)
                       CHGVAR     VAR(&TEGWBR) VALUE(0)
                       CHGVAR     VAR(&TEGWNT) VALUE(0)
                       CHGVAR     VAR(&TELM)   VALUE('   ')
/*                                                               */
                       CHGVAR     VAR(&TZEAN)  VALUE('   ')
                       CHGVAR     VAR(&TZVLL)  VALUE(0)
                       CHGVAR     VAR(&TZVLB)  VALUE(0)
                       CHGVAR     VAR(&TZVLH)  VALUE(0)
                       CHGVAR     VAR(&TZBRUT) VALUE(0)
                       CHGVAR     VAR(&TZNETT) VALUE(0)
                       CHGVAR     VAR(&TZLM)   VALUE('   ')
                 ENDDO
                 IF       COND(&IN66  *EQ '0') THEN(DO)
                    CALL    PGM(KHT_ITEMR) PARM(&D3FIRM  &D3FKT   &D3TENR +
                            &TZEAN  &TZVLL  &TZVLB  &TZVLH  &TZBRUT &TZNETT +
                            &TZLM                               +
                            &TEEANR &TELANG &TEBREI &TEHOHE &TEGWBR &TEGWNT +
                            &TELM &D3CC)
                 ENDDO
                 IF       COND(&D3CC   *EQ 'E') THEN(DO)
                       CHGVAR     VAR(&MSGPGM) VALUE('KHT004C    ')
                       CHGVAR     VAR(&PARMTXT) +
                       VALUE('Artikel fehlt in Datenbank ! ')
                       SNDPGMMSG MSG(&PARMTXT) TOPGMQ(*SAME (&MSGPGM))
                       CHGVAR     VAR(&IN66)    VALUE('1')
                       MONMSG     MSGID(CPF0000)
                       CHGVAR     VAR(&TEEANR) VALUE('   ')
                       CHGVAR     VAR(&TELANG) VALUE(0)
                       CHGVAR     VAR(&TEBREI) VALUE(0)
                       CHGVAR     VAR(&TEHOHE) VALUE(0)
                       CHGVAR     VAR(&TEGWBR) VALUE(0)
                       CHGVAR     VAR(&TEGWNT) VALUE(0)
                       CHGVAR     VAR(&TELM)   VALUE('   ')
/*                                                               */
                       CHGVAR     VAR(&TZEAN)  VALUE('   ')
                       CHGVAR     VAR(&TZVLL)  VALUE(0)
                       CHGVAR     VAR(&TZVLB)  VALUE(0)
                       CHGVAR     VAR(&TZVLH)  VALUE(0)
                       CHGVAR     VAR(&TZBRUT) VALUE(0)
                       CHGVAR     VAR(&TZNETT) VALUE(0)
                       CHGVAR     VAR(&TZLM)   VALUE('   ')
                 ENDDO

                 CHGVAR     VAR(&XXQUAN)  VALUE(%SST(&ATR 33 01))
                 CHGVAR     VAR(&XXLANG)  VALUE(%SST(&ATR 33 01))
                 CHGVAR     VAR(&XXBREI)  VALUE(%SST(&ATR 33 01))
                 CHGVAR     VAR(&XXHOHE)  VALUE(%SST(&ATR 33 01))
                 CHGVAR     VAR(&XXGWBR)  VALUE(%SST(&ATR 33 01))
                 CHGVAR     VAR(&XXGWNT)  VALUE(%SST(&ATR 33 01))
                 CHGVAR     VAR(&XXLM)    VALUE(%SST(&ATR 33 01))

                 IF    COND(&TEQUAN *NE &ZTZQ  *OR &TEQUAN = 0) THEN(DO)
                       CHGVAR     VAR(&XXQUAN)  VALUE(%SST(&ATR 09 01))
                 ENDDO
                 IF    COND(&TELANG *NE &TZVLL *OR &TELANG = 0) THEN(DO)
                       CHGVAR     VAR(&XXLANG)  VALUE(%SST(&ATR 09 01))
                 ENDDO
                 IF    COND(&TEBREI *NE &TZVLB *OR &TEBREI = 0) THEN(DO)
                       CHGVAR     VAR(&XXBREI)  VALUE(%SST(&ATR 09 01))
                 ENDDO
                 IF    COND(&TEHOHE *NE &TZVLH *OR &TEHOHE = 0) THEN(DO)
                       CHGVAR     VAR(&XXHOHE)  VALUE(%SST(&ATR 09 01))
                 ENDDO
                 IF    COND(&TEGWBR *NE &TZBRUT *OR &TEGWBR = 0) THEN(DO)
                       CHGVAR     VAR(&XXGWBR)  VALUE(%SST(&ATR 09 01))
                 ENDDO
                 IF    COND(&TEGWNT *NE &TZNETT *OR &TEGWNT = 0) THEN(DO)
                       CHGVAR     VAR(&XXGWNT)  VALUE(%SST(&ATR 09 01))
                 ENDDO
                 IF    COND(&TELM   *NE &TZLM  *OR &TELM = '???') THEN(DO)
                       CHGVAR     VAR(&XXLM)    VALUE(%SST(&ATR 09 01))
                 ENDDO
                 IF       COND(&D3QUAN *EQ 0    ) +
                          THEN(DO)
                       CHGVAR     VAR(&MSGPGM) VALUE('KHT004C    ')
                       CHGVAR     VAR(&PARMTXT) +
                       VALUE('Menge fehlt als Ein/Übergabe!      ')
                       SNDPGMMSG MSG(&PARMTXT) TOPGMQ(*SAME (&MSGPGM))
                       CHGVAR     VAR(&IN66)    VALUE('1')
                       CHGVAR     VAR(&IN64)    VALUE('0')
                       CHGVAR     VAR(&§§QUAN)  VALUE(%SST(&ATR 09 01))
                       MONMSG     MSGID(CPF0000)
                 ENDDO
                 IF       COND(&D3LANG *EQ 0    ) +
                          THEN(DO)
                       CHGVAR     VAR(&MSGPGM) VALUE('KHT004C    ')
                       CHGVAR     VAR(&PARMTXT) +
                       VALUE('Länge in dm als Übergabe fehlt!  ')
                       SNDPGMMSG MSG(&PARMTXT) TOPGMQ(*SAME (&MSGPGM))
                       CHGVAR     VAR(&IN66)    VALUE('1')
                       CHGVAR     VAR(&IN64)    VALUE('0')
                       CHGVAR     VAR(&§§LANG)  VALUE(%SST(&ATR 09 01))
                       MONMSG     MSGID(CPF0000)
                 ENDDO
                 IF       COND(&D3BREI *EQ 0    ) +
                          THEN(DO)
                       CHGVAR     VAR(&MSGPGM) VALUE('KHT004C    ')
                       CHGVAR     VAR(&PARMTXT) +
                       VALUE('Breite in dm als Übergabe fehlt! ')
                       SNDPGMMSG MSG(&PARMTXT) TOPGMQ(*SAME (&MSGPGM))
                       CHGVAR     VAR(&IN66)    VALUE('1')
                       CHGVAR     VAR(&IN64)    VALUE('0')
                       CHGVAR     VAR(&§§BREI)  VALUE(%SST(&ATR 09 01))
                       MONMSG     MSGID(CPF0000)
                 ENDDO
                 IF       COND(&D3HOHE *EQ 0    )    +
                          THEN(DO)
                       CHGVAR     VAR(&MSGPGM) VALUE('KHT004C    ')
                       CHGVAR     VAR(&PARMTXT) +
                       VALUE('Höhe in dm als Übergabe fehlt!  ')
                       SNDPGMMSG MSG(&PARMTXT) TOPGMQ(*SAME (&MSGPGM))
                       CHGVAR     VAR(&IN66)    VALUE('1')
                       CHGVAR     VAR(&IN64)    VALUE('0')
                       CHGVAR     VAR(&§§HOHE)  VALUE(%SST(&ATR 09 01))
                       MONMSG     MSGID(CPF0000)
                 ENDDO
                 IF       COND(&D3LM *LT '   ') +
                          THEN(DO)
                       CHGVAR     VAR(&MSGPGM) VALUE('KHT004C    ')
                       CHGVAR     VAR(&PARMTXT) +
                       VALUE('Lademittel fehlt!               ')
                       SNDPGMMSG MSG(&PARMTXT) TOPGMQ(*SAME (&MSGPGM))
                       CHGVAR     VAR(&IN66)    VALUE('1')
                       CHGVAR     VAR(&IN64)    VALUE('0')
                       MONMSG     MSGID(CPF0000)
                 ENDDO
                 IF       COND(&IN65   *EQ '1') THEN(DO)
              /*       GOTO      CMDLBL(MENUE)              */
                 ENDDO
                 IF       COND(&IN66   *EQ '1') THEN(DO)
              /*       GOTO      CMDLBL(MENUE)              */
                 ENDDO
                 IF       COND(&IN66   *EQ '0') THEN(DO)
              /*       GOTO      CMDLBL(ENDE)               */
                 ENDDO
                 IF         COND(&RC *NE '0') THEN(DO)
                       CHGVAR     VAR(&RC) VALUE('1')
                       CHGVAR     VAR(&MSGPGM) VALUE('KHT004C    ')
                       SNDPGMMSG MSG(&PARMTXT) TOPGMQ(*SAME (&MSGPGM))
                       MONMSG     MSGID(CPF0000)
                       GOTO      CMDLBL(MENUE)
                 ENDDO
                 IF         COND(&RC *EQ '0') THEN(DO)
                      CHGVAR     VAR(&RC) VALUE('1')
                      CHGVAR     VAR(&MSGPGM) VALUE('KHT004C    ')
                      SNDPGMMSG MSG(&PARMTXT) TOPGMQ(*SAME (&MSGPGM))
                      MONMSG     MSGID(CPF0000)
/*-CALL AUF DRUCKSTEUERPROGRAMM---==> START-----------------------------------*/
                      CHGVAR     VAR(&PRT) VALUE('          ')
                      IF COND(&D3AUSGABE *EQ 'D') THEN(DO)
                /*       CALL       PGM(DRUCK_R) PARM(&PRT)    */
                /*       MONMSG     MSGID(CPF0000)             */
                      ENDDO
                /*       CHGVAR     VAR(&CTL) VALUE(&D3AUSGABE)         */
                /*       CALL PGM(PRTCTL) PARM(&PRT 'KHT004P   ' &CTL + */
                /*           '*NO ' '1')                                */
          /*   !!! GOTO      CMDLBL(ENDE)                   */
                    CALL    PGM(KHT_INSERT) PARM(&D3TENR   +
                                &D3QUAN &D3LANG &D3BREI &D3HOHE &D3GWBR  +
                                &D3GWNT &D3EANR &D3LM &D3CC)
                   GOTO      CMDLBL(MENUE)
                 ENDDO
             ENDDO
             CHGVAR     VAR(&IN65)    VALUE('0')
             CHGVAR     VAR(&IN66)    VALUE('0')
             CHGVAR     VAR(&IN66)    VALUE('0')

             GOTO       CMDLBL(MENUE)

/******************************************************************************/

ENDE:        IF         COND(&LDAS= 'S') THEN(DO)
 /*             CALL       PGM(##SVRLDA) PARM('R')              */
             ENDDO
/*           RCLRSC        */

             ENDPGM
