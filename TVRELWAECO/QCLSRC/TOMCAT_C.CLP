/*    * PROGRAMMNAME.: $GANG                                                 */
/*    * FUNKTION.....: ...                                                   */
/*    * OKTOBER  2010   GANG, MANFRED                                         */
/*    *                                                                       */
/*    *TOMCATLOG:  LOGFILE SERVER                                            */
/*    *TOMCATUSER: USERZUGRIFFE                                              */
/*    *TOMCATLOG2: WORKFILE                                                  */
/*    *TOMCATERRO: FEHLER DURCH ZUGRIFF                                      */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&PARM)

             DCL        VAR(&PARM)       TYPE(*CHAR) LEN(1)
             DCL        VAR(&CLIENT)     TYPE(*CHAR) LEN(07)
             DCL        VAR(&CRTDATE)    TYPE(*CHAR) LEN(13)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBR)        TYPE(*CHAR) LEN(06)
             DCL        VAR(&TC_NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&JOB)        TYPE(*CHAR) LEN(10)
             DCL        VAR(&TC_JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&CUSER)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&TC_USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)       TYPE(*CHAR) LEN(1)
             DCL        VAR(&#TOMCAT_C)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATETIME)   TYPE(*CHAR) LEN(20)
             DCL        VAR(&MSGDTA)       TYPE(*CHAR) LEN(4)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCLF       FILE(TVRELWAECO/#TOMCAT)

             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR) +
                          CURUSER(&CUSER) TYPE(&TYPE) +
                          DATETIME(&DATETIME)
             MONMSG     MSGID(CPF0000)
    /*       DLYJOB     DLY(1)              */
             ADDLIBLE   LIB(TVRELWAECO) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR1) +
                          VALUE('1'))
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR2) +
                          VALUE('1'))
             MONMSG     MSGID(CPF0000)

             WRKACTJOB OUTPUT(*PRINT) SBS(GANG) JOB(QP0ZSPWT)
             MONMSG     MSGID(CPF0000)
             CPYSPLF    FILE(QPDSPAJB) TOFILE(TVRELWAECO/#TOMCAT) +
                          JOB(&NBR/&USER/&JOB) SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)
             DLTSPLF    FILE(QPDSPAJB) JOB(&NBR/&USER/&JOB) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(TVRELWAECO/TC_USER) VALUE('*')
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(TVRELWAECO/TC_NBR) VALUE('*')
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(TVRELWAECO/TC_JOB) VALUE('*')
             MONMSG     MSGID(CPF0000)

 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(LOOPENDE))

             IF         COND(%SST(&#TOMCAT 4 10) = 'QP0ZSPWT  ') +
                          THEN(DO)
                CHGDTAARA  DTAARA(TVRELWAECO/TC_USER) +
                                   VALUE(%SST(&#TOMCAT 17 10))
                MONMSG     MSGID(CPF0000)
                CHGDTAARA  DTAARA(TVRELWAECO/TC_NBR)  +
                                   VALUE(%SST(&#TOMCAT 29 06))
                MONMSG     MSGID(CPF0000)
                CHGDTAARA  DTAARA(TVRELWAECO/TC_JOB)  +
                                   VALUE(%SST(&#TOMCAT 04 10))
                MONMSG     MSGID(CPF0000)
             ENDDO
                GOTO LOOP
 LOOPENDE:

             RTVDTAARA  DTAARA(TVRELWAECO/TC_USER) RTNVAR(&TC_USER)
             MONMSG     MSGID(CPF0000)
             RTVDTAARA  DTAARA(TVRELWAECO/TC_NBR) RTNVAR(&TC_NBR)
             MONMSG     MSGID(CPF0000)
             RTVDTAARA  DTAARA(TVRELWAECO/TC_JOB) RTNVAR(&TC_JOB)
             MONMSG     MSGID(CPF0000)


       /*   *** TOMCAT INSTANZ                                               */
             QSH        +
                          CMD('                                       -
    cd /TRENDJAVA/servers/trendWebClient/apache-tomcat-6.0.20/bin ')

             RTVDTAARA  DTAARA(TVRELWAECO/TOMCAT_C) RTNVAR(&#TOMCAT_C)
             MONMSG     MSGID(CPF0000)
             IF         COND(&#TOMCAT_C = 'E' *AND &TC_USER *NE +
                          '*         ') THEN(DO)
          /*    CHGJOB     LOG(4 00 *SECLVL) LOGCLPGM(*YES) +     */
          /*              JOBMSGQFL(*WRAP)                        */
                CPYFRMSTMF +
                          FROMSTMF('/TRENDJAVA/servers/trendWebClient+
                          /logs/catalina.out') +
                          TOMBR('/QSYS.LIB/TVRELWAECO.LIB/tomcatlog.F+
                          ILE/tomcatlog.mbr') MBROPT(*REPLACE)
                MONMSG     MSGID(CPF0000)
                CALL       PGM(DUMMY512) PARM('&MD' '#TC0500' ' ' ' ' +
                          'TOMCATUSER' 'TVRELWAECO' '*REPLACE')
                CALL       PGM(DUMMY512) PARM('&MD' '#TC0600' ' ' ' ' +
                          'TOMCATLOG2' 'TVRELWAECO' '*REPLACE')
                CALL       PGM(DUMMY512) PARM('&MD' '#TC0605' ' ' ' ' +
                          'TOMCATERRO' 'TVRELWAECO' '*REPLACE')
                ENDJOB     JOB(&TC_NBR/&TC_USER/&TC_JOB) OPTION(*IMMED)
                MONMSG     MSGID(CPF0000)
             ENDDO

/*                                                         */
             IF         COND(&PARM = 'S' *AND &TC_USER = '*         +
                          ') THEN(DO)
                CPYFRMSTMF +
                          FROMSTMF('/TRENDJAVA/servers/trendWebClient+
                          /logs/catalina.out') +
                          TOMBR('/QSYS.LIB/TVRELWAECO.LIB/tomcatlog.F+
                          ILE/tomcatlog.mbr') MBROPT(*REPLACE)
                MONMSG     MSGID(CPF0000)
                CALL       PGM(DUMMY512) PARM('&MD' '#TC0500' ' ' ' ' +
                          'TOMCATUSER' 'TVRELWAECO' '*REPLACE')
                CALL       PGM(DUMMY512) PARM('&MD' '#TC0600' ' ' ' ' +
                          'TOMCATLOG2' 'TVRELWAECO' '*REPLACE')
                CALL       PGM(DUMMY512) PARM('&MD' '#TC0605' ' ' ' ' +
                          'TOMCATERRO' 'TVRELWAECO' '*REPLACE')
         /*     CHGJOB     LOG(4 00 *SECLVL) LOGCLPGM(*YES) +      */
         /*               JOBMSGQFL(*WRAP)                         */
                CD         +
                          DIR('/TRENDJAVA/SERVERS/TRENDWEBCLIENT/APAC+
                          HE-TOMCAT-6.0.20/BIN')
                QSH        CMD('./STARTUP.SH')
                CHGDTAARA  DTAARA(TVRELWAECO/TOMCAT_C) VALUE('S')
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&PARM = 'E' *AND &TC_USER *NE +
                          '*         ') THEN(DO)
         /*     CHGJOB     LOG(4 00 *SECLVL) LOGCLPGM(*YES) +     */
         /*               JOBMSGQFL(*WRAP)                        */
                CD         +
                          DIR('/TRENDJAVA/SERVERS/TRENDWEBCLIENT/APAC+
                          HE-TOMCAT-6.0.20/BIN')
                QSH        CMD('./SHUTDOWN.SH')
                MONMSG     MSGID(CPF0000)
                DLYJOB     DLY(45)
                MONMSG     MSGID(CPF0000)
                QSH        CMD('./SHUTDOWN.SH')
                MONMSG     MSGID(CPF0000)
                CHGDTAARA  DTAARA(TVRELWAECO/TOMCAT_C) VALUE('E')
                MONMSG     MSGID(CPF0000)
                DLYJOB     DLY(15)
                MONMSG     MSGID(CPF0000)
                CPYFRMSTMF +
                          FROMSTMF('/TRENDJAVA/servers/trendWebClient+
                          /logs/catalina.out') +
                          TOMBR('/QSYS.LIB/TVRELWAECO.LIB/tomcatlog.F+
                          ILE/tomcatlog.mbr') MBROPT(*REPLACE)
                MONMSG     MSGID(CPF0000)
                CALL       PGM(DUMMY512) PARM('&MD' '#TC0500' ' ' ' ' +
                          'TOMCATUSER' 'TVRELWAECO' '*REPLACE')
                CALL       PGM(DUMMY512) PARM('&MD' '#TC0600' ' ' ' ' +
                          'TOMCATLOG2' 'TVRELWAECO' '*REPLACE')
                CALL       PGM(DUMMY512) PARM('&MD' '#TC0605' ' ' ' ' +
                          'TOMCATERRO' 'TVRELWAECO' '*REPLACE')
                ENDJOB     JOB(&TC_NBR/&TC_USER/&TC_JOB) OPTION(*IMMED)
                MONMSG     MSGID(CPF0000)
             ENDDO

 ENDPGM:
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(TVRELWAECO)
             ENDDO
             IF         COND(&ERROR2 = '0') THEN(DO)
                RMVLIBLE   LIB(GANG)
             ENDDO
       /*    DSPJOBLOG  OUTPUT(*PRINT)   */
             RCLRSC
             ENDPGM
