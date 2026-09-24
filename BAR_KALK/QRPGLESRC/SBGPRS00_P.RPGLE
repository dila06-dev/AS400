     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*                                                          *
     F************************************************************
     F* PROGRAMMFUNKTION:                                        *
/*   F*Verbuchung der Preise in SBGPRS00                        *            */
/*   F*Hinweis: 72xxx als lieferant ist ICN                     *            */
/*   F*         73xxx als lieferant ist ICS                     *            */
/*   F*         70xxx als lieferant ist EXN                     *            */
/*   F*         74xxx als lieferant ist EXS                     *            */
/*   F*         75xxx als lieferant ist OEM                     *            */
     F************************************************************

     fe_preis   up   e             disk
     f*SBGPRS00g uf a e           k disk
     fSBGPRS00  uf a e           k disk

     I*-------------------------------------------------------------------------
     c*  Schlüsselliste für SBGPRS00
     c     artkey        klist
     c                   kfld                    #PRS010
     c                   kfld                    #PRS020
     c                   kfld                    #PRS030
     c                   kfld                    #PRS040

     C*-------------------------------------------------------------------------

     C     *ENTRY        PLIST
     C                   PARM                    kunde             5
     C                   PARM                    rtncode           1

     C* --------------------------------------------------

     c     artkey        chain     sbgprs00
     c*    artkey        chain     sbgprs00g
     c                   if        #GEBUCHT = *zero
     c                   if        kunde = #PRS020 or kunde = *blank
     c                   exsr      sr9500
     C                   if        not %found(sbgprs00)
     C*                  if        not %found(sbgprs00g)
     c                   movel     'W'           #modus
     c                   write     PRS00R1
     c                   ELSE
     c                   movel     'U'           #modus
     c                   update    PRS00R1
     C                   ENDIF
     c                   z-add     udate         #GEBUCHT
     c                   update    e_preisr
     c                   endif
     c                   endif

     C**************************************************************************
     C* SR9500: update auf Preisdatei
     C*-------------------------------------------------------------------------
     C     SR9500        BEGSR
     C*
     C                   clear                   #PRS050_A                      Firma
     C                   clear                   #PRS070_A                      Firma
     C                   clear                   #PRS080_A                      Firma
     C                   clear                   #PRS120_A                      Firma
     C                   if        not %found(sbgprs00)
     C                   else                                                   Firma
     C                   z-add     PRS050        #PRS050_A                      Firma
     C                   z-add     PRS070        #PRS070_A                      Firma
     C                   movel     PRS080        #PRS080_A                      Firma
     C                   z-add     PRS120        #PRS120_A                      Firma
     C                   endif
     C*
     C                   z-add     #PRS010       PRS010                         Firma
     C                   movel(p)  #PRS020       PRS020                         Schlüssel KDGR,Ver
     C                   movel(p)  #PRS030       PRS030                         Verkaufsartikel Li
     C                   movel(p)  #PRS040       PRS040                         Verkaufsartikel Ar
     C                   z-add     #PRS050       PRS050                         Netto-Preis
     C                   z-add     99            PRS060                         Währungs-Schlüssel
     C                   if        #PRS070 <> 010101                            Gültig Ab TTMMJJ
     C                   z-add     #PRS070       PRS070                         Gültig Ab TTMMJJ
     C                   endif                                                  Gültig Ab TTMMJJ
     C     '#':' '       xlate     #prs080       #prs080                        Kunden-Artikel-Nr.
     C                   movel(p)  #PRS080       PRS080                         Kunden-Artikel-Nr.
     C                   movel(p)  ' '           PRS090                         Lief.Schlüssel
     C                   movel(p)  ' '           PRS100                         Mont.Anl.
     C                   z-add     0             PRS110                         Brutto-Preis
     C                   z-add     #PRS120       PRS120                         Gültig Bis TTMMJJ
     C                   movel(p)  'N'           PRS130                         Brutto/Netto-Kennz
     C                   movel(p)  '1'           PRS999                         Status
     C*
     C     ##9500        ENDSR

     C*-------------------------------------------------------------------------
     C     *inzsr        BEGSR
     C                   ENDSR

