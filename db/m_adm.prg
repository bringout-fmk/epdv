#include "\dev\fmk\epdv\epdv.ch"

/*
 * ----------------------------------------------------------------
 *                                     Copyright Sigma-com software 
 * ----------------------------------------------------------------
 */


// -------------------------------------------
// -------------------------------------------
function m_adm()
*{
private opc:={}
private opcexe:={}
private Izbor:=1

AADD(opc, "1. install db-a                         ")
AADD(opcexe, {|| goModul:oDatabase:install()})
AADD(opc, "2. security")
AADD(opcexe, {|| MnuSecMain()})
AADD(opc, "3. renumeracija g_r_br KUF")
AADD(opcexe, {|| rn_gr("KUF")})
AADD(opc, "4. renumeracija g_r_br KIF")
AADD(opcexe, {|| rn_gr("KIF")})

Menu_SC("adm")

return
*}

// ---------------------------------
// ---------------------------------
static function rn_gr(cTblName)

if Pitanje(,"Izvrsiti renumeriranje ? " + cTblName, "N") == "D"
  if SigmaSif("RNGR")
  	rn_g_r_br(cTblName)
  else
  	MsgBeep("Pogresna lozinka, nista od posla ...")
  endif
endif

return
