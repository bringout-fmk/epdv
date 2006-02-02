#include "\dev\fmk\epdv\epdv.ch"

// --------------------------------------------------------------------
//                                   Copyright Sigma-com 2006
// ---------------------------------------------------------------------


// -------------------------------
// -------------------------------
function save_pdv_obracun(dDatOd, dDatDo)

SELECT (F_R_PDV)
if !used()
	O_R_PDV
endif
// set mem vars _
Scatter()

if Pitanje( , "Zelite li obracun pohraniti u bazu PDV prijava ?", " ") == "D"

	SELECT F_PDV
	if !used()
		O_PDV
	endif

	SET ORDER TO TAG "period"
	seek DTOS(dDatOd) + DTOS(dDatDo)
	if !found()
		APPEND BLANK
	else
		if lock == "D"
			MsgBeep("Vec postoji obracun koji je zakljucan #" +;
				"promjena NIJE snimljena !")
			SELECT (F_PDV)
			use
			SELECT (F_R_PDV)
			use
			return
		endif
	endif

// datum kreiranja

	if empty(pdv->datum_1)
		// datum kreiranja
		_datum_1 := date()
	endif
	// datum azuriranja
	_datum_2 := date()


	// snimi _ -> PDV
	Gather()
	SELECT (F_PDV)


	use

endif

return
