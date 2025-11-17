.text

#	 nome COMPLETO e matricula dos componentes do grupo...
#

.GLOBL _start


_start:
	MOVL $_str_0Len, %EDX
	MOVL $_str_0, %ECX
	CALL _writeLit
	CALL _writeln
	PUSHL $1
	POPL %EDX
	MOVL %EDX, _i
	PUSHL %EDX
	POPL %EAX   # descarta resultado da inicializacao do for
	JMP rot_01
rot_01:
	PUSHL _i
	PUSHL $5
	POPL %EAX
	POPL %EDX
	CMPL %EAX, %EDX
	MOVL $0, %EAX
	SETLE %AL
	PUSHL %EAX
	POPL %EAX   # condicao do for
	CMPL $0, %EAX
	JE rot_04
	JMP rot_02
rot_03:
	PUSHL _i
	MOVL _i, %EAX
	ADDL $1, %EAX
	MOVL %EAX, _i
	POPL %EAX   # incremento do for
	JMP rot_01
rot_02:
	MOVL $_str_1Len, %EDX
	MOVL $_str_1, %ECX
	CALL _writeLit
	PUSHL _i
	POPL %EAX
	CALL _write
	CALL _writeln
	JMP rot_03
rot_04:
	MOVL $_str_2Len, %EDX
	MOVL $_str_2, %ECX
	CALL _writeLit
	CALL _writeln
	MOVL $_str_3Len, %EDX
	MOVL $_str_3, %ECX
	CALL _writeLit
	CALL _writeln
	PUSHL $10
	POPL %EDX
	MOVL %EDX, _i
	PUSHL %EDX
	JMP rot_05
rot_05:
	PUSHL _i
	PUSHL $13
	POPL %EAX
	POPL %EDX
	CMPL %EAX, %EDX
	MOVL $0, %EAX
	SETLE %AL
	PUSHL %EAX
	POPL %EAX   # condicao do for
	CMPL $0, %EAX
	JE rot_08
	JMP rot_06
rot_07:
	JMP rot_05
rot_06:
	MOVL $_str_4Len, %EDX
	MOVL $_str_4, %ECX
	CALL _writeLit
	PUSHL _i
	POPL %EAX
	CALL _write
	CALL _writeln
	PUSHL _i
	MOVL _i, %EAX
	ADDL $1, %EAX
	MOVL %EAX, _i
		# terminou o bloco...
	JMP rot_07
rot_08:
	MOVL $_str_5Len, %EDX
	MOVL $_str_5, %ECX
	CALL _writeLit
	CALL _writeln
	MOVL $_str_6Len, %EDX
	MOVL $_str_6, %ECX
	CALL _writeLit
	CALL _writeln
	PUSHL $100
	POPL %EDX
	MOVL %EDX, _i
	PUSHL %EDX
	JMP rot_09
rot_09:
	JMP rot_10
rot_11:
	JMP rot_09
rot_10:
	PUSHL _i
	MOVL _i, %EAX
	ADDL $1, %EAX
	MOVL %EAX, _i
	PUSHL _i
	PUSHL $105
	POPL %EAX
	POPL %EDX
	CMPL %EAX, %EDX
	MOVL $0, %EAX
	SETL  %AL
	PUSHL %EAX
	POPL %EAX
	CMPL $0, %EAX
	JE rot_13
	JMP rot_11   # continue
	JMP rot_14
rot_13:
rot_14:
	PUSHL _i
	PUSHL $110
	POPL %EAX
	POPL %EDX
	CMPL %EAX, %EDX
	MOVL $0, %EAX
	SETG  %AL
	PUSHL %EAX
	POPL %EAX
	CMPL $0, %EAX
	JE rot_15
	JMP rot_12   # break
	JMP rot_16
rot_15:
rot_16:
	MOVL $_str_7Len, %EDX
	MOVL $_str_7, %ECX
	CALL _writeLit
	PUSHL _i
	POPL %EAX
	CALL _write
	CALL _writeln
		# terminou o bloco...
	JMP rot_11
rot_12:
	MOVL $_str_8Len, %EDX
	MOVL $_str_8, %ECX
	CALL _writeLit
	CALL _writeln
	MOVL $_str_9Len, %EDX
	MOVL $_str_9, %ECX
	CALL _writeLit
	CALL _writeln
	PUSHL $1
	POPL %EDX
	MOVL %EDX, _i
	PUSHL %EDX
	POPL %EAX   # descarta resultado da inicializacao do for
	JMP rot_17
rot_17:
	PUSHL _i
	PUSHL $3
	POPL %EAX
	POPL %EDX
	CMPL %EAX, %EDX
	MOVL $0, %EAX
	SETLE %AL
	PUSHL %EAX
	POPL %EAX   # condicao do for
	CMPL $0, %EAX
	JE rot_20
	JMP rot_18
rot_19:
	PUSHL _i
	MOVL _i, %EAX
	ADDL $1, %EAX
	MOVL %EAX, _i
	POPL %EAX   # incremento do for
	JMP rot_17
