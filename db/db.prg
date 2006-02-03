#include "\dev\fmk\epdv\epdv.ch"

/*
 * ----------------------------------------------------------------
 *                                     Copyright Sigma-com software 
 * ----------------------------------------------------------------
 */
 

/*! \file fmk/fin/db/2g/db.prg
 *  \brief TDBFin database objekat
 */


/*! \fn TDBePdvNew()
 *  \brief Kreira novi database objekat TDBFin
 */
 
function TDBePdvNew()
*{
local oObj

oObj:=TDBePdv():new()
oObj:self:=oObj
oObj:cName:="EPDV"
oObj:lAdmin:=.f.
return oObj
*}



#include "class(y).ch"
CREATE CLASS TDBePdv INHERIT TDB 
	EXPORTED:
	var self
	method skloniSezonu	
	method install	
	method setgaDBFs	
	method ostalef	
	method obaza	
	method kreiraj	
	method konvZn
	method scan

END CLASS


*void TDBePdv::dummy()
*{
method dummy
return
*}


/*! \fn *void TDBePdv::skloniSez(string cSezona, bool finverse, bool fda, bool lNulirati, bool fRS)
 *  \brief formiraj sezonsku bazu podataka
 */
 
method skloniSezonu(cSezona, finverse, fda, lNulirati, fRS)
local cScr

save screen to cScr

if fda==nil
  fDA:=.f.
endif
if finverse==nil
  finverse:=.f.
endif
if lNulirati==nil
  lNulirati:=.f.
endif
if fRS==nil
  // mrezna radna stanica , sezona je otvorena
  fRS:=.f.
endif

if fRS // radna stanica
  if file(ToUnix(PRIVPATH+cSezona+"\P_KUF.DBF"))
      // nema se sta raditi ......., pripr.dbf u sezoni postoji !
      return
  endif
  aFilesK:={}
  aFilesS:={}
  aFilesP:={}
endif

if KLevel<>"0"
	MsgBeep("Nemate pravo na koristenje ove opcije")
endif

cls

if fRS
	// mrezna radna stanica
	? "Formiranje DBF-ova u privatnom direktoriju, RS ...."
endif
?
if finverse
 	? "Prenos iz  sezonskih direktorija u radne podatke"
else
	? "Prenos radnih podataka u sezonske direktorije"
endif
?
// privatni
fnul:=.f.
Skloni(PRIVPATH,"P_KUF.DBF",cSezona,finverse,fda,fnul)
Skloni(PRIVPATH,"P_KIF.DBF",cSezona,finverse,fda,fnul)
Skloni(PRIVPATH,"FMK.INI",cSezona,finverse,fda,fnul)

if fRS
 // mrezna radna stanica!!! , baci samo privatne direktorije
 ?
 ?
 ?
 Beep(4)
 ? "pritisni nesto za nastavak.."

 restore screen from cScr
 return
endif

if lNulirati
	fnul:=.t.
else
	fnul:=.f.
endif  
Skloni(KUMPATH,"KIF.DBF",cSezona,finverse,fda,fnul)
Skloni(KUMPATH,"KUF.DBF",cSezona,finverse,fda,fnul)
Skloni(KUMPATH,"PDV.DBF",cSezona,finverse,fda,fnul)

fnul:=.f.
Skloni(KUMPATH,"SG_KIF.DBF",cSezona,finverse,fda,fnul)
Skloni(KUMPATH,"SG_KUF.DBF",cSezona,finverse,fda,fnul)
Skloni(KUMPATH,"FMK.INI",cSezona,finverse,fda,fnul)

?
?
?
Beep(4)
? "pritisni nesto za nastavak.."

restore screen from cScr
return
*}

/*! \fn *void TDBePdv::setgaDBFs()
 *  \brief Setuje matricu gaDBFs 
 */
