     D EBC             C                   CONST(X'000102030405060708-
     D                                     09101112131415161718192021-
     D                                     22232425262728293031323334-
     D                                     35363738394041424344454647-
     D                                     48495051525354555657585960-
     D                                     61626364656667686970717273-
     D                                     74757677787980818283848586-
     D                                     87888990919293949596979899-
     D                                     0A0B0C0D0E0F1A1B1C1D1E1F2A-
     D                                     2B2C2D2E2F3A3B3C3D3E3F4A4B-
     D                                     4C4D4E4F5A5B5C5D5E5F6A6B6C-
     D                                     6D6E6F7A7B7C7D7E7F8A8B8C8D-
     D                                     8F9A9B9C9D9E9FA0A1A2A3A4A5-
     D                                     A6A7A8A9AAABACADAEAFB0B1B2-
     D                                     B3B4B5B6B7B8B9BABBBCBDBEBF-
     D                                     C0C1C2C3C4C5C6C7C8C9CACBCC-
     D                                     CDCECFD0D1D2D3D4D5D6D7D8D9-
     D                                     DADBDCDDDEDFE0E1E2E3E4E5E6-
     D                                     E7E8E9EAEBECEDEFF0F1F2F3F4-
     D                                     F5F6F7F8F9FAFBFCFDFEFF')
     D ASC             C                   CONST(X'202020202020202020-
     D                                     20202020202020202020202020-
     D                                     20202020202020202020202020-
     D                                     20202020202020202020202020-
     D                                     2020262020202020202020202D-
     D                                     2F202020202020202020202020-
     D                                     20202020206020616263646566-
     D                                     676869206A6B6C6D6E6F707172-
     D                                     20202020202020202020202020-
     D                                     20202020202020202020208E2E-
     D                                     3C282B5D9A242A293B5E942C25-
     D                                     5F3E3F3A2340273D2220202020-
     D                                     2020202020202020E173747576-
     D                                     7778797A202020202020202020-
     D                                     20202020202020202020202020-
     D                                     84414243444546474849202020-
     D                                     202020814A4B4C4D4E4F505152-
     D                                     20202020202099205354555657-
     D                                     58595A20202020203031323334-
     D                                     3536373839202020202020')
     D EB              C                   CONST(X'40')
     D AS              C                   CONST(X'20')
     D chrc            S              1    DIM(1024)
     C     *ENTRY        PLIST
     C                   PARM                    CHRFLD         1024
     C                   PARM                    UMWMOD            1
     C     UMWMOD        IFEQ      *BLANK
     C                   MOVEL     'A'           UMWMOD
     C                   END
     C     UMWMOD        IFNE      'A'
     C     UMWMOD        ANDNE     'E'
     C                   MOVEL     'A'           UMWMOD
     C                   END
     C     UMWMOD        IFEQ      'A'
     C     EBC:ASC       XLATE     CHRFLD        CHRFLD
     C                   ELSE
     C     ASC:EBC       XLATE     CHRFLD        CHRFLD
     C*    AS:EB         XLATE     CHRFLD        CHRFLD
     C                   exsr      #cvt00
     C                   END
     C                   MOVEL     '1'           *INLR
     c     #cvt00        begsr
     c                   z-add     0             n                 4 0
     c                   movea     CHRFLD        chrc
     c                   movel     ' '           chrfl1            1
     c                   do        1024          n
     c                   movea     chrc(n)       chrfl1
     c     chrfl1        iflt      X'40'
     c                   move      X'40'         chrfl1
     c                   movea     chrfl1        chrc(n)
     c                   endif
     c                   movea     chrc          CHRFLD
     c                   enddo
     c                   endsr
