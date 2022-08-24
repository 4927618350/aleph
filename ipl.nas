; aleph-os
; TAB=4
main:
        ORG     0x7c00
        JMP     entry
        DB		0x90
        DB		"ALEPHIPL"      ; 启动区名称（8B）
        DW		512				; 扇区大小 const
        DB		1				; 簇的大小 const
        DW		1				; fat起始位置 
        DB		2				; fat的个数 cosnt
        DW		224				; 根目录大小
        DW      2880			; 磁盘大小 const
        DB		0xf0			; 磁盘的种类 const
        DW		9				; fat的长度 const
        DW		18				; 一个磁道有几个磁区 const
        DW		2				; 磁头数 const
        DD		0				; cosnt
        DD		2880			; cosnt
        DB      0,0,0x29		; const
        DD      0xffffffff		; const
        DB      "ALEPH-OS   "	; 磁盘名称（11B）
        DB		"FAT12   "
    	RESB	18				

entry:
        MOV     AX,0
        MOV     SS,AX
        MOV     SP,0x7c00
        MOV		DS,AX
        MOV     ES,AX
        MOV     SI,msg

lop:
        MOV     AL,BYTE[SI]
        ADD     SI,1
        CMP     AL,0
        JE      fin
        MOV     AH,0x0e     	; 显示一个文字
        MOV     BX,15       	; 颜色
        INT     0x10        	; bios
        JMP     lop

fin:
        HLT
        JMP     fin

msg:
        DB      0x0a, 0x0a		; \n\n
        DB		"hello,bug" 
        DB		0x0a			
        DB		0
        RESB	0x7dfe-$    	; 写0x00到0x7dfe		
        DB		0x55, 0xaa

JMP		main