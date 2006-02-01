#include "\dev\fmk\epdv\epdv.ch"

static aHeader:={}
static aZaglLen:={5, 50 }
static aZagl:={}

// izvjestaj je u dvije kolone

// lijeva margina
static RPT_LM  := 5

//  row indent
static RPT_RI := 2

// ispis teksta u jednoj koloni
static RPT_W2 := 45

// sirina jedne kolone
static RPT_COL := 58

// sirina razmaka izmedju kolona
static RPT_GAP := 4

// korekcija sirine za bold colone
static RPT_BOLD_DELTA := 2
// tekuca linija reporta
static nCurrLine := 0

static cRptNaziv := "PDV prijava" 

static cTbl := "PDV"

// source 
// 1 - kuf kif podaci
// 2 - pdv baza
static cSource := "1"

static dDatOd
static dDatDo

// -------------------------------------------
// PDV prijava
// -------------------------------------------
function rpt_p_pdv()
local cAzurirati

aDInt := rpt_d_interval (DATE())

dDate := DATE()

dDatOd := aDInt[1]
dDatDo := aDInt[2]

cAzurirati := "D"

nX:=1
Box(, 12, 60)

  // izvjestaj za period
  @ m_x+nX, m_y+2 SAY "Period"
  nX++
  
  @ m_x+nX, m_y+2 SAY "od " GET dDatOd
  @ m_x+nX, col()+2 SAY "do " GET dDatDo
  
  nX += 2
  @ m_x+nX, m_y+2 SAY "obrazac se pravi na osnovu :"
  nX++
  @ m_x+nX, m_y+2 SAY " 1 - kuf/kif"
  nX++
  @ m_x+nX, m_y+2 SAY " 2 - pdv baze" 
  nX++
  @ m_x+nX, m_y+2 SAY " izbor ?" GET cSource ;
  	PICT "@!" ;
	VALID cSource $ "12"
	
  READ
  nX ++

  if cSource == "1"
  	@ m_x+nX, m_y+2 SAY " azurirati podatke u PDV bazu ?" GET cAzurirati ;
	  	PICT "@!" ;
		VALID cAzurirati $ "DN"
	READ

  endif
  
BoxC()

if LastKey()==K_ESC
	closeret
endif

fill_rpt()
show_rpt(  .f.,  .f.)

return




// -----------------------------------
// -----------------------------------
static function cre_r_tbl()
local aArr:={}

close all

ferase ( PRIVPATH + "R_" +  cTbl + ".CDX" )
ferase ( PRIVPATH + "R_" +  cTbl + ".DBF" )

altd()
aArr := get_pdv_fields()

// kreiraj tabelu
dbcreate2(PRIVPATH + "R_" + cTbl + ".DBF", aArr)


return
*}

// ------------------------------------------
// napuni r_pdv
// ------------------------------------------
static function fill_rpt()
cre_r_tbl()

if cSource == "1"
	f_iz_kuf_kif()
else
	f_iz_pdv()
endif

return


// -------------------------------------
// napuni iz kuf i kif podataka
// -------------------------------------
static function f_iz_kuf_kif()
local nBPdv

O_R_PDV
APPEND BLANK
// setuj mem vars
Scatter()

PRIVATE cFilter := ""

// datumski period
cFilter := cm2str(dDatOd) + " <= datum .and. " + cm2str(dDatDo) + ">= datum" 

#ifdef PROBA
MsgBeep(cFilter)
#endif

O_KUF
SET FILTER TO &cFilter
GO TOP

Box(,3, 60)

nCount := 0

// KUF
do while !eof()

++nCount

@ m_x+2, m_y+2 SAY "KUF" + STR(nCount, 6, 0)


cIdTar := id_tar
nBPdv := i_b_pdv
nPdv := i_pdv

do case 
	case t_nab_opor(cIdTar)
		_nab_opor += nBPdv
	case t_nab_uvoz(cIdTar)
		_nab_uvoz += nBPdv
	case t_nab_ne_opor(cIdTar)
		_nab_ne_opor += nBPdv
	case t_nab_st_sr(cIdTar)
		_nab_st_sr += nBPdv
