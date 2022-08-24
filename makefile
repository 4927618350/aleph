path		= ../tolset/z_tools/
make    	= $(path)make.exe -r
nask    	= $(path)nask.exe
edimg   	= $(path)edimg.exe
imgtol  	= $(path)imgtol.com
bin_name	= ipl.bin

default:
	make run

aleph.img:ipl.bin
	$(edimg)\
	imgin:$(path)fdimg0at.tek\
	wbinimg src:ipl.bin\
	len:512 from:0 to:0\
	imgout:aleph.img

$(bin_name):ipl.nas
	$(path)nask.exe\
	ipl.nas\
	ipl.bin\
	ipl.lst

run:aleph.img
	copy aleph.img $(path)qemu/fdimage0.bin
	$(path)make.exe	-C ../tolset/z_tools/qemu

img:
	../tolset/z_tools/make.exe -r aleph.img

bin:
	../tolset/z_tools/make.exe -r $(bin_name)

clean:
	del ipl.bin
	del ipl.lst

delete:
	make clean
	del aleph.img
