; aleph-ipl
; TAB=4

CYLS	EQU		10					; #define CYLS 10//读取10个柱面

		ORG		0x7c00				; 程序装载到

		JMP		entry
		DB		0x90
		DB		"ALEPHIPL"			; 启动区名称（8B）
		DW		512					; 扇区大小 const
		DB		1					; 簇的大小 const
		DW		1					; fat起始位置
		DB		2					; fat的个数 cosnt
		DW		224					; 根目录大小
		DW		2880				; 磁盘大小 const
		DB		0xf0				; 磁盘的种类 const
		DW		9					; fat的长度 const
		DW		18					; 一个磁道有几个磁区 const
		DW		2					; 磁头数 const
		DD		0					; cosnt
		DD		2880				; cosnt
		DB		0,0,0x29			; const
		DD		0xffffffff			; const
		DB		"ALEPH-OS   "		; 磁盘名称（11B）
		DB		"FAT12   "
		RESB	18

entry:
		MOV		AX,0
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX
		MOV		AX,0x0820
		MOV		ES,AX
		MOV		CH,0				; 柱面
		MOV		DH,0				; 磁头
		MOV		CL,2				; 扇区

readloop:
		MOV		SI,0				; 记录读取尝试次数

retry:
		MOV		AH,0x02				; 0x02读盘 0x03写盘 0x04效验 0x0c寻道
		MOV		AL,1				; 1个扇区
		MOV		BX,0				; 缓冲地址
		MOV		DL,0x00				; 驱动器号
		INT		0x13				; bios:磁盘 成功CF=0 失败CF=1错误码存在AH
		JNC		next				; if(CF=0)
		ADD		SI,1				; 增加尝试次数
		CMP		SI,5
		JAE		error				; jump if above or equal
		MOV		AH,0x00
		MOV		DL,0x00
		INT		0x13				; 重置
		JMP		retry

next:
		MOV		AX,ES
		ADD		AX,0x0020
		MOV		ES,AX				; 将ES后移0x0020
		ADD		CL,1				; 下一扇区
		CMP		CL,18				; 读18个扇区
		JBE		readloop			; jump if below or equal
		MOV		CL,1
		ADD		DH,1				; 下一个磁头
		CMP		DH,2
		JB		readloop			; jump if below
		MOV		DH,0
		ADD		CH,1				; 下一个柱面
		CMP		CH,CYLS				; 读CYLS个柱面
		JB		readloop
		MOV		[0x0ff0],CH
		JMP		0xc200

error:
		MOV		SI,msg

showloop:
		MOV		AL,BYTE[SI]
		ADD		SI,1
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e				; 显示一个文字
		MOV		BX,15				; 颜色
		INT		0x10				; bios:显卡
		JMP		showloop

fin:
		HLT
		JMP     fin

msg:
		DB		0x0a, 0x0a			; \n\n
		DB		"error"
		DB		0x0a
		DB		0
		RESB	0x7dfe-$			; 写0x00到0x7dfe
		DB		0x55, 0xaa
