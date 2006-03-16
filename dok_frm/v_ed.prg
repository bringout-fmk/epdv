#include "sc.ch"

// ----------------------------------------------
// validacija
// ----------------------------------------------
function v_id_tar(cIdTar, nOsnov, nPdv,  nShow, lNova)
local nStopa 
local nPrerPdv

PushWa()


P_Tarifa(@cIdTar)

SELECT TARIFA
SET ORDER TO TAG "ID"
SEEK cIdTar
nStopa := tarifa->opp

nPrerPdv := ROUND(nOsnov * nStopa / 100, ZAO_IZN())

if lNova
	// nema se sta pitati
	nPdv := nPrerPdv
else

	if ((ROUND(nPrerPdv, 4) <> ROUND(nPdv, 4))) 
		if Pitanje("", "Preracunati prema stopi PDV ?", "N") == "D"
			nPdv :=	nPrerPdv
		endif
	endif
endif

if nShow <> nil
	@ row(), nShow + 2 SAY "Tarifa:" + stopa_pdv(nStopa)
	@ row(), col() + 2 SAY "iznos pdv: " 
	@ row(), col() + 2 SAY nPdV PICT PIC_IZN()
endif

PopWa()

return .t.

// ------------------------------
// partner
// ------------------------------
function v_part(cIdPart, cIdTar, cTbl, lShow)

if lShow == nil
	lShow := .t.
endif

p_part(@cIdPart)

if IsIno(cIdPart)
	if lShow
		if cTbl == "KUF"
			MsgBeep("Ino dobavljac, setuje tarifu na PDV7UV !")
			cIdTar := PADR("PDV7UV", 6)
		else
			MsgBeep("Ino kupac, setuje tarifu na PDV0IZ !")
			cIdTar := PADR("PDV0IZ", 6)
			
		endif
	endif
endif

// uprava za indirektno oporezivanje
if IsUio(cIdPart)
	cIdTar := PADR("UIO", 6)
endif

return .t.

// --------------------------
// --------------------------
function v_nazad(nNazad)
for i:=1 to nNazad
	KEYBOARD K_UP
next
return .t.


