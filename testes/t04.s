.text
.GLOBL _start

_start:
	PUSHL $_i
	PUSHL $0
	POPL %EAX
	POPL %EDX
	MOVL %EAX, (%EDX)
	PUSHL %EAX
	POPL %EAX
rot_01:
	PUSHL $1
	POPL %EAX
	CMPL $0, %EAX
	JE rot_02
	MOVL $_str_0Len, %EDX
	MOVL $_str_0, %ECX
	CALL _writeLit
	CALL _writeln
	PUSHL _i
	MOVL $_str_1Len, %EDX
	MOVL $_str_1, %ECX
	CALL _writeLit
	POPL %EAX
	CALL _write
	CALL _writeln
	PUSHL _i
	PUSHL $3
	POPL %EAX
	POPL %EDX
	CMPL %EAX, %EDX
	MOVL $0, %EAX
	SETG %AL
	PUSHL %EAX
	POPL %EAX
	CMPL $0, %EAX
	JE rot_04
	JMP rot_02
	JMP rot_05
rot_04:
rot_05:
	PUSHL $_j
	PUSHL $0
	POPL %EAX
	POPL %EDX
	MOVL %EAX, (%EDX)
	PUSHL %EAX
	POPL %EAX
rot_06:
	PUSHL _j
	PUSHL $6
	POPL %EAX
	POPL %EDX
	CMPL %EAX, %EDX
	MOVL $0, %EAX
	SETLE %AL
	PUSHL %EAX
	POPL %EAX
	CMPL $0, %EAX
	JE rot_07
	PUSHL _j
	PUSHL $_j
	POPL %EDX
	POPL %EAX
	ADDL $1, %EAX
	MOVL %EAX, (%EDX)
	SUBL $1, %EAX
	PUSHL %EAX
	POPL %EAX
	PUSHL _j
	PUSHL $2
	POPL %EAX
	POPL %EDX
	CMPL %EAX, %EDX
	MOVL $0, %EAX
	SETL %AL
	PUSHL %EAX
	PUSHL _j
	PUSHL $4
	POPL %EAX
	POPL %EDX
	CMPL %EAX, %EDX
	MOVL $0, %EAX
	SETG %AL
	PUSHL %EAX
	POPL %EDX
	POPL %EAX
	CMPL $0, %EAX
	MOVL $0, %EAX
	SETNE %AL
	CMPL $0, %EDX
	MOVL $0, %EDX
	SETNE %DL
	ORL %EDX, %EAX
	PUSHL %EAX
	POPL %EAX
	CMPL $0, %EAX
	JE rot_09
	JMP rot_08
	JMP rot_10
rot_09:
rot_10:
	PUSHL _j
	MOVL $_str_2Len, %EDX
	MOVL $_str_2, %ECX
	CALL _writeLit
	POPL %EAX
	CALL _write
	CALL _writeln
rot_08:
	JMP rot_06
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
rot_03:
	JMP rot_01
rot_02:

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

_str_0:	.ascii " "
_str_0Len = . - _str_0
_str_1:	.ascii "i: "
_str_1Len = . - _str_1
_str_2:	.ascii "   j: "
_str_2Len = . - _str_2
