/*    * PROGRAMMNAME.:PARTIE2C                                               */
/*    * FUNKTION.....:CALL PARTIE2R                                          */
/*    *               DISPONIERUNG                                           */
/*    * NOVEMBER 2000                                                         */
/*    *                                                                       */
/*    * FASERWERKE-LINGEN GMBH                                                */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&KEY1 &KEY2 &KEY3 &KEY4 &KEY5 +
                          &KEY6 &KEY7 &KEY8 &LOT +
                                 &CDORD &LNNUM &CDODL)

/*----------------------------------------------------------------------------*/
             DCL        VAR(&CDORD)  TYPE(*CHAR) LEN(06)
             DCL        VAR(&LNNUM)   TYPE(*DEC)  LEN(06 0)
             DCL        VAR(&CDODL)   TYPE(*DEC)  LEN(02 0)
             DCL        VAR(&PRNBR) TYPE(*DEC) LEN(03 0)
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
                          VALUE('110000000')

/* &SFLPAG   SUBFILE-PAG-PARAMETER                              */
             DCL        VAR(&SFLPAG) TYPE(*CHAR) LEN(05) VALUE('19999')

/* &CTLLD1   DEFAULD-LOAD                                       */
             DCL        VAR(&CTLLD1) TYPE(*CHAR) LEN(01) VALUE('N')

/* &KEY1     SCHLÜSSELPOSITION AB                               */
             DCL        VAR(&KEY1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&KEY2) TYPE(*CHAR) LEN(02)
             DCL        VAR(&KEY3) TYPE(*CHAR) LEN(08)
             DCL        VAR(&KEY4) TYPE(*CHAR) LEN(06)
             DCL        VAR(&KEY5) TYPE(*CHAR) LEN(06)
             DCL        VAR(&KEY6) TYPE(*CHAR) LEN(06)
             DCL        VAR(&KEY7) TYPE(*CHAR) LEN(06)
             DCL        VAR(&KEY8) TYPE(*CHAR) LEN(09)
             DCL        VAR(&KEY9) TYPE(*CHAR) LEN(10) +
                          VALUE('          ')
             DCL        VAR(&KEY10) TYPE(*CHAR) LEN(09) +
                          VALUE('         ')

/* &KEYV1    RANGE-AREA FROM                                    */
             DCL        VAR(&KEYV1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&KEYV2) TYPE(*CHAR) LEN(02)
             DCL        VAR(&KEYV3) TYPE(*CHAR) LEN(08)
             DCL        VAR(&KEYV4) TYPE(*CHAR) LEN(06)
             DCL        VAR(&KEYV5) TYPE(*CHAR) LEN(06)
             DCL        VAR(&KEYV6) TYPE(*CHAR) LEN(06)
             DCL        VAR(&KEYV7) TYPE(*CHAR) LEN(06) VALUE('      ')
             DCL        VAR(&KEYV8) TYPE(*CHAR) LEN(09) +
                          VALUE('         ')
             DCL        VAR(&KEYV9) TYPE(*CHAR) LEN(10) +
                          VALUE('          ')
             DCL        VAR(&KEYV10) TYPE(*CHAR) LEN(09) +
                          VALUE('         ')

/* &KEYB1    RANGE-AREA TO                                      */
             DCL        VAR(&KEYB1) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&KEYB2) TYPE(*CHAR) LEN(02) VALUE('  ')
             DCL        VAR(&KEYB3) TYPE(*CHAR) LEN(08) +
                          VALUE('        ')
             DCL        VAR(&KEYB4) TYPE(*CHAR) LEN(06) VALUE('      ')
             DCL        VAR(&KEYB5) TYPE(*CHAR) LEN(06) VALUE('      ')
             DCL        VAR(&KEYB6) TYPE(*CHAR) LEN(06) VALUE('      ')
             DCL        VAR(&KEYB7) TYPE(*CHAR) LEN(06) VALUE('      ')
             DCL        VAR(&KEYB8) TYPE(*CHAR) LEN(09) +
                          VALUE('         ')
             DCL        VAR(&KEYB9) TYPE(*CHAR) LEN(10) +
                          VALUE('          ')
             DCL        VAR(&KEYB10) TYPE(*CHAR) LEN(09) +
                          VALUE('         ')

/* &CTL34    MODIFIZIERTES LESEN IM FEHLERFALL                  */
             DCL        VAR(&CTL34) TYPE(*CHAR) LEN(01) VALUE('J')

/* &CTLWRT   SCHLÜSSELBEGRIFF MODIFIZIERBAR IM UPDATE-MODUS     */
             DCL        VAR(&CTLRWT) TYPE(*CHAR) LEN(01) VALUE('J')

             DCL        VAR(&MSGPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LDAS)   TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&FWLFIRM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&LOT)     TYPE(*CHAR) LEN(10)
/*                                                              */
/*----------------------------------------------------------------------------*/
/*-ENVIRONMENT ANPASSEN BZW ERSTELLEN-----------------------------------------*/
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
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
                   GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
             ENDDO
/*----------------------------------------------------------------------------*/
             CHGVAR     VAR(&XPOS)    VALUE(&XXPOS)
             CHGVAR     VAR(&YPOS)    VALUE(&YYPOS)
/*                                                          */
             RTVDTAARA  DTAARA(*LDA (954 10)) RTNVAR(&MSGPGM)
             IF         COND(&MSGPGM= '          ') THEN(DO)
                CALL       PGM(##SVRLDA) PARM('S')
                CHGDTAARA  DTAARA(*LDA (954 10)) VALUE(BAB0505R)
                CHGVAR     VAR(&LDAS) VALUE('S')
                CALL       PGM(#DEFLDA) PARM(' ')
             ENDDO
             DLTF       FILE(QTEMP/BOFFTRN)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(BOFFTRN) FROMLIB(LMFLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) NEWOBJ(BOFFTRN)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(§000PHY1) TOFILE(*LIBL/UNTBL00F) +
                          MBR(*FIRST) OVRSCOPE(*CALLLVL)
             OVRDBF     FILE(§000LOG1) TOFILE(*LIBL/UNTBL90L) +
                          MBR(*FIRST) OVRSCOPE(*CALLLVL)
/*                                                          */
             CALL       PGM(PARTIE2R) PARM(&DSPMOD &XPOS &YPOS +
                          &FUNKT &SFLPAG &CTLLD1 &KEY1 &KEY2 &KEY3 +
                          &KEY4  &KEY5  &KEY6  &KEY7  &KEY8  &KEY9  +
                          &KEY10     +
                          &KEYV1 &KEYV2 &KEYV3 &KEYV4 &KEYV5 &KEYV6 +
                          &KEYV7 &KEYV8 &KEYV9 &KEYV10              +
                          &KEYB1 &KEYB2 &KEYB3 &KEYB4 &KEYB5 &KEYB6 +
                          &KEYB7 &KEYB8 &KEYB9 &KEYB10              +
                          &CTL34 &CTLRWT &LOT                       +
                          &CDORD &LNNUM &CDODL)
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
