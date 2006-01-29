#include "\dev\fmk\epdv\epdv.ch"

/*
 * ----------------------------------------------------------------
 *                                     Copyright Sigma-com software 
 * ----------------------------------------------------------------
 */
 

 
/*! \fn TePDVModNew()
 *  \brief funkcija koja kreira TePdvMod objekat
 */

function TePdvModNew()
*{
local oObj

oObj:=TePDVMod():new()

oObj:self:=oObj
return oObj
*}


#include "class(y).ch"
CREATE CLASS TePdvMod INHERIT TAppMod
	EXPORTED: 
	var oSqlLog
	method dummy
	method setGVars
	method mMenu
	method mMenuStandard
	method sRegg
	method initdb
	method srv
END CLASS

/*! \fn TePdvMod::dummy()
 *  \brief dummy
 */

*void TePdvMod::dummy()
*{
method dummy()
return
*}


*void TePdvMod::initdb()
*{
method initdb()

::oDatabase:=TDBePdvNew()

return NIL
*}


/*! \fn *void TFinMod::mMenu()
 *  \brief Osnovni meni ePDV modula
 *  \todo meni prebaciti na Menu_SC!
 */

*void TePdvMod::mMenu()
*{
method mMenu()


PID("START")

close all

SETKEY(K_SH_F1,{|| Calc()})

CheckROnly(KUMPATH + "\PDV.DBF")

O_PDV
select PDV
TrebaRegistrovati(3)
use

close all

@ 1,2 SAY padc( gNFirma, 50, "*")
@ 4,5 SAY ""

s_params()

::mMenuStandard()

::quit()

return nil
*}


/*! \fn *void TePDVMod::mStandardMenu()
 *  \brief Osnovni meni ePDV modula
 *  \todo meni prebaciti na Menu_SC!
 */

*void TePDVMod::mMenuStandard()
*{
method mMenuStandard()

private Izbor:=1
private opc:={}
private opcexe:={}

AADD(opc, "1. KUF unos/ispravka           ")

if (ImaPravoPristupa(goModul:oDataBase:cName,"DOK","EDIT"))
	AADD(opcexe, {|| ed_kuf()})
else
	AADD(opcexe, {|| MsgBeep(cZabrana)})
endif

AADD(opc, "2. KIF unos/ispravka")
if (ImaPravoPristupa(goModul:oDataBase:cName,"DOK","EDIT"))
	AADD(opcexe, {|| ed_kif()})
else
	AADD(opcexe, {|| MsgBeep(cZabrana)})
endif


AADD(opc, "3. generacija dokumenata")
if (ImaPravoPristupa(goModul:oDataBase:cName,"DOK","GENDOK"))
	AADD(opcexe, {|| m_gen()})
else
	AADD(opcexe, {|| MsgBeep(cZabrana)})
endif

AADD(opc, "4. izvjestaji")
AADD(opcexe, {|| m_rpt()})


AADD(opc, "------------------------------------")
AADD(opcexe, {|| nil})

AADD(opc, "S. sifrarnici")
AADD(opcexe, {|| m_sif()})

AADD(opc, "------------------------------------")
AADD(opcexe, {|| nil})

AADD(opc, "9. administracija baze podataka")
if (ImaPravoPristupa(goModul:oDataBase:cName, "DB", "ADMIN"))
	AADD(opcexe, {|| m_adm()})
else
	AADD(opcexe, {|| MsgBeep(cZabrana)})
endif

AADD(opc, "------------------------------------")
AADD(opcexe, {|| nil})


AADD(opc, "X. parametri")

if (ImaPravoPristupa(goModul:oDataBase:cName,"PARAM","ALL"))
	AADD(opcexe, {|| m_par()})
else
	AADD(opcexe, {|| MsgBeep(cZabrana)})
endif

Menu_SC("gpdv",.t., .f.)

return
*}


*void TFinMod::sRegg()
*{
method sRegg()
sreg("EPDV","EPDV")
return
*}


*void TFinMod::srv()
*{
method srv()

return
*}


/*! \fn *void TePdvMod::setGVars()
 *  \brief opste funkcije EPDV modula
 */

*void TePdvMod::setGVars()
*{

method setGVars()

SetFmkSGVars()
SetFmkRGVars()

private cSection:="1"
private cHistory:=" "
private aHistory:={}

public gFirma:="10"
public gNFirma:=space(20)  
public gPicVrijednost := "9999999.99"

::super:setTGVars()

O_PARAMS
Rpar("ff",@gFirma)
Rpar("fn",@gNFirma)
Rpar("p1",@gPicVrijednost)

if empty(gNFirma)
	Beep(1)
  	Box(,1,50)
    		@ m_x+1,m_y+2 SAY "Unesi naziv firme:" GET gNFirma pict "@!"
    		read
  	BoxC()
  	WPar("fn",gNFirma)
endif
select (F_PARAMS)

use

public gModul
public gTema
public gGlBaza

gModul:="EPDV"
gTema:="OSN_MENI"
gGlBaza:="PDV.DBF"

public cZabrana:="Opcija nedostupna za ovaj nivo !!!"

return
*}

