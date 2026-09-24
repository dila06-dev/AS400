PGM
/*  ********************************************************************** */
/*  TREND RECHNUNGEN AN DIE STDDAT ÜBERGEBEN                               */
/*  STEFAN BARENKAMP 14.10.2011                                            */
/*  ********************************************************************** */
/*  ******** PROTOKOLL DER RECHUNGSSÄTZE IN DER STDDAT ******************  */

             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&ERROR1)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR3)     TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&RECHEDI)    TYPE(*CHAR) LEN(1)

             DCL        VAR(&D)         TYPE(*CHAR) LEN(8)
             DCL        VAR(&ABDATUM)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&QTIME)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&QDATETIME) TYPE(*CHAR) LEN(20)

             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)     TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&TXT2)    TYPE(*CHAR) LEN(50)

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('RECHEDI2  ')
             RTVMBRD    FILE(BAR_VERT/QCLSRC) MBR(&PGM) TEXT(&TXT)
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
             RUNQRY     QRY(BAR_VERT/EDIRECH)
             MONMSG     MSGID(CPF0000)

/*  ******** PROTOKOLL DER RECHUNGSSÄTZE MARKANT       ******************  */
             RUNQRY     QRY(BAR_VERT/KDZENTRRE)
             MONMSG     MSGID(CPF0000)
             RUNQRY     QRY(BAR_VERT/KDZENTR2E)
             MONMSG     MSGID(CPF0000)

/*           CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '20' 'EA') */

/* JOHNDEERE RE FÜR HDX BEREITSTELLEN         12.02/2019  */
/* MONMSG UND BERECHTIGUNGEN EINGBAUT GANG    18.10/2022  */

             RUNQRY     QRY(BAR_EDI/JOHNDEERE1)
             CVTDBF     OBJ('HDX/SND/JOHNDEERERE.CSV') +
                          DBFILE(BAR_EDI/JOHNDEERE1) DBOUTFMT(*CSV) +
                          DBFLDDSC(*YES) CSVSEPCHR(';')
             MONMSG     MSGID(CPF0000)

             CHGAUT OBJ('/HDX/SND/JOHNDEERERE.CSV') +
             USER(HDXDATA) DTAAUT(*RWX)        +
             OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)

             MONMSG     MSGID(CPF0000)
             RUNQRY     QRY(BAR_EDI/MAN1)
             CVTDBF     OBJ('HDX/SND/MAN.CSV') DBFILE(BAR_EDI/MAN1) +
                          DBOUTFMT(*CSV) DBFLDDSC(*YES) CSVSEPCHR(';')
             MONMSG     MSGID(CPF0000)

             CHGAUT OBJ('/HDX/SND/MAN.CSV')    +
             USER(HDXDATA) DTAAUT(*RWX)        +
             OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)
             MONMSG     MSGID(CPF0000)




ENDPGM
/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(&MD) +
                          VALUE('                                     -
                                                           ')
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

