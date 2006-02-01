
// -------------------------------
// nabavke koje su oporezive
// --------------------------------
function t_isp_opor(cIdTar)
return t_opor(cIdTar)

// -------------------------------
// nabavke koje su oporezive
// --------------------------------
function t_nab_opor(cIdTar)
return t_opor(cIdTar)



// -------------------------------
// nabavke, isporuke koje su oporezive
// --------------------------------
function t_opor(cIdTar)
local lRet

cIdTar := PADR(cIdTar, 6)

lRet := .f.

// standardne nabavke
lRet := lRet .or. (cIdTar == PADR("PDV17", 6) )
// nabavka poljoprivreda - oporezivo
lRet := lRet .or. (cIdTar == PADR("PDV7PO", 6) )
// avansne nabavke
lRet := lRet .or. (cIdTar == PADR("PDV7AV", 6) )

return lRet



// -------------------------------
// nabavke uvoz
// --------------------------------
function t_nab_uvoz(cIdTar)
local lRet

cIdTar := PADR(cIdTar, 6)

lRet := .f.
lRet := lRet .or. (cIdTar == PADR("PDV7UV",6) )

return lRet

// -------------------------------
// nabavke neoporezivo
// --------------------------------
function t_nab_ne_opor(cIdTar)
local lRet

cIdTar := PADR(cIdTar, 6)

lRet := .f.
lRet := lRet .or. (cIdTar == PADR("PDV0", 6) )
lRet := lRet .or. (cIdTar == PADR("PDV0UV", 6) )
lRet := lRet .or. (cIdTar == PADR("PDV0PO", 6) )

return lRet

// -------------------------------
// isporuke neoporezivo
// --------------------------------
function t_isp_neopor(cIdTar)
local lRet

cIdTar := PADR(cIdTar, 6)

lRet := .f.
lRet := lRet .or. (cIdTar == PADR("PDV0",6) )
lRet := lRet .or. (cIdTar == PADR("PDV0IZ",6) )
lRet := lRet .or. (cIdTar == PADR("PDV0PO",6) )

return lRet

// -------------------------------
// isporuke nenposlovne svrhe
// --------------------------------
function t_isp_nep_svr(cIdTar)
local lRet

cIdTar := PADR(cIdTar, 6)

lRet := .f.
lRet := lRet .or. (cIdTar == PADR("PDV7NP", 6) )
return lRet

// -------------------------------
// isporuke izvoz
// --------------------------------
function t_isp_izv(cIdTar)
local lRet

cIdTar := PADR(cIdTar, 6)

lRet := .f.
lRet := lRet .or. (cIdTar == PADR("PDV0IZ", 6) )
return lRet


// -------------------------------
// nabavke stalna sredstva
// --------------------------------
function t_nab_st_sr(cIdTar)
local lRet

cIdTar := PADR(cIdTar, 6)

lRet := .f.
lRet := lRet .or. (cIdTar == PADR("PDV7SS", 6) )
lRet := lRet .or. (cIdTar == PADR("PDV7SU", 6) )

return lRet


