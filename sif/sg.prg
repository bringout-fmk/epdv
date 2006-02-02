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

// tip: sifrarnik setuje varijable sa "W" prefixom za tekuca polja 
AADD(aImeKol, {"src", {|| src}, "src", {|| .t.}, {|| !empty(g_src_modul(wsrc, .t.))} })
AADD(aImeKol, {"src TD", {|| td_src}, "td_src", {|| .t.}, {|| .t.} })

AADD(aImeKol, {"Src.Lokacija.", {|| s_path}, "s_path", {|| .t.}, {|| .t.} })
AADD(aImeKol, {"Src.lok. sif", {|| s_path_s}, "s_path_s", {|| .t.}, {|| .t.} })

AADD(aImeKol, {"For.B.PDV vr.", {|| form_b_pdv }, "form_b_pdv", {|| .t.}, {|| .t.} })
AADD(aImeKol, {"For.PDV vr.", {|| form_pdv }, "form_pdv", {|| .t.}, {|| .t.} })

AADD(aImeKol, {"Tarifa", {|| id_tar }, "id_tar", {|| .t.}, {|| .t.} })
AADD(aImeKol, {"Konto", {|| id_kto }, "id_kto", {|| .t.}, {|| .t.} })

AADD(aImeKol, {"Razb.tar.", {|| razb_tar }, "razb_tar", {|| .t.}, {|| .t.} })
AADD(aImeKol, {"Razb.kto.", {|| razb_kto }, "razb_kto", {|| .t.}, {|| .t.} })
AADD(aImeKol, {"Razb.dan.", {|| razb_dan }, "razb_dan", {|| .t.}, {|| .t.} })
AADD(aImeKol, {"Kat.part.", {|| g_kat_p(kat_p) }, "kat_p", {|| .t.}, {|| !EMPTY(g_kat_p(wkat_p,.t.))} })
AADD(aImeKol, {"Kat.part.2", {|| g_kat_p_2(kat_p_2) }, "kat_p_2", {|| .t.}, {|| !EMPTY(g_kat_p_2(wkat_p_2,.t.))} })
AADD(aImeKol, {"Zaok c*kol", {|| zaok }, "zaok", {|| wzaok := iif(wzaok==0, 2, wzaok), .t.}, {|| .t. } })
AADD(aImeKol, {"Zaok dok", {|| zaok }, "zaok2", {|| wzaok2 := iif(wzaok2==0, 2, wzaok2), .t.}, {|| .t. } })

// setuj id tar u kuf/kif
AADD(aImeKol, {"Set.Tar", {|| s_id_tar }, "s_id_tar", {|| .t.}, {|| .t.} })

// setuj id tar u kuf/kif
AADD(aImeKol, {"Set.Par", {|| s_id_part }, "s_id_part", {|| .t.}, {|| .t.} })

AADD(aImeKol, {"Aktivan", {|| aktivan }, "aktivan", {|| waktivan := iif(waktivan == " ", "D", waktivan) , .t.}, {|| .t.} })

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

