/*    * PROGRAMMNAME.:DISPO02C                                               */
/*    * FUNKTION.....:CALL DISPO02R                                          */
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
             PGM        PARM(&KEYV1 &KEYV2 &KEYV3 &KEYV4 &KEYV5 +
                          &KEYV6 &CDORD &LNNUM &CDODL &PRNBR &CALLPGM)

/*----------------------------------------------------------------------------*/
             DCL        VAR(&CDORD)  TYPE(*CHAR) LEN(06)
             DCL        VAR(&LNNUM)   TYPE(*DEC)  LEN(06 0)
             DCL        VAR(&CDODL)   TYPE(*DEC)  LEN(02 0)
             DCL        VAR(&PRNBR)   TYPE(*DEC)  LEN(03 0)
             DCL        VAR(&CALLPGM)  TYPE(*CHAR) LEN(06)
             DCL        VAR(&NBRCURRCD) TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
/* &DSPMOD  DSPMOD: 0 = DS3 ==>   24 *  80                     */
/*          DSPMOD: 1 = DS4 ==>   27 * 132                     */
             DCL        VAR(&DSPMOD) TYPE(*CHAR) LEN(01) VALUE('0')

/* &XXPOS    X-WINDOW-POSITION (DSPMOD-ABHÄNGIG)               */
             DCL        VAR(&XPOS) TYPE(*DEC) LEN(03)
             DCL        VAR(&XXPOS) TYPE(*CHAR) LEN(03) VALUE('  0')

/* &YYPOS    Y-WINDOW-POSITION (DSPMOD-ABHÄNGIG)               */
             DCL        VAR(&YPOS)    TYPE(*DEC)  LEN(02)
             DCL        VAR(&YYPOS)   TYPE(*CHAR) LEN(02) VALUE(' 0')

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
             DCL        VAR(&KEY1) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&KEY2) TYPE(*CHAR) LEN(02) VALUE('  ')
             DCL        VAR(&KEY3) TYPE(*CHAR) LEN(08) +
                          VALUE('        ')
             DCL        VAR(&KEY4) TYPE(*CHAR) LEN(06) VALUE('      ')
             DCL        VAR(&KEY5) TYPE(*CHAR) LEN(06) VALUE('      ')
             DCL        VAR(&KEY6) TYPE(*CHAR) LEN(06) VALUE('      ')
             DCL        VAR(&KEY7) TYPE(*CHAR) LEN(06) VALUE('      ')
             DCL        VAR(&KEY8) TYPE(*CHAR) LEN(09) +
                          VALUE('         ')
             DCL        VAR(&KEY9) TYPE(*CHAR) LEN(09) +
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
             DCL        VAR(&KEYV9) TYPE(*CHAR) LEN(09) +
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
             DCL        VAR(&KEYB9) TYPE(*CHAR) LEN(09) +
                          VALUE('         ')

/* &CTL34    MODIFIZIERTES LESEN IM FEHLERFALL                  */
             DCL        VAR(&CTL34) TYPE(*CHAR) LEN(01) VALUE('J')

/* &CTLWRT   SCHLÜSSELBEGRIFF MODIFIZIERBAR IM UPDATE-MODUS     */
             DCL        VAR(&CTLRWT) TYPE(*CHAR) LEN(01) VALUE('J')

             DCL        VAR(&MSGPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LDAS)   TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
/*                                                              */
/*----------------------------------------------------------------------------*/
/*-ENVIRONMENT ANPASSEN BZW ERSTELLEN-----------------------------------------*/
             ADDLIBLE   LIB(FWLFR) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
             CRTDTAARA  DTAARA(QTEMP/TASTATUR) TYPE(*CHAR) LEN(480)
             MONMSG     MSGID(CPF0000)
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
/*                                                */
             DLTF       FILE(QTEMP/DIS0002L1)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&MD 1 06)) VALUE(&KEYV3)
             CALL       PGM(DUMMY512) PARM(&MD 'DIS0002' ' ' ' ' +
                          'DIS0002' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(DUMMY512) PARM(' ' 'DIS0003' ' ' ' ' +
                          ' ' ' ' ' ')
    /*       CRTLF      FILE(QTEMP/DIS0002L1) +               */
    /*                    SRCFILE(UEBERNAHME/QDDSSRC) +       */
    /*                    SRCMBR(DIS0002L1) OPTION(*NOLIST)   */
             MONMSG     MSGID(CPF0000)
             RTVMBRD    FILE(QTEMP/DIS0002) NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000)
/*    MDO'S ????                                  */
             IF         COND(&NBRCURRCD = 0) THEN(DO)
                CALL       PGM(DUMMY512) PARM(&MD 'DIS0004' ' ' ' ' +
                             'DIS0002' 'QTEMP' '*REPLACE')
                MONMSG     MSGID(CPF0000)
                CALL       PGM(DUMMY512) PARM(' ' 'DIS0003' ' ' ' ' +
                             ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)
             ENDDO
/*                                                */
             OVRDBF     FILE(§000PHY1) TOFILE(*LIBL/DIS0002) +
                          MBR(*FIRST) OVRSCOPE(*CALLLVL)
             OVRDBF     FILE(§000LOG1) TOFILE(*LIBL/DIS0002L1) +
                          MBR(*FIRST) OVRSCOPE(*CALLLVL)
/*                                                          */
             CALL       PGM(DISPO02R) PARM(&DSPMOD &XPOS &YPOS +
                          &FUNKT &SFLPAG &CTLLD1 &KEY1 &KEY2 &KEY3 +
                          &KEY4  &KEY5  &KEY6  &KEY7  &KEY8  &KEY9  +
                          &KEYV1 &KEYV2 &KEYV3 &KEYV4 &KEYV5 &KEYV6 +
                          &KEYV7 &KEYV8 &KEYV9                      +
                          &KEYB1 &KEYB2 &KEYB3 &KEYB4 &KEYB5 &KEYB6 +
                          &KEYB7 &KEYB8 &KEYB9                      +
                          &CTL34 &CTLRWT &CDORD &LNNUM &CDODL &PRNBR +
                          &CALLPGM)
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
