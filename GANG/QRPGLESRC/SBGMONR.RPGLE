     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*                                                          *
     F************************************************************
     F*  PROGRAMMFUNKTION:                                       *
     F*                                                          *
     F*  OVRDBF FILE(SBGNMON) TOFILE(SBGN.MON) OVRSCOPE(*JOB)    *
     F*  M.Gang 18.09.2009                                       *
     F*  Änderungsprotokoll:                                     *
     F*  ...                                                     *
     F*  ...                                                     *
     F************************************************************

     fSBGNmon   ip   e             disk
     F                                     RENAME(SBGN.MON:LOG01R)
     F                                     INFDS(DSF1)
     ff1        if   e             disk
     F                                     RENAME(f1:satzF1)
     ff2        if   e             disk
     F                                     RENAME(f2:satzF2)
     ff3        if   e             disk
     F                                     RENAME(f3:satzF3)
     ff4        if   e             disk
     F                                     RENAME(f4:satzF4)
     ff5        if   e             disk
     F                                     RENAME(f5:satzF5)
     ff6        if   e             disk
     F                                     RENAME(f6:satzF6)
     fHELLADRPF if a e             disk

     D*-------------------------------------------------------------------------
     D DSF1            DS
     D  F1STS                 11     15  0
     D  F1RRN                397    400B 0

     DDate             S               D   DATFMT(*EUR)
     DPLZHelp          S              5A

     D*-------------------------------------------------------------------------
     D*---key Firma, Kunden#, Auftrag, Auftragsart, SatzArt, Pos#, PosArt-------
     D KEY             DS
     D  FAK1010                1      2S 0
     D  FAK1020                3      7S 0
     D  FAK1030                8     13S 0
     D  FAK1040               14     15S 0
     D  FAK1050               16     17S 0
     D  FAK1060               18     20S 0
     D  FAK1070               21     21A
     D
     I*-------------------------------------------------------------------------
     ILOG01R
     I              SBGN.MON                    §x
     I
     C**************************************************************************
     C*VORLAUFKARTEN ÜBERGABEBEREICHE                                  *********
     C**************************************************************************
     c
     C     *ENTRY        PLIST
     C                   PARM                    ###1010
     C                   PARM                    ###1020
     C                   PARM                    ###1030
     C                   PARM                    ###1040
     C                   PARM                    ###1050
     C                   PARM                    ###1060
     C                   PARM                    ###1070
     c
     C     *LIKE         DEFINE    FAK1010       ###1010
     C     *LIKE         DEFINE    FAK1020       ###1020
     C     *LIKE         DEFINE    FAK1030       ###1030
     C     *LIKE         DEFINE    FAK1040       ###1040
     C     *LIKE         DEFINE    FAK1050       ###1050
     C     *LIKE         DEFINE    FAK1060       ###1060
     C     *LIKE         DEFINE    FAK1070       ###1070
     C
     c                   exsr      sr4000

     c                   write     HELLADRR


     c************************************************************
     c* Prüfung auf Satz
     c************************************************************

     C     sr4000        begsr

     C                   select
     C                   when      ###1010 =  FAK1010 and
     C                             ###1020 =  FAK1020 and
     C                             ###1030 =  FAK1030 and
     C                             ###1040 =  FAK1040 and
     C                             ###1050 =  FAK1050 and
     C                             ###1060 =  FAK1060 and
     C                             ###1070 =  FAK1070
     C                   exsr      sr4001
     C                   when      ###1010 =  FAK1010 and
     C                             ###1020 =  FAK1020 and
     C                             ###1030 =  FAK1030 and
     C                             ###1040 =  FAK1040 and
     C                             ###1050 =  FAK1050 and
     C                             ###1060 =  FAK1060
     C                   exsr      sr4001
     C                   when      ###1010 =  FAK1010 and
     C                             ###1020 =  FAK1020 and
     C                             ###1030 =  FAK1030 and
     C                             ###1040 =  FAK1040 and
     C                             ###1050 =  FAK1050
     C                   exsr      sr4001
     C                   when      ###1010 =  FAK1010 and
     C                             ###1020 =  FAK1020 and
     C                             ###1030 =  FAK1030 and
     C                             ###1040 =  FAK1040
     C                   exsr      sr4001
     C                   when      ###1010 =  FAK1010 and
     C                             ###1020 =  FAK1020 and
     C                             ###1030 =  FAK1030
     C                   exsr      sr4001
     C                   when      ###1010 =  FAK1010 and
     C                             ###1020 =  FAK1020
     C                   exsr      sr4001
     C                   when      ###1010 =  FAK1010
     C                   exsr      sr4001
     C                   other
     C                   endsl
     C
     C     ##4000        endsr

     c************************************************************
     c* Prüfung auf Satzart sr4001
     c************************************************************

     C     sr4001        begsr

     C                   select
     C                   when      FAK1050 =  01
     C                   exsr      sr_s1
     C                   when      FAK1050 =  02
     C                   exsr      sr_s2
     C                   when      FAK1050 =  03
     C                   exsr      sr_s3
     C                   when      FAK1050 =  10  and
     C                             FAK1070 =  'N'
     C                   exsr      sr_s5
     C                   when      FAK1050 =  10  and
     C                             FAK1070 =  'T'
     C                   exsr      sr_s6
     C                   other
     C                   endsl
     C
     C     ##4001        endsr

     c************************************************************
     c* Satz s1
     c************************************************************

     C     sr_s1         begsr

     C
     C     ##_s1         endsr

     c************************************************************
     c* Satz s2
     c************************************************************

     C     sr_s2         begsr

     C
     C     ##_s2         endsr

     c************************************************************
     c* Satz s3
     c************************************************************

     C     sr_s3         begsr

     C
     C     ##_s3         endsr

     c************************************************************
     c* Satz s4
     c************************************************************

     C     sr_s4         begsr

     C
     C     ##_s4         endsr

     c************************************************************
     c* Satz s5
     c************************************************************

     C     sr_s5         begsr

     C
     C     ##_s5         endsr

     c************************************************************
     c* Satz s6
     c************************************************************

     C     sr_s6         begsr

     C
     C     ##_s6         endsr

     C* --------------------------------------------------


     C     *inzsr        BEGSR
     C*                  setoff                                       30
     C*  30              read      f1
     C                   TIME                    Date
     c*                  z-add     1             firma
     C                   ENDSR

