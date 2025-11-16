.text
.GLOBL _start

_start:
	MOVL $_str_0Len, %EDX
	MOVL $_str_0, %ECX
	CALL _writeLit
	CALL _writeln
	PUSHL $_i
	PUSHL $1
	POPL %EAX
	POPL %EDX
	MOVL %EAX, (%EDX)
	PUSHL %EAX
	POPL %EAX
rot_01:
	PUSHL _i
	PUSHL $5
	POPL %EAX
	POPL %EDX
	CMPL %EAX, %EDX
	MOVL $0, %EAX
	SETLE %AL
	POPL %EAX
	CMPL $0, %EAX
	JE rot_02
	PUSHL _i
	MOVL $_str_1Len, %EDX
	MOVL $_str_1, %ECX
	CALL _writeLit
	POPL %EAX
	CALL _write
	CALL _writeln
rot_03:
	PUSHL _i
	PUSHL $_i
	POPL %EDX
	POPL %EAX
	ADDL $1, %EAX
	MOVL %EAX, (%EDX)
	SUBL $1, %EAX
	JMP rot_01
rot_02:
	MOVL $_str_2Len, %EDX
	MOVL $_str_2, %ECX
	CALL _writeLit
	CALL _writeln
	MOVL $_str_3Len, %EDX
	MOVL $_str_3, %ECX
	CALL _writeLit
	CALL _writeln
	PUSHL $_i
	PUSHL $10
	POPL %EAX
	POPL %EDX
	MOVL %EAX, (%EDX)
	PUSHL %EAX
	POPL %EAX
rot_04:
	PUSHL _i
	PUSHL $13
	POPL %EAX
	POPL %EDX
	CMPL %EAX, %EDX
	MOVL $0, %EAX
	SETLE %AL
	POPL %EAX
	CMPL $0, %EAX
	JE rot_05
	PUSHL _i
	MOVL $_str_4Len, %EDX
	MOVL $_str_4, %ECX
	CALL _writeLit
	POPL %EAX
	CALL _write
	CALL _writeln
	PUSHL _i
	PUSHL $_i
	POPL %EDX
	POPL %EAX
	ADDL $1, %EAX
	MOVL %EAX, (%EDX)
	SUBL $1, %EAX
	PUSHL %EAX
	POPL %EAX
rot_06:
	JMP rot_04
rot_05:
	MOVL $_str_5Len, %EDX
	MOVL $_str_5, %ECX
	CALL _writeLit
	CALL _writeln
	MOVL $_str_6Len, %EDX
	MOVL $_str_6, %ECX
	CALL _writeLit
	CALL _writeln
	PUSHL $_i
	PUSHL $100
	POPL %EAX
	POPL %EDX
	MOVL %EAX, (%EDX)
	PUSHL %EAX
	POPL %EAX
rot_07:
	PUSHL _i
	PUSHL $_i
	POPL %EDX
	POPL %EAX
	ADDL $1, %EAX
	MOVL %EAX, (%EDX)
	SUBL $1, %EAX
	PUSHL %EAX
	POPL %EAX
	PUSHL _i
	PUSHL $105
	POPL %EAX
	POPL %EDX
	CMPL %EAX, %EDX
	MOVL $0, %EAX
	SETL %AL
	PUSHL %EAX
	POPL %EAX
	CMPL $0, %EAX
	JE rot_10
	JMP rot_09
	JMP rot_11
rot_10:
rot_11:
	PUSHL _i
	PUSHL $110
	POPL %EAX
	POPL %EDX
	CMPL %EAX, %EDX
	MOVL $0, %EAX
	SETG %AL
	PUSHL %EAX
	POPL %EAX
	CMPL $0, %EAX
	JE rot_12
	JMP rot_08
	JMP rot_13
rot_12:
rot_13:
	PUSHL _i
	MOVL $_str_7Len, %EDX
	MOVL $_str_7, %ECX
	CALL _writeLit
	POPL %EAX
	CALL _write
	CALL _writeln
rot_09:
	JMP rot_07
rot_08:
	MOVL $_str_8Len, %EDX
	MOVL $_str_8, %ECX
	CALL _writeLit
	CALL _writeln
	MOVL $_str_9Len, %EDX
	MOVL $_str_9, %ECX
	CALL _writeLit
	CALL _writeln
	PUSHL $_i
	PUSHL $1
	POPL %EAX
	POPL %EDX
	MOVL %EAX, (%EDX)
	PUSHL %EAX
	POPL %EAX
rot_14:
	PUSHL _i
	PUSHL $3
	POPL %EAX
	POPL %EDX
	CMPL %EAX, %EDX
	MOVL $0, %EAX
	SETLE %AL
	POPL %EAX
	CMPL $0, %EAX
	JE rot_15
	PUSHL $_j
	PUSHL $1
	POPL %EAX
	POPL %EDX
	MOVL %EAX, (%EDX)
	PUSHL %EAX
	POPL %EAX
rot_17:
	PUSHL _j
	PUSHL $3
	POPL %EAX
	POPL %EDX
	CMPL %EAX, %EDX
	MOVL $0, %EAX
	SETLE %AL
	POPL %EAX
	CMPL $0, %EAX
	JE rot_18
	PUSHL _i
	PUSHL _j
	POPL %EBX
	POPL %EAX
	IMULL %EBX, %EAX
	PUSHL %EAX
	MOVL $_str_10Len, %EDX
	MOVL $_str_10, %ECX
	CALL _writeLit
	POPL %EAX
	CALL _write
	CALL _writeln
