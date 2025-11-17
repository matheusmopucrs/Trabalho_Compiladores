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
	PUSHL $10
	POPL %EAX
	POPL %EDX
	CMPL %EAX, %EDX
	MOVL $0, %EAX
	SETLE %AL
	PUSHL %EAX
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
