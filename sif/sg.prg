#include "\dev\fmk\epdv\epdv.ch"

/*
* ----------------------------------------------------------------
*                                     Copyright Sigma-com software 
* ----------------------------------------------------------------
*/



// ------------------------------------------------
// prelged sifrarnika shema generacije za kuf i kif 
// ------------------------------------------------
function p_sg(cTabela, cId, dx, dy)
*{
local nArea
local cHeader

cHeader := "Lista: shema generacije "
cHeader += cTabela

Private Kol
Private ImeKol

if (cTabela == "SG_KIF")
	nArea := F_SG_KIF
else
	nArea := F_SG_KUF
endif

SELECT (nArea)

if !used()
	if (cTabela == "SG_KIF")
		O_SG_KIF
	else
		O_SG_KUF
	endif
endif	

set_a_kol( @Kol, @ImeKol)
return PostojiSifra( nArea, 1, 10, 75, cHeader, ;
       @cId, dx, dy, ;
	{|Ch| k_handler(Ch)} )
	

// ---------------------------------------------------
//
// ---------------------------------------------------
static function set_a_kol( aKol, aImeKol )

aImeKol := {}

AADD(aImeKol, {"ID", {|| id}, "id", {|| .t.}, {|| .t.} })
AADD(aImeKol, {"Opis", {|| naz}, "naz", {|| .t.}, {|| .t.} })

AADD(aImeKol, {"source", {|| src}, "src", {|| .t.}, {|| .t.} })

AADD(aImeKol, {"Source lokacija", {|| s_path}, "s_path", {|| .t.}, {|| .t.} })
AADD(aImeKol, {"Source lokacija sif", {|| s_path_s}, "s_path_s", {|| .t.}, {|| .t.} })

AADD(aImeKol, {"Formula B.PDV vrijednost", {|| form_b_pdv }, "form_b_pdv", {|| .t.}, {|| .t.} })
AADD(aImeKol, {"Formula PDV vrijednost", {|| form_pdv }, "form_pdv", {|| .t.}, {|| .t.} })

AADD(aImeKol, {"Tarifa", {|| id_tar }, "id_tar", {|| .t.}, {|| .t.} })
AADD(aImeKol, {"Konto", {|| id_kto }, "id_kto", {|| .t.}, {|| .t.} })

AADD(aImeKol, {"Razb.tar.", {|| razb_tar }, "razb_tar", {|| .t.}, {|| .t.} })
AADD(aImeKol, {"Razb.kto.", {|| razb_kto }, "razb_kto", {|| .t.}, {|| .t.} })
AADD(aImeKol, {"Razb.dan.", {|| razb_dan }, "razb_dan", {|| .t.}, {|| .t.} })
AADD(aImeKol, {"Kat.part.", {|| kat_part }, "kat_part", {|| .t.}, {|| .t.} })

aKol:={}
FOR i:=1 TO LEN(aImeKol)
	AADD(aKol, i)
NEXT
return


// ------------------------------------
// gen shema kif keyboard handler
// ------------------------------------
static function k_handler(Ch)

return DE_CONT