endcase


if ROUND( g_pdv_stopa(cIdTar), 2) > 0
	// oporezivo, obracunat pdv

	if IsIno(id_part)
		// 42 - uvoz, na osnovu sifre partnera
		_u_pdv_uv += nPdv
	else
		// sve ostalo moraju biti domaci obveznici
		// 41 - ulazni pdv, registrovani obveznici
		_u_pdv_r += nPdv
	endif
endif

SELECT KUF

SKIP

enddo

// azuriram R_PDV za stavke KUF-a
SELECT r_pdv
Gather()

SELECT KUF
use


Beep(1)

// ----------------------------------------------------------------------
// idemo sada na izlazne fakture
// ----------------------------------------------------------------------
O_KIF

// datumski period
cFilter := cm2str(dDatOd) + " <= datum .and. " + cm2str(dDatDo) + ">= datum" 

#ifdef PROBA
MsgBeep(cFilter)
#endif

O_KIF
SET FILTER TO &cFilter
GO TOP

// KIF
do while !eof()

++nCount

@ m_x+2, m_y+2 SAY "KIF" + STR(nCount, 6, 0)


cIdTar := id_tar
nBPdv := i_b_pdv
nPdv := i_pdv

do case

	case t_isp_opor(cIdTar)
		// 11 - oporezive isporuke
		_isp_opor += nBPdv
	case t_isp_izv(cIdTar)
		// 12 - isporuke izvoz
		_isp_izv += nBPdv
	case t_isp_neopor(cIdTar)
		// 13 - ostale neoporezive isporuke
		_isp_neopor += nBPdv
	case t_isp_nep_svr(cIdTar)
		// 14 - neposlovne svrhe upotreba
		_isp_nep_svr += nBPdv
		
endcase


if ROUND( g_pdv_stopa(cIdTar), 2) > 0

	// oporezivo, obracunat pdv

	if IsPdvObveznik(id_part)

		_i_pdv_r += nPdv
	
	else
		cRejon := part_rejon(id_part)

		do case
			case cRejon == "2"
				// rs
				_i_pdv_nr_2 += nPdv
			
			case cRejon == "3"
				// bd
				_i_pdv_nr_3 += nPdv
			otherwise
				// federacija
				_i_pdv_nr_1 += nPdv
		endcase
	endif
				
endif

SELECT KIF

SKIP

enddo

// azuriram R_PDV za stavke KUF-a
SELECT r_pdv
Gather()

SELECT KIF
use

Beep(1)


BoxC()

return


// ------------------------------------
// ------------------------------------
static function f_iz_pdv()

SELECT F_PDV

if !used()
	O_PDV
endif

SET ORDER TO TAG "period"
// "period","DTOS(per_od)+DTOS(per_do)"

// pronadji ovaj obracun
SEEK DTOS(dDatOd) + DTOS(dDatDo)

if !found()
	Beep(2)
	MsgBeep("Ne postoji pohranjen PDV obracun #"+;
	   "za period " + CTOD(dDatOd) + "-" + CTOD(dDatDo) )
	use
	return
endif


// kreiraj r_pdv zapis
O_R_PDV
APPEND BLANK

SELECT (F_PDV)
// setuj mem vars
Scatter()

SELECT (F_R_PDV)
// zapisi u report
Gather()

SELECT (F_PDV)
use


return

// ---------------------------------------
// prikaz pdv prijava
// ---------------------------------------
static function show_rpt()

local nLenUk
local nPom1
local nPom2

nCurrLine := 0

START PRINT CRET

nPageLimit := 65

nRow := 0

r_zagl()

SELECT r_pdv
SET ORDER TO TAG "1"
go top


P_COND
? 
?? rpt_lm()
?? PADL( "Obrazac P PDV, ver 01.00", RPT_COL * 2 + RPT_GAP )

?
?? rpt_lm()
?? PADC( " ", RPT_COL * 2 + RPT_GAP )
?? rpt_lm()

?
P_10CPI

