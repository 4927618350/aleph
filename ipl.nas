; aleph-os

main:
        ORG     0x7c00
        JMP     entry
        DB	0x90
        DB	"ALEPHIPL"      ;启动区名称（8B）
        DW	512				
        DB	1				
        DW	1				
        DB	2				
        DW	224				
        DW      2880			
        DB	0xf0			
        DW	9				
        DW	18				
        DW	2				
        DD	0				
        DD	2880			
        DB      0,0,0x29		
        DD      0xffffffff		
        DB	"ALEPH-OS   "	;磁盘名称（11B）
        DB	"FAT12   "
        RESB	18				

entry:
        MOV     AX,0
        MOV     SS,AX
        MOV     SP,0x7c00
        MOV     DS,AX
        MOV     ES,AX
        MOV     SI,msg

lop:
        MOV     AL,BYTE[SI]
        ADD     SI,1
        CMP     AL,0
        JE      fin
        MOV     AH,0x0e     ;显示一个文字
        MOV     BX,15       ;颜色
        INT     0x10        ;bios
        JMP     lop

fin:
        HLT
        JMP     fin

msg:
        DB      0x0a, 0x0a      ;\n\n
        DB	"hello,bug" 
        DB	0x0a			
        DB	0
        RESB	0x7dfe-$    ;写0x00到0x7dfe		
        DB	0x55, 0xaa

JMP     main