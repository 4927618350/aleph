; aleph-os
; TAB=4

; BOOT_INFO
CYLS	EQU		0x0ff0					; #define CYLS 10//读取10个柱面
LEDS	EQU		0x0ff1
VMODE	EQU		0x0ff2					; 颜色位数
SCRNX	EQU		0x0ff4					; 分辨率x
SCRNY	EQU		0x0ff6					; 分辨率y
VRAM	EQU		0x0ff8					; 图像缓冲区地址

		ORG 	0xc200					; 程序装载到0xc200
		MOV		AL,0x13					; mode VGA显卡 320*200*8位彩色
		MOV		AH,0x00					; const
		INT		0x10					; bois 显卡
		MOV		BYTE [VMODE],8			; 画面模式
		MOV		WORD [SCRNX],320
		MOV		WORD [SCRNY],200
		MOV		DWORD [VRAM],0x000a0000
		MOV		AH,0x02			; 键盘上LED灯状态
		INT		0x16 			; BIOS 键盘
		MOV		[LEDS],AL

fin:
		HLT
		JMP		fin