rot_19:
	PUSHL _j
	PUSHL $_j
	POPL %EDX
	POPL %EAX
	ADDL $1, %EAX
	MOVL %EAX, (%EDX)
	SUBL $1, %EAX
	JMP rot_17
rot_18:
rot_16:
	JMP rot_14
rot_15:
	MOVL $_str_11Len, %EDX
	MOVL $_str_11, %ECX
	CALL _writeLit
	CALL _writeln
	MOVL $_str_12Len, %EDX
	MOVL $_str_12, %ECX
	CALL _writeLit
	CALL _writeln
	PUSHL $_i
	PUSHL $1
	POPL %EAX
	POPL %EDX
	MOVL %EAX, (%EDX)
	PUSHL %EAX
	POPL %EAX
rot_20:
	PUSHL _i
	PUSHL $3
	POPL %EAX
	POPL %EDX
	CMPL %EAX, %EDX
	MOVL $0, %EAX
	SETLE %AL
	POPL %EAX
	CMPL $0, %EAX
	JE rot_21
	PUSHL $_j
	PUSHL $1
	POPL %EAX
	POPL %EDX
	MOVL %EAX, (%EDX)
	PUSHL %EAX
	POPL %EAX
rot_23:
	PUSHL _j
	PUSHL $3
	POPL %EAX
	POPL %EDX
	CMPL %EAX, %EDX
	MOVL $0, %EAX
	SETLE %AL
	POPL %EAX
	CMPL $0, %EAX
	JE rot_24
	PUSHL _i
	PUSHL _j
	POPL %EBX
	POPL %EAX
	IMULL %EBX, %EAX
	PUSHL %EAX
	MOVL $_str_13Len, %EDX
	MOVL $_str_13, %ECX
	CALL _writeLit
	POPL %EAX
	CALL _write
	CALL _writeln
rot_25:
	PUSHL $_j
	PUSHL _j
	PUSHL $1
	POPL %EAX
	POPL %EBX
	POPL %EDX
	ADDL %EBX, %EAX
	MOVL %EAX, (%EDX)
	JMP rot_23
rot_24:
rot_22:
	JMP rot_20
rot_21:

	mov $0, %ebx
	mov $1, %eax
	int $0x80

_writeln:
	MOVL $__fim_msg, %ECX
	DECL %ECX
	MOVB $10, (%ECX)
	MOVL $1, %EDX
	JMP _writeLit
_write:
	MOVL $__fim_msg, %ECX
	MOVL $0, %EBX
	CMPL $0, %EAX
	JGE _write3
	NEGL %EAX
	MOVL $1, %EBX
_write3:
	PUSHL %EBX
	MOVL $10, %EBX
_divide:
	MOVL $0, %EDX
	IDIVL %EBX
	DECL %ECX
	ADD $48, %DL
	MOVB %DL, (%ECX)
	CMPL $0, %EAX
	JNE _divide
	POPL %EBX
	CMPL $0, %EBX
	JE _print
	DECL %ECX
	MOVB $'-', (%ECX)
_print:
	MOVL $__fim_msg, %EDX
	SUBL %ECX, %EDX
_writeLit:
	MOVL $1, %EBX
	MOVL $4, %EAX
	int $0x80
	RET
_read:
	MOVL $15, %EDX
	MOVL $__msg, %ECX
	MOVL $0, %EBX
	MOVL $3, %EAX
	int $0x80
	MOVL $0, %EAX
	MOVL $0, %EBX
	MOVL $0, %EDX
	MOVL $__msg, %ECX
	CMPB $'-', (%ECX)
	JNE _reading
	INCL %ECX
	INC %BL
_reading:
	MOVB (%ECX), %DL
	CMP $10, %DL
	JE _fimread
	SUB $48, %DL
	IMULL $10, %EAX
	ADDL %EDX, %EAX
	INCL %ECX
	JMP _reading
_fimread:
	CMPB $1, %BL
	JNE _fimread2
	NEGL %EAX
_fimread2:
	RET
.data
_i:	.zero 4
_j:	.zero 4
__msg:	.zero 30
__fim_msg:	.byte 0

_str_0:	.ascii "> teste 1 "
_str_0Len = . - _str_0
_str_1:	.ascii " i: "
_str_1Len = . - _str_1
_str_2:	.ascii " "
_str_2Len = . - _str_2
_str_3:	.ascii "> teste 2 "
_str_3Len = . - _str_3
_str_4:	.ascii " i: "
_str_4Len = . - _str_4
_str_5:	.ascii " "
_str_5Len = . - _str_5
_str_6:	.ascii "> teste 3 "
_str_6Len = . - _str_6
_str_7:	.ascii " i: "
_str_7Len = . - _str_7
_str_8:	.ascii " "
_str_8Len = . - _str_8
_str_9:	.ascii "> teste 4 "
_str_9Len = . - _str_9
_str_10:	.ascii " - "
_str_10Len = . - _str_10
_str_11:	.ascii " "
_str_11Len = . - _str_11
_str_12:	.ascii "> teste 5 "
_str_12Len = . - _str_12
_str_13:	.ascii " - "
_str_13Len = . - _str_13
