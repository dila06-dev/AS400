/*    * PROGRAMMNAME.:..                                                     */
/*    * FUNKTION.....:..                                                     */
/*    * OKTOBER 2009   GANG, MANFRED                                          */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&#AEBEJJ &#AEBENR &#USER)

             DCL        VAR(&PARM)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')

             DCL        VAR(&ERROR4)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR5)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR6)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR7)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR8)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR9)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR10) TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&#USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&SPLNBR) TYPE(*DEC) LEN(06 0)
             DCL        VAR(&#AEBEJJ)  TYPE(*CHAR) LEN(04)
             DCL        VAR(&#AEBENR)  TYPE(*CHAR) LEN(06)

             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))

    /*       ADDLIBLE   LIB(TMNP) POSITION(*LAST)                 */
    /*       MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR4) + */
    /*                    VALUE('1'))                             */

    /*       ADDLIBLE   LIB(MODWAO) POSITION(*AFTER TMNP)         */
    /*       MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR5) + */
    /*                    VALUE('1'))                             */

    /*       ADDLIBLE   LIB(TAMF) POSITION(*AFTER MODWAO)         */
    /*       MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR6) + */
    /*                    VALUE('1'))                             */

    /*       ADDLIBLE   LIB(TAMP) POSITION(*AFTER TAMF)           */
    /*       MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR7) + */
    /*                    VALUE('1'))                             */

    /*       ADDLIBLE   LIB(TVPF) POSITION(*AFTER TAMP)           */
    /*       MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR8) + */
    /*                    VALUE('1'))                             */

    /*       ADDLIBLE   LIB(TVPP) POSITION(*AFTER TVPF)           */
    /*       MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR9) + */
    /*                    VALUE('1'))                             */

    /*       ADDLIBLE   LIB(TFXF) POSITION(*AFTER TVPP)           */
    /*       MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR10) +*/
    /*                    VALUE('1'))                             */

             CALL MODWAO/STRTRDSJ

    /*       CALL       PGM(TAMP/TRDV00ST) PARM('TRBA47ST  ')  */
             CALL       PGM(TRDV01ST)

             OVRPRTF    FILE(TRBA47DR) HOLD(*YES) OVRSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(TRBA47ST) PARM(&#AEBEJJ &#AEBENR)

             MONMSG     MSGID(CPF0000)

        /*   WRKSPLFA FILE(TRBA47) JOB(&NBR/&USER/&JOB) SPLNBR(*LAST)*/
        /*   MONMSG   MSGID(CPF0000)                                 */

             CRTPF      FILE(QTEMP/TRBA47) RCDLEN(132) OPTION(*NOSRC +
                          *NOLIST *NOSECLVL *NOEVENTF) SIZE(10000 10)
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(&USER) VALUE(&#USER)
             CALL       PGM(GANG/#PRTJOB) PARM(&USER &JOB &NBR)
             MONMSG     MSGID(CPF0000)

             CHGDTAARA  DTAARA(GANG/F1) VALUE(&USER)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(GANG/F2) VALUE(&NBR)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(GANG/F3) VALUE(&JOB)
             MONMSG     MSGID(CPF0000)

             CPYSPLF    FILE(TRBA47) TOFILE(QTEMP/TRBA47) +
                          JOB(&NBR/&USER/&JOB) SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)

        /*   FAXSPLF   EMAIL('gang@dometic-waeco.de') FILE(TRBA47) +*/
        /*                JOB(&NBR/&USER/&JOB) SPLNBR(*LAST) +      */
        /*                DLTSPLF(*YES)                             */
        /*   MONMSG     MSGID(CPF0000)                              */

             DLTSPLF    FILE(TRBA47) JOB(&NBR/&USER/&JOB) SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)

             IF         COND(&PARM = '1') THEN(DO)
             ENDDO
 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
    /*          RMVLIBLE   LIB(GANG)                   */
             ENDDO

    /*       IF         COND(&ERROR4 = '0') THEN(DO)    */
    /*          RMVLIBLE   LIB(TMNP)                    */
    /*       ENDDO                                      */
    /*       IF         COND(&ERROR5 = '0') THEN(DO)    */
    /*          RMVLIBLE   LIB(MODWAO)                  */
    /*       ENDDO                                      */
    /*       IF         COND(&ERROR6 = '0') THEN(DO)    */
    /*          RMVLIBLE   LIB(TAMF)                    */
    /*       ENDDO                                      */
    /*       IF         COND(&ERROR7 = '0') THEN(DO)    */
    /*          RMVLIBLE   LIB(TAMP)                    */
    /*       ENDDO                                      */
    /*       IF         COND(&ERROR8 = '0') THEN(DO)    */
    /*          RMVLIBLE   LIB(TVPF)                    */
    /*       ENDDO                                      */
    /*       IF         COND(&ERROR9 = '0') THEN(DO)    */
    /*          RMVLIBLE   LIB(TVPP)                    */
    /*       ENDDO                                      */
    /*       IF         COND(&ERROR10 = '0') THEN(DO)   */
    /*          RMVLIBLE   LIB(TFXF)                    */
    /*       ENDDO                                      */

             ADDLIBLE   LIB(DATENKW) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)
             DSPJOBLOG  OUTPUT(*PRINT)
             MONMSG     MSGID(CPF0000)

             ENDPGM
