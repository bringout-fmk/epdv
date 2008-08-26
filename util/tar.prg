#include "epdv.ch"

/*
* ----------------------------------------------------------------
*                           Copyright Sigma-com software 2006
* ----------------------------------------------------------------
*/

function s_tarifa(cIdTar)
local cPom := ""

PushWa()

SELECT (F_TARIFA)

if !used()
	O_TARIFA
endif
SET ORDER TO TAG "ID"

seek cIdTar

if !found()
	cPom := "-NEP.TAR- ?!"
else
	cPom := ALLTRIM(naz) 
endif

PopWa()
return cPom


// -----------------------------
// get stopu za tarifu
// -----------------------------
function g_pdv_stopa(cIdTar)
local nStopa

PushWa()

SELECT (F_TARIFA)

if !used()
	O_TARIFA
endif
SET ORDER TO TAG "ID"

seek PADR(cIdTar, 6)

if !found()
	nStopa := -999
else
	nStopa := tarifa->opp
endif

PopWa()
return nStopa


