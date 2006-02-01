VERZIJA=CDX
MODUL=epdv_rpt

include /sclib/Makefile_clipper

SRCDOSROOT=c:\\dev\\fmk\\epdv\\rpt\\

PRGS=m_rpt.prg rpt_kif.prg rpt_kuf.prg rpt_pdv.prg r_lista.prg

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


