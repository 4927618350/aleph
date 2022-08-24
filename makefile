default:
	make run

aleph.img:ipl.bin
	..\tolset\z_tools\edimg.exe\
	imgin:../tolset/z_tools/fdimg0at.tek\
	wbinimg src:ipl.bin\
	len:512 from:0 to:0\
	imgout:aleph.img

ipl.bin:ipl.nas
	..\tolset\z_tools\nask.exe\
	ipl.nas\
	ipl.bin\
	ipl.lst

run:aleph.img
	copy aleph.img\
	 ..\tolset\z_tools\qemu\fdimage0.bin
	..\tolset\z_tools\make.exe	-C ..\tolset/z_tools/qemu

img:
	../tolset/z_tools/make.exe -r aleph.img

bin:
	../tolset/z_tools/make.exe -r ipl.bin

clean:
	del ipl.bin
	del ipl.lst

delete:
	make clean
	del aleph.img
