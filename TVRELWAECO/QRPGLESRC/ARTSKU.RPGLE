     update TRANSFER set transfer = substr(TRANSFER , 01, 20) concat
      (select substr(char(digits(ics_)), 1, 10) from bar_kalk/Kalk_file
      where artnr = substr(TRANSFER, 1, 15) and version='$$EL_PS_DB')
      where exists
      (select substr(char(digits(ics_)), 1, 10) from bar_kalk/Kalk_file
      where artnr = substr(TRANSFER, 1, 15) and version='$$EL_PS_DB')
     238 Zeilen in TRANSFER in TVRELWAECO aktualisiert.
