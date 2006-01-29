#include "\dev\fmk\epdv\epdv.ch"

/*
 * ----------------------------------------------------------------
 *                                     Copyright Sigma-com software 
 * ----------------------------------------------------------------
 *
 */

/*! \file fmk/fin/main/1g/e.prg
 */

#ifndef CPP
EXTERNAL DESCEND
EXTERNAL RIGHT
#endif



#ifndef LIB

/*! \fn function Main(cKorisn, cSifra, p3, p4, p5, p6, p7)
 *  \brief Main fja za FIN.EXE
 */
function Main(cKorisn, cSifra, p3, p4, p5, p6, p7)
*{
  MainEPdv(cKorisn, cSifra, p3, p4, p5, p6, p7)
return
*}

#endif


/*! \fn MainFin(cKorisn, cSifra, p3, p4, p5, p6, p7)
 *  \brief Glavna funkcija Fin aplikacijskog modula
 */
 
function MainePdv(cKorisn, cSifra, p3, p4, p5, p6, p7)
*{
local oFin
local cModul

PUBLIC gKonvertPath:="D"

oePdv:=TePDVModNew()
cModul:="EPDV"

PUBLIC goModul

goModul:=oePdv
oePdv:init(NIL, cModul, D_EP_VERZIJA, D_EP_PERIOD , cKorisn, cSifra, p3, p4, p5, p6, p7)

oePdv:run()

return
*}


