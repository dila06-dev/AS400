             PGM
             ADDLIBLE UEBERNAHME
             MONMSG   MSGID(CPF0000)
             OVRDBF     FILE(VPL0006W) TOFILE(SUBR36/#VPL0006) +
                          MBR(*FIRST)
             MONMSG   MSGID(CPF0000)
             OVRDBF     FILE(VPL0007) TOFILE(SUBR36/#VPL0007) +
                          MBR(*FIRST)
             MONMSG   MSGID(CPF0000)
             OVRDBF     FILE(VPL0008) TOFILE(SUBR36/#VPL0008) +
                          MBR(*FIRST)
             MONMSG   MSGID(CPF0000)
             OVRDBF     FILE(VPL0009) TOFILE(SUBR36/#VPL0009) +
                          MBR(*FIRST)
             MONMSG   MSGID(CPF0000)
             CRTBNDRPG  PGM(UEBERNAHME/VPLDRUCK) +
                          SRCFILE(UEBERNAHME/QRPGLESRC)
             MONMSG   MSGID(CPF0000)
             DLTOVR     FILE(*ALL)
             MONMSG   MSGID(CPF0000)
             ENDPGM
