#include "epdv.ch"
/*
* ----------------------------------------------------------------
*                                     Copyright Sigma-com software 
* ----------------------------------------------------------------
*/


// ------------------------------
// ------------------------------
function m_gen()
*{
private opc:={}
private opcexe:={}
private Izbor:=1

AADD(opc, "1. generisi kuf           ")
AADD(opcexe, {|| gen_kuf()})
AADD(opc, "2. generisi kif")
AADD(opcexe, {|| gen_kif()})

Menu_SC("gen")

return

