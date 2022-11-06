tool_path		= ..\tolset\z_tools
ipl_path		= ipl
make			= $(tool_path)\make.exe -r
nask			= $(tool_path)\nask.exe
edimg			= $(tool_path)\edimg.exe
imgtol			= $(tool_path)\imgtol.com
qemu			= $(tool_path)\qemu
makefile_name	= makefile
ipl_nas_name	= $(ipl_path)\ipl.nas
ipl_bin_name	= $(ipl_path)\ipl.bin
ipl_lst_name	= $(ipl_path)\ipl.lst
nas_name		= aleph.nas
sys_name		= aleph.sys
lst_name		= aleph.lst
img_name		= aleph.img

default:
	$(make) run

$(ipl_bin_name):$(makefile_name) $(ipl_nas_name)
	$(nask)\
	$(ipl_nas_name)\
	$(ipl_bin_name)\
	$(ipl_lst_name)

$(sys_name):$(makefile_name) $(nas_name)
	$(nask) $(nas_name) $(sys_name) $(lst_name)

$(img_name):$(makefile_name) $(ipl_bin_name) $(sys_name)
	$(edimg)\
	imgin:$(tool_path)\fdimg0at.tek\
	wbinimg src:$(ipl_bin_name)\
	len:512 from:0 to:0\
	copy from:$(sys_name) to:@:\
	imgout:$(img_name)

bin:$(makefile_name)
	$(make) $(ipl_bin_name)

img:$(makefile_name)
	$(make) $(img_name)

run:$(makefile_name) $(img_name)
	copy $(img_name) $(qemu)\fdimage0.bin
	$(make) -C $(qemu)

install:$(makefile_name) $(img_name)
	$(imgtol) w a:$(img_name)

clean:$(makefile_name)
	del $(ipl_bin_name)
	del $(ipl_lst_name)
	del $(lst_name)

delete:$(makefile_name)
	$(make) clean
	del $(img_name)
	del $(sys_name)