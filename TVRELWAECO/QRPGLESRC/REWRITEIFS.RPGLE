     HDEBUG
     HOPTION(*NODEBUGIO: *SRCSTMT)
     HINDENT(' |')
     HDFTACTGRP(*NO) ACTGRP(*NEW) BNDDIR('QC2LE')
   1  ***********************************
   2  *    (_) / /| |/_/  |/  / /       *
   3  *   / /_  _/>  </ /|_/ / /__      *
   4  *  /_/ /_//_/|_/_/  /_/____/      *
   5  ***********************************
   6  ************************************************************************
   7  *    _________  _______  _____  _______                                *
   8  *   / ___/ __ \/ __/ _ \/  _/ |/ / ___/                                *
   9  *  / (_ / /_/ / _// , _// //    / (_ /                                 *
  10  *  \___/\____/___/_/|_/___/_/|_/\___/                                  *
  11  *                                                                      *
  12  *                                                                      *
  13  *    (_) __/__ ____(_)__ ___   / __/__  / /_ __/ /_(_)__  ___  ___     *
  14  *   / /\ \/ -_) __/ / -_|_-<  _\ \/ _ \/ / // / __/ / _ \/ _ \(_-<     *
  15  *  /_/___/\__/_/ /_/\__/___/ /___/\___/_/\_,_/\__/_/\___/_//_/___/     *
  16  *                                                                      *
  17  *      GOERING iSeries Solutions +  http://www.goering.de              *
  18  *                                                                      *
  18  * REWRITEIFS IFSIN('/EINVOICE/Out/SE411 _DE411 2016110526.XML')        *
  18  *            IFSOUT('/EINVOICE/Out/SE411 _DE411 819.XML')              *
  18  *                                                                      *
  18  * Eval      FileDescrO=open(FileNamPO:'w, codepage=923')               *
  18  * REWRITEIFS IFSIN('/EINVOICE/Out/SE411 _DE411 2016110526.XML')        *
  18  *            IFSOUT('/EINVOICE/Out/SE411 _DE411 923.XML')              *
  18  *                                                                      *
  18  * REWRITEIFS IFSIN('/EINVOICE/Out/HK411 _US111A_161546.XML')           *
  18  *            IFSOUT('/EINVOICE/Out/HK411 _US111A819.XML')              *
  18  *                                                                      *
  18  * Eval      FileDescrO=open(FileNamPO:'w, codepage=923')               *
  18  * REWRITEIFS IFSIN('/EINVOICE/Out/HK411 _US111A_161546.XML')           *
  18  *            IFSOUT('/EINVOICE/Out/HK411 _US111A923.XML')              *
      **************************************************************************
      *
     D BIG             PR
     D  Text                        512a
      *---------------------------------------------------------------
      * Sample to Read from IFS
      *---------------------------------------------------------------
     D*
     DCmdstring        S            512
     DCmdlength        S             15  5
     D stream          S            132A
     D LF              S              1                                         LF
     DE_FIRM           S              1A                                        Eing. FIRM
     DE_WKNR           S              3A                                        Eing. WKNR
     DE_LMID           S             25A                                        Eing. LMID
     DE_OUTQ           S             10A                                        Eing. OUTQ
     DE_TEMP           S            512A                                        Template
     DMESSAGE          S             75A                                        Fehlernachricht
     DQ                S              1    inz('''')                            Quotation
      *
     Doutput           S             50A
      *
      * for IFS-Access
      * ==============
      *
     D FileNamI        S            512A
     D FileNamDI       S            512A
     D FileNamPI       S               *   INZ(%ADDR(FileNamI))
     D FileNamPDI      S               *   INZ(%ADDR(FileNamDI))
     D FileDescrI      S               *
     D FileDescrDI     S             10I 0
      *
     D FileNamO        S            512A
     D FileNamDO       S            512A
     D FileNamPO       S               *   INZ(%ADDR(FileNamO))
     D FileNamPDO      S               *   INZ(%ADDR(FileNamDO))
     D FileDescrO      S               *
     D FileDescrDO     S             10I 0
      *
     D SEEK_SET        S             10I 0 INZ(0)
      *
     D O_CREAT         S             10I 0 INZ(8)
     D O_WRONLY        S             10I 0 INZ(2)
     D O_RDWR          S             10I 0 INZ(4)
     D O_TEXT          S             10I 0 INZ(16777216)
     D O_CODEPAGE      S             10I 0 INZ(8388608)
     D O_APPEND        S             10I 0 INZ(256)
      *
     D CharZero        S              1A   INZ(*ALLX'00')
     D Omode           S             10U 0 INZ(511)
     D cp              S             10U 0 INZ(819)
     D*cp              S             10U 0 INZ(819)
      *
     D RC              S             10I 0
     D Bufr            S           2000A
     D RCCR            S             10I 0
     D lenendtag       S             10U 0
     D cutendtag       S            100A
     D slashfound      S              5U 0
     d lastslash       S              5U 0
     D restendtag      S            100A
      *
ag015D#CR              S              2    INZ(x'25')
ag015D#CRLEN           S              1  0 INZ(1)
ag015D#CRLF            S              2    INZ(x'0D25')
ag015D#CRFLAG          S              1    INZ(' ')
     D RC#             S             10I 0
     D Codepage        S             10I 0
     D Bufr#           S           2000A
      *
     D xmlfound        S              5u 0
      *
      * IFS Error
     Dperror           PR            10I 0 EXTPROC('perror')
     Dconst                            *   VALUE
      * IFS File Open
     Dopen             Pr              *   ExtProc( '_C_IFS_fopen' )
     D                                 *   Value Options( *String )
     D                                 *   Value Options( *String )
      * IFS File Read
     Dread             PR            10I 0 EXTPROC('read')
     D                               10I 0 VALUE
     D                                 *   Value
     D                               10U 0 VALUE
      * Zeilenweises lesen
     Dfgets            Pr              *   ExtProc( '_C_IFS_fgets' )
     D                                 *   Value
     D                               10i 0 Value
     D                                 *   Value
      *
     Dfputs            Pr            10i 0 ExtProc( '_C_IFS_fputs' )
     D                                 *   Value  Options( *String )
     D                                 *   Value
      *
      *
     Dfwrite           Pr            10i 0 ExtProc( '_C_IFS_fwrite' )
     D                                 *   Value  Options( *String )
     D                                 *   Value
      *
      * IFS File Write
     Dwrite            PR            10I 0 EXTPROC('write')
     D                               10I 0 VALUE
     D                                 *   Value
     D                               10U 0 VALUE
     D
      * IFS File Seek
     Dlseek            PR            10I 0 EXTPROC('lseek')
     D                               10I 0 VALUE
     D                               10I 0 VALUE
     D                               10U 0 VALUE
     D
      * IFS File Close
     Dclose            Pr            10i 0 ExtProc( '_C_IFS_fclose' )
     D                                 *   Value
      * Programm Parameter
ag015DiFile            S            512a
ag015DoFile            S            512a
      *
      *---------------------------------------------------------------
      *    Instructions
      *---------------------------------------------------------------
      *
     C     *ENTRY        PLIST
     C                   PARM                    iFile                          Input  (IFS-File)
     C                   PARM                    oFile                          Output (IFS-File)
      *
     c                   callp     big(iFile)
     c                   eval      xmlfound = %scan('.XML':iFile)
     c                   if        xmlfound > 0
     c                   eval      iFile = %subst(iFile:1:xmlfound+4)
     c                   endif
      *
     c                   callp     big(oFile)
     c                   eval      xmlfound = %scan('.XML':oFile)
     c                   if        xmlfound > 0
     c                   eval      oFile = %subst(oFile:1:xmlfound+4)
     c                   endif
      *
     C                   EVAL      LF = x'25'                                   Zeilenabschluss
      *
     C                   exsr      openin
     C                   exsr      openout
      *
     C                   Eval      Bufr   = *blanks
      *
      * Read the next bytes of Characters into the buffer
      *
     C                   Dow       fgets( %Addr( Bufr )
     C                                      : %Size( Bufr )
     C                                      : FileDescrI
     C                                      ) <> *Null
     c*   UPDATE  GXSSCAN = ''%<PROCESS> />%''       */
     c                   if        %subst(bufr:1:19)='<Process></Process>'
     c                   Eval      Bufr   = *blanks
     c                   eval      bufr      ='<Process />'
     c                   endif
     C*
     c*   UPDATE  GXSSCAN = ''<gxsxtd:Description></gxsxtd:Description>
     c                   if        %subst(bufr:1:20)='<gxsxtd:Description>'
     c                   Eval      Bufr   = *blanks
     c                   eval      bufr   =
     c                             '<gxsxtd:Description></gxsxtd:Description>'
     c                   endif
     C*
     c*   UPDATE  GXSSCAN = ''<Charge ChargeType     */
     c                   if        %subst(bufr:1:18)='*Charge ChargeType'
     c                   Eval      Bufr#  = Bufr
     c                   Eval      Bufr   = *blanks
     c                   eval      bufr      ='<Charge>'
     C                   Eval      rc         =  fputs(%trim(Bufr) + LF
     C                                                : FileDescrO
     C                                                )
     C                   eval      bufr=*blanks
     C                   clear                   string#         112
     C                   eval      string#  = %subst(bufr#:9:25)
     C                   eval      bufr      ='<' +
     C                                          %trimr(%subst(bufr#:9:25))
     c                   endif
     C*
     c*   UPDATE  GXSSCAN = ''<ApplicationArea>''    */
     c                   if        %subst(bufr:1:23) ='<ProcessInvoice xmlns:x'
     c                   Eval      Bufr#  = Bufr
     c                   Eval      Bufr   = *blanks
     c                   eval      %subst(bufr:1:255)=%subst(bufr#:1:255)
     C                   Eval      rc         =  fputs(%trim(Bufr) + LF
     C                                                : FileDescrO
     C                                                )
     C                   eval      bufr=*blanks
     c                   eval      bufr      ='<ApplicationArea>'
     C********no******   Eval      rc         =  fwrite(%trim(Bufr) + LF
     C********no******                                : FileDescrO
     C********no******                                )
     c                   endif
     C*
     C*
     C*
     C                   Eval      rc         =  fputs(%trim(Bufr) + LF
     C                                                : FileDescrO
     C                                                )
     C                   eval      bufr=*blanks
     C
     C                   Enddo
      *
      * Close the Original Files
     C                   Eval      RC = close(FileDescrI)
     C                   Eval      RC = close(FileDescrO)
     C*
     C*---------------------------------------------------------------
     C*    ENDE
     C*---------------------------------------------------------------
     C*
     C     END           TAG
     C                   SETON                                        LR
      *
 $SJ  **************************************************************************
     C     openin        BEGSR
 $SJ  **************************************************************************
      *
     C                   Eval      FilenamI = %TRIM(iFile)
      *
     C                   Eval      FileNamI = %TRIM(FileNamI)+CharZero
      *
     C                   Eval      FileDescrI=open(FileNamPI:'r')
     C                   If        FileDescrI = *NULL
     C                   Eval      RC = perror(FileNamPI)
     C                   Return
     C                   EndIf
      *
     C                   Endsr
      *
 $SJ  **************************************************************************
     C     openout       BEGSR
 $SJ  **************************************************************************
      *
     C                   Eval      FilenamO = %TRIM(oFile)
      *
     C                   Eval      FileNamO = %TRIM(FileNamO)+CharZero
      *
     C                   Eval      FileDescrO=open(FileNamPO:'w, codepage=819')
     C                   If        FileDescrO = *NULL
     C                   Eval      RC = perror(FileNamPO)
     C                   Return
     C                   EndIf
     C                   Eval      RC = close(FileDescrO)
      *
     C                   Eval      FileDescrO=open(FileNamPO:'w')
     C                   If        FileDescrO = *NULL
     C                   Eval      RC = perror(FileNamPO)
     C                   Return
     C                   EndIf
      *
     C                   Endsr
      *
      *http://www-01.ibm.com/software/globalization/ccsid/ccsid_registered.html*
     P BIG             B
      **************************************************************************
      *  Convert to Big Letters
      **************************************************************************
     D BIG             PI
     D  Text                        512a
      *
     Ducase            C                   CONST('ABCDEFGHIJKLMNOPQRST-
     D                                     UVWXYZÄÖÜ')

     Dlcase            C                   CONST('abcdefghijklmnopqrst-
     D                                     uvwxyzäöü')
      *
     C     lcase:ucase   xlate     text          TEXT
      *
     c                   return
      *
     P                 E
