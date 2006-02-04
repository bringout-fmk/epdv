#include "\dev\fmk\epdv\epdv.ch"

/*
* ----------------------------------------------------------------
*                            Copyright Sigma-com software 2006 
* ----------------------------------------------------------------
*/

function gen_kif()

local dDatOd
local dDatDo

dDatOd := DATE()
dDatDo := DATE()

Box(, 3, 40)
	@ m_x+1, m_y+2 SAY "Datum do " GET dDatOd 
	@ m_x+2, m_y+2 SAY "      do " GET dDatDo
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
	fakt_kif(dDatOd, dDatDo)
	
	kalk_kif(dDatOd, dDatDo)
	
	tops_kif(dDatOd, dDatDo)

	renm_rbr("P_KIF", .f.)
BoxC()

return

