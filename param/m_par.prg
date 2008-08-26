#include "epdv.ch"
/*
* ----------------------------------------------------------------
*                                     Copyright Sigma-com software 
* ----------------------------------------------------------------
*/


// ------------------------------
// ------------------------------
function m_par()
*{
private opc:={}
private opcexe:={}
private Izbor:=1

//AADD(opc, "1. globalni parametri za firmu ")
//AADD(opcexe, {|| ed_g_params()})

//Menu_SC("pa9")

ed_g_params()

return

