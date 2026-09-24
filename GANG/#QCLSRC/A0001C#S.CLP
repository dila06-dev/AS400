/*    * PROGRAMMNAME.:A0001C                                                 */
/*    * FUNKTION.....:....                                                   */
/*    *               ...                                                    */
/*    * 2004                                                                  */
/*    *                                                                       */
/*    * FASERWERKE-LINGEN GMBH                                                */
/*    * DARMER ESCH 75                                                        */
/*    * 49811 LINGEN                                                          */
/*    *                                                                       */
/*    *-ÄNDERUNGSDIENST-------------------------------------------------------*/
/*    * XX.XX.XX                                              PGMR.....       */
/*    * 04.07.2001                                            GANG            */
/******************************************************************************/
             PGM

             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')

             DCL        VAR(&MSGPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LDAS)   TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&ERROR1)  TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)  TYPE(*CHAR) LEN(01) VALUE('0')
/*                                                              */
             DCL        VAR(&MODUS)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATMOD)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&RTNCOD)  TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&SYSGES)  TYPE(*CHAR) LEN(26)
             DCL        VAR(&SYSDAT)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYSZEI)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FWLFIRM) TYPE(*CHAR) LEN(01)
/*----------------------------------------------------------------------------*/
             RTVDTAARA  DTAARA(FWLFIRM (1 1)) RTNVAR(&FWLFIRM)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             GOTO       CMDLBL(ENDE)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
             ENDDO
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
             ENDDO
/*----------------------------------------------------------------------------*/
             DLTF       FILE(QTEMP/BAB0706)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/BAB0721)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/BAB0706E)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/BAB0721E)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/ARCHIV)
             MONMSG     MSGID(CPF0000)
/*----------------------------------------------------------------------------*/
/*-ENVIRONMENT ANPASSEN BZW ERSTELLEN-----------------------------------------*/
             CRTDUPOBJ  OBJ(BAB0706) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             CRTDUPOBJ  OBJ(BAB0721) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             CRTDUPOBJ  OBJ(BAB0706E) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             CRTDUPOBJ  OBJ(BAB0721E) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             CRTDUPOBJ  OBJ(ARCHIV) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
/*                                                */
             CALL       A0001R
             MONMSG     MSGID(CPF0000)
/*                                                */
             CALL       A0002R
             MONMSG     MSGID(CPF0000)
/*                                                */
/*          ---DA DIE DATENBASIS IN DEN SÄTZEN AUF EBENE PACKLISTEN---       */
/*          ---VORLIEGEN, MUß EINE ZUSAMMENFASSUNG ERFOLGEN UND    ---       */
/*          ---DIE SÄTZE MÜSSEN KOPIERT WERDEN IN DIE ORIGINALE    ---       */
/*                                                */
             IF         COND(&FWLFIRM *EQ 'L') THEN(DO)
                CPYF       FROMFILE(QTEMP/BAB0706) +
                             TOFILE(FMAPLIB/BAB0706) MBROPT(*ADD)
                CPYF       FROMFILE(QTEMP/BAB0721) +
                             TOFILE(FMAPLIB/BAB0721) MBROPT(*ADD)
                CPYF       FROMFILE(QTEMP/BAB0706E) +
                             TOFILE(FMAPLIB/BAB0706E) MBROPT(*ADD)
                CPYF       FROMFILE(QTEMP/BAB0721E) +
                             TOFILE(FMAPLIB/BAB0721E) MBROPT(*ADD)
                CPYF       FROMFILE(QTEMP/ARCHIV) +
                             TOFILE(FMAPLIB/ARCHIV) MBROPT(*ADD)
             ENDDO
/*                                                */
             IF         COND(&FWLFIRM *EQ 'D') THEN(DO)
                CPYF       FROMFILE(QTEMP/BAB0706) +
                             TOFILE(DMAPLIB/BAB0706) MBROPT(*ADD)
                CPYF       FROMFILE(QTEMP/BAB0721) +
                             TOFILE(DMAPLIB/BAB0721) MBROPT(*ADD)
                CPYF       FROMFILE(QTEMP/BAB0706E) +
                             TOFILE(DMAPLIB/BAB0706E) MBROPT(*ADD)
                CPYF       FROMFILE(QTEMP/BAB0721E) +
                             TOFILE(DMAPLIB/BAB0721E) MBROPT(*ADD)
                CPYF       FROMFILE(QTEMP/ARCHIV) +
                             TOFILE(DMAPLIB/ARCHIV) MBROPT(*ADD)
             ENDDO
/*                                                */
             CPYF       FROMFILE(QTEMP/BAB0706) +
                          TOFILE(FWLGSMLIB/BAB0706) MBROPT(*ADD)
             CPYF       FROMFILE(QTEMP/BAB0721) +
                          TOFILE(FWLGSMLIB/BAB0721) MBROPT(*ADD)
             CPYF       FROMFILE(QTEMP/BAB0706E) +
                          TOFILE(FWLGSMLIB/BAB0706E) MBROPT(*ADD)
             CPYF       FROMFILE(QTEMP/BAB0721E) +
                          TOFILE(FWLGSMLIB/BAB0721E) MBROPT(*ADD)
             CPYF       FROMFILE(QTEMP/ARCHIV) +
                          TOFILE(FWLGSMLIB/ARCHIV) MBROPT(*ADD)
/*          ----------------------------------------------------------       */
ENDE:
             DLTF       FILE(QTEMP/BAB0706)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/BAB0721)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/BAB0706E)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/BAB0721E)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/ARCHIV)
             MONMSG     MSGID(CPF0000)

             DLTOVR     FILE(*ALL) LVL(*)
             MONMSG     MSGID(CPF0000)
             RCLRSC
             ENDPGM
