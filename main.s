  .section .data
  .section .bss


  .section .text
  .global _start
_start:
  movq %rsp, %rbp 
  
  pushq 16(%rbp)
  call readNameInBuffer
  addq $8, %rsp
  
  pushq %rax
  xorq %rbx, %rbx
  movb $2, %bl
  movb $1, %bh
  pushq %rbx
  call testCom
  addq $16, %rsp

  movq $1, %rax
  movq $0, %rbx
  int $0x80
  
