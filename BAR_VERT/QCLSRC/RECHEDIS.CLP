             PGM
/*  ********************************************************************** */
/*  TREND RECHNUNGEN AN DIE STDDAT ÜBERGEBEN                               */
/*  STEFAN BARENKAMP 14.10.2011                                            */
/*  ********************************************************************** */
/*  BEISPIEL                                                               */
/*                                                                         */
/*           CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +       */
/*                        '          ' '006016')                           */
/*           MONMSG     MSGID(CPF0000)                                     */
/*  AUFRUF EINZELKUNDE                                                     */
/*                                                                         */
/*           CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +       */
/*                        '002377    ' '      ')                           */
/*           MONMSG     MSGID(CPF0000)                                     */
/*                                                                         */
/* " WKFIRM -->  DIE TREND FIRMA, FÜR DIE DAS PROGRAMM AKTIVIERT WIRD      */
/* " WKEDIF --> DAS EDI FORMAT                                             */
/* " FALLS LEER WIRD AUF DIE SYTK MIT CODE EDIF ZUGEGRIFFEN UND DER DEFAULT*/
/* GEHOLT  --> DFT = EA                                                    */
/* HINTER DEN EINZELNEN FORMATEN STEHT JEWEILS FOLGENDES EDI FORMAT UND    */
/* FOLGENDES PROGRAMM.                                                     */
/* EA         EANCOM  --> TRED74                                           */
/* EE         EDIFACT96A -->   TRED74 ODER TRED73                          */
/* HD         HDX  --> ???                                                 */
/* VD         VDA --> TRED72                                               */
/* XL         XML  --> ???                                                 */
/* " WKZRKD --> NUMMER DES ZENTRALREGULIERERS                              */
/* " WKRAKD --> KUNDENNUMMER RECHNUNG                                      */
/*                                                                         */
/* KAES                                                                    */
/*CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +                  */
/*             '          ' '401367')                                      */
/*                                                                         */
/* UPDATE STDDAT SET SCDDAT=''                                             */
/*                      WHERE SNDREC='SND' AND LINNUM=0 AND MAIKEY =       */
/* '357723'                                                                */
/* 1 ZEILEN IN STDDAT IN EDIFACT AKTUALISIERT.                             */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  *********************************************************************  */
             DCL        VAR(&MD) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&ERROR1) TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR2) TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&ERROR3) TYPE(*CHAR) LEN(01) VALUE('0')
             DCL        VAR(&OUTFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFKT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBRCURRCD) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBRCURRCD2) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&RECHEDI) TYPE(*CHAR) LEN(1)

             DCL        VAR(&D) TYPE(*CHAR) LEN(8)
             DCL        VAR(&ABDATUM) TYPE(*CHAR) LEN(8)
             DCL        VAR(&QTIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&QDATETIME) TYPE(*CHAR) LEN(20)

             DCL        VAR(&PGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(06)
             DCL        VAR(&TXT) TYPE(*CHAR) LEN(50)

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)


/*          PROTOKOLLIERUNG ---                                           */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PGM) VALUE('RECHEDI ')
             RTVMBRD    FILE(BAR_VERT/QCLSRC) MBR(&PGM) TEXT(&TXT)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('START')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                          'JOB_RUN ' 'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */
             RTVDTAARA  DTAARA(BAR_VERT/RECHEDI *ALL) RTNVAR(&RECHEDI)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDPGM))
             CHGDTAARA  DTAARA(BAR_VERT/RECHEDI *ALL) VALUE('0')
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDPGM))

/** METRO WAR IN SCHEDULER UNTER ###BARTRR1           ****************/
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          '100002 ' ' ')
             MONMSG     MSGID(CPF0000)
/** METRO WAR IN SCHEDULER UNTER ###BARTRR2           ****************/
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '006016')
             MONMSG     MSGID(CPF0000)

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '013862')
             MONMSG     MSGID(CPF0000)

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '002377')
             MONMSG     MSGID(CPF0000)

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '007006')
             MONMSG     MSGID(CPF0000)

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '001515')
             MONMSG     MSGID(CPF0000)

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '003979')
             MONMSG     MSGID(CPF0000)



             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '041997')
             MONMSG     MSGID(CPF0000)

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '024476')
             MONMSG     MSGID(CPF0000)

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '004302')
             MONMSG     MSGID(CPF0000)

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '001975')
             MONMSG     MSGID(CPF0000)



             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '004289')
             MONMSG     MSGID(CPF0000)

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EE' +
                          ' ' '011016')
             MONMSG     MSGID(CPF0000)

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '091613')
             MONMSG     MSGID(CPF0000)

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '016001')
             MONMSG     MSGID(CPF0000)

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EE' +
                          '011016 ' ' ')
             MONMSG     MSGID(CPF0000)

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          '003211 ' ' ')
             MONMSG     MSGID(CPF0000)

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '059078')
             MONMSG     MSGID(CPF0000)

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '109999')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '003112')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '015177')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '088505')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '091613')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '006123')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '001248')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '091610')
             MONMSG     MSGID(CPF0000)

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '091611')
             MONMSG     MSGID(CPF0000)

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '003113')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '003114')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '022691')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '175000')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '003115')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '003116')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '003117')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '003118')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '040586')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '020160')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '009202')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '001075')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '040308')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '003211')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '005427')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '005991')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '023971')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '198257')

/** EDI DATEN ÜBERGABE MIT EINER ZR REGULIERER NUMMER ****************/
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          '009788 ' ' ')

