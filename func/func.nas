; func.nas
; TAB=4

[FORMAT "WCOFF"]							; 制作目标文件的模式
[INSTRSET "i486p"]							; 486 32位寄存器
[BITS 32]									; 32位

; 目标文件信息

[FILE "func.nas"]							; 源文件名
		GLOBAL	_io_hlt,_write_mem8			; 程序中包含的的函数

; 实际的函数

[SECTION .text]								; 目标文件中写了这个以后再写程序

_io_hlt:									; void io_hlt();
		HLT
		RET

_write_mem8:								; void write_mem8(int addr,int data);
		MOV		ECX,[ESP+4]					; addr
		MOV		AL,[ESP+8]					; data
		MOV		[ECX],AL
		RET