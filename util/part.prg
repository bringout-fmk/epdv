#include "\dev\fmk\epdv\epdv.ch"

/*
* ----------------------------------------------------------------
*                           Copyright Sigma-com software 2006
* ----------------------------------------------------------------
*/

function s_partner(cIdPartn)
local cPom
local cIdBroj

PushWa()

o_partn()
select PARTN
SET ORDER TO TAG "ID"
seek cIdPartn

cPom := ""

cPom += ALLTRIM(naz) 

cMjesto := ALLTRIM(mjesto)
if EMPTY(cMjesto)
	cMjesto := "-NEP.MJ-"
endif

if !EMPTY(ptt)
	cPom += ALLTRIM(ptt) + " " + cMjesto
endif

cIdBroj := IzSifK("PARTN", "REGB", cIdPartn, .f.)
if EMPTY(cIdBroj)
	cIdBroj := "-NEP.ID-"
endif

cPom += ", " + cIdBroj

PopWa()
return cPom


// -------------------------------------
// sifrarnik partnera sa sifk/sifv
// -------------------------------------
function o_partn()

select F_PARTN
if !used()
	O_PARTN
endif

select F_SIFK
if !used()
	O_SIFK
endif

select F_SIFV
if !used()
	O_SIFV
endif

return
