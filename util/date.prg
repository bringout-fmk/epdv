

// Ako je dan < 10
//     return { 01.predhodni_mjesec , zadnji.predhodni_mjesec}
//     else
//     return { 01.tekuci_mjesec, danasnji dan }

function rpt_d_interval (dToday)
local nDay, nFDOm
local dDatOd, dDatDo
nDay:= DAY(dToday)
nFDOm := BOM(dToday)

if nDay < 10
	// prvi dan u tekucem mjesecu - 1
	dDatDo := nFDom - 1
	// prvi dan u proslom mjesecu
	dDatOd := BOM(dDatDo)
	
else
	dDatOd := nFDom
	dDatDo := dToday
endif


return { dDatOd, dDatDo }

