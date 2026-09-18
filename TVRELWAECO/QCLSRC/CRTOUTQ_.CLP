             CRTOUTQ    OUTQ(QUSRSYS/PRTLAG99) RMTSYS(*INTNETADR) +
                          RMTPRTQ('lpr') AUTOSTRWTR(1) CNNTYPE(*IP) +
                          DESTTYPE(*OTHER) TRANSFORM(*NO) +
                          INTNETADR('172.16.102.180') DESTOPT('XAIX +
                          XAUTOQ')
  /*         ENDWTR     WTR(PRTLAG99)               */
             STRRMTWTR  OUTQ(QUSRSYS/PRTLAG99)
