      * PROGRAMMNAME.:##PGMFKT                                                
      * FUNKTION.....:........Funktionstastenbestimmung
      * 06.07.98       GANG, MANFRED
      *
      *
      *-ÄNDERUNGSDIENST---------------------------------------------------------
      * XX.XX.XX                                              PGMR.....
      * Das Programm soll die Anzeige einer Liste von für das aufrufende Program
      * Funktionstasten aufbereiten.
      * Die gültigen Funktionstasten (01 bis 24) samt ihre Standard-Zuordnung si
      * Datenstruktur ##I004LE (/COPY) definiert.
      * Dem Programm werden folgende Parameter übergeben:
      * ftlng      num   3 0, Länge des vom aufrufendes Programm verwendetes Anz
      *                       für die möglichen Funktionstasten.
      * fktfld     alp  48  , Liste der vom aufrufendes Programm zugelassenen Fu
      *                       Tasten (z.B. 01020304000600000000001200 usw.)
      * neufnr     num   2 0, Position einer Funktionstasten, dessen Beschreibun
      *                       neuer Text überschrieben werden soll.
      * neufkt     alp  20  , Neue Beschreibung für die im Feld neufnr angegeben
      * fktrtn     alp 132  , Rückgabefeld mit der aufbereitete Funktionsliste i
      *                       Fleld ftlng angegebene Länge.
      * ctl29      alp   1  , Kontrollfeld für Funktionstaste F24 (weitere Taste
      *                       Feld ist 0 wenn F24 nicht benötigt wird, weil alle
      *                       Programm zugeordeneten Funktionstasten in das Anze
      *                       dargestellt werden kann, sonst wird 1 zurückgegebe
      * ctlarb     num   1 0, Kontrollfeld Programmablauf:
      *                       0 Erstaufruf bzw. geänderte Funktionsliste.
      *                         Die Liste soll neu aufgebaut werden, der Wert de
      *                         ctl29 wird neu ermittelt. ctlarb wird auf 1 gese
      *                       1 Aufruf bei F24. Nächste Teilliste der Funktionen
      *                         gegeben. Die Gesamtliste der Funktionstasten kan
      *                         zu 20-Teillisten aufgeteilt werden, je nach der
      *                         ftlng übergebene Länge. Rollend, d. h. daß die e
      *                         Teilliste erneut angezeigt wird wenn die zuletzt
      *                         Teilliste die letztmögliche war.
      *                       9 Es wird kein weiterer Aufruf benötigt, Programm
      *-------------------------------------------------------------------------
      /SPACE 1
      *-------------------------------------------------------------------------
      * Verwendete Feldgruppen
      *-------------------------------------------------------------------------
      /SPACE 1
     D FT              S             20    DIM(24)
     D FL              S              2  0 DIM(24)
     D FG              S              3  0 DIM(24)
     D FK              S            132    DIM(20)
     D FKF             S              1    DIM(132)
     D FB              S              2    DIM(24)
     D NFB             S              2    DIM(24)
     D FT_neu          S             20    DIM(24)
     I/COPY ##I004le
     Dstrlen           s             10u 0
     I/SPACE 1
     I* Kopiestrecke Funktionstasten mit Standardtexte
     I*
     C/EJECT
      *-------------------------------------------------------------------------
      * Aufruf-Parameter
      *-------------------------------------------------------------------------
      /SPACE 1
     C     *entry        plist
     C                   parm                    ftlng             3 0
     c                   parm                    fktfld           48
     c                   parm                    neufnr            2 0
     c                   parm                    neufkt           20
     c                   parm                    fktrtn          132
     C                   parm                    ctl29             1
     C                   parm                    ctlarb            1 0
      /SPACE 1
      *-------------------------------------------------------------------------
      * Verarbeiten
      *-------------------------------------------------------------------------
      /SPACE 1
      *
      * Aufrufmodus:
      * 0       neu Aufruf, Funktionslisten neu
      * 1       Nur bei F24 (anzeige nächste)
      * 9       Programm beenden
      *
      /SPACE 1
      * wenn Kontrollfeld 0, Neuaufruf bzw. aufbereiten geänderte Liste
      * wenn              9, kein weiterer Aufruf nötigm Programm beenden
      * sonst              , nächste Teilliste übergeben
      *
     C     ctlarb        ifgt      0
     C     ctlarb        ifeq      9
     C                   movel     '1'           *inlr
     C                   goto      #end
     C                   else
     C                   goto      #pgm100
     C                   end
     C                   end
      /EJECT
      * Initialisierung bei Neuaufruf bzw. geänderte Liste
      *
     c                   move      *blank        fk
     c                   move      *blank        fkf
     c                   z-add     1             ctlarb
     c                   z-add     0             nbrfkt            2 0
     c                   z-add     0             fgs               3 0
      *
      * Standard-Funktionen in Feldgruppe übernehmen
      *
     c                   eval      ft(1) = i§§f01
     c                   eval      ft(2) = i§§f02
     c                   eval      ft(3) = i§§f03
     c                   eval      ft(4) = i§§f04
     c                   eval      ft(5) = i§§f05
     c                   eval      ft(6) = i§§f06
     c                   eval      ft(7) = i§§f07
     c                   eval      ft(8) = i§§f08
     c                   eval      ft(9) = i§§f09
     c                   eval      ft(10) = i§§f10
     c                   eval      ft(11) = i§§f11
     c                   eval      ft(12) = i§§f12
     c                   eval      ft(13) = i§§f13
     c                   eval      ft(14) = i§§f14
     c                   eval      ft(15) = i§§f15
     c                   eval      ft(16) = i§§f16
     c                   eval      ft(17) = i§§f17
     c                   eval      ft(18) = i§§f18
     c                   eval      ft(19) = i§§f19
     c                   eval      ft(20) = i§§f20
     c                   eval      ft(21) = i§§f21
     c                   eval      ft(22) = i§§f22
     c                   eval      ft(23) = i§§f23
     c                   eval      ft(24) = i§§f24
     c                   exsr      sr9999
      *
      * Falls Funktionsüberschreibung gewünscht, übernehmen
      *
     c     ' ':'0'       xlate     fktfld        fktfld
     c                   movea     fktfld        fb
     c                   movel     '00'          cft               2
      *
     c     neufnr        ifgt      0
     c     neufnr        andle     23
     c     neufkt        andne     *blank
     c                   eval      zft = neufnr
     c                   move      zft           cft
     c                   exsr      #srf100
     c                   movea     nfb           fktfld
     c                   eval      ft(neufnr) = neufkt
     c                   end
      *
      * initialisieren einzelnen Funktionslängen
      *
     c                   move      *blank        fktler           20
     c                   move      *blank        fktvol           20
     c                   eval      fg = 0
     c                   z-add     0             f                 2 0
     c                   z-add     0             n                 2 0
     c                   movel     '00'          cft               2
     c                   z-add     0             zft               2 0
      *
      * Übergebene Funktionsliste übernehmen
      *
     c     ' ':'0'       xlate     fktfld        fktfld
     c                   movea     fktfld        fb
      *
      * Prüfschleife
      *
     c                   do        24            n
      *
     c                   eval      cft = fb(n)
      *
      * evtl. Blanks durch 0 ersetzen
      *
     c     ' ':'0'       xlate     cft           cft
     c                   move      cft           zft
      *
      * zft ist die Nummer der verwendete Funktionstaste
      * (nur 01 bis 23)
      *
     c     zft           ifgt      0
     c     zft           andlt     24
      *
      * Länge der Funktionstasten-Beschreibung ermitteln
      *
     c                   eval      fktvol = ft(zft)
     c     ' '           checkr    fktvol        strlen
     c                   eval      fl(zft) = strlen
      *
      * Falls < 20, um 1 vergrößern für Blankfeld (Trennung einzelnen Funktionen
      *
     c     strlen        iflt      20
     c                   eval      fl(zft) = strlen + 2
     c*                  eval      fl(zft) = strlen + 1
     c                   end
     c                   end
      *
     c                   enddo
      *
      * Länge für Anzeige F24 ermitteln
      *
     c     fl(24)        ifeq      0
     c                   eval      fktvol = ft(24)
     c     ' '           checkr    fktvol        strlen
     c                   eval      fl(24) = strlen
     c     strlen        iflt      20
     c                   eval      fl(24) = strlen + 1
     c                   end
     c                   end
      *
      * Benötigte Gesamtlänge für die Anzeige aller verwendeten Funktionen ermit
      *
     c                   z-add     0             n
      *
      * Arbeitsschleife
      *
     c                   do        24            n
      *
     c     fl(n)         ifgt      0
     c                   eval      fgs = fgs + fl(n)
     c                   eval      fg(n) = fgs
     c                   else
     c                   eval      fg(n) = 0
     c                   end
      *
     c                   enddo
      *
     c                   z-add     0             fgs
     c                   z-add     0             n
      *
     c                   do        23            n
     c                   eval      fgs = fgs + fl(n)
     c                   enddo
      *
      * Anzahl der benötigten Teillisten ermitteln
      * Index der ersten Teilliste ist standard 1
      *
     c                   z-add     1             nbrfkt
      *
      * wenn die benötigte Gesamtlänge die übergebene Länge des Anzeigefeldes
      * nicht überschreitet, Anzeigefeld aufbereiten und ctl29 aus
      * Rückgabe an aufrufendes Programm
      *
     c     fgs           ifle      ftlng
     c                   movel     '0'           ctl29
     c                   z-add     1             ctlarb
     c                   exsr      #lng000
     c                   movea     fkf           fktrtn
     c                   eval      fk(1) = fktrtn
     c                   return
     c                   endif
      *
      * Es werden mehrere Teillisten benötigt, F24 wird zugelassen (ctl29 1)
      * Aufbereitung der einzelnen Teillisten aufrufen
      * Erste Teilliste an aufrufendes Programm zurückgeben
      *
     c                   movel     '1'           ctl29
     c                   z-add     1             ctlarb
     c                   exsr      #lng100
     c                   movea     fk(1)         fktrtn
     c                   return
      *
      * Aufruf bei F24
      *
     c     #pgm100       tag
      *
      * Teillisten-Index um 1 erhöhen
      *
     c                   add       1             nbrfkt
      *
      * Falls Index größer als ermittelte Anzahl der Teillisten,
      * mit erste Teilliste wieder beginnen
      *
     c     nbrfkt        ifgt      f
     c                   z-add     1             nbrfkt
     c                   end
      *
      * Teilliste am aufrufendes Programm zurückgeben
      *
     c                   movea     fk(nbrfkt)    fktrtn
     c                   return
      *
     c     #end          tag
      /EJECT
      * Routine #lng000, F24 wird nicht benötigt, nur eine Teilliste aufbereiten
      *
     c     #lng000       begsr
      *
     c                   move      *blank        fkf
     c                   z-add     0             n
      *
      * Startposition Funktionstext in Anzeigezeile
      *
     c                   z-add     1             fpo               3 0
      *
      * Aufbereitungsschleife
      *
     c                   do        23            n
      *
      * Nur wenn Funktionstaste verwendet (Funktionslänge > 0)
      * Beschreibung in Zeile stellen und Position für nächste ermitteln
      *
     c     fl(n)         ifgt      0
     c                   movea     ft(n)         fktvol
     c                   movea     fktvol        fkf(fpo)
     c                   eval      fpo = fpo + fl(n)
     c                   end
      *
     c                   enddo
      *
     c                   endsr
      /EJECT
      * Routine #lng100, Aufteilen in Teillisten
      *
     c     #lng100       begsr
      *
      * aus übergebene Länge des Anzeigefeldes, ermitteln welche Länge
      * noch verfügbar ist um die F24-Beschreibung anzuzeigen
      *
     c                   z-add     ftlng         gftlng            3 0
     c                   eval      gftlng = ftlng - fl(24)
      *
      * Initialisierung
      *
     c                   z-add     0             n
     c                   z-add     0             fgs
     c                   z-add     1             f
     c                   z-add     1             fpo
     c                   move      *blank        fkf
      *
      * Aufteilungs-Schleife
      *
     c     #lng110       tag
      *
     c                   add       1             n
      *
      * Nur bis Funktion F23
      *
     c     n             ifgt      23
     c                   goto      #lng10x
     c                   end
      *
      * wenn Funktion nicht verwendet, nächste
      *
     c     fl(n)         ifeq      0
     c                   goto      #lng110
     c                   end
      *
      * bis inklusive diese Funktion benötigte Länge
      *
     c                   movea     ft(n)         fktvol
     c                   eval      fgs = fgs + fl(n)
      *
      * Falls <= mögliche Teillistenlänge, übernehmen
      * und nächste Position ermitteln
      *
     c     fgs           ifle      gftlng
     c                   movea     fktvol        fkf(fpo)
     c                   eval      fpo = fpo + fl(n)
     c                   movea     fkf           fktrtn
     c                   movea     fktrtn        fk(f)
      *
      * sonst neue Teilliste initialisieren und mit Position 1 beginnen
      *
     c                   else
     c                   eval      fgs = fl(n)
     c                   move      *blank        fkf
     c                   z-add     1             fpo
     c                   movea     fktvol        fkf(fpo)
     c                   eval      fpo = fpo + fl(n)
     c                   add       1             f
     c                   movea     fkf           fktrtn
     c                   movea     fktrtn        fk(f)
      *
     c                   endif
      *
      * nächste Funktion
      *
     c                   goto      #lng110
      *
     c     #lng10x       tag
      *
      * Funktionstaste F24 in den Teillisten hinzufügen
      *
     c                   movea     ft(24)        fktvol
      *
      * Startposition für Beschreibung F24 in den Zeilen ermitteln
      *
     c                   eval      fpo = ftlng - fl(24) + 1
      *
     c                   z-add     0             n
      *
      * in jede der benötigten Teillisten, F24-Beschreibung hinzufügen
      *
     c                   do        f             n
      *
     c                   movea     fk(n)         fktrtn
     c                   movea     fktrtn        fkf
     c                   movea     fktvol        fkf(fpo)
     c                   movea     fkf           fktrtn
     c                   movea     fktrtn        fk(n)
      *
     c                   enddo
      *
     c                   endsr
      /EJECT
      * Routine #srf100, geänderte Liste bei zusatzfunktion
      *
     C     #srf100       begsr
      *
     c                   z-add     0             n
     c                   move      *all'0'       nfb
      *
     c                   do        24            n
     c     fb(n)         ifeq      '00'
     c                   eval      fb(n) = cft
     c                   leave
     c                   endif
     c                   enddo
      *
     c                   z-add     0             n
     c                   z-add     0             t                 2 0
      *
     c                   do        24            n
     c     fb(n)         ifne      '00'
     c                   movea     fb(n)         cft
     c                   add       1             t
     c                   movea     cft           nfb(t)
     c                   endif
     c                   enddo
      *
     c                   z-add     0             n
      *
     c                   endsr
     C**************************************************************************
     C* Initialisierungen
     C*-------------------------------------------------------------------------
     C*
     C     SR9999        BEGSR
     C*
     C     *DTAARA       DEFINE                  tastatur        480
     C*    aktuelle Firma einlesen
     C                   IN        tastatur
     C                   movea     tastatur      ft_neu
     c                   if        ft_neu(1)  <> '                    '
     c                   eval      ft(1) = ft_neu(1)
     c                   endif
     c                   if        ft_neu(2)  <> '                    '
     c                   eval      ft(2) = ft_neu(2)
     c                   endif
     c                   if        ft_neu(3)  <> '                    '
     c                   eval      ft(3) = ft_neu(3)
     c                   endif
     c                   if        ft_neu(4)  <> '                    '
     c                   eval      ft(4) = ft_neu(4)
     c                   endif
     c                   if        ft_neu(5)  <> '                    '
     c                   eval      ft(5) = ft_neu(5)
     c                   endif
     c                   if        ft_neu(6)  <> '                    '
     c                   eval      ft(6) = ft_neu(6)
     c                   endif
     c                   if        ft_neu(7)  <> '                    '
     c                   eval      ft(7) = ft_neu(7)
     c                   endif
     c                   if        ft_neu(8)  <> '                    '
     c                   eval      ft(8) = ft_neu(8)
     c                   endif
     c                   if        ft_neu(9)  <> '                    '
     c                   eval      ft(9) = ft_neu(9)
     c                   endif
     c                   if        ft_neu(10)  <> '                    '
     c                   eval      ft(10) = ft_neu(10)
     c                   endif
     c                   if        ft_neu(11)  <> '                    '
     c                   eval      ft(11) = ft_neu(11)
     c                   endif
     c                   if        ft_neu(12)  <> '                    '
     c                   eval      ft(12) = ft_neu(12)
     c                   endif
     c                   if        ft_neu(13)  <> '                    '
     c                   eval      ft(13) = ft_neu(13)
     c                   endif
     c                   if        ft_neu(14)  <> '                    '
     c                   eval      ft(14) = ft_neu(14)
     c                   endif
     c                   if        ft_neu(15)  <> '                    '
     c                   eval      ft(15) = ft_neu(15)
     c                   endif
     c                   if        ft_neu(16)  <> '                    '
     c                   eval      ft(16) = ft_neu(16)
     c                   endif
     c                   if        ft_neu(17)  <> '                    '
     c                   eval      ft(17) = ft_neu(17)
     c                   endif
     c                   if        ft_neu(18)  <> '                    '
     c                   eval      ft(18) = ft_neu(18)
     c                   endif
     c                   if        ft_neu(19)  <> '                    '
     c                   eval      ft(19) = ft_neu(19)
     c                   endif
     c                   if        ft_neu(20)  <> '                    '
     c                   eval      ft(20) = ft_neu(20)
     c                   endif
     c                   if        ft_neu(21)  <> '                    '
     c                   eval      ft(21) = ft_neu(21)
     c                   endif
     c                   if        ft_neu(22)  <> '                    '
     c                   eval      ft(22) = ft_neu(22)
     c                   endif
     c                   if        ft_neu(23)  <> '                    '
     c                   eval      ft(23) = ft_neu(23)
     c                   endif
     c                   if        ft_neu(24)  <> '                    '
     c                   eval      ft(24) = ft_neu(24)
     c                   endif
     C*
     C     ##9999        ENDSR
     C*