rot_18:
	PUSHL $1
	POPL %EDX
	MOVL %EDX, _j
	PUSHL %EDX
	POPL %EAX   # descarta resultado da inicializacao do for
	JMP rot_21
rot_21:
	PUSHL _j
	PUSHL $3
	POPL %EAX
	POPL %EDX
	CMPL %EAX, %EDX
	MOVL $0, %EAX
	SETLE %AL
	PUSHL %EAX
	POPL %EAX   # condicao do for
	CMPL $0, %EAX
	JE rot_24
	JMP rot_22
rot_23:
	PUSHL _j
	MOVL _j, %EAX
	ADDL $1, %EAX
	MOVL %EAX, _j
	POPL %EAX   # incremento do for
	JMP rot_21
rot_22:
	MOVL $_str_10Len, %EDX
	MOVL $_str_10, %ECX
	CALL _writeLit
	PUSHL _i
	PUSHL _j
	POPL %EBX
	POPL %EAX
	IMULL %EBX, %EAX
	PUSHL %EAX
	POPL %EAX
	CALL _write
	CALL _writeln
	JMP rot_23
rot_24:
	JMP rot_19
rot_20:
	MOVL $_str_11Len, %EDX
	MOVL $_str_11, %ECX
	CALL _writeLit
	CALL _writeln
	MOVL $_str_12Len, %EDX
	MOVL $_str_12, %ECX
	CALL _writeLit
	CALL _writeln
	PUSHL $1
	POPL %EDX
	MOVL %EDX, _i
	PUSHL %EDX
	POPL %EAX   # descarta resultado da inicializacao do for
	JMP rot_25
rot_25:
	PUSHL _i
	PUSHL $3
	POPL %EAX
	POPL %EDX
	CMPL %EAX, %EDX
	MOVL $0, %EAX
	SETLE %AL
	PUSHL %EAX
	POPL %EAX   # condicao do for
	CMPL $0, %EAX
	JE rot_28
	JMP rot_26
rot_27:
	PUSHL $1
	POPL %EDX
	MOVL _i, %EAX
	ADDL %EDX, %EAX
	MOVL %EAX, _i
	PUSHL %EAX
	POPL %EAX   # incremento do for
	JMP rot_25
rot_26:
	PUSHL $1
	POPL %EDX
	MOVL %EDX, _j
	PUSHL %EDX
	POPL %EAX   # descarta resultado da inicializacao do for
	JMP rot_29
rot_29:
	PUSHL _j
	PUSHL $3
	POPL %EAX
	POPL %EDX
	CMPL %EAX, %EDX
	MOVL $0, %EAX
	SETLE %AL
	PUSHL %EAX
	POPL %EAX   # condicao do for
	CMPL $0, %EAX
	JE rot_32
	JMP rot_30
rot_31:
	PUSHL $1
	POPL %EDX
	MOVL _j, %EAX
	ADDL %EDX, %EAX
	MOVL %EAX, _j
	PUSHL %EAX
	POPL %EAX   # incremento do for
	JMP rot_29
rot_30:
	MOVL $_str_13Len, %EDX
	MOVL $_str_13, %ECX
	CALL _writeLit
	PUSHL _i
	PUSHL _j
	POPL %EBX
	POPL %EAX
	IMULL %EBX, %EAX
	PUSHL %EAX
	POPL %EAX
	CALL _write
	CALL _writeln
	JMP rot_31
rot_32:
	JMP rot_27
rot_28:



#
# devolve o controle para o SO (final da main)
#
	mov $0, %ebx
	mov $1, %eax
	int $0x80


#
# Funcoes da biblioteca (IO)
#


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



#
# area de dados
#
.data
#
# variaveis globais
#
_i:	.zero 4
_j:	.zero 4

#
# area de literais
#
__msg:
	.zero 30
__fim_msg:
	.byte 0


_str_0:
	 .ascii "> teste 1 "
_str_0Len = . - _str_0
_str_1:
	 .ascii " i: "
_str_1Len = . - _str_1
_str_2:
	 .ascii " "
_str_2Len = . - _str_2
_str_3:
	 .ascii "> teste 2 "
_str_3Len = . - _str_3
_str_4:
	 .ascii " i: "
_str_4Len = . - _str_4
_str_5:
	 .ascii " "
_str_5Len = . - _str_5
_str_6:
	 .ascii "> teste 3 "
_str_6Len = . - _str_6
_str_7:
	 .ascii " i: "
_str_7Len = . - _str_7
_str_8:
	 .ascii " "
_str_8Len = . - _str_8
_str_9:
	 .ascii "> teste 4 "
_str_9Len = . - _str_9
_str_10:
	 .ascii " - "
_str_10Len = . - _str_10
_str_11:
	 .ascii " "
_str_11Len = . - _str_11
_str_12:
	 .ascii "> teste 5 "
_str_12Len = . - _str_12
_str_13:
	 .ascii " - "
_str_13Len = . - _str_13
