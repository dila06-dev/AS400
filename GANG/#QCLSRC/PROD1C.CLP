/*    * PROGRAMMNAME.:BALL001C                                               */
/*    * FUNKTION.....:CALL BALL001R                                          */
/*    *               LOTÄNDERUNEGN                                          */
/*    * NOVEMBER 2000                                                         */
/*    *                                                                       */
/*    * FASERWERKE-LINGEN GMBH                                                */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

/*----------------------------------------------------------------------------*/
/* &DSPMOD  DSPMOD: 0 = DS3 ==>   24 *  80                     */
/*          DSPMOD: 1 = DS4 ==>   27 * 132                     */
             DCL        VAR(&DSPMOD) TYPE(*CHAR) LEN(01) VALUE('0')

/* &XXPOS    X-WINDOW-POSITION (DSPMOD-ABHÄNGIG)               */
             DCL        VAR(&XPOS) TYPE(*DEC) LEN(03)
             DCL        VAR(&XXPOS) TYPE(*CHAR) LEN(03) VALUE('  1')

/* &YYPOS    Y-WINDOW-POSITION (DSPMOD-ABHÄNGIG)               */
             DCL        VAR(&YPOS)    TYPE(*DEC)  LEN(02)
             DCL        VAR(&YYPOS)   TYPE(*CHAR) LEN(02) VALUE(' 2')

/* &FUNKT    FUNKTION  1 SÄTZE ANZEIGEN                    */
/*           FUNKTION  1 SÄTZE MODIFIZIEREN                */
/*           FUNKTION  1 SÄTZE ANLEGEN                     */
/*           FUNKTION  1 SÄTZE LÖSCHEN                     */
/*           FUNKTION  5 SONSTIGE FUNKTION                 */
/*           FUNKKTIO  9 CALL FÜR SATZ ANLEGEN             */
             DCL        VAR(&FUNKT) TYPE(*CHAR) LEN(09) +
                          VALUE('100000000')

/* &SFLPAG   SUBFILE-PAG-PARAMETER                              */
             DCL        VAR(&SFLPAG) TYPE(*CHAR) LEN(05) VALUE('19999')

/* &CTLLD1   DEFAULD-LOAD                                       */
             DCL        VAR(&CTLLD1) TYPE(*CHAR) LEN(01) VALUE('N')

/* &KEY1     SCHLÜSSELPOSITION AB                               */
             DCL        VAR(&KEY1) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&KEY2) TYPE(*CHAR) LEN(02) VALUE('  ')
             DCL        VAR(&KEY3) TYPE(*CHAR) LEN(06) VALUE('      ')
             DCL        VAR(&KEY4) TYPE(*CHAR) LEN(08) +
                          VALUE('        ')
             DCL        VAR(&KEY5) TYPE(*CHAR) LEN(06) VALUE('      ')
             DCL        VAR(&KEY6) TYPE(*CHAR) LEN(06) VALUE('      ')
             DCL        VAR(&KEY7) TYPE(*CHAR) LEN(06) VALUE('      ')
             DCL        VAR(&KEY8) TYPE(*CHAR) LEN(06) VALUE('      ')

/* &KEYV1    RANGE-AREA FROM                                    */
             DCL        VAR(&KEYV1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&KEYV2) TYPE(*CHAR) LEN(02)
             DCL        VAR(&KEYV3) TYPE(*CHAR) LEN(06)
             DCL        VAR(&KEYV4) TYPE(*CHAR) LEN(08)
             DCL        VAR(&KEYV5) TYPE(*CHAR) LEN(06)
             DCL        VAR(&KEYV6) TYPE(*CHAR) LEN(06)
             DCL        VAR(&KEYV7) TYPE(*CHAR) LEN(06)
             DCL        VAR(&KEYV8) TYPE(*CHAR) LEN(06) VALUE('      ')

