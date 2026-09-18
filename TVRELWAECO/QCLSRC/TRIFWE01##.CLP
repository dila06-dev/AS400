/*    * PROGRAMMNAME.:......                                                 */
/*    * FUNKTION.....:...                                                    */
/*    * AUGUST  2017   M. GANG                                                */
/*    AUFRUF ÜBER 'MODWAO' UND COPMANY CODE '01' BZW. ANDERE                  */
/******************************************************************************/
             PGM        PARM(&LIBRARY &COMPANY)

             DCL        VAR(&LIBRARY) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COMPANY) TYPE(*CHAR) LEN(02)

             DCL        VAR(&CODE)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&DONE) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&RUN) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&$INTERFACE) TYPE(*CHAR) LEN(01)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('TRIFWE01##')
             RTVMBRD    FILE(TVRELWAECO/QCLSRC) MBR(&PGM) TEXT(&TXT)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('START')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)

/*          PROTOKOLLIERUNG ---                                           */

/*          AUFRUF TRENBASIERTE PROGRAMME                                 */
 /*          CALL       PGM(TRDV00ST) PARM(&PGM)                     */
 /*          CALL       PGM(TRIFWE01)                                */

             CALL       PGM(TRIFWE01SJ) PARM(&LIBRARY &COMPANY)

 /*          SBMJOB CMD(CALL PGM(TRIFWE01SJ) PARM('MODWAO' '01')) +  */
 /*             JOB(JOB_R) JOBD(GANG/GANG) +                         */
 /*             INLLIBL(QTEMP TMNP MODWAO TEVMF TEVMP TAMF TAMP +    */
 /*             TVPF TVPP SEAXCALP MODWAOQRY TRENDMG TVRELWAECO +    */
 /*             DOMDTAPRD EDIFACT SASF SAS SFBF SFB SFBA QGPL   +    */
 /*             GANG)                                                */

 ENDPGM:
             DSPJOBLOG  OUTPUT(*PRINT)

/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('ENDE ')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                           'JOB_RUN   '  'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */


