#include "epdv.ch"

/*
* ----------------------------------------------------------------
*                            Copyright Sigma-com software 2006 
* ----------------------------------------------------------------
*/

function gen_kif()

local dDatOd
local dDatDo
local cSezona

dDatOd := DATE()
dDatDo := DATE()
cSezona := SPACE(4)

Box(, 3, 40)
	@ m_x+1, m_y+2 SAY "Datum do " GET dDatOd 
	@ m_x+2, m_y+2 SAY "      do " GET dDatDo
	@ m_x+3, m_y+2 SAY "sezona" GET cSezona
	
	READ
BoxC()

if LASTKEY()==K_ESC
	return 
endif


// ima li nesto u kif pripremi ?
SELECT F_P_KIF
if !used()
	O_P_KIF
endif

if RECCOUNT2() <>0
	MsgBeep("KIF Priprema nije prazna !")
	if Pitanje(,"Isprazniti KIF pripremu ?", "N") == "D"
		SELECT p_kif
		zap
	endif
endif


Box(,5, 60)
	fakt_kif(dDatOd, dDatDo, cSezona)
	
	kalk_kif(dDatOd, dDatDo, cSezona)
	
	tops_kif(dDatOd, dDatDo, cSezona)
	
	fin_kif(dDatOd, dDatDo, cSezona)

	renm_rbr("P_KIF", .f.)
BoxC()

return