/** EDI DATEN ÜBERGABE MIT EINER ZR REGULIERER OBI    ****************/
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          '018304 ' ' ')

/** MEDIA MARKT ZENTRALREGULIERER  ***********************************/
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          '198454 ' ' ')


/** WESSELS MULLER ZENTRALREGULIERER  ********************************/
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          '091522 ' ' ')

/** CARAT GMBH ZR                                    ****************/
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          '045011 ' ' ')

/** AKTIVBANK AG ZR               ***********************************/
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          '097293 ' ' ')


/** AKTIVBANK AG ZR               ***********************************/
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          '403116 ' ' ')

/**          CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
             MONMSG     MSGID(CPF0000) */

/*          ACHTUNG AKTUELL PROBLEME BEI CALL ÜBER ZENTRALREGULIERER BEI  */
/*          198454 BATCH LÄUFT ANDERS ALS DIALOG      02.07.2025          */
             DSPJOBLOG  OUTPUT(*OUTFILE) +
                          OUTFILE(TVRELWAECO/$INTERFACE) +
                          OUTMBR(*FIRST *ADD)
             MONMSG     MSGID(CPF0000)


             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '091620')
             MONMSG     MSGID(CPF0000)

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '091621')
             MONMSG     MSGID(CPF0000)

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '091610')
             MONMSG     MSGID(CPF0000)

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401367')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '224191')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '085938')


             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '040573')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '040593')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '040329')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '085932')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '040582')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '072043')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '079540')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '085901')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '085908')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '089963')



             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '040581')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '224185')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '224186')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '489440')
/*    CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +  */
/*                 '          ' '054288')                      */
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '400383')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '400384')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '400385')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '400386')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '400388')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401305')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401575')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401576')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401577')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401578')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401579')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401580')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401582')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401583')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401584')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401587')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401589')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401590')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401591')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401592')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401593')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401595')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401596')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401597')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401598')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401599')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401600')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401603')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401605')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401606')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401607')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401609')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401610')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401612')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401615')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '401617')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '402114')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '489441')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '299319')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '299318')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '049206')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '040306')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '192624')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '400174')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '020385')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '192625')
/**   VOLVO TRUCK                                             **/
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '420264')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '252377')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '251377')

/**   TRADEINN                                                **/
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '500415')
/**   COOLBLUE                                                **/
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '602494')

/**   MEDIA MARKT E-BUSINESS INGOLS                           **/
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '196010')

/**   HOGAST                                                  **/
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '338504')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '338503')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '338506')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '338492')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '338492')

/**   MEDIA MARKT                                             **/
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '084079')


             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '024513')

/**   BOL                                                     **/
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '604075')


/**   HOGAST                                                  **/
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '338504')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '338503')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '338506')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '338492')

/**   GALAXUS                                                 **/
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '316499')

             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '220840')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '220860')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '220870')
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '001316')
/**   VOLVO PLANT 39971 KN: 252377                            **/
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '252377')
/**   DAF  601981 RE: 600238                                  **/
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '600238')

/*     CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' + */
/*                  '          ' '198690')                     */
/*     DA SIE ALLE ÜBER 054288 LAUFEN TEST MIT ANJA            */
             CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +
                          ' ' '054288')

             CHGDTAARA  DTAARA(BAR_VERT/RECHEDI *ALL) VALUE('1')
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDPGM))

/*     ADDLIBLE   LIB(TVRELWAECO) POSITION(*LAST)              */
/*     MONMSG     MSGID(CPF0000)                               */
/*     ADDLIBLE   LIB(GANG) POSITION(*LAST)                    */
/*     MONMSG     MSGID(CPF0000)                               */
/*                                                             */
/*     CALL PGM(TVRELWAECO/AKTIVBANKR)                         */
/*     MONMSG     MSGID(CPF0000)                               */



/*  AUFRUF ALLE KD FA 20                                                   */
/*           CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '20' 'EA' + */
/*                        '          ' '      ')              */
/*  AUFRUF ALLE KD FA 01                                                   */

/*           CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA' +       */
/*                        '          ' '      ')                           */

             ADDLIBLE   LIB(TVRELWAECO) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(GANG) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

/*          PROTOKOLLIERUNG ---                                           */
             CHGVAR     VAR(&MD) VALUE(' ')
             CHGVAR     VAR(%SST(&MD 01 10)) VALUE(&PGM)
             CHGVAR     VAR(%SST(&MD 11 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&MD 22 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&MD 33 06)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&MD 40 06)) VALUE('ENDE ')
             CHGVAR     VAR(%SST(&MD 46 50)) VALUE(&TXT)
             CALL       PGM(DUMMY512) PARM(&MD '#DC0002' ' ' ' ' +
                          'JOB_RUN ' 'TVRELWAECO' '*ADD')
             MONMSG     MSGID(CPF0000)
/*          PROTOKOLLIERUNG ---                                           */

             IF         COND(&ERROR1 = '0') THEN(DO)
             RMVLIBLE   LIB(TVRELWAECO)
             MONMSG     MSGID(CPF0000)
             ENDDO

             IF         COND(&ERROR2 = '0') THEN(DO)
             RMVLIBLE   LIB(GANG)
             MONMSG     MSGID(CPF0000)
             ENDDO













/*  ******** PROTOKOLL DER RECHUNGSSÄTZE IN DER STDDAT ******************  */
/*           RUNQRY     QRY(BAR_VERT/EDIRECH)                              */



/*           MONMSG     MSGID(CPF0000)                                     */



ENDPGM:





             ENDPGM
