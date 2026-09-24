/*    * PROGRAMMNAME.:#DSPFILES                                              */
/*    * FUNKTION.....:ALLE DATEIEN EINER LIB ANZEIGEN                        */
/*    * 06.07.98       MANFRED GANG                                           */
/*    *                                                                       */
/*    * FASER-WERKE-LINGEN GMBH                                               */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * 18.11.99  LDA WIRD NICHT GESICHERT                    GANG            */
/******************************************************************************/
             PGM        PARM(&LIBL)

             DCL        VAR(&LIBL)       TYPE(*CHAR)    LEN(10)
             DCL        VAR(&FILE)       TYPE(*CHAR)    LEN(10)
             DCL        VAR(&FILEATR)    TYPE(*CHAR)    LEN(03)
             DCL        VAR(&TXT)        TYPE(*CHAR)    LEN(50)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC)     LEN(10 0)
             DCL        VAR(&NBRDLTRCD)  TYPE(*DEC)     LEN(10 0)
             DCL        VAR(&NBRDTAMBRS) TYPE(*DEC)     LEN(02 0)
             DCL        VAR(&ERROR1)     TYPE(*CHAR)    LEN(01)
             DCL        VAR(&USER)       TYPE(*CHAR)    LEN(10)
             DCL        VAR(&JOB)        TYPE(*CHAR)    LEN(10)
             DCL        VAR(&NBR)        TYPE(*CHAR)    LEN(08)
             DCL        VAR(&ATR1)       TYPE(*CHAR)    LEN(02)
             DCL        VAR(&ATR2)       TYPE(*CHAR)    LEN(05)
             DCLF       FILE(QTEMP/QPDSPLIB)
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&NBRCURRCD) VALUE(0)
             CHGVAR     VAR(&NBRDLTRCD) VALUE(0)
             CHGVAR     VAR(&NBRDTAMBRS) VALUE(0)
             CHGVAR     VAR(&TXT) VALUE('Job +
                          gestartet:                              ')
/*ÜBERGABEPARAMETER                                                          */
             DSPLIB     LIB(&LIBL) OUTPUT(*PRINT)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                           VALUE('1'))
             IF         COND(&ERROR1 = '1') THEN(DO)
                 GOTO       CMDLBL(ENDE)
             ENDDO
/*ÜBERGABEPARAMETER                                                          */
             CRTPF      FILE(QTEMP/QPDSPLIB) RCDLEN(132)
             MONMSG     MSGID(CPF0000)
             CPYSPLF    FILE(QPDSPLIB) TOFILE(QTEMP/QPDSPLIB) +
                          JOB(&NBR/&USER/&JOB)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                           VALUE('1'))
             IF         COND(&ERROR1 = '1') THEN(DO)
                 GOTO       CMDLBL(ENDE)
             ENDDO
             DLTSPLF    FILE(QPDSPLIB) JOB(&NBR/&USER/&JOB)
             MONMSG     MSGID(CPF0000)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(QPDSPLIB) TOFILE(QTEMP/QPDSPLIB) +
                          OVRSCOPE(*CALLLVL)
             IF         COND(&LIBL = 'TESDATFWL') THEN(DO)
                CALL       PGM(DUMMY512) PARM(' ' 'DSP0002' ' ' ' ' +
                             ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&LIBL = 'EDV') THEN(DO)
                CALL       PGM(DUMMY512) PARM(' ' 'DSP0004' ' ' ' ' +
                             ' ' ' ' ' ')
                MONMSG     MSGID(CPF0000)
             ENDDO
             CALL       PGM(UEBERNAHME/#DSPFILESR) PARM(&LIBL)
             CALL       PGM(DUMMY512) PARM(' ' 'DSP0001' ' ' 'GANG' +
                          ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(*ALL) LVL(*)
 EOF:
/*ÜBERGABEPARAMETER                                                          */
             GOTO       CMDLBL(ENDE)

/******************************************************************************/

ENDE:
             CHGVAR     VAR(&NBRCURRCD) VALUE(0)
             CHGVAR     VAR(&NBRDLTRCD) VALUE(0)
             CHGVAR     VAR(&NBRDTAMBRS) VALUE(0)
             CHGVAR     VAR(&TXT) VALUE('Job +
                          beendet:                                ')

             ENDPGM
