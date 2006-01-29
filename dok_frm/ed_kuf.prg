#include "\dev\fmk\epdv\epdv.ch"

/*
 * ----------------------------------------------------------------
 *                                     Copyright Sigma-com software 
 * ----------------------------------------------------------------
 *
 */

// ---------------------------------------------
// edit KUF-a
// ---------------------------------------------
function ed_kuf()
*{

// procitaj parametre
read_params()

// otvori tabele
o_kuf()

// prikazi tabelu pripreme
tbl_priprema()

return
*}


// ---------------------------------------------
// ---------------------------------------------
static function read_params()

/*
O_PARAMS
private cSection:="1"
private cHistory:=" "
private aHistory:={}
Params1()
//RPar("po",@gPotpis)
select params
use
*/
return

// ------------------------------------------------
// otvori tabele potrebne za ispravku kuf-a
// ------------------------------------------------
function o_kuf()

select F_KUF
if !used()
	O_KUF
endif

select F_TARIFA
if !used()
	O_TARIFA
endif

select F_PARTN
if !used()
	O_PARTN
endif

return



// ---------------------------------------------
// prikazi tabelu pripreme
// ---------------------------------------------
static function tbl_priprema()


Box(,20,77)
@ m_x+18,m_y+2 SAY "<c-N>  Nove Stavke    | <ENT> Ispravi stavku   | <c-T> Brisi Stavku         "
@ m_x+19,m_y+2 SAY "<c-A>  Ispravka Naloga| <c-P> Stampa dokumenta | <a-A> Azuriranje           "

private ImeKol
private Kol

set_a_kol( @ImeKol, @Kol)
ObjDbedit("ekuf", 20, 77, {|| t_kuf_k_handler()}, "", "KUF Priprema...", , , , , 3)
BoxC()
closeret


// ---------------------------------------------
// postavi matrice ImeKol, Kol
// ---------------------------------------------
static function set_a_kol( aKol, aImeKol )

aImeKol := {}

AADD(aImeKol, {"R.br", {|| r_br}, "r_br", {|| .t.}, {|| .t.} })
AADD(aImeKol, {"Datum", {|| datum_1}, "datum_1", {|| .t.}, {|| .t.} })
AADD(aImeKol, {"opis", {|| opis}, "opis", {|| .t.}, {|| .t.} })
AADD(aImeKol, {"i.b.pdv", {|| i_b_pdv}, "i_b_pdv", {|| .t.}, {|| .t.} })
AADD(aImeKol, {"pdv", {|| i_pdv}, "i_pdv", {|| .t.}, {|| .t.} })


aKol:={}
for i:=1 to LEN(aImeKol)
	AADD(aKol,i)
next

return


// ---------------------------------------------
// ---------------------------------------------
static function ed_item(lNova)
local _ispravno := "D"


Box(, 10, 70)
if lNova
	_r_br := next_rbr()
	_id_part:= SPACE(LEN(id_part))
	_id_tar:= PADR("PDV17", LEN(id_tar))
	_datum := DATE()
	_opis:= SPACE(LEN(opis))
	_i_b_pdv := 0
	_i_pdv := 0
endif

@ m_x+1, m_y+2 SAY "R.br: " GET _rbr
@ m_x+1, col()+2 SAY "datum: " GET _datum

@ m_x+2, m_y+2 SAY "opis: " GET _opis


@ m_x+3, m_y+2 SAY "Iznos bez PDV (osnovica): " GET _i_b_pdv
@ m_x+4, m_y+2 SAY "tarifa: " GET _id_tar ;
	valid v_id_tar(@_id_tar, col()) 

@ m_x+4, m_y+2 SAY "Iznos sa PDV: " GET _i_s_pdv ;
	when { || .f. }

@ m_x+5, m_y+2 SAY "ispravno ?" GET _ispravno ;
	valid { || _ispravno == "D" } ;
	pict "@!"

read


BoxC()

ESC_RETURN .f.

return .t.
*}

// ------------------------
// ------------------------
static function next_rbr()
SELECT p_kuf
GO BOTTOM
nLastRbr := r_br
return nLastRbr + 1


// ---------------------------------------------
// tabela KUF keyboard handler 
// ---------------------------------------------
static function t_kuf_k_handler()

if (Ch==K_CTRL_T .or. Ch==K_ENTER) .and. reccount2()==0
	return DE_CONT
endif


do case

  case (Ch == K_CTRL_T)

	select P_KUF
	if Pitanje(,"Zelite izbrisati ovu stavku ?","D")=="D"
      		delete
      		EventLog(nUser, goModul:oDataBase:cName, "DOK", "EDIT", nil, nil, nil, nil, "", "", "KUF Stavka pobrisana", Date(), Date(), "", "Brisanje stavke...")		

      		return DE_REFRESH
      	endif
     	return DE_CONT

   case (Ch == K_F5)
   
        // kontrola zbira KUF
   	kzb_kuf()
      	return DE_REFRESH

   case (Ch == K_ENTER)
 
 	SELECT P_KUF
  	Scatter()
  	if ed_item(.f.)
		Gather()
		RETURN DE_REFRESH
	endif
	return DE_CONT
	
   case (Ch == K_CTRL_N)
   
   	SELECT P_KUF
	
        APPEND BLANK
        Gather()
	
	if ed_item(.t.)
	
      		EventLog(nUser, goModul:oDataBase:cName, "DOK", "EDIT", nDug, nPot, nil, nil, "", "", "Unos stavke ....", Date(), Date(), "", "KUF - nova stavka")
	        return DE_REFRESH
	else
		return DE_CONT
	endif
	
   case (Ch  == K_CTRL_F9)
   
        if Pitanje( ,"Zelite li izbrisati pripremu !!????","N") == "D"
	     	EventLog(nUser, goModul:oDataBase:cName, "DOK", "EDIT", nil, nil, nil, nil, "", "", pripr->idfirma+"-"+pripr->idvn+"-"+pripr->brnal, Date(), Date(), "", " KUF Brisanje pripreme ....")
	     	zap
        	return DE_REFRESH
	endif
        return DE_CONT

   case Ch==K_CTRL_P
     	rpt_d_kuf()
     	return DE_REFRESH


   case (Ch == K_F10)
     	t_ost_opcije()
     	return DE_REFRESH

endcase

return DE_CONT
*}


// ---------------------------------
// ---------------------------------
static function t_ost_opcije()

MsgBeep("Tabela KUF - ostale opcije = 0")

return


// ---------------------------------
// kontrola zbira za stavke u pripremi
// ---------------------------------
static function kzb_kuf()

MsgBeep("Tabela KUF - ostale opcije = 0")

return
