/*    * PROGRAMMNAME.: $GANG                                                 */
/*    * FUNKTION.....: ...                                                   */
/*    * OKTOBER  2010   GANG, MANFRED                                         */
/*    *                                                                       */
/*    *...                                                                   */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/******************************************************************************/
             PGM        PARM(&CLIENT)

             DCL        VAR(&CLIENT)     TYPE(*CHAR) LEN(07)
             DCL        VAR(&CRTDATE)    TYPE(*CHAR) LEN(13)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&MBR)        TYPE(*CHAR) LEN(10)
             DCL        VAR(&RECORDS)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATETIME)   TYPE(*CHAR) LEN(20)
             DCL        VAR(&TXT50)      TYPE(*CHAR) LEN(50)

             RTVJOBA    USER(&USER) DATETIME(&DATETIME)
             MONMSG     MSGID(CPF0000)
             DLYJOB     DLY(1)

             MONMSG     MSGID(CPF0000)
             RTVMBRD    FILE(TVRELWAECO/ORDERINPUT) MBR(TXT) +
                          CRTDATE(&CRTDATE) NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDPGM))

             IF         COND( &NBRCURRCD *NE 0) THEN(DO)
                CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('XX')
                IF         COND(&CLIENT *EQ '0088505') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('FR')
                ENDDO
                IF         COND(&CLIENT *EQ '0055278') THEN(DO)
                   CHGVAR    VAR(%SST(&MBR 1 2)) VALUE('IT')
                ENDDO
                CHGVAR    VAR(%SST(&MBR 3 6)) VALUE(%SST(&CRTDATE 8 6))
                CPYF      FROMFILE(TVRELWAECO/ORDERINPUT) +
                          TOFILE(TVRELWAECO/ORDERINPUT) +
                          FROMMBR(TXT) TOMBR(&MBR) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NOCHK)
                MONMSG    MSGID(CPF0000)
                CHGVAR     VAR(%SST(&TXT50 1 20)) VALUE(&DATETIME)
                CHGVAR     VAR(%SST(&TXT50 22 10)) VALUE(&USER)
                CHGVAR     VAR(&RECORDS) VALUE(&NBRCURRCD)
                CHGVAR     VAR(%SST(&TXT50 33 10)) VALUE(&RECORDS)
                CHGPFM    FILE(TVRELWAECO/ORDERINPUT) MBR(&MBR) +
                          TEXT(&TXT50)
                MONMSG    MSGID(CPF0000)
                OVRDBF     FILE(ORDERINPUT) +
                          TOFILE(TVRELWAECO/ORDERINPUT) MBR(&MBR)
                MONMSG    MSGID(CPF0000)
                CALL       PGM(ORDERIN_R)
                MONMSG    MSGID(CPF0000)
             ENDDO

 ENDPGM:

             DLTOVR     FILE(ORDERINPUT)
             MONMSG     MSGID(CPF0000)
     /*      DSPJOBLOG  OUTPUT(*PRINT)                */

             ENDPGM
