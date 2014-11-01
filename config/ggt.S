.data
	a: .long 7
	b: .long 77
	outform: .string ”%d ist ggT von %d und %d.\n”
.text
.globl main
main:
	movl a, %eax
	pushl %eax
	movl b, %ebx
	pushl %ebx
	subl $4, %esp
	call ggt
	popl %eax
	add $8, %esp
	pushl %eax
	pushl $result
	call printf
	movl $0, %ebx
	movl $1, %eax
	int $0x80
.globl ggt
ggt:
	pushl %ebp
	mov %esp, %ebp
	movl 16(%ebp), %eax
	movl 12(%ebp), %ebx
	.while:
	cmpl $0, %ebx
	je .end

	cmpl %ebx, %eax
	jle .else
	subl %ebx, %eax
	j .while

	.else:
	subl %eax, %ebx
	j .while

	.end:
		movl %eax, 8(%ebp)
		popl %ebp
		ret

