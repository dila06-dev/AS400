/*    * PROGRAMMNAME.:EINK001C                                               */
/*    * FUNKTION.....:CALL PARTIE2R                                          */
/*    *               DISPONIERUNG                                           */
/*    * NOVEMBER 2000                                                         */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM
    /*       PGM        PARM(&KEY1 &KEY2 )    */

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
             DCL        VAR(&SFLPAG) TYPE(*CHAR) LEN(05) VALUE('01000')

/* &CTLLD1   DEFAULD-LOAD                                       */
             DCL        VAR(&CTLLD1) TYPE(*CHAR) LEN(01) VALUE('N')

/* &KEY1     SCHLÜSSELPOSITION AB                               */
             DCL        VAR(&KEY1) TYPE(*DEC) LEN(7) VALUE(0000000)
             DCL        VAR(&KEY2) TYPE(*CHAR) LEN(30) +
                          VALUE('                              ')

/* &KEYV1    RANGE-AREA FROM                                    */
             DCL        VAR(&KEYV1) TYPE(*DEC) LEN(7) VALUE(0000000)
             DCL        VAR(&KEYV2) TYPE(*CHAR) LEN(30) +
                          VALUE('                              ')

/* &KEYB1    RANGE-AREA TO                                      */
             DCL        VAR(&KEYB1) TYPE(*DEC) LEN(7) VALUE(0000000)
             DCL        VAR(&KEYB2) TYPE(*CHAR) LEN(30) +
                          VALUE('                              ')

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
/*                                                              */
/*----------------------------------------------------------------------------*/
             CALL       PGM(GANG/F5C) PARM(' ')

/*-ENVIRONMENT ANPASSEN BZW ERSTELLEN-----------------------------------------*/
             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))
             ADDLIBLE   LIB(WAECOEDI) POSITION(*LAST)
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

             OVRDBF     FILE(§000PHY1) TOFILE(*LIBL/WAEEDIHP) +
                          MBR(*FIRST) OVRSCOPE(*CALLLVL)
             OVRDBF     FILE(§000LOG1) TOFILE(*LIBL/WAEEDIHPL1) +
                          MBR(*FIRST) OVRSCOPE(*CALLLVL)
/*                                                          */
             CALL       PGM(FTPI001R) PARM(&DSPMOD &XPOS &YPOS +
                          &FUNKT &SFLPAG &CTLLD1 &KEY1 &KEY2 &KEYV1 +
                          &KEYV2 &KEYB1 &KEYB2 &CTL34 &CTLRWT)
             MONMSG     MSGID(CPF0000)
     /*      GOTO       CMDLBL(ENDE)      */
             DLTOVR     FILE(*ALL) LVL(*)

ENDE:        IF         COND(&LDAS= 'S') THEN(DO)
                CALL       PGM(##SVRLDA) PARM('R')
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(WAECOEDI)
             ENDDO
             IF         COND(&ERROR1 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO
             RCLRSC
             ENDPGM
