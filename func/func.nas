; func.nas
; TAB=4

[FORMAT "WCOFF"]							; 制作目标文件的模式
[INSTRSET "i486p"]							; 486 32位寄存器
[BITS 32]									; 32位

; 目标文件信息

[FILE "func.nas"]							; 源文件名
		GLOBAL	_io_hlt						; 程序中包含的的函数

; 实际的函数

[SECTION .text]								; 目标文件中写了这个以后再写程序

_io_hlt:									; void io_hlt();
		HLT
		RET
