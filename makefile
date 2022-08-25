path		= ..\tolset\z_tools
make    	= $(path)\make.exe -r
nask    	= $(path)\nask.exe
edimg   	= $(path)\edimg.exe
imgtol  	= $(path)\imgtol.com
qemu		= $(path)\qemu
nas_name	= ipl.nas
bin_name	= ipl.bin
lst_name	= ipl.lst
img_name	= aleph.img

default:
	$(make) run

$(img_name):$(bin_name)
	$(edimg)\
	imgin:$(path)\fdimg0at.tek\
	wbinimg src:$(bin_name)\
	len:512 from:0 to:0\
	imgout:$(img_name)

$(bin_name):$(nas_name)
	$(nask)\
	$(nas_name)\
	$(bin_name)\
	$(lst_name)

run:$(img_name)
	copy $(img_name) $(qemu)\fdimage0.bin
	$(make) -C $(qemu)

img:
	$(make) $(img_name)

bin:
	$(make) $(bin_name)

clean:
	del $(bin_name)
	del $(lst_name)

delete:
	$(make) clean
	del $(img_name)
