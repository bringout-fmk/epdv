#include "\dev\fmk\epdv\epdv.ch"

/*
* ----------------------------------------------------------------
*                           Copyright Sigma-com software 2006
* ----------------------------------------------------------------
*/


// ----------------------------------------------
// napuni sifrarnik sifk  sa poljem za unos 
// podatka o pripadnosti rejonu
//   1 - federacija
//   2 - rs
//   3 - distrikt brcko
// ---------------------------------------------
function fill_part()
local lFound
local cSeek
local cNaz
local cId


SELECT (F_SIFK)

if !used()
	O_SIFK
endif

SET ORDER TO TAG "ID"
//id+SORT+naz

cId := PADR("PARTN", 8) 
cNaz := PADR("1-FED,2-RS 3-DB", LEN(naz))
cSeek :=  cId + "09" + cNaz


SEEK cSeek   

if !FOUND()
	APPEND BLANK
	replace id with cId ,;
		naz with cNaz ,;
		oznaka with "REJO" ,;
		sort with "09" ,;
		veza with "1" ,;
		tip with "C" ,;
		duzina with 1 ,;
		decimal with 0
endif


