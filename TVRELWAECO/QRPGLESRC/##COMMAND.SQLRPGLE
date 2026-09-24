     C**************************************************************************
     C*command
     C*CRTDTAARA DTAARA(EINVOICE/USESCH1401) TYPE(*CHAR) LEN(280)
     C*TEXT(INVOICE)
     C*
     C*CHGDTAARA DTAARA(EINVOICE/USESCH1401 (01 250))
     C*VALUE('(''xmlns:xsi="http:
     C*//www.w3.org/2001/XMLSchema-instance"
     C*xmlns:gxsxtd="http://www.gxs.com/sa1 (01 250))
     C*_ext" xmlns="http://www.openapplications.org/oagis/9"
     C*xsi:schemaLocation=MLSchema-instance"
     C*"http://www.openapplications.org/oagis/9 ProcessInvoice.xsd"
     C*releaseID="1"http://www.openapplications.org/oagis/9"
     C*.0"'')')
     C*-------------------------------------------------------------------------

     C     srCOMMAND     BEGSR
     C*
     C                   clear                   xmledition       60
     C                   eval      xmledition  =
     C                             '''/EINVOICE/Out/' +
     C                             %subst(keys:01:doclength)  + '.XML'')'
     c                   eval      %subst(#protokoll: 120: 8)='        '
      /free
       MONITOR;
       Wrk.var1 =
           'EXTXMLDTA TAGNAM(INV140402A)' +
           ' PATH(' + %trim(xmledition)   +
           ' MASTTAG(ProcessInvoice)'     +
           ' RECLVLTAG(*NONE)'            +
           ' USESCH' + USESCH1401         +
           ' XMLENC(''UTF-8'')'           +
           ' DECFMT(''.'')';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
         eval %subst(#protokoll: 120: 8)='cmderror';
       endmon;
      /End-Free

     C     ##COMMAND     ENDSR
     c*
