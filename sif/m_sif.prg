#include "epdv.ch"
/*
* ----------------------------------------------------------------
*                                     Copyright Sigma-com software 
* ----------------------------------------------------------------
*/


// ------------------------------
// ------------------------------
function m_sif()
*{
private opc:={}
private opcexe:={}
private Izbor:=1

AADD(opc, "1. partneri               ")
AADD(opcexe, {|| p_part()})
AADD(opc, "-------------------------")
AADD(opcexe, {|| nil})

AADD(opc, "5. sheme generacije kuf")
AADD(opcexe, {|| p_sg_kuf()})
AADD(opc, "6. sheme generacije kif")
AADD(opcexe, {|| p_sg_kif()})

AADD(opc, "-------------------------")
AADD(opcexe, {|| nil})

AADD(opc, "8. tarife")
AADD(opcexe, {|| P_Tarifa()})

AADD(opc, "-------------------------")
AADD(opcexe, {|| nil})

AADD(opc, "S. sifk")
AADD(opcexe, {|| P_SifK()})


Menu_SC("sif")

return



