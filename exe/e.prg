/* 
 * This file is part of the bring.out FMK, a free and open source 
 * accounting software suite,
 * Copyright (c) 1996-2011 by bring.out doo Sarajevo.
 * It is licensed to you under the Common Public Attribution License
 * version 1.0, the full text of which (including FMK specific Exhibits)
 * is available in the file LICENSE_CPAL_bring.out_FMK.md located at the 
 * root directory of this source code archive.
 * By using this software, you agree to be bound by its terms.
 */


#include "epdv.ch"


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


