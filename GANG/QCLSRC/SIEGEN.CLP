/*    * PROGRAMMNAME.:SIEGEN                                                 */
/*    * FUNKTION.....:MAIL STEINBACH                                         */
/*    * SEPTEMBER 2010 GANG, MANFRED                                          */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM

             DCL        VAR(&ERROR1)   TYPE(*CHAR) LEN(01)  VALUE('0')
             DCL        VAR(&ERROR2)   TYPE(*CHAR) LEN(01)  VALUE('0')

             SBMJOB     CMD(CALL PGM(IBSSC/SCBBEWDP01) PARM('BBEWDP' +
                          'IBSSC')) JOB(DOM01J) JOBD(IBSSC/SFBIBS) +
                          JOBQ(*JOBD) OUTQ(*USRPRF) RTGDTA(*JOBD) +
                          INLLIBL(IBSSC REXEL_FI SFB SFBF SAS SASF +
                          SFBS SASS BUDOM)
             DSPJOBLOG  OUTPUT(*PRINT)

 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
             ENDDO

             ENDPGM
