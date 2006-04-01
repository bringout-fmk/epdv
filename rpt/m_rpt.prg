#include "\dev\fmk\epdv\epdv.ch"
/*
* ----------------------------------------------------------------
*                                     Copyright Sigma-com software 
* ----------------------------------------------------------------
*/


// ------------------------------
// ------------------------------
function m_rpt()
*{
private opc:={}
private opcexe:={}
private Izbor:=1

AADD(opc, "1. kuf lista dokumenata ")
AADD(opcexe, {|| r_lista("KUF")})
AADD(opc, "2. kuf")
AADD(opcexe, {|| rpt_kuf()})

AADD(opc, "-------------------------")
AADD(opcexe, {|| nil})


AADD(opc, "3. kif lista dokumenata ")
AADD(opcexe, {|| r_lista("KIF")})
AADD(opc, "4. kif")
AADD(opcexe, {|| rpt_kif()})

AADD(opc, "-------------------------")
AADD(opcexe, {|| nil})

AADD(opc, "5. prijava pdv-a")
AADD(opcexe, {|| rpt_p_pdv()})

AADD(opc, "-------------------------")
AADD(opcexe, {|| nil})

AADD(opc, "6. test pdf")
AADD(opcexe, {|| test_pdf()})

Menu_SC("rpt")

return


