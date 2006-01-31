#include "sc.ch"

// ----------------------------------------------
// validacija
// ----------------------------------------------
function v_id_tar(cIdTar, nOsnov, nPdv,  nShow)
local nStopa 

PushWa()


P_Tarifa(@cIdTar)

SELECT TARIFA
SET ORDER TO TAG "ID"
SEEK cIdTar
nStopa := tarifa->opp

nPdv := ROUND(nOsnov * nStopa / 100, ZAO_IZN())

if nShow <> nil
	@ row(), nShow + 2 SAY "Tarifa:" + stopa_pdv(nStopa)
	@ row(), col() + 2 SAY "iznos pdv: " 
	@ row(), col() + 2 SAY nPdV PICT PIC_IZN()
endif

PopWa()

return .t.


