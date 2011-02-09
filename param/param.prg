#include "epdv.ch"

/*
* ----------------------------------------------------------------
*                             Copyright Sigma-com software 2006
* ----------------------------------------------------------------
*/

// zaokruzenje iznos
static gZAO_IZN
// zaokruzenje cijena
static gZAO_CIJ
// zaokruzenje cijena
static gZAO_PDV

// picture iznos
static gPIC_IZN

// picture cijena
static gPIC_CIJ

// ulazni pdv koji se ne moze odbiti
// da li ulazi u statistiku krajnje potrosnje
// ako ulazi onda se stavlja polje u koje se dodaje
// " " - ne dodajes u statistiku
// "1" - federacija
// "2" - sprski republikanci 
// "3" - brcko district do las vegasa
static gUlPdvKp := "1"

// -------------------------------------
// set parametre pri pokretanju modula
// ------------------------------------
function s_params()

// procitaj globalne - kparams
read_g_params()

// napuni sifrarnik tarifa
fill_tar()

// napuni sifk radi unosa partnera - rejon
fill_part()

return


// --------------------------------------
// --------------------------------------
function ed_g_params()

gPIC_IZN:= PADR(gPIC_IZN, 20)
gPIC_CIJ:= PADR(gPIC_CIJ, 20)

gUlPdvKp:= PADR(gUlPdvKp, 1)

nX:=1
Box(, 20, 70)

 set cursor on

 @ m_x + nX, m_y+2 SAY "1. Osnovni podaci ***"

 nX++
 
 @ m_x + nX , m_y+2 SAY "Firma:" GET gFirma
 @ m_x + nX , col() + 1 SAY "Naziv:" GET gNFirma

 nX ++

 @ m_x + nX, m_y+2 SAY "2. Zaokruzenje ***"
 nX++
 
 @ m_x + nX , m_y+2 SAY PADL("iznos ", 30)   GET gZAO_IZN PICT "9"
 nX++
 
 @ m_x + nX, m_y+2 SAY PADL("cijena ", 30)   GET gZAO_CIJ PICT "9"
 nX++
 
 @ m_x + nX, m_y+2 SAY PADL(" podaci na pdv prijavi ", 30)   GET gZAO_PDV PICT "9"
 nX ++

 @ m_x + nX, m_y+2 SAY "3. Prikaz ***"
 nX ++
 
 @ m_x + nX, m_y+2 SAY PADL(" iznos ", 30)   GET gPIC_IZN
 nX ++
 
 @ m_x + nX, m_y+2 SAY PADL(" cijena ", 30)   GET gPIC_CIJ
 nX ++

 @ m_x + nX, m_y+2 SAY "4. Obracun ***"
 nX ++
 
 @ m_x + nX, m_y+2 SAY PADL(" ul. pdv kr.potr-stat fed-1, rs-2, bd-3", 55)   GET gUlPdvKp ;
	VALID gUlPdvKp $ " 123"
 nX ++
 
 @ m_x + nX, m_y+2 SAY "5. Ostalo ***"
 nX ++
 
 @ m_x + nX, m_y+2 SAY PADL(" konta dobavljaci:", 30) GET gL_kto_dob ;
 	PICT "@S30"
 nX ++
 
 @ m_x + nX, m_y+2 SAY PADL("      konta kupci:", 30) GET gL_kto_kup ;
 	PICT "@S30"
 nX ++
 
 @ m_x + nX, m_y+2 SAY PADL("ulazni pdv:", 30) GET gKt_updv ;
 	PICT "@S30"
 nX ++
 
 @ m_x + nX, m_y+2 SAY PADL("izlazni pdv:", 30) GET gKt_ipdv ;
 	PICT "@S30"

 READ

BoxC()

gPIC_IZN := ALLTRIM(gPIC_IZN)
gPIC_CIJ := ALLTRIM(gPIC_CIJ)

if lastkey()<>K_ESC
	write_g_params()
endif

return


