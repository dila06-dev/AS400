/*    * PROGRAMMNAME.:SYS0005C                                               */
/*    * FUNKTION.....:CALL SYS0005R                                          */
/*    * OKT 2009                                                              */
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
/*           FUNKKTIO  9 CALL FÜR SATZ ANLEGEN             */
             DCL        VAR(&FUNKT) TYPE(*CHAR) LEN(09) +
                          VALUE('111100000')

/* &SFLPAG   SUBFILE-PAG-PARAMETER                              */
             DCL        VAR(&SFLPAG) TYPE(*CHAR) LEN(05) VALUE('00500')

/* &CTLLD1   DEFAULD-LOAD                                       */
             DCL        VAR(&CTLLD1) TYPE(*CHAR) LEN(01) VALUE('J')

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
             DCL        VAR(&CTL34) TYPE(*CHAR) LEN(01) VALUE('J')

/* &CTLWRT   SCHLÜSSELBEGRIFF MODIFIZIERBAR IM UPDATE-MODUS     */
             DCL        VAR(&CTLRWT) TYPE(*CHAR) LEN(01) VALUE('J')

             DCL        VAR(&MSGPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LDAS)   TYPE(*CHAR) LEN(1) VALUE(' ')
/*                                                              */
             DCL        VAR(&TEXT)   TYPE(*CHAR) LEN(50) VALUE(' ')
             DCL        VAR(&DATETIME) TYPE(*CHAR) LEN(18) VALUE(' ')
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             RTVJOBA    USER(&USER)
/*                                                              */
             CRTDTAARA  DTAARA(QTEMP/TASTATUR) TYPE(*CHAR) LEN(480)
             MONMSG     MSGID(CPF0000)
/*----------------------------------------------------------------------------*/
/*                                                          */
             RTVDTAARA  DTAARA(*LDA (954 10)) RTNVAR(&MSGPGM)
             IF         COND(&MSGPGM= '          ') THEN(DO)
                CALL       PGM(##SVRLDA) PARM('S')
                CHGDTAARA  DTAARA(*LDA (954 10)) VALUE(SYS0005R)
                CHGVAR     VAR(&LDAS) VALUE('S')
                CALL       PGM(#DEFLDA)
             ENDDO

/*          FIRMA IN QTEMP WENN NICHT VON AUSSEN                             */
             CHKOBJ     OBJ(QTEMP/FIRMA) OBJTYPE(*DTAARA)
                MONMSG     MSGID(CPF0000) EXEC(DO)
                CRTDTAARA  DTAARA(QTEMP/FIRMA) TYPE(*CHAR) LEN(2) +
                           TEXT(FIRMA)
             ENDDO

             RTVOBJD    OBJ(GANG/&USER) OBJTYPE(*DTAARA) TEXT(&TEXT)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                CHGVAR  VAR(%SST(&TEXT 01 15)) VALUE('Befehlsstruktur')
                RTVDTAARA  DTAARA(*LDA (975 18)) RTNVAR(&DATETIME)
                CHGVAR   VAR(%SST(&TEXT 20 18)) VALUE(%SST(&DATETIME +
                          1 18))
                CRTDTAARA  DTAARA(GANG/&USER) TYPE(*CHAR) LEN(256) +
                          TEXT(&TEXT)
             ENDDO

             CRTDTAARA  DTAARA(QTEMP/MSGUSER) TYPE(*CHAR) LEN(512)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(QTEMP/PRINTER) TYPE(*CHAR) LEN(010)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(QTEMP/BATCH)   TYPE(*CHAR) LEN(001)
             MONMSG     MSGID(CPF0000)

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
             IF         COND(&XPOS *EQ 0) THEN(DO)
                CHGVAR     VAR(&XPOS) VALUE(1)
             ENDDO
             IF         COND(&YPOS *LT 2) THEN(DO)
                CHGVAR     VAR(&YPOS) VALUE(2)
             ENDDO
/*                                                          */
             CALL       PGM(SYS0005R) PARM(&DSPMOD &XPOS &YPOS +
                          &FUNKT &SFLPAG &CTLLD1 &KEY1 &KEY2 &KEY3 +
                          &KEYV1 &KEYV2 &KEYV3 &KEYB1 &KEYB2 &KEYB3 +
                          &CTL34 &CTLRWT)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(*ALL) LVL(*)

ENDE:        IF         COND(&LDAS= 'S') THEN(DO)
                CALL       PGM(##SVRLDA) PARM('R')
                MONMSG     MSGID(CPF0000)
             ENDDO
             RCLRSC
             ENDPGM
