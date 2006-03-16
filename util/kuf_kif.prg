#include "\dev\fmk\epdv\epdv.ch"

/*
* ----------------------------------------------------------------
*                           Copyright Sigma-com software 2006
* ----------------------------------------------------------------
*/

// ------------------------------------------------
// otvori tabele potrebne za ispravku kuf-a
// ------------------------------------------------
function o_kuf(lPriprema)

if lPriprema == nil
	lPriprema := .f.
endif

select F_TARIFA
if !used()
	O_TARIFA
endif

select F_PARTN
if !used()
	O_PARTN
endif

select F_KUF
if !used()
	O_KUF
endif

if lPriprema == .t.
SELECT (F_P_KUF)

if !used()
	O_P_KUF
endif
endif


return


// ------------------------------------------------
// otvori tabele potrebne za ispravku kif-a
// ------------------------------------------------
function o_kif(lPriprema)

if lPriprema == nil
	lPriprema := .f.
endif

select F_TARIFA
if !used()
	O_TARIFA
endif

select F_PARTN
if !used()
	O_PARTN
endif

select F_KIF
if !used()
	O_KIF
endif

if lPriprema == .t.
SELECT (F_P_KIF)

if !used()
	O_P_KIF
endif
endif


return



// ------------------------
// ------------------------
function next_r_br(cTblName)

PushWa()
do case
	case cTblName == "P_KUF"
		SELECT p_kuf
	case cTblName == "P_KIF"
		SELECT p_kif
	
endcase

SET ORDER TO TAG "BR_DOK"
GO BOTTOM
nLastRbr := r_br
PopWa()
return nLastRbr + 1


// ------------------------
// ------------------------
function next_g_r_br(cTblName)

PushWa()
do case
	case cTblName == "KUF"
		SELECT kuf
	case cTblName == "KIF"
		SELECT kif
	
endcase

SET ORDER TO TAG "G_R_BR"

GO BOTTOM
nLastRbr := g_r_br
PopWa()
return nLastRbr + 1


// -----------------------------
// -----------------------------
function next_br_dok(cTblName)
local nLastBrDok


PushWa()
do case
	case cTblName == "KUF"
		SELECT kuf
	case cTblName == "KIF"
		SELECT kif
	
endcase

SET ORDER TO TAG "BR_DOK"

GO BOTTOM
nLastBrDok := br_dok
PopWa()

return nLastBrdok + 1


// ------------------------
// ------------------------
function rn_g_r_br(cTblName)
local nRbr

// TAG: datum : "dtos(datum)+src_br_2"

close all

do case
	case cTblName == "KUF"
		O_KUF
	case cTblName == "KIF"
		O_KIF
	
endcase

GO TOP
nRbr := 1
SET ORDER TO TAG "DATUM"

if !FLOCK()
	MsgBeep("Ne mogu zakljucati bazu " + cTblName + ;
	 "## renumeracije nije izvrsena !")
	 close all
endif	 

Box(,2, 35)
do while !eof()
	@ m_x+1, m_y+2 SAY "Renumeracija: G_R_BR " + STR(nRbr, 4, 0)
	replace g_r_br with nRbr
	nRbr++
	SKIP
enddo
BoxC()

close all
return 

