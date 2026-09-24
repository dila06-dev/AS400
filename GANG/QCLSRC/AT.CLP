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
             PGM        PARM(&AT)

             DCL        VAR(&AT)        TYPE(*CHAR) LEN(5)
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


 ENDPGM:

             DSPJOBLOG  OUTPUT(*PRINT)

             ENDPGM
