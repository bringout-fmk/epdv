#include "\dev\fmk\epdv\epdv.ch"

/*
* ----------------------------------------------------------------
*                           Copyright Sigma-com software 2006
* ----------------------------------------------------------------
*/

// -------------------------------------------
// azuriranje kufa
// -------------------------------------------
function azur_kif()
return azur_ku_ki("KIF")

// -------------------------------------------
// azuriranje kif-a
// -------------------------------------------
function azur_kuf()
return azur_ku_ki("KUF")


// -------------------------------------------
// povrat kuf dokument
// -------------------------------------------
function pov_kuf( nBrDok )
return pov_ku_ki("KUF", nBrDok )

// -------------------------------------------
// povrat kif dokument
// -------------------------------------------
function pov_kif(nBrDok)
return pov_ku_ki("KIF", nBrDok)


// -------------------------------------------
// -------------------------------------------
function azur_ku_ki(cTbl)
local nBrDok
public _br_dok := 0

if cTbl == "KUF"
	o_kuf(.t.)
	// privatno podrucje
	nPArea := F_P_KUF
	
	// kumulativ 
	nKArea := F_KUF
else
	o_kif(.t.)
	nPArea := F_P_KIF
	nKArea := F_KIF
endif


Box(, 2, 60)

nCount := 0

SELECT (nPArea)
if RECCOUNT2() == 0
	return 0
endif

nNextGRbr:= next_g_r_br(cTbl)


SELECT (nPArea)
GO TOP

// novi dokument je u pripremi i nema uopste postavljen
// broj dokumenta
if (br_dok == 0)
	nNextBrDok := next_br_dok(cTbl)
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
	@ m_x+2, m_y+2 SAY PADR("   "+ cTbl +" G.R.BR: " + transform(nNextGRbr, "99999"), 40)

	nNextGRbr ++
	
	SELECT (nKArea)
	APPEND BLANK
	Gather()

	select (nPArea)
	SKIP
enddo

SELECT (nKArea)
use

@ m_x+1, m_y+2 SAY PADR("Brisem pripremu ...", 40)

// sve je ok brisi pripremu
SELECT (nPArea)
zap
use

if (cTbl == "KUF")
	o_kuf(.t.)
else
	o_kuf(.t.)
endif	

BoxC()

MsgBeep("Azuriran je " + cTbl + " dokument " + STR( _br_dok, 6, 0) )

return _br_dok



// -------------------------------------------
// povrat kuf/kif dokumenata u pripremu
// -------------------------------------------
function pov_ku_ki(cTbl, nBrDok)


if (cTbl == "KUF")
	o_kuf(.t.)
	// privatno podrucje
	nPArea := F_P_KUF
	
	// kumulativ 
	nKArea := F_KUF
else
	o_kif(.t.)
	nPArea := F_P_KIF
	nKArea := F_KIF
endif



nCount := 0


SELECT (nKArea)
set order to tag "BR_DOK"
seek STR(nBrdok, 6, 0)


if !found()
	return 0
endif

SELECT (nPArea)
if RECCOUNT2()>0
	MsgBeep("U pripremi postoji dokument#ne moze se izvrsiti povrat#operacija prekinuta !")
	return -1
endif


Box(, 2, 60)
SELECT (nKArea)
// dodaj u pripremu dokument
do while !eof() .and. (br_dok == nBrDok)
	
	++nCount
	@ m_x+1, m_y+2 SAY PADR("P_" + cTbl+  " -> " + cTbl + " :" + transform(nCount, "9999"), 40)
	

	SELECT (nKArea)
	// setuj mem vars _
	Scatter()
	
	SELECT (nPArea)
	// dodaj zapis
	APPEND BLANK
	// memvars -> db
	Gather()
	
	// kumulativ tabela
	SELECT (nKArea)
	SKIP	
enddo

// vrati sam dokument, sada mogu  dokument izbrisati iz kumulativa
seek STR(nBrdok, 6, 0)
do while !eof() .and. (br_dok == nBrDok)
	
	SKIP
	// sljedeci zapis
	nTRec := RECNO()
	SKIP -1
	
	++nCount
	@ m_x+1, m_y+2 SAY PADR("Brisem " + cTbl + transform(nCount, "9999"), 40)
	
	DELETE
	// idi na sljedeci
	go nTRec
	
enddo

SELECT (nKArea)
use


if (cTbl == "KUF")
	o_kuf(.t.)
else
	o_kuf(.t.)
endif	

BoxC()

MsgBeep("Izvrsen je povrat dokumenta " + STR( nBrDok, 6, 0) + " u pripremu" )

return nBrDok
