VERZIJA=CDX
MODUL=epdv_sif

include /sclib/Makefile_clipper

SRCDOSROOT=c:\\dev\\fmk\\epdv\\sif\\

PRGS= m_sif.prg sg.prg sg_kuf.prg sg_kif.prg part.prg 

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


