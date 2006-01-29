#include "sc.ch"

// validacija

function v_id_tar(cIdTar, nOsnov, nPdv,  nShow)
local n_stopa 

n_stopa := tarifa->opp

P_Tarifa(@c_id_tar)

nPdv := ROUND(nOsnov * nStopa, ZAO_IZN())

if nShow <> nil
	@ row(), nShow SAY "Tarifa:" + stopa_pdv(nStopa)
	@ row(), col() + 2 SAY "iznos pdv " PICT PIC_IZN()
endif


return .t.