P_10CPI
?? SPACE(10)
?? PADC( "P D V   P R I J A V A", ROUND((RPT_COL * 2 + RPT_GAP)/2, 0) )

B_OFF

show_raz_1()

P_12CPI

?? rpt_lm()
?? "1. Identifikacioni broj:" 
?? id_br

?? SPACE(6)
?? "2. Period"
?? per_od 
?? " - " 
?? per_do

show_raz_1()

?? rpt_lm()
?? "3. Naziv poreskog obveznika:"
?? po_naziv

show_raz_1()

?? rpt_lm()
?? "4. Adresa " 
?? po_adresa

show_raz_1()

?? rpt_lm()
?? "5. Postanski broj/Mjesto "
?? po_ptt
?? " / "
?? po_mjesto

show_raz_1()

P_COND

? 
?? rpt_lm()
B_ON
U_ON
?? PADR("I. Isporuke i nabavke (iznosi bez PDV-a)", RPT_COL - RPT_BOLD_DELTA)
U_OFF
B_OFF

show_raz_1()

?? rpt_lm()
?? SPACE(RPT_RI)

cPom := PADR("11. Oporezive isporuke ", RPT_W2) + TRANSFORM(isp_opor, PIC_IZN())
// sirina kolone - indent
?? PADL(cPom, RPT_COL - RPT_RI + 1)

// razmak izmedju kolona
?? SPACE(RPT_GAP)

?? SPACE(RPT_RI)
cPom := PADR("21. Oporezive nabavke ", RPT_W2) + TRANSFORM(nab_opor, PIC_IZN())
?? PADL(cPom, RPT_COL - RPT_RI + 1)


// razmak izmedju dva reda -----------------------------------------
show_raz_1()
?? rpt_lm()
// 12
cPom := PADR("12. Izvoz ", RPT_W2) + TRANSFORM(isp_izv, PIC_IZN())
// sirina kolone - indent
?? SPACE(RPT_RI)
?? PADL(cPom, RPT_COL - RPT_RI + 1)

// razmak izmedju kolona
?? SPACE(RPT_GAP)

// 22
?? SPACE(RPT_RI)
cPom := PADR("22. Uvoz ", RPT_W2) + TRANSFORM(nab_uvoz, PIC_IZN())
?? PADL(cPom, RPT_COL - RPT_RI + 1)


// razmak izmedju dva reda -----------------------------------------
show_raz_1()

?? rpt_lm()
?? SPACE(RPT_RI)

// 13
cPom := PADR("13. Neoporezive isporuke ", RPT_W2) + TRANSFORM(isp_neopor, PIC_IZN())
// sirina kolone - indent
?? PADL(cPom, RPT_COL - RPT_RI + 1)

// razmak izmedju kolona
?? SPACE(RPT_GAP)

?? SPACE(RPT_RI)
// 23
cPom := PADR("23. Nabavke oslobodjene PDV-a ", RPT_W2) + TRANSFORM(nab_ne_opor, PIC_IZN())
?? PADL(cPom, RPT_COL - RPT_RI + 1)


// razmak izmedju dva reda -----------------------------------------
show_raz_1()

?? rpt_lm()
// 14
cPom := PADR("14. Upotr neposl. svrhe ", RPT_W2) + TRANSFORM(isp_nep_svr, PIC_IZN())
// sirina kolone - indent
?? SPACE(RPT_RI)
?? PADL(cPom, RPT_COL - RPT_RI + 1)

// razmak izmedju kolona
?? SPACE(RPT_GAP)

?? SPACE(RPT_RI)
// 24
cPom := PADR("24. Nabavke stalnih sredstava ", RPT_W2) + TRANSFORM(nab_st_sr, PIC_IZN())
?? PADL(cPom, RPT_COL - RPT_RI + 1)

// -------------------- II dio izvjestaja ----------------------------------

show_raz_1()

?
?? rpt_lm()

B_ON
U_ON
?? PADR("II. Izlazni PDV", RPT_COL - RPT_BOLD_DELTA )
U_OFF
B_OFF

