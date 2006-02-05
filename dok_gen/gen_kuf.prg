#include "\dev\fmk\epdv\epdv.ch"
/*
* ----------------------------------------------------------------
*                                     Copyright Sigma-com software 
* ----------------------------------------------------------------
*/

function gen_kuf()

local dDatOd
local dDatDo

dDatOd := DATE()
dDatDo := DATE()

Box(, 4, 40)
	@ m_x+1, m_y+2 SAY "Generacija KUF"
	
	@ m_x+3, m_y+2 SAY "Datum do " GET dDatOd 
	@ m_x+4, m_y+2 SAY "      do " GET dDatDo
	READ
BoxC()

if LASTKEY()==K_ESC
	return 
endif


// ima li nesto u kif pripremi ?
SELECT F_P_KUF
if !used()
	O_P_KUF
endif

if RECCOUNT2() <>0
	MsgBeep("KUF Priprema nije prazna !")
	if Pitanje(,"Isprazniti KUF pripremu ?", "N") == "D"
		SELECT p_kuf
		zap
	endif
endif


Box(,5, 60)
	
	kalk_kuf(dDatOd, dDatDo)
	fin_kuf(dDatOd, dDatDo)
	
	renm_rbr("P_KUF", .f.)
BoxC()

return

