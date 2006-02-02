VERZIJA=CDX
MODUL=epdv_ut

include /sclib/Makefile_clipper

SRCDOSROOT=c:\\dev\\fmk\\epdv\\util\\

PRGS=date.prg part.prg tar.prg kuf_kif.prg pdv.prg gen_dok.prg

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