?? SPACE(RPT_GAP)
B_ON
U_ON
?? PADL("Ulazni PDV  ", RPT_COL - RPT_BOLD_DELTA)
U_OFF
B_OFF

show_raz_1()
?
?? rpt_lm()
?? SPACE(RPT_RI)

B_ON
?? PADR("Obracunato za isporuke dobara i usluga", RPT_COL - RPT_RI)
B_OFF
?? SPACE(RPT_GAP)

?? SPACE(RPT_RI)

B_ON
?? PADR("Obracunato za nabavku dobara i usluga", RPT_COL - RPT_RI)
B_OFF


// razmak izmedju dva reda -----------------------------------------
show_raz_1()

?? rpt_lm()
?? SPACE(RPT_RI)
// 31
cPom := PADR("31. Registrovani PDV obv.", RPT_W2) + TRANSFORM(i_pdv_r , PIC_IZN())
// sirina kolone - indent
?? PADL(cPom, RPT_COL - RPT_RI + 1)

// razmak izmedju kolona
?? SPACE(RPT_GAP)

?? SPACE(RPT_RI)
// 41
cPom := PADR("41. Registrovani PDV obv.", RPT_W2) + TRANSFORM(u_pdv_r, PIC_IZN())
?? PADL(cPom, RPT_COL - RPT_RI + 1)

// razmak izmedju dva reda -----------------------------------------
show_raz_1()

?? rpt_lm()
?? SPACE(RPT_RI)
cPom := "Lica koja nisu reg PDV obveznici iz:"
// sirina kolone - indent
?? PADR(cPom, RPT_COL - RPT_RI + 1)

// razmak izmedju kolona
?? SPACE(RPT_GAP)

?? SPACE(RPT_RI)
// 42
cPom := PADR("42. Uvoz ", RPT_W2) + TRANSFORM(u_pdv_uv, PIC_IZN())
?? PADL(cPom, RPT_COL - RPT_RI + 1)

// razmak izmedju dva reda -----------------------------------------
show_raz_1()

?? rpt_lm()
?? SPACE(RPT_RI)
cPom := PADR("32. Federacije BiH ", RPT_W2) + TRANSFORM(i_pdv_nr_1, PIC_IZN())
// sirina kolone - indent
?? PADL(cPom, RPT_COL - RPT_RI + 1)

// razmak izmedju kolona
?? SPACE(RPT_GAP)

?? SPACE(RPT_RI)
cPom := " "
?? PADL(cPom, RPT_COL - RPT_RI + 1)

// razmak izmedju dva reda -----------------------------------------
show_raz_1()

?? rpt_lm()
?? SPACE(RPT_RI)
cPom := PADR("33. Republike Srpske ", RPT_W2) + TRANSFORM(i_pdv_nr_2, PIC_IZN())
// sirina kolone - indent
?? PADL(cPom, RPT_COL - RPT_RI + 1)

// razmak izmedju kolona
?? SPACE(RPT_GAP)

?? SPACE(RPT_RI)
cPom := " "
?? PADL(cPom, RPT_COL - RPT_RI + 1)

// razmak izmedju dva reda -----------------------------------------
show_raz_1()
?? rpt_lm()
?? SPACE(RPT_RI)
// 34
cPom := PADR("34. Brcko Distrikta ", RPT_W2) + TRANSFORM(i_pdv_nr_3, PIC_IZN())
// sirina kolone - indent
?? PADL(cPom, RPT_COL - RPT_RI + 1)

// razmak izmedju kolona
?? SPACE(RPT_GAP)

?? SPACE(RPT_RI)
cPom := PADR("43. Preneseno iz predhodnog perioda ", RPT_W2) + TRANSFORM(u_pdv_pp, PIC_IZN())
?? PADL(cPom, RPT_COL - RPT_RI + 1)

// razmak izmedju dva reda -----------------------------------------
show_raz_1()
show_raz_1()

?? rpt_lm()
?? SPACE(RPT_RI)
cPom :=  PADR("51. Izlazni PDV - ukupno ", RPT_W2 - RPT_BOLD_DELTA ) + TRANSFORM(i_pdv_uk, PIC_IZN())
// sirina kolone - indent
B_ON
?? PADL(cPom, RPT_COL - RPT_RI - RPT_BOLD_DELTA + 1 )
B_OFF

