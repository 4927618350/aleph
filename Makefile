name			= aleph
tool_path		= ..\z_tools
ipl_path		= ipl
makefile_name	= Makefile
ams_path		= amshead
boot_path		= bootpack
func_path		= func
stack			= 3136KB

make			= $(tool_path)\make.exe -r
nask			= $(tool_path)\nask.exe
edimg			= $(tool_path)\edimg.exe
imgtol			= $(tool_path)\imgtol.com
qemu			= $(tool_path)\qemu
cc1				= $(tool_path)\cc1.exe -I$(tool_path)\haribote -Os -Wall -quiet
gas2nask		= $(tool_path)\gas2nask.exe -a
obj2bim			= $(tool_path)\obj2bim.exe
bim2hrb			= $(tool_path)\bim2hrb.exe

ipl_name		= $(ipl_path)\ipl.bin
amshead_name	= $(ams_path)\amshead.bin
bootpack_hrb	= $(boot_path)\bootpack.hrb
bootpack_bim	= $(boot_path)\bootpack.bim
bootpack_obj	= $(boot_path)\bootpack.obj
bootpack_map	= $(boot_path)\bootpack.map
bootpack_nas	= $(boot_path)\bootpack.nas
sys_name		= $(name).sys
img_name		= $(name).img
func_name		= $(func_path)\func.obj

default:
	$(make) run

%.bin:$(makefile_name) %.nas
	$(nask) $*.nas $*.bin $*.lst

$(sys_name):$(makefile_name) $(amshead_name) $(bootpack_hrb)
	copy /b $(amshead_name)+$(bootpack_hrb) $(sys_name)

$(img_name):$(makefile_name) $(ipl_name) $(sys_name)
	$(edimg)\
		imgin:$(tool_path)\fdimg0at.tek\
		wbinimg src:$(ipl_name)\
		len:512 from:0 to:0\
		copy from:$(sys_name) to:@:\
		imgout:$(img_name)


%.gas:$(makefile_name) %.c 
	$(cc1) -o $*.gas $*.c 

%.nas:$(makefile_name) %.gas
	$(gas2nask) $*.gas $*.nas

%.obj:$(makefile_name) %.nas
	$(nask) $*.nas $*.obj $*.lst

%.bim:$(makefile_name) %.obj
	$(obj2bim)\
		@$(tool_path)\haribote\haribote.rul\
		out:$*.bim stack:$(stack) map:$*.map\
		$*.obj

$(bootpack_bim):$(makefile_name) $(bootpack_obj) $(func_name)
	$(obj2bim)\
		@$(tool_path)\haribote\haribote.rul\
		out:$(bootpack_bim) stack:$(stack) map:$(bootpack_map)\
		$(bootpack_obj) $(func_name)

%.hrb:$(makefile_name) %.bim
	$(bim2hrb) $*.bim $*.hrb 0


img:$(makefile_name)
	$(make) $(img_name)

run:$(makefile_name) $(img_name)
	copy $(img_name) $(qemu)\fdimage0.bin
	$(make) -C $(qemu)

install:$(makefile_name) $(img_name)
	$(imgtol) w a:$(img_name)

clean:$(makefile_name)
	-del $(bootpack_nas)
	-del /s *.bin
	-del /s *.lst
	-del /s *.sys
	-del /s *.gas
	-del /s *.map
	-del /s *.hrb
	-del /s *.obj
	-del /s *.bim

delete:$(makefile_name)
	$(make) clean
	-del $(img_name)