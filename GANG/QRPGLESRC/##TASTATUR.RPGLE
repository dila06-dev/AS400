     C**************************************************************************
     C* PROGRAMMNAME.:##TASTATUR                                              
     C* FUNKTION.....:HANDLING TASTATUR
     C* Oktober 2009   GANG, MANFRED
     C**************************************************************************
     C* FUNKTION.....:TASTATURDEFINITIONEN-STANDARD
     C**************************************************************************
     C*
     C     TASTEN        BEGSR
     C   35              MOVEL     '01'          KEY(1)
     C   82              MOVEL     '02'          KEY(2)
     C                   MOVEL     '03'          KEY(3)
     C                   MOVEL     '04'          KEY(4)
     C                   MOVEL     '05'          KEY(5)
     C   83              MOVEL     '06'          KEY(6)
     C   36              MOVEL     '07'          KEY(7)
     C   36              MOVEL     '08'          KEY(8)
     C   40              MOVEL     '09'          KEY(9)
      *                    MOVEL'10'      KEY,10           10  *
     C   37              MOVEL     '11'          KEY(11)
     C                   MOVEL     '12'          KEY(12)
      *                    MOVEL'13'      KEY,13           13  *
     C   82              MOVEL     '14'          KEY(14)
     C   83              MOVEL     '14'          KEY(14)
     C   86              MOVEL     '15'          KEY(15)
      *                    MOVEL'16'      KEY,16           16  *
     C   39              MOVEL     '17'          KEY(17)
     C   39              MOVEL     '18'          KEY(18)
     C   38              MOVEL     '19'          KEY(19)
     C   38              MOVEL     '20'          KEY(20)
     C   85              MOVEL     '21'          KEY(21)
     C   88              MOVEL     '22'          KEY(22)
     C   84              MOVEL     '23'          KEY(23)
      *                    MOVEL'24'      KEY,24           24RESERVIERT
     C     ##STEN        ENDSR
     C*
     C**************************************************************************
     C* FUNKTION.....:CALL ##PGMFKT
     C**************************************************************************
     C*
     C     FKTPGM        BEGSR
     C                   CALL      '##PGMFKT'                           97
     C                   PARM                    FTLNG             3 0
     C                   PARM                    KEY
     C                   PARM                    NEUFNR            2 0
     C                   PARM                    NEUFKT           20
     C                   PARM                    FKTRTN          132
     C                   PARM                    CTL29             1
     C                   PARM                    CTLARB            1 0
     C*
     C                   MOVEL     FKTRTN        D2FT01
     C                   MOVEA     CTL29         *IN(29)
     C     ##TPGM        ENDSR
     C*