// razmak izmedju kolona
?? SPACE(RPT_GAP)

?? SPACE(RPT_RI)
// 61
B_ON
cPom := PADR("61. Ulazni PDV - ukupno ", RPT_W2 - RPT_BOLD_DELTA ) + TRANSFORM(u_pdv_uk, PIC_IZN())
?? PADL(cPom, RPT_COL - RPT_RI - RPT_BOLD_DELTA + 1)
B_OFF

// razmak izmedju dva reda -----------------------------------------
show_raz_1()
show_raz_1()

?? rpt_lm()
?? SPACE(RPT_RI)
// 71
cPom := PADR("71. Obaveza PDV-a za uplatu ", RPT_W2 - RPT_BOLD_DELTA ) + TRANSFORM(pdv_uplatiti, PIC_IZN())
// sirina kolone - indent
B_ON
?? PADL(cPom, RPT_COL - RPT_RI - RPT_BOLD_DELTA + 1)
B_OFF

// razmak izmedju kolona
?? SPACE(RPT_GAP)

?? SPACE(RPT_RI)
// 72
cPom := PADR("72. Preplata ", RPT_W2 - RPT_BOLD_DELTA ) + TRANSFORM(pdv_preplata, PIC_IZN())
B_ON
?? PADL(cPom, RPT_COL - RPT_RI - RPT_BOLD_DELTA  + 1)
B_OFF


// ----- kraj obrasca  -----------------------------------------
show_raz_1()
show_raz_1()

?? rpt_lm()
cPom := "80.  Zahtjev za povrat < " +  pdv_povrat + " >"
// sirina kolone - indent
B_ON
?? PADL(cPom, RPT_COL * 2  + RPT_GAP - 8)
B_OFF

show_raz_1()
show_raz_1()

?? rpt_lm()
?? "Pod krivicnom i materijalnom odgovornoscu potvrdjujem da su podaci u PDV prijavi potuni i tacni"

show_raz_1()
show_raz_1()

?? rpt_lm()
?? "Mjesto : "
U_ON

?? pot_mjesto
U_OFF

?? SPACE(35)
?? "Potpis obveznika"

show_raz_1()

?? rpt_lm()

?? "Datum : "
U_ON
?? pot_datum
U_OFF

?? SPACE(50)
U_ON
?? PADR(pot_ob, 55)
U_OFF

show_raz_1()
?? rpt_lm()
?? SPACE(86)
?? "Ime, prezime"


FF
END PRINT
return
*}

// -----------------------------
// -----------------------------
static function show_raz_1()
?
?
return

// ----------------------------
// ----------------------------
static function r_zagl()

// header
P_COND
B_ON
for i:=1 to LEN(aHeader)
 ? aHeader[i]
 ++nCurrLine
next
B_OFF

P_COND2


for i:=1 to LEN(aZagl)
 ++nCurrLine
 ?
 for nCol:=1 to LEN(aZaglLen)
  	// mergirana kolona ovako izgleda
	// "#3 Zauzimam tri kolone"
 	if LEFT(aZagl[i, nCol],1) = "#" 
	  
	  nMergirano := VAL( SUBSTR(aZagl[i, nCol], 2, 1 ) )
	  cPom := SUBSTR(aZagl[i,nCol], 3, LEN(aZagl[i,nCol])-2)
	  nMrgWidth := 0
	  for nMrg:=1 to nMergirano 
	  	nMrgWidth += aZaglLen[nCol+nMrg-1] 
		nMrgWidth ++
	  next
	  ?? PADC(cPom, nMrgWidth)
	  ?? " "
	  nCol += (nMergirano - 1)
	 else
 	  ?? PADC(aZagl[i, nCol], aZaglLen[nCol])
	  ?? " "
	 endif
 next
next

return

// -----------------------------------
// lijeva margina
// ------------------------------------
static function rpt_lm()
return SPACE(RPT_LM)
