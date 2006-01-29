#include "\dev\fmk\epdv\epdv.ch"

/*
* ----------------------------------------------------------------
*                           Copyright Sigma-com software 2006
* ----------------------------------------------------------------
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

SELECT (F_P_KUF)

if !used()
	O_P_KUF
endif

set_a_kol( @Kol, @ImeKol)
ObjDbedit("ekuf", 20, 77, {|| k_handler()}, "", "KUF Priprema...", , , , , 3)
BoxC()
closeret


// ---------------------------------------------
// postavi matrice ImeKol, Kol
// ---------------------------------------------
static function set_a_kol( aKol, aImeKol )

aImeKol := {}

AADD(aImeKol, {"R.br", {|| r_br}, "r_br", {|| .t.}, {|| .t.} })
AADD(aImeKol, {"Datum", {|| datum}, "datum", {|| .t.}, {|| .t.} })
AADD(aImeKol, { PADR("opis", 15), {|| PADR(opis, 13) + ".." }, "opis", {|| .t.}, {|| .t.} })
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
local cIspravno := "D"
local nI_s_pdv := 0
local nX := 1

Box(, 14, 70)
if lNova
	_r_br := next_rbr()
	_id_part:= SPACE(LEN(id_part))
	_id_tar:= PADR("PDV17", LEN(id_tar))
	_datum := DATE()
	_opis:= SPACE(LEN(opis))
	_i_b_pdv := 0
	_i_pdv := 0
endif

@ m_x + nX, m_y+2 SAY "R.br: " GET _r_br
@ m_x + nX, col()+2 SAY "datum: " GET _datum
nX += 1

@ m_x + nX, m_y+2 SAY "opis: " GET _opis ;
	PICT "@S50"
nX += 2

@ m_x + nX, m_y+2 SAY "Iznos bez PDV (osnovica): " GET _i_b_pdv ;
	PICT PIC_IZN()
++nX

@ m_x + nX, m_y+2 SAY "tarifa: " GET _id_tar ;
	valid v_id_tar(@_id_tar, @_i_b_pdv, @_i_pdv,  col())  
++nX

@ m_x + nX, m_y+2 SAY "Iznos sa PDV: " GET _i_pdv ;
        valid { || nI_s_pdv := _i_b_pdv + _i_pdv, .t. } ;
	PICT PIC_IZN()
++nX

@ m_x + nX, m_y+2 SAY "Iznos sa PDV: " GET nI_s_pdv ;
	when { || .f. } ;
	PICT PIC_IZN()
nX += 2

@ m_x + nX, m_y+2 SAY "Ispravno ?" GET cIspravno ;
	valid { || cIspravno == "D" } ;
	pict "@!"
++nX

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
static function k_handler()

if (Ch==K_CTRL_T .or. Ch==K_ENTER) .and. reccount2()==0
	return DE_CONT
endif


do case

  case (Ch == K_CTRL_T)

	select P_KUF
	if Pitanje(,"Zelite izbrisati ovu stavku ?","D")=="D"
      		delete
      		//EventLog(nUser, goModul:oDataBase:cName, "DOK", "EDIT", nil, nil, nil, nil, "", "", "KUF Stavka pobrisana", Date(), Date(), "", "Brisanje stavke...")		

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
        Scatter()	
        APPEND BLANK
	
	if ed_item(.t.)
	
      		//EventLog(nUser, goModul:oDataBase:cName, "DOK", "EDIT", nDug, nPot, nil, nil, "", "", "Unos stavke ....", Date(), Date(), "", "KUF - nova stavka")
		Gather()
	        return DE_REFRESH
	else
		return DE_CONT
	endif
	
   case (Ch  == K_CTRL_F9)
   
        if Pitanje( ,"Zelite li izbrisati pripremu !!????","N") == "D"
	     	//EventLog(nUser, goModul:oDataBase:cName, "DOK", "EDIT", nil, nil, nil, nil, "", "", pripr->idfirma+"-"+pripr->idvn+"-"+pripr->brnal, Date(), Date(), "", " KUF Brisanje pripreme ....")
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

MsgBeep("KUF - kzb = 0")

return
