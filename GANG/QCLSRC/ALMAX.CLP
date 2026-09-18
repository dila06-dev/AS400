/*    * PROGRAMMNAME.:ALMAX                                                  */
/*    * FUNKTION.....:...                                                    */
/*    * OKTOBER 2010   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *-C:\                                                                  */
/*    *-RTOPCB C:\ALAMX.DTF                                                  */
/*    *-C:                                                                   */
/*    *-CD \PROGRAMME                                                        */
/*    *-CD "MICROSOFT OFFICE"                                                */
/*    *-CD OFFICE                                                            */
/*    *-EXCEL.EXE C:\SYS110L.XLS C:\DATENBANK\SYS110D.XLS                    */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&CODE)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&JOB)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&$GANG)     TYPE(*CHAR) LEN(32)
             DCL        VAR(&EXCEL)  TYPE(*CHAR) LEN(512) VALUE(' ')
             DCL        VAR(&BEFEHL)   TYPE(*CHAR) LEN(126) VALUE(' ')
             DCL        VAR(&DOKUMENT) TYPE(*CHAR) LEN(512) VALUE(' ')

             RTVJOBA    JOB(&JOB) USER(&USER)
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&QTIME)
             RUNQRY     QRY(GANG/AUFOFFEXP1) RCDSLT(*YES)

             CHGVAR     VAR(&EXCEL) +
                          VALUE('G:\Abteilungen\Export\WICHTRUP\Excel+
                          \backorder\ALMAX')
             CHGVAR     VAR(&EXCEL) +
                          VALUE('G:\Abteilungen\Export\' *TCAT &USER  +
                          *TCAT '\Excel\backorder\ALMAX')
         MONMSG     MSGID(CPF0000)
         CHGVAR     VAR(&DOKUMENT) VALUE('ALMAX.DTF')
         CHGVAR     VAR(&BEFEHL) VALUE('"' *TCAT &EXCEL *TCAT +
                          ' /' *CAT &DOKUMENT *TCAT '"')
         STRPCO     PCTA(*NO)
         MONMSG     MSGID(CPF0000)
         STRPCCMD   PCCMD(&BEFEHL) PAUSE(*NO)
         MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&EXCEL) +
                          VALUE('G:\Abteilungen\Export\WICHTRUP\Excel+
                          \backorder\ALMAX')
             CHGVAR     VAR(&EXCEL) +
                          VALUE('G:\Abteilungen\Export\' *TCAT &USER  +
                          *TCAT '\Excel\backorder\ALMAX')
         MONMSG     MSGID(CPF0000)
         CHGVAR     VAR(&DOKUMENT) VALUE('ALMAX.BAT')
         CHGVAR     VAR(&BEFEHL) VALUE('"' *TCAT &EXCEL *TCAT +
                          ' /' *CAT &DOKUMENT *TCAT '"')
         STRPCO     PCTA(*NO)
         MONMSG     MSGID(CPF0000)
         STRPCCMD   PCCMD(&BEFEHL) PAUSE(*NO)
         MONMSG     MSGID(CPF0000)

 ENDPGM:

     /*      DSPJOBLOG  OUTPUT(*PRINT)                */

             ENDPGM
