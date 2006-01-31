#include "\dev\fmk\epdv\epdv.ch"

/*
* ----------------------------------------------------------------
*                           Copyright Sigma-com software 2006
* ----------------------------------------------------------------
*/


// ----------------------------
// napuni sifrarnik tarifa sa 
// 
function fill_tar()


SELECT (F_TARIFA)
if !used()
	O_TARIFA
endif

// nabavka od pdv obveznika, standardna prodaja
cPom:=PADR("PDV17" ,6)
seek cPom
if !found()
	append blank
	replace id with cPom
	replace naz with "PDV 17%"
	replace opp with 17
endif

// nabavka od ne-pdv obvenznika
cPom:=PADR("PDV0N" ,6)
seek cPom
if !found()
	append blank
	replace id with cPom
	replace naz with "NEPDV OBVEZNICI, PDV 0%, NAB"
	replace opp with 0
endif


// nabavka od poljoprivrednika oporezivi dio 5%
cPom:=PADR("PDV7PO" ,6)
seek cPom
if !found()
	append blank
	replace id with cPom
	replace naz with "POLJOPR., OPOR. DIO PDV 17%"
	replace opp with 17
endif

// nabavka od poljoprivrednika neopoprezivi dio 95%
cPom:=PADR("PDV0PO" ,6)
seek cPom
if !found()
	append blank
	replace id with cPom
	replace naz with "POLJOPR., NEOPOR. DIO PDV 0%"
	replace opp with 0
endif

// uvoz  oporezivo
cPom:=PADR("PDV7UV" ,6)
seek cPom
if !found()
	append blank
	replace id with cPom
	replace naz with "UVOZ OPOREZIVO, PDV 17"
	replace opp with 17
endif

// uvoz  neoporezivo
cPom:=PADR("PDV0UV" ,6)
seek cPom
if !found()
	append blank
	replace id with cPom
	replace naz with "UVOZ NEOPOREZIVO, PDV 0%"
	replace opp with 0
endif


// nabavka neposlovne svrhe - ne priznaje se ul porez
cPom:=PADR("PDV0NP" ,6)
seek cPom
if !found()
	append blank
	replace id with cPom
	replace naz with "NEPOSLOVNE SVRHE, UL. PDV = 0"
	replace opp with 0
endif


// nabavka i prodaja avansne fakture
cPom:=PADR("PDV7AV" , 6)
seek cPom
if !found()
	append blank
	replace id with cPom
	replace naz with "AVANSNE FAKTURE, PDV 17%"
	replace opp with 17
endif


// prodaja, izvoz
cPom:=PADR("PDV0IZ" , 6)
seek cPom
if !found()
	append blank
	replace id with cPom
	replace naz with "IZVOZ, PDV 0%"
	replace opp with 0
endif


return

