; aleph-os
; TAB=4

BOTPAK	EQU		0x00280000					; bootpack的加载位置
DSKCAC	EQU		0x00100000					; 磁盘缓存位置
DSKCAC0	EQU		0x00008000					; 磁盘缓存位置（实时模式）

; BOOT_INFO
CYLS	EQU		0x0ff0						; #define CYLS 10//读取10个柱面
LEDS	EQU		0x0ff1
VMODE	EQU		0x0ff2						; 颜色位数
SCRNX	EQU		0x0ff4						; 分辨率x
SCRNY	EQU		0x0ff6						; 分辨率y
VRAM	EQU		0x0ff8						; 图像缓冲区地址

; 画面设置
		ORG 	0xc200						; 程序装载到0xc200
		MOV		AL,0x13						; mode VGA显卡 320*200*8位彩色
		MOV		AH,0x00						; const
		INT		0x10						; bois 显卡
		MOV		BYTE [VMODE],8				; 画面模式
		MOV		WORD [SCRNX],320
		MOV		WORD [SCRNY],200
		MOV		DWORD [VRAM],0x000a0000

; 键盘上LED灯状态
		MOV		AH,0x02						
		INT		0x16 						; BIOS 键盘
		MOV		[LEDS],AL

; PIC不接受任何中断
; 在AT兼容机的规格中，如果要初始化PIC
; 如果不在CLI前做这个的话，偶尔会死机
; PIC的初始化以后再做

		MOV		AL,0xff
		OUT		0x21,AL
		NOP									; 如果连续OUT命令的话，好像有不顺利的机种
		OUT		0xa1,AL
		CLI									; 此外，CPU级别也禁止中断

; 设置A20门，以便从CPU访问1MB以上的存储器
		CALL	waitkbdout
		MOV		AL,0xd1
		OUT		0x64,AL
		CALL	waitkbdout
		MOV		AL,0xdf						; enable A20
		OUT		0x60,AL
		CALL	waitkbdout

; 保护模式迁移
[INSTRSET "i486p"]							; 想使用486的命令的记述
		LGDT	[GDTR0]						; 设置临时GDT
		MOV		EAX,CR0
		AND		EAX,0x7fffffff				; bit31为0（禁止分页）
		OR		EAX,0x00000001				; 将bit0设为1（为了转移保护模式）
		MOV		CR0,EAX
		JMP		pipelineflush

pipelineflush:
		MOV		AX,1*8						;  可读写段32bit
		MOV		DS,AX
		MOV		ES,AX
		MOV		FS,AX
		MOV		GS,AX
		MOV		SS,AX
; 转发bootpack
		MOV		ESI,bootpack				; 转发源
		MOV		EDI,BOTPAK					; 转发地址
		MOV		ECX,512*1024/4
		CALL	memcpy

; 顺便把磁盘数据也传送到原来的位置
; 首先从引导扇区开始
		MOV		ESI,0x7c00					; 转发源
		MOV		EDI,DSKCAC					; 转发地址
		MOV		ECX,512/4
		CALL	memcpy
		
; 剩下的全部
		MOV		ESI,DSKCAC0+512				; 转发源
		MOV		EDI,DSKCAC+512				; 转发地址
		MOV		ECX,0
		MOV		CL,BYTE [CYLS]
		IMUL	ECX,512*18*2/4				; 从气缸数转换为字节数/4
		SUB		ECX,512/4					; 只扣除IPL的部分
		CALL	memcpy

; 因为asmhead必须做的事全部做完了
; 接下来就交给bootpack了
; 启动bootpack
		MOV		EBX,BOTPAK
		MOV		ECX,[EBX+16]
		ADD		ECX,3						; ECX += 3;
		SHR		ECX,2						; ECX /= 4;
		JZ		skip						; 无需转发
		MOV		ESI,[EBX+20]				; 转发源
		ADD		ESI,EBX
		MOV		EDI,[EBX+12]				; 转发地址
		CALL	memcpy 

skip:
		MOV		ESP,[EBX+12]				; 堆栈初始值
		JMP		DWORD 2*8:0x0000001b

waitkbdout:
		IN		 AL,0x64
		AND		 AL,0x02
		JNZ		waitkbdout					; 如果AND的结果不是0，则转到waitkbdout
		RET

memcpy:
		MOV		EAX,[ESI]
		ADD		ESI,4
		MOV		[EDI],EAX
		ADD		EDI,4
		SUB		ECX,1
		JNZ		memcpy						; 如果相减的结果不是0，则返回memcpy
		RET

; memcpy只要不忘记放入地址大小前缀，也可以写字符串指令
		ALIGNB	16 

GDT0:
		RESB	8							; 空选择器
		DW		0xffff,0x0000,0x9200,0x00cf	; 可读写段32bit
		DW		0xffff,0x0000,0x9a28,0x0047	; 可执行段32bit（bootpack用）
		DW		0 
		
GDTR0:
		DW		8*3-1
		DD		GDT0
		ALIGNB	16 

bootpack: