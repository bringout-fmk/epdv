VERZIJA=CDX
MODUL=EPDV

PRGS=/dev/fmk/epdv/main/e.prg
CS=
ASMS=

include /sclib/Makefile_clipper

FMK_LIBS=fmk_roba.lib  fmk_svi.lib  fmk_evn.lib fmk_sec.lib 

SCLIB_LIBS=sc1g_arh.lib sc1g_ba.lib sc1g_cui.lib sc1g_db.lib sc1g_os.lib sc1g_ost.lib sc1g_par.lib sc1g_pr.lib sc1g_sif.lib sc1g_sql.lib sc1g_ut.lib sc2g_app.lib sc2g_db.lib sc1g_rpt.lib sc1g_key.lib sc2g_cui.lib


MODUL_LIBS=epdv_m.lib epdv_db.lib epdv_dg.lib  epdv_rpt.lib epdv_df.lib epdv_sif.lib epdv_par.lib epdv_ut.lib

PREF2=lib $(LIB_DOS_DEST)
FMKLIBCMD=$(addprefix $(PREF2), $(SCLIB_LIBS) $(FMK_LIBS) $(MODUL_LIBS) )


OBJS=$(OBJPRGS) $(OBJCS) $(OBJASMS)

all:    mod 

mod: $(OBJS)
	echo Prilikom kompilacije obj se napravi u tekucem direktoriju
	echo a blinker opet trazi obj fajl u orig direktoriju
	cp e.obj /dev/fmk/epdv/main/
	/sclib/form_blinker_lnk.sh $(LINKCMD)
	/sclib/form_blinker_lnk_2.sh $(FMKLIBCMD)
	$(LINKEREXE) @_bl_.lnk   @_bl_2_.lnk $(DEBUGLINK) @H:\\CLIPPER\\$(VERZIJA)\\BL.LNK output e.exe
	cp e.exe $(EXEDEST)/$(MODUL).EXE

zip:
	/sclib/zip.sh h:\\cs\\FMK\\binary\\$(MODUL).zip ..\\chs\\\*.chs c:\\dev\\fmk\af\cl-af\\svi\\\*.chs ..\template\\\*.txt $(EXEDOSDEST)\\$(MODUL).EXE

commit:
	/sclib/commit.sh $(MODUL) h:\\cs\\FMK\\binary\\$(MODUL).zip
	/sclib/commit.sh $(MODUL) h:\\cs\\FMK\\binary\\sfx\\$(MODUL).exe
clean:
	rm -f *.obj *.OBJ
	rm -f $(OBJS) I$(MODULH).OBJ *.bak *.BAK

7exe:
	/sclib/7exe.sh h:\\cs\\fmk\\binary\\sfx\\$(MODUL).exe ..\\chs\\\*.chs \\dev\\fmk\\af\\cl-af\\svi\\\*.chs ..\\template\\\*.txt $(EXEDOSDEST)\\$(MODUL).EXE
	