*void TDBFin::setgaDBFs()
*{
method setgaDBFs()
PUBLIC gaDBFs:={}

AADD(gaDBFs, { F_P_KIF, "P_KIF", P_PRIVPATH  } )
AADD(gaDBFs, { F_P_KUF, "P_KUF", P_PRIVPATH  } )

AADD(gaDBFs, { F_KUF, "KUF", P_KUMPATH  } )
AADD(gaDBFs, { F_KIF, "KIF", P_KUMPATH  } )
AADD(gaDBFs, { F_PDV, "PDV", P_KUMPATH  } )

AADD(gaDBFs, { F_SG_KIF, "SG_KIF", P_KUMPATH } )
AADD(gaDBFs, { F_SG_KUF, "SG_KUF", P_KUMPATH } )

return
*}

/*! \fn *void TDBePdv::install(string cKorisn,string cSifra,variant p3,variant p4,variant p5,variant p6,variant p7)
 *  \brief osnovni meni za instalacijske procedure
 *  \todo  prosljedjuje se goModul, ovo ce biti eliminsano eliminisanjem ISC_START-a procedure (tj zamjenom odgovarajucim klasama)
 */

*void TDBePdv::install(string cKorisn,string cSifra,variant p3,variant p4,variant p5,variant p6,variant p7)
*{
method install()
ISC_START(goModul,.f.)
return
*}

/*! *void TDBePdv::kreiraj(int nArea)
 *  \brief kreirane baze podataka EPDV
 */
 
