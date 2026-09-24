PGM
             RUNQRY     QRY(BAR_FRA/LAGERB_NAV)
             CPYTOIMPF  FROMFILE(BAR_FRA/WINARTNAV) +
                          TOSTMF('www/winartnav.txt') +
                          MBROPT(*REPLACE) STMFCODPAG(819) +
                          RCDDLM(*CRLF) DTAFMT(*FIXED)
ENDPGM
