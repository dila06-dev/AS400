/*    * PROGRAMMNAME.:#PRTJOB                                                */
/*    * FUNKTION.....:PRINT_JOB ERMITTELN                                    */
/*    * 01.01.2010     GANG, MANFRED                                          */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&USER &JOB &NBR)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&#USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&#JOB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&#NBR)    TYPE(*CHAR) LEN(06)
             DCL        VAR(&MD)      TYPE(*CHAR) LEN(256)

             WRKUSRJOB  USER(&USER) STATUS(*ALL) OUTPUT(*PRINT) +
                          JOBTYPE(*BATCH)
             MONMSG     MSGID(CPF0000)

             ADDLIBLE   LIB(GANG)
             MONMSG     MSGID(CPF0000)

             RTVJOBA    JOB(&#JOB) USER(&#USER) NBR(&#NBR)
             MONMSG     MSGID(CPF0000)

             CRTPF      FILE(QTEMP/QPDSPSBJ) RCDLEN(132) +
                          OPTION(*NOSRC *NOLIST *NOSECLVL +
                          *NOEVENTF) SIZE(10000 10)
             MONMSG     MSGID(CPF0000)
             CRTPF      FILE(GANG/QPDSPSBJ) RCDLEN(132) +
                          OPTION(*NOSRC *NOLIST *NOSECLVL +
                          *NOEVENTF) SIZE(10000 10)
             MONMSG     MSGID(CPF0000)

             CPYSPLF    FILE(QPDSPSBJ) TOFILE(QTEMP/QPDSPSBJ) +
                          JOB(&USER/QPRTJOB) SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)
             CPYSPLF    FILE(QPDSPSBJ) TOFILE(GANG/QPDSPSBJ) +
                          JOB(&USER/QPRTJOB) SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)
   /*        CPYSPLF    FILE(QPDSPSBJ) TOFILE(GANG/QPDSPSBJ) +   */
   /*                     JOB(&#NBR/&#USER/&#JOB) SPLNBR(*LAST)  */
   /*        MONMSG     MSGID(CPF0000)                           */

             DLTSPLF    FILE(QPDSPSBJ) JOB(&USER/QPRTJOB) SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&USER)
             CALL       PGM(DUMMY512) PARM(&MD '#PR1000' ' ' ' +
                          ' '#PR1000' 'QTEMP' '*REPLACE')
             MONMSG     MSGID(CPF0000)

             CALL       PGM(#PRTJOBR) PARM(&USER &JOB &NBR)

             RETURN
