#include "\dev\fmk\epdv\epdv.ch"

/*
* ----------------------------------------------------------------
*                           Copyright Sigma-com software 2006
* ----------------------------------------------------------------
*/

function s_tarifa(cIdTarifa)
local cPom

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
	cPom += ALLTRIM(naz) 
endif

PopWa()
return cPom

// -----------------------------------------------
// podaci o mojoj firmi ubaceni u partnera "10"
// -----------------------------------------------
function my_firma()
loca cIdBroj
local cPom := gNFirma
PushWa()

