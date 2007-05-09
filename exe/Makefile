VERZIJA=CDX
MODUL=EPDV

SRCDOSROOT=c:\\dev\\fmk\\epdv\\exe\\
PRGS=e.prg

CS=
ASMS=

EOBJCOPY=echo nista za kopirati
FMK_LIBS=fmk_roba.lib  fmk_svi.lib  fmk_evn.lib fmk_sec.lib fmk_lok.lib fmk_rule.lib 

SCLIB_LIBS=sc1g_arh.lib sc1g_ba.lib sc1g_cui.lib sc1g_db.lib sc1g_os.lib sc1g_ost.lib sc1g_par.lib sc1g_pr.lib sc1g_sif.lib sc1g_sql.lib sc1g_ut.lib sc2g_app.lib sc2g_db.lib sc1g_rpt.lib sc1g_key.lib sc2g_cui.lib sc_epl2.lib sc_gvp.lib

#sc1g_pdf.lib

MODUL_LIBS=epdv_m.lib epdv_db.lib epdv_dg.lib  epdv_rpt.lib epdv_df.lib epdv_sif.lib epdv_par.lib epdv_ut.lib

e.obj : $(SC_BUILD_HOME_DIR)/sclib/sc.ch $(SC_BUILD_HOME_DIR)/sclib/std_cdx.ch ../epdv.ch

include $(SC_BUILD_HOME_DIR)/sclib/Makefile_clipper