*void TDBePdv::kreiraj(int nArea)
*{
method kreiraj(nArea)
local cImeDbf


if (nArea==nil)
	nArea:=-1
endif

Beep(1)

if (nArea<>-1)
	CreSystemDb(nArea)
endif


CreFmkSvi()
CreRoba()
CreFmkPi()

cre_tbls(nArea, "PDV")
cre_tbls(nArea, "KUF")
cre_tbls(nArea, "KIF")
cre_tbls(nArea, "P_KIF")
cre_tbls(nArea, "P_KUF")
cre_tbls(nArea, "SG_KIF")
cre_tbls(nArea, "SG_KUF")

cre_sifk(nArea)

return


// ----------------------------------------------
// pdv fields
// ----------------------------------------------
function get_pdv_fields()

local aDbf

aDbf:={}
// datum kreiranja
AADD(aDBf,{ "datum_1"    , "D" ,   8 ,  0 })

// datum posljednje ispravke
AADD(aDBf,{ "datum_2"      , "D" ,   8 ,  0 })

// datum zakljucavanja
AADD(aDBf,{ "datum_3"      , "D" ,   8 ,  0 })


// identifikacijski broj
AADD(aDBf,{ "id_br"      , "C" ,   12 ,  0 })

// period od
AADD(aDBf,{ "per_od"      , "D" ,   8 ,  0 })
// do
AADD(aDBf,{ "per_do"      , "D" ,   8 ,  0 })

// naziv poreskog obveznika
AADD(aDBf,{ "po_naziv"      , "C" ,   60 ,  0 })

// adresa
AADD(aDBf,{ "po_adresa"      , "C" ,   60 ,  0 })

// ptt broj
AADD(aDBf,{ "po_ptt"      , "C" ,   10 ,  0 })
// mjesto
AADD(aDBf,{ "po_mjesto"      , "C" ,   40 ,  0 })

// 11 - oporezive isporuke
AADD(aDBf,{ "isp_opor"      , "N" ,   18 ,  2 })
// 12 - isporuke izvoz
AADD(aDBf,{ "isp_izv"      , "N" ,   18 ,  2 })
// 13 - ostale neoporezive isporuke
AADD(aDBf,{ "isp_neopor"    , "N" ,   18 ,  2 })
// 14 - neposlovne svrhe upotreba
AADD(aDBf,{ "isp_nep_svr"    , "N" ,   18 ,  2 })

// 21 - oporezive nabavke
AADD(aDBf,{ "nab_opor"    , "N" ,   18 ,  2 })
// 22  - uvoz
AADD(aDBf,{ "nab_uvoz"    , "N" ,   18 ,  2 })
// 23 - nabavke oslobodjene pdv
AADD(aDBf,{ "nab_ne_opor" , "N" ,   18 ,  2 })
// 24 - nabavka stalnih sredstava
AADD(aDBf,{ "nab_st_sr" , "N" ,   18 ,  2 })

// 31 - pdv za registrovane pdv obveznike
AADD(aDBf,{ "i_pdv_r" , "N" ,   18 ,  2 })
// 32 - pdv za neregistovane, federacija
AADD(aDBf,{ "i_pdv_nr_1" , "N" ,   18 ,  2 })
// 33 - rs
AADD(aDBf,{ "i_pdv_nr_2" , "N" ,   18 ,  2 })
// 34 - bdistrikt
AADD(aDBf,{ "i_pdv_nr_3" , "N" ,   18 ,  2 })
// ne koristi se
AADD(aDBf,{ "i_pdv_nr_4" , "N" ,   18 ,  2 })


// 41 - ulazni pdv, registrovani obveznici
AADD(aDBf,{ "u_pdv_r" , "N" ,   18 ,  2 })
// 42 - uvoz
AADD(aDBf,{ "u_pdv_uv" , "N" ,   18 ,  2 })

// 43 - preneseno iz predhodnog perioda
AADD(aDBf,{ "u_pdv_pp" , "N" ,   18 ,  2 })

// 51 izlazni pdv ukupno
AADD(aDBf,{ "i_pdv_uk" , "N" ,   18 ,  2 })

// 61
AADD(aDBf,{ "u_pdv_uk" , "N" ,   18 ,  2 })

// 71 obaveza za uplatu, ako ima
AADD(aDBf,{ "pdv_uplatiti" , "N" ,   18 ,  2 })
// 72 preplaceno pdv-a ako jeste
AADD(aDBf,{ "pdv_preplata" , "N" ,   18 ,  2 })

// 80 zahtjev za povrat
//  D - da
//  N - ne
AADD(aDBf,{ "pdv_povrat" , "C" ,   1,  0 })


// potpis mjesto
AADD(aDBf,{ "pot_mjesto" , "C" ,   40,  0 })
// potpis datum 
AADD(aDBf,{ "pot_datum" ,  "D" ,   8,  0 })
// potpis obveznik pdv-a
AADD(aDBf,{ "pot_ob" ,  "C" ,   80,  0 })

// zakljucan obracun
AADD(aDBf,{ "lock" ,  "C" ,   1,  0 })

return aDbf


// ------------------------------------------------------
// kif struktura
// ------------------------------------------------------
static function get_kif_fields()
local aDbf

aDbf:={}
AADD(aDBf,{ "datum" , "D" ,   8 ,  0 })

// ne koristi se
AADD(aDBf,{ "datum_2" , "D" ,   8 ,  0 })

// 1 - FIN
// 2 - KALK
// 3 - FAKT
// 4 - OS
// 5 - SII
AADD(aDBf,{ "src"  , "C" ,   1 ,  0 })

// tip dokumenta 
// 
AADD(aDBf,{ "td_src" , "C" ,   2,  0 })

// podnivo src-a
// ako nam je to potrebno, ako nije empty
AADD(aDBf,{ "src_2"  , "C" ,   1,  0 })

AADD(aDBf,{ "id_tar" , "C" ,   6,  0 })
AADD(aDBf,{ "id_part" , "C" ,   6,  0 })

// id partner, id broj
AADD(aDBf,{ "part_idbr" , "C" ,   13,  0 })

// kategorija partnera
// 1-pdv obveznik
// 2-ne pdv obvezink
AADD(aDBf,{ "p_kat"  , "C" ,   1,  0 })

// za ne-pdv obveznike
//   1-federacija
//   2-rs
//   3-distrikt brcko
AADD(aDBf,{ "p_kat_2" , "C" ,   1,  0 })


// source dokument prodajno mjesto
AADD(aDBf,{ "src_pm" , "C" ,  6,  0 })

AADD(aDBf,{ "src_td" , "C" ,  12,  0 })

// source dokument broj
AADD(aDBf,{ "src_br" , "C" ,  12,  0 })

// source dokument broj - veza
//  ako slucaj avansne fakture:
//   05.01 - src_br = 00005,  i_b_pdv = 500 KM  opis=avans 50%
//  nakon toga desi se placanje
//   12.02 - src_br = 00033 (broj fakture),   src_veza_br = 00005
//           i_b_pdv = 500 KM (placeno po avansnoj fakturi)
//           i_v_b_pdv = 1000 KM (placeno po fakturi)
//  kako vidimo veza broj je broj avansne fakture 
AADD(aDBf,{ "src_veza_br"  , "C" ,  12,  0 })


// source dokument eksterni broj 
// (br dobavljaca ako je razlicit od brdokumenta)
AADD(aDBf,{ "src_br_2"  , "C" ,  12,  0 })


// redni broj stavke unutar dokumenta
AADD(aDBf,{ "r_br"      , "N" ,   6,  0 })

// broj kif dokumenta kod knjizenja
AADD(aDBf,{ "br_dok"      , "N" ,   6,  0 })

// globalni redni broj kif-a 
AADD(aDBf,{ "g_r_br"      , "N" ,   8,  0 })

// lock = D - zakljucano i ne moze se renumerisati i mjenjati 
// (osim stavki kao sto je opis itd)
AADD(aDBf,{ "lock"      , "C" ,   1,  0 })

// kategorija stavke
//  1  - dnevni bezgotovinski promet
//  2  - dnevni gotovinski promet
//  3  - gotovinski promet bez racuna iz clana 120 pravilnika ZPDV
//  4  - racun za isporuke bez naknade ili uz licni popust
//  5  - naknadne ispravke racuna
AADD(aDBf,{ "kat"      , "C" ,   1,  0 })

// kategorija 2 stavke
//  1  - izlazne fakture PDV obveznicima 
//  2  - izlazne fakture ne-PDV obveznicima 
//  3  - izlazne fakture izvoz, oslobodjen od pdv-a
//  4  - izlazne fakture oslobodjene od PDV-a po ostalim osnovama
//  5  - primljeni avansi - avansne fakture 
//  6  -  izvanposlovne svrhe
AADD(aDBf,{ "kat_2"    , "C" ,   1,  0 })

// opis stavke
AADD(aDBf,{ "opis"      , "C" ,   160,  0 })

// iznos bez pdv-a - osnovica
AADD(aDBf,{ "i_b_pdv"      , "N" ,   16,  2 })
// pdv
AADD(aDBf,{ "i_pdv"      , "N" ,   16,  2 })


// vezna stavka, iznos bez pdv-a - ako imamo veznu stavku
// (pogledati gore primjer avansne fakture)
AADD(aDBf,{ "i_v_b_pdv"      , "N" ,   16,  2 })
AADD(aDBf,{ "i_v_pdv"      , "N" ,   16,  2 })


// status stavke
//  " " - nepoznato
//  1 - nije placeno
//  2 - placeno
AADD(aDBf,{ "status"      , "C" ,   1,  0 })

return aDbf


// ------------------------------------------------------
// kuf struktura
// ------------------------------------------------------
function get_kuf_fields()
local aDbf

aDbf:={}
AADD(aDBf,{ "datum"      , "D" ,   8 ,  0 })

// ne koristi se
AADD(aDBf,{ "datum_2"      , "D" ,   8 ,  0 })

// 1 - FIN
// 4 - OS
// 5 - SII
AADD(aDBf,{ "src"      , "C" ,   1 ,  0 })

// tip dokumenta 
// 
AADD(aDBf,{ "td_src"      , "C" ,   2,  0 })

// podnivo source-a
// ako nam je to potrebno, ako nije empty
AADD(aDBf,{ "src_2"      , "C" ,   1,  0 })

AADD(aDBf,{ "id_tar"    , "C" ,   6,  0 })
AADD(aDBf,{ "id_part"   , "C" ,   6,  0 })

// id partner, id broj
AADD(aDBf,{ "part_idbr"      , "C" ,   13,  0 })

// kategorija partnera
// 1-pdv obveznik
// 2-ne pdv obvezink
AADD(aDBf,{ "p_kat"      , "C" ,   1,  0 })

// ne koristi se trenutno
AADD(aDBf,{ "p_kat_2"      , "C" ,   1,  0 })


AADD(aDBf,{ "src_td"      , "C" ,  12,  0 })

// source dokument broj
AADD(aDBf,{ "src_br"      , "C" ,  12,  0 })

// source dokument broj - veza
//  ako slucaj avansne fakture:
//   05.01 - src_br = 00005,  i_b_pdv = 500 KM  opis=avans 50%
//  nakon toga desi se placanje
//   12.02 - src_br = 00033 (broj fakture),   src_veza_br = 00005
//           i_b_pdv = 500 KM (placeno po avansnoj fakturi)
//           i_v_b_pdv = 1000 KM (placeno po fakturi)
//  kako vidimo veza broj je broj avansne fakture 
AADD(aDBf,{ "src_veza_br"      , "C" ,  12,  0 })


// source dokument eksterni broj 
// (br dobavljaca ako je razlicit od brdokumenta)
AADD(aDBf,{ "src_br_2"      , "C" ,  12,  0 })


// redni broj stavke
AADD(aDBf,{ "r_br"      , "N" ,   6,  0 })

// broj kuf dokumenta kod knjizenja
AADD(aDBf,{ "br_dok"      , "N" ,   6,  0 })


// globalni redni broj kuf-a 
AADD(aDBf,{ "g_r_br"      , "N" ,   8,  0 })

// lock = D - zakljucano i ne moze se renumerisati i mjenjati 
// (osim stavki kao sto je opis itd)
AADD(aDBf,{ "lock"      , "C" ,   1,  0 })

// kategorija stavke
//  1  - ima pravo na odbitak pdv-a
//  2  - nema pravo na odbitak
AADD(aDBf,{ "kat"      , "C" ,   1,  0 })

// kategorija 2 stavke
// trenutno se ne koristi
AADD(aDBf,{ "kat_2"    , "C" ,   1,  0 })

// opis stavke
AADD(aDBf,{ "opis"      , "C" ,   160,  0 })

// iznos bez pdv-a - osnovica
AADD(aDBf,{ "i_b_pdv"      , "N" ,   16,  2 })
// pdv
AADD(aDBf,{ "i_pdv"      , "N" ,   16,  2 })


// vezna stavka, iznos bez pdv-a - ako imamo veznu stavku
// (pogledati gore primjer avansne fakture)
AADD(aDBf,{ "i_v_b_pdv"      , "N" ,   16,  2 })
AADD(aDBf,{ "i_v_pdv"      , "N" ,   16,  2 })


// status stavke
//  " " - nepoznato
//  1 - nije placeno
//  2 - placeno
AADD(aDBf,{ "status"      , "C" ,   1,  0 })

return aDbf

// -----------------------------
// gen shema kuf, kif fields
// -----------------------------
function g_sg_fields()
local aDbf

aDbf:={}

// 0001 - stavka 1, 0002 - stavka 2 itd ...
AADD(aDBf, { "id"      , "C" ,   4,  0 })

// npr: "got. promet prodavnica Tuzla 1"
AADD(aDBf, { "naz"      , "C" ,   60,  0 })


// src - pogledaj g_src_modul(cSrc)
AADD(aDBf,{ "src"      , "C" ,   1,  0 })

// tip dokumenta source-a 
AADD(aDBf,{ "td_src"      , "C" ,   2,  0 })

// source path kumulativ
AADD(aDBf,{ "s_path"      , "C" ,   60,  0 })
// ako je potreban i sifrarnik
AADD(aDBf,{ "s_path_s"      , "C" ,   60,  0 })

// formula za izracunavanje osnovice - iznos b. pdv
AADD(aDBf,{ "form_b_pdv"      , "C" ,   160,  0 })

// formula za izracunavanje PDV-a
AADD(aDBf,{ "form_pdv"      , "C" ,   160,  0 })

// tarifa dobra, moze se navesti vise tarifa sa ";"
AADD(aDBf,{ "id_tar"      , "C" ,   160,  0 })
// ako se podaci uzimaju iz fin-a, onda nam je konto najbitniji
// moze se uzeti vise konta iz fin-a
AADD(aDBf,{ "id_kto"      , "C" ,   160,  0 })

// "PKONTO", "MKONTO" , "IDKONTO"
AADD(aDBf,{ "id_kto"      , "C" ,   10,  0 })

// svaki konto posebno
// razbij za svaku tarifu posebno, ako ih ima vise
// D - da
// N - ne
AADD(aDBf,{ "razb_tar"      , "C" ,   1,  0 })

// razbij za svaki konto posebno, ako ih vise ima
// D - da
// N - ne
AADD(aDBf,{ "razb_kto"      , "C" ,   1,  0 })

// razbij po danima
// D - da
// N - ne
AADD(aDBf,{ "razb_dan"      , "C" ,   1,  0 })

// kategorija partnera
// shema se primjenjuje samo za odredjenu kategoriju partnera
AADD(aDBf,{ "kat_p"        , "C" ,   1,  0 })
AADD(aDBf,{ "kat_p_2"      , "C" ,   1,  0 })

// set id tarifa kod kuf/kif stavke
AADD(aDBf,{ "s_id_tar"      , "C" ,   6,  0 })

// setuj id partnera
AADD(aDBf,{ "s_id_par"      , "C" ,   6,  0 })

// aktivan 
// D - da
// N - ne
AADD(aDBf,{ "aktivan"      , "C" ,   1,  0 })

return aDbf


function g_sifk_fields(aDbf)
		
aDbf := {}
AADD(aDBf,{ 'ID'                  , 'C' ,   8 ,  0 })
AADD(aDBf,{ 'SORT'                , 'C' ,   2 ,  0 })
AADD(aDBf,{ 'NAZ'                 , 'C' ,  25 ,  0 })
AADD(aDBf,{ 'Oznaka'              , 'C' ,   4 ,  0 })
AADD(aDBf,{ 'Veza'                , 'C' ,   1 ,  0 })
AADD(aDBf,{ 'Unique'              , 'C' ,   1 ,  0 })
AADD(aDBf,{ 'Izvor'               , 'C' ,  15 ,  0 })
AADD(aDBf,{ 'Uslov'               , 'C' , 100 ,  0 })
AADD(aDBf,{ 'Duzina'              , 'N' ,   2 ,  0 })
AADD(aDBf,{ 'Decimal'             , 'N' ,   1 ,  0 })
AADD(aDBf,{ 'Tip'                 , 'C' ,   1 ,  0 })
AADD(aDBf,{ 'KVALID'              , 'C' , 100 ,  0 })
AADD(aDBf,{ 'KWHEN'               , 'C' , 100 ,  0 })
AADD(aDBf,{ 'UBROWSU'             , 'C' ,   1 ,  0 })
AADD(aDBf,{ 'EDKOLONA'            , 'N' ,   2 ,  0 })
AADD(aDBf,{ 'K1'                  , 'C' ,   1 ,  0 })
AADD(aDBf,{ 'K2'                  , 'C' ,   2 ,  0 })
AADD(aDBf,{ 'K3'                  , 'C' ,   3 ,  0 })
AADD(aDBf,{ 'K4'                  , 'C' ,   4 ,  0 })
// Primjer:
// ID   = ROBA
// NAZ  = Barkod
// Oznaka = BARK
// VEZA  = N ( 1 - moze biti samo jedna karakteristika, N - n karakteristika)
// UNIQUE = D - radi se o jedinstvenom broju
// Izvor =  ( sifrarnik  koji sadrzi moguce vrijednosti)
// Uslov =  ( za koje grupe artikala ova karakteristika je interesantna
// Tip = C ( N numericka, C - karakter, D datum )
// Valid = "ImeFje()"
// validacija  mogu biti vrijednosti A,B,C,D
//             aktiviraj funkciju ImeFje()

return aDbf



// cre kuf tabelu
function cre_tbls(nArea, cTable)
local nArea2 := 0
local aDbf
local cPath


do case 
	case cTable == "KUF"
		nArea2 := F_KUF
	case cTable == "KIF"
		nArea2 := F_KIF
	case cTable == "P_KIF"
		nArea2 := F_P_KIF
	case cTable == "P_KUF"
		nArea2 := F_P_KUF
	case cTable == "SG_KIF"
		nArea2 := F_SG_KIF
	case cTable == "SG_KUF"
		nArea2 := F_SG_KUF
	case cTable == "PDV"
		nArea2 := F_PDV
endcase

if (nArea==-1 .or. nArea == nArea2)
	
	do case 
		case cTable == "KUF" .or. cTable == "P_KUF"
			aDbf := get_kuf_fields()
			
		case cTable == "KIF" .or. cTable == "P_KIF"
			aDbf := get_kif_fields()
			
		case cTable == "SG_KIF" 
			aDbf := g_sg_fields()
			
		case cTable == "SG_KUF" 
			aDbf := g_sg_fields()
			
		case cTable == "PDV" 
			aDbf := get_pdv_fields()
			
	endcase

	do case 
		case LEFT(cTable, 2) == "P_"
			cPath := PRIVPATH
		otherwise
			cPath := KUMPATH
		
	endcase

	
	if !FILE(cPath + cTable + ".DBF")
		DBcreate2(cPath + cTable + ".DBF", aDbf)
	endif

	do case 
		case (nArea2 == F_P_KUF)  .or. (nArea2 == F_P_KIF)
		  CREATE_INDEX("datum","dtos(datum)+src_br_2", cPath + cTable)
		  CREATE_INDEX("l_datum","lock+dtos(datum)+src_br_2", cPath + cTable)
		  CREATE_INDEX("br_dok", "STR(br_dok,6,0)+STR(r_br,6,0)", cPath + cTable)
		 
		case (nArea2 == F_KUF) .or. (nArea2 == F_KIF)
		  CREATE_INDEX("datum","dtos(datum)+src_br_2", cPath + cTable)
		  CREATE_INDEX("l_datum","lock+dtos(datum)+src_br_2", cPath + cTable)
		  CREATE_INDEX("g_r_br","STR(g_r_br,6,0)+dtos(datum)", cPath + cTable)
		  CREATE_INDEX("BR_DOK","STR(BR_DOK, 6, 0)+STR(r_br,6,0)", cPath + cTable)
		
		case (nArea2 == F_SG_KUF) .or. (nArea2 == F_SG_KIF)
		   CREATE_INDEX("id","id", cPath + cTable)
		   CREATE_INDEX("naz","id", cPath + cTable)

		case (nArea2 == F_PDV) 
		   CREATE_INDEX("period","DTOS(per_od)+DTOS(per_do)", cPath + cTable)
		
	endcase
		  
		
endif
return 


// --------------------------------
// --------------------------------
function cre_sifk(nArea)
local cTbl

if (nArea==-1 .or. nArea == F_SIFK)

	aDbf := g_sifk_fields()
	cTbl := "SIFK"

	if !FILE( SIFPATH+ cTbl + '.DBF' )
		dbcreate2(SIFPATH+ cTbl + '.DBF', aDbf)
	endif
	
	CREATE_INDEX("ID","id+SORT+naz", SIFPATH+cTbl)
	CREATE_INDEX("ID2","id+oznaka", SIFPATH+cTbl)
	CREATE_INDEX("NAZ","naz", SIFPATH+cTbl)
endif

return



























/*! \fn *void TDBePdv::obaza(int i)
 *  \brief otvara odgovarajucu tabelu
 *  
 *  S obzirom da se koristi prvenstveno za instalacijske funkcije
 *  otvara tabele u exclusive rezimu
 */

*void TDBePdv::obaza(int i)
*{
method obaza (i)
local lIdIDalje
local cDbfName

lIdiDalje:=.f.


if i==F_KUF .or. i==F_KIF .or. i==F_PDV 
	lIdiDalje:=.t.
endif

if i==F_P_KUF .or. i==F_P_KIF 
	lIdidalje:=.t.
endif

if i==F_SG_KUF .or. i==F_SG_KIF 
	lIdidalje:=.t.
endif

if lIdiDalje
	cDbfName:=DBFName(i,.t.)
	if gAppSrv 
		? "OPEN: " + cDbfName + ".DBF"
		if !File(cDbfName + ".DBF")
			? "Fajl " + cDbfName + ".dbf ne postoji!!!"
			use
			return
		endif
	endif
	
	select(i)
	usex(cDbfName)
else
	use
	return
endif

return
*}

/*! \fn *void TDBePdv::ostalef()
 *  \brief Ostalef funkcije (bivsi install modul)
*/

*void TDBePdv::ostalef()
*{

method ostalef()

closeret
return
*}

/*! \fn *void TDBePdv::konvZn()
 *  \brief Koverzija znakova
 *  \note sifra: KZ
 */
 
*void TDBePdv::konvZn()
*{
method konvZn()

LOCAL cIz:="7", cU:="8", aPriv:={}, aKum:={}, aSif:={}
LOCAL GetList:={}, cSif:="D", cKum:="D", cPriv:="D"
if !gAppSrv
	IF !SigmaSif("KZ      ")
   		RETURN
 	ENDIF
	Box(,8,50)
  	@ m_x+2, m_y+2 SAY "Trenutni standard (7/8)        " GET cIz   VALID   cIz$"78"  PICT "9"
  	@ m_x+3, m_y+2 SAY "Konvertovati u standard (7/8/A)" GET cU    VALID    cU$"78A" PICT "@!"
  	@ m_x+5, m_y+2 SAY "Konvertovati sifrarnike (D/N)  " GET cSif  VALID  cSif$"DN"  PICT "@!"
  	@ m_x+6, m_y+2 SAY "Konvertovati radne baze (D/N)  " GET cKum  VALID  cKum$"DN"  PICT "@!"
  	@ m_x+7, m_y+2 SAY "Konvertovati priv.baze  (D/N)  " GET cPriv VALID cPriv$"DN"  PICT "@!"
  	READ
  	IF LASTKEY()==K_ESC
		BoxC()
		RETURN
	ENDIF
  	IF Pitanje(,"Jeste li sigurni da zelite izvrsiti konverziju (D/N)","N")=="N"
    		BoxC()
		RETURN
  	ENDIF
 	BoxC()
else
	?
	cKonvertTo:=IzFmkIni("FMK","KonvertTo","78",EXEPATH)
	
	if cKonvertTo=="78"
		cIz:="7"
		cU:="8"
		? "Trenutni standard: " + cIz
		? "Konvertovati u: " + cU 
	elseif cKonvertTo=="87"
		cIz:="8"
		cU:="7"
		? "Trenutni standard: " + cIz
		? "Konvertovati u: " + cU 
	else // pitaj
		?
		@ 10, 2 SAY "Trenutni standard (7/8)        " GET cIz VALID cIz$"78" PICT "9"
		?
		@ 11, 2 SAY "Konvertovati u standard (7/8/A)" GET cU VALID cU$"78A" PICT "@!"
		read
	endif
	cSif:="D"
	cKum:="D"
	cPriv:="D"
endif
 
aKum  := { F_KIF, F_KUF, F_PDV }
aPriv := { }
aSif  := { }

 IF cSif  == "N"; aSif  := {}; ENDIF
 IF cKum  == "N"; aKum  := {}; ENDIF
 IF cPriv == "N"; aPriv := {}; ENDIF

KZNbaza(aPriv,aKum,aSif,cIz,cU)

return
*}


/*! \fn *void TDbePdv::scan()
 */
*void TDbePdv::scan()
*{
method scan
return

return
*}