/* &KEYB1    RANGE-AREA TO                                      */
             DCL        VAR(&KEYB1) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&KEYB2) TYPE(*CHAR) LEN(02) VALUE('  ')
             DCL        VAR(&KEYB3) TYPE(*CHAR) LEN(06) +
                          VALUE('      ')
             DCL        VAR(&KEYB4) TYPE(*CHAR) LEN(08) +
                          VALUE('        ')
             DCL        VAR(&KEYB5) TYPE(*CHAR) LEN(06) VALUE('      ')
             DCL        VAR(&KEYB6) TYPE(*CHAR) LEN(06) VALUE('      ')
             DCL        VAR(&KEYB7) TYPE(*CHAR) LEN(06) VALUE('      ')
             DCL        VAR(&KEYB8) TYPE(*CHAR) LEN(06) VALUE('      ')

/* &CTL34    MODIFIZIERTES LESEN IM FEHLERFALL                  */
             DCL        VAR(&CTL34) TYPE(*CHAR) LEN(01) VALUE('J')

/* &CTLWRT   SCHLÜSSELBEGRIFF MODIFIZIERBAR IM UPDATE-MODUS     */
             DCL        VAR(&CTLRWT) TYPE(*CHAR) LEN(01) VALUE('J')

             DCL        VAR(&MSGPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LDAS)   TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&FWLFIRM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
/*                                                              */
/*-ENVIRONMENT ANPASSEN BZW ERSTELLEN-----------------------------------------*/
/*----------------------------------------------------------------------------*/
/*-ENVIRONMENT ANPASSEN BZW ERSTELLEN-----------------------------------------*/
             RTVJOBA    USER(&USER)
             ADDLIBLE   LIB(FWLFR) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
             CRTDTAARA  DTAARA(QTEMP/TASTATUR) TYPE(*CHAR) LEN(480)
             MONMSG     MSGID(CPF0000)
/*----------------------------------------------------------------------------*/
             RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
             ENDDO
/*----------------------------------------------------------------------------*/
             CHGVAR     VAR(&XPOS)    VALUE(&XXPOS)
             CHGVAR     VAR(&YPOS)    VALUE(&YYPOS)
/*                                                          */
             RTVDTAARA  DTAARA(*LDA (954 10)) RTNVAR(&MSGPGM)
             IF         COND(&MSGPGM= '          ') THEN(DO)
                CALL       PGM(##SVRLDA) PARM('S')
                CHGDTAARA  DTAARA(*LDA (954 10)) VALUE(BALL001R)
                CHGVAR     VAR(&LDAS) VALUE('S')
                CALL       PGM(#DEFLDA) PARM(' ')
             ENDDO
             DLTF       FILE(QTEMP/BOFFTRN)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(§000PHY1) TOFILE(*LIBL/DISDT00F) +
                          MBR(*FIRST) OVRSCOPE(*CALLLVL)
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
                OVRDBF     FILE(§000LOG1) TOFILE(*LIBL/DISDT04L2) +
                            MBR(*FIRST) OVRSCOPE(*CALLLVL)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
                OVRDBF     FILE(§000LOG1) TOFILE(*LIBL/DISDT04L3) +
                            MBR(*FIRST) OVRSCOPE(*CALLLVL)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
                IF         COND(&USER *EQ 'NIEHOFF' *OR &USER *EQ +
                             'HANKAMP' *OR &USER = 'GANG') THEN(DO)
                   OVRDBF     FILE(§000LOG1) TOFILE(*LIBL/DISDT04L3F) +
                            MBR(*FIRST) OVRSCOPE(*CALLLVL)
                ENDDO
             ENDDO
/*                                                          */
             CALL       PGM(PROD001R) PARM(&DSPMOD &XPOS &YPOS +
                          &FUNKT &KEY1 &KEY2 &KEY3 &KEY4 &KEY5 +
                          &KEY6 &KEY7 &KEY8              &CTLRWT)
             MONMSG     MSGID(CPF0000)
     /*      GOTO       CMDLBL(ENDE)      */
             DLTOVR     FILE(*ALL) LVL(*)

ENDE:        IF         COND(&LDAS= 'S') THEN(DO)
                CALL       PGM(##SVRLDA) PARM('R')
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(FWLFR)
             ENDDO
             RCLRSC
             ENDPGM
