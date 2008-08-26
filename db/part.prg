#include "epdv.ch"

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

// -----------------------------------------------------
// fill from source-a ako je razlicito od sifpath
// --------------------------------------------------
function f_part_f_src(cSrcSifPath, cIdPart)
local cIdBroj

if UPPER( cSrcSifPath ) == UPPER(SIFPATH)
	// sifrarnik je identican
	return
endif

// trenutno je tabela otvorena u src ext lokaciji
SELECT PARTN
SET ORDER TO TAG ID
SEEK cIdPart
// stavi u mem var
Scatter()

cIdBroj := IzSifK("PARTN", "REGB", cIdPart, .f.)


SELECT F_PARTN
use

SELECT F_SIFK
use

SELECT F_SIFV
use

O_PARTN
SET ORDER TO TAG "ID"

O_SIFK
O_SIFV

// dodaj u EPDV sifrarnik
SELECT partn
seek _id
if !found()
	// dodaj partnera
	APPEND BLANK
	Gather()
	USifK("PARTN", "REGB", _id, cIdBroj)
endif

// ponovo pozatvaraj
SELECT F_PARTN
use

SELECT F_SIFK
use

SELECT F_SIFV
use

// pa otvori externi source tabele
SELECT F_PARTN
USE (cSrcSifPath + "PARTN")
SET ORDER TO TAG "ID"

SELECT F_SIFK
USE (cSrcSifPath + "SIFK")
SET ORDER TO TAG "ID"

SELECT F_SIFV
USE (cSrcSifPath + "SIFV")
SET ORDER TO TAG "ID"

return
