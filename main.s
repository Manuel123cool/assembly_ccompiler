  .section .data
LINE_DONT_EXIST:
  .ascii "Line dosnt exist"
LINE_DATA:
  .ascii "Halli i am line number penis\n"
hallo:
  .section .bss

  .global _start

  .section .text
_start:
  movq %rsp, %rbp 
  
  pushq 16(%rbp)
  call readNameInBuffer
  addq $8, %rsp
  
  pushq %rax
  xorq %rbx, %rbx
  movb $0, %bl
  movb $0, %bh
  pushq %rbx
  call testCom
  addq $16, %rsp

  pushq %rax
  xorq %rbx, %rbx
  movb $0, %bl
  movb $1, %bh
  pushq %rbx
  call testCom
  addq $16, %rsp

  pushq %rax
  xorq %rbx, %rbx
  movb $0, %bl
  movb $2, %bh
  pushq %rbx
  call testCom
  addq $16, %rsp

  xorq %rbx, %rbx
  movq $1, %rax
  movq $0, %rbx
  int $0x80
  
