/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/*   MENÜ INTRAST MEDLUNGEN LIB INTWAE                           */
/*                                                               */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
             PGM

             DCLF       FILE(MENINTRA)

             DCL        VAR(&BERECH) TYPE(*CHAR) LEN(1)

             IF         COND(&BERECH *EQ '0') THEN(GOTO +
                          CMDLBL(SCHLUSS))
             ADDLIBLE   LIB(INTWAE)
 ANFANG:

             SNDRCVF    RCDFMT(FMT010)

             IF         COND(&IN03 *EQ '1') THEN(GOTO CMDLBL(SCHLUSS))

             IF         COND(&AUSW *EQ '01') THEN(CALL +
                          PGM(INTWAE/VKF0868))

             IF         COND(&AUSW *EQ '02') THEN(CALL +
                          PGM(INTWAE/VKF0869CV))

             IF         COND(&AUSW *EQ '03') THEN(CALL +
                          PGM(INTWAE/VKF0880))

             IF         COND(&AUSW *EQ '19') THEN(STRPCO)
             IF         COND(&AUSW *EQ '19') THEN(STRPCCMD +
                          PCCMD('c:\WinNt\system32\calc.exe s'))

             IF         COND(&AUSW *EQ '20') THEN(STRPCO)
             IF         COND(&AUSW *EQ '20') THEN(STRPCCMD +
                          PCCMD('G:\ABTEILUNGEN\ORGA\BARENKAMP\I_VIEW+
                          32.EXE 1.jpg'))
             IF         COND(&AUSW *EQ '99') THEN(GOTO CMDLBL(SCHLUSS))

             GOTO       CMDLBL(ANFANG)

 SCHLUSS:    SIGNOFF
             ENDPGM