// --------------------------------------
// --------------------------------------
function read_g_params()
gZAO_IZN := 2
gZAO_CIJ := 3
gZAO_PDV := 0
gPIC_IZN := "9999999.99"
gPIC_CIJ := "9999999.99"
gUlPdvKp := "1"
gFirma := SPACE(2)
gNFirma := SPACE(20)

SELECT F_KPARAMS

if !used()
	O_KPARAMS
endif
private cSection:="5"
private cHistory:=" "
private aHistory:={}

RPar("Z1", @gZAO_IZN)
RPar("Z2", @gZAO_CIJ)
RPar("Z3", @gZAO_PDV)

RPar("P1", @gPIC_IZN)
RPar("P2", @gPIC_CIJ)

RPar("O1", @gUlPdvKp)

RPar("K1", @gL_kto_dob)
RPar("K2", @gL_kto_kup)
RPar("K3", @gkt_updv)
RPar("K4", @gkt_ipdv)

SELECT F_PARAMS
if !used()
	O_PARAMS
endif
private cSection:="1"
private cHistory:=" "
private aHistory:={}

Rpar("fn",@gNFirma)
Rpar("ff",@gFirma)

close

return


// ---------------------------
// ---------------------------
function write_g_params()

SELECT F_KPARAMS

if !used()
	O_KPARAMS
endif
private cSection:="5"
private cHistory:=" "
private aHistory:={}

WPar("Z1", gZAO_IZN)
WPar("Z2", gZAO_CIJ)
WPar("Z3", gZAO_PDV)

WPar("P1", gPIC_IZN)
WPar("P2", gPIC_CIJ)

WPar("O1", gUlPdvKp)

WPar("K1", gL_kto_dob)
WPar("K2", gL_kto_kup)
WPar("K3", gkt_updv)
WPar("K4", gkt_ipdv)

SELECT F_PARAMS
if !used()
	O_PARAMS
endif
private cSection:="1"
private cHistory:=" "
private aHistory:={}

WPar("ff", gFirma)
WPar("fn", gNFirma)

close

return


// ---------------------------------------------------------------
// ---------------------------------------------------------------
function read_pdv_pars(dPotDatum, cPotMjesto, cPotOb, cPdvPovrat)

SELECT F_PARAMS

if !used()
	O_PARAMS
endif

private cSection:="9"
private cHistory:=" "
private aHistory:={}

RPar("D1", @dPotDatum)
RPar("C1", @cPotMjesto)
RPar("C2", @cPotOb)
RPar("C3", @cPdvPovrat)

close

return

// ---------------------------------------------------------------
// ---------------------------------------------------------------
function save_pdv_pars(dPotDatum, cPotMjesto, cPotOb, cPdvPovrat)

SELECT F_PARAMS

if !used()
	O_PARAMS
endif

private cSection:="9"
private cHistory:=" "
private aHistory:={}

WPar("D1", dPotDatum)
WPar("C1", cPotMjesto)
WPar("C2", cPotOb)
WPar("C3", cPdvPovrat)

close

return

// SET - GET sekcija  za PIC i ZAO vrijednostai

// -------------------------------
// -------------------------------
function ZAO_IZN(xVal)

if xVal <> nil
	gZAO_IZN := xVal
endif

return gZAO_IZN

// -------------------------------
// -------------------------------
function ZAO_CIJ(xVal)

if xVal <> nil
	gZAO_CIJ := xVal
endif

return gZAO_CIJ

// -------------------------------
// -------------------------------
function ZAO_PDV(xVal)

if xVal <> nil
	gZAO_PDV := xVal
endif

return gZAO_PDV


// -------------------------------
// -------------------------------
function PIC_IZN(xVal)
if xVal <> nil
	gPIC_IZN := xVal
endif
return gPIC_IZN

// -------------------------------
// -------------------------------
function PIC_CIJ(xVal)
if xVal <> nil
	gPIC_CIJ := xVal
endif
return gPIC_CIJ


// -------------------------------
// -------------------------------
function gUlPdvKp(xVal)
if xVal <> nil
	gUlPdvKp := xVal
endif
return gUlPdvKp


