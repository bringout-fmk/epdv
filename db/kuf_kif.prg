#include "\dev\fmk\epdv\epdv.ch"

/*
* ----------------------------------------------------------------
*                           Copyright Sigma-com software 2006
* ----------------------------------------------------------------
*/

function azur_kuf()
local nBrDok

o_kuf(.t.)


Box(, 2, 60)

nCount := 0

nNextGRbr:= next_g_r_br("KUF")



SELECT p_kuf
GO TOP

// novi dokument je u pripremi i nema uopste postavljen
// broj dokumenta
if (br_dok == 0)
	nNextBrDok := next_br_dok("KUF")
	nBrdok := nNextBrDok
else
	nBrDok := br_dok
endif

do while !eof()
	
	Scatter()
	
	// datum azuriranja
	_datum_2 := DATE()
	_g_r_br := nNextGRbr
	
	_br_dok := nBrDok
	
	++nCount
	@ m_x+1, m_y+2 SAY PADR("Dodajem P_KIF -> KUF " + transform(nCount, "9999"), 40)
	@ m_x+2, m_y+2 SAY PADR("   KUF G.R.BR: " + transform(nNextGRbr, "99999"), 40)

	nNextGRbr ++
	
	SELECT kuf
	APPEND BLANK
	Gather()

	select p_kuf
	SKIP
enddo

SELECT kuf
use

@ m_x+1, m_y+2 SAY PADR("Brisem pripremu ...", 40)

// sve je ok brisi pripremu
SELECT p_kuf
zap
use

o_kuf(.t.)

BoxC()

MsgBeep("Azuriran je KUF dokument " + STR( _br_dok, 6, 0) )

return _br_dok

