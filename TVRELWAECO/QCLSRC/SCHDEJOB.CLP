/*    * PROGRAMMNAME.:TREND ENVIRONMENT AUFBAUEN                             */
/*    * FUNKTION.....:..                                                     */
/*    * SEPTEMBER 2010   GANG, MANFRED                                        */
/*    *                                                                       */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                          PGMR.....           */
/******************************************************************************/
             PGM

             DCL        VAR(&PARM) TYPE(*CHAR) LEN(01)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*FIRST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))

             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
             MONMSG     MSGID(CPF0000)
             ADDJOBSCDE JOB(RUNONCER) CMD(SBMJOB CMD(CALL +
                          PGM(TVRELWAECO/RUNONCER)) JOB(SPED51DPDC) +
                          JOBD(GANG/GANG) INLLIBL(QPDA QTEMP TMNP +
                          MODWAO TEVMF TEVMP TAMF TAMP TVPF TVPP +
                          TFXF TVRELWAECO SFBF SFB SASF SAS +
                          SEAXCALP MODWAOQRY QGPL #LIBRARY QSSP +
                          GANG)) FRQ(*WEEKLY) SCDDATE(*NONE) +
                          SCDDAY(*MON *TUE *WED *THU *FRI) +
                          SCDTIME('10:00:00') OMITDATE(*NONE) +
                          RCYACN(*SBMRLS) JOBD(*USRPRF) USER(GANG) +
                          MSGQ(*USRPRF) TEXT('einmalige Jobs')
             MONMSG     MSGID(CPF0000)


             IF         COND(&PARM = '1') THEN(DO)
             ENDDO
 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
    /*          RMVLIBLE   LIB(GANG)                       */
             ENDDO
             IF         COND(&ERROR1 = '0') THEN(DO)
    /*          RMVLIBLE   LIB(TVRELWAECO)                 */
             ENDDO

             ENDPGM
