VERZIJA=CDX
MODUL=epdv_dg

include /sclib/Makefile_clipper

SRCDOSROOT=c:\\dev\\fmk\\epdv\\dok_gen\\

PRGS=m_gen.prg gen_kuf.prg gen_kif.prg g_fakt.prg

CS=
ASMS=

OBJS=$(OBJPRGS) $(OBJCS) $(OBJASMS)

all: $(OBJS)
	rm -f $(MODUL).lib 
	$(LIBEXE) $(MODUL) $(LIBCMD) ,,
	cp $(MODUL).lib $(LIB_DEST)

	
clean:
	rm -f *~
	rm -f *.xref
	rm -f *.xrefs
	rm -f *.html
	rm -f *.OBJ *.obj
	rm -f xref_files
	rm -f $(OBJS) *.bak *.BAK


