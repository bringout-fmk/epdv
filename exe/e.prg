#include "\dev\fmk\epdv\epdv.ch"

/*
 * ----------------------------------------------------------------
 *                                     Copyright Sigma-com software 
 * ----------------------------------------------------------------
 *
 */

/*! \file fmk/fin/main/1g/e.prg
 */

EXTERNAL DESCEND
EXTERNAL RIGHT

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


/*! \fn MainePdv(cKorisn, cSifra, p3, p4, p5, p6, p7)
 *  \brief Glavna funkcija Fin aplikacijskog modula
 */
 
function MainePdv(cKorisn, cSifra, p3, p4, p5, p6, p7)
local oePdv
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


