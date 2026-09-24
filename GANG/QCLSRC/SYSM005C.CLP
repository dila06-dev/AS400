/*    * PROGRAMMNAME.:SYSM005C                                               */
/*    * FUNKTION.....:CALL SYS0005R                                          */
/*    * 06.07.98                                                              */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
/*           PGM        PARM(&DSPMOD &XXPOS &YYPOS &FUNKT &SFLPAG +  */
/*                        &CTLLD1 &KEY1 &KEYV1 &KEYB1 &CTL34 +       */
/*                        &CTLRWT)                                   */

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
/*           FUNKTION  9 CALL FÜR SATZ ANLEGEN             */
             DCL        VAR(&FUNKT) TYPE(*CHAR) LEN(09) +
                          VALUE('000000001')

/* &SFLPAG   SUBFILE-PAG-PARAMETER                              */
             DCL        VAR(&SFLPAG) TYPE(*CHAR) LEN(05) VALUE('00009')

/* &CTLLD1   DEFAULD-LOAD                                       */
             DCL        VAR(&CTLLD1) TYPE(*CHAR) LEN(01) VALUE('N')

/* &KEY1     SCHLÜSSELPOSITION AB                               */
             DCL        VAR(&KEY1) TYPE(*CHAR) LEN(10) VALUE('     ')
             DCL        VAR(&KEY2) TYPE(*DEC) LEN(05) VALUE(00000)
             DCL        VAR(&KEY3) TYPE(*CHAR) LEN(10) VALUE('     ')

/* &KEYV1    RANGE-AREA FROM                                    */
             DCL        VAR(&KEYV1) TYPE(*CHAR) LEN(10) VALUE('     ')
             DCL        VAR(&KEYV2) TYPE(*DEC) LEN(05) VALUE(00000)
             DCL        VAR(&KEYV3) TYPE(*CHAR) LEN(10) VALUE('     ')

/* &KEYB1    RANGE-AREA TO                                      */
             DCL        VAR(&KEYB1) TYPE(*CHAR) LEN(10) VALUE('     ')
             DCL        VAR(&KEYB2) TYPE(*DEC) LEN(05) VALUE(00000)
             DCL        VAR(&KEYB3) TYPE(*CHAR) LEN(10) VALUE('     ')

/* &CTL34    MODIFIZIERTES LESEN IM FEHLERFALL                  */
             DCL        VAR(&CTL34) TYPE(*CHAR) LEN(01) VALUE('N')

/* &CTLWRT   SCHLÜSSELBEGRIFF MODIFIZIERBAR IM UPDATE-MODUS     */
             DCL        VAR(&CTLRWT) TYPE(*CHAR) LEN(01) VALUE('J')

/*                                                              */
             CRTDTAARA  DTAARA(QTEMP/TASTATUR) TYPE(*CHAR) LEN(480)
             MONMSG     MSGID(CPF0000)
/*----------------------------------------------------------------------------*/
             CHGVAR     VAR(&XPOS)    VALUE(&XXPOS)
             CHGVAR     VAR(&YPOS)    VALUE(&YYPOS)
/*                                                          */
             OVRDBF     FILE(§000PHY1) TOFILE(*LIBL/SYSPROGPF) +
                          MBR(*FIRST) OVRSCOPE(*CALLLVL)
             OVRDBF     FILE(§000LOG1) TOFILE(*LIBL/SYSPROGL1) +
                          MBR(*FIRST) OVRSCOPE(*CALLLVL)
             OVRDBF     FILE(SYSPROF1) TOFILE(*LIBL/SYSPROFL1) +
                          MBR(*FIRST) OVRSCOPE(*CALLLVL)
             OVRDBF     FILE(§000PHY2) TOFILE(*LIBL/SYSPROFPF) +
                          MBR(*FIRST) OVRSCOPE(*CALLLVL)
             OVRDBF     FILE(SYSPROG2) TOFILE(*LIBL/SYSPROGL2) +
                          MBR(*FIRST) OVRSCOPE(*CALLLVL)
/*                                                          */
             CHGDTAARA  DTAARA(*LDA (954 10)) VALUE(SYS0005R)
             CALL       PGM(SYS0005R) PARM(&DSPMOD &XPOS &YPOS +
                          &FUNKT &SFLPAG &CTLLD1 &KEY1 &KEY2 &KEY3 +
                          &KEYV1 &KEYV2 &KEYV3 &KEYB1 &KEYB2 &KEYB3 +
                          &CTL34 &CTLRWT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(*ALL) LVL(*)

ENDE:
             ENDPGM
