
all: 
	rm -f main/e.obj
	make -C main
	make -C db
	make -C dok_gen
#	make -C dok_rpt
	make -C dok_frm
	make -C rpt
	make -C sif
	make -C param
	make -C util 
	make -C exe
	

clean:
	rm -f main/e.obj
	make -C main clean
	make -C db clean
	make -C dok_gen clean
#	make -C dok_rpt clean
	make -C dok_frm clean
	make -C rpt clean
	make -C sif clean
	make -C util clean
	make -C param clean

zip:
	cd main; make zip; make 7exe

commit:
	cd main; make commit

