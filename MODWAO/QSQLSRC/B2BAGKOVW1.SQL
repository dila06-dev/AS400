/**************************************************************************/
/*  Copyright 2025 by    trend SWM EDV-Beratung GmbH & Co. KG             */
/*                       Jechtinger Straße 9                              */
/*                       DE 79111 Freiburg                                */
/*  --------------------------------------------------------------------  */
/*  Erstellt: RR 19.08.2025 Case #03777387 "Quote-List / Angebotsliste"   */
/*  --------------------------------------------------------------------  */
/*  Erzeugt eine View um Angebote pro Kunde auf zu listen.                */
/*  Dient als Workaround um Paging über LIMIT und OFFSET in Kombination   */
/*  mit Funktionsaufrufen wie GetB2BAFKNKOWT verwenden zu können.         */
/**************************************************************************/

CREATE OR REPLACE VIEW B2BAGKOVW1 AS

   SELECT
        GKFIRM,
        GKWKNR,
        GKKDNR,
	GKAGJJ,
	GKAGNR,
	GKJDAT,
	GKGBDA,
 GKAGDA,
	case when GKAGST='90' then 'CLOSED' else 'OPEN' end as GKAGST,
 sum(GPNESU) as GPWAWT,
	GKWACD,
	GetB2BAFKNKOWT(GKFIRM, GKAGJJ, GKAGNR, 'AGNR') as CHARGE
  FROM AGKO

  LEFT JOIN AGPO
	 ON(GKFIRM=GPFIRM and GKAGJJ=GPAGJJ and GKAGNR=GPAGNR)

  WHERE
        GKFIRM='01'
	and GKWKNR='001'
  GROUP BY
	GKFIRM,
	GKWKNR,
	GKKDNR,
	GKAGJJ,
	GKAGNR, 	
	GKJDAT,
 GKAGDA,
	GKGBDA,
	GKAGST,
	GKWACD	


