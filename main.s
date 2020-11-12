  .section .data
  .section .bss

  .global _start

  .section .text
_start:
  movq %rsp, %rbp 

  
  pushq 16(%rbp)
  call readNameInBuffer
  addq $8, %rsp

  pushq %rax
  pushq $6
  call readLine
  addq $16, %rsp
  
  movq %rax, %rsi

  movq $4, %rax 
  movq $1, %rbx 
  movq %rsi, %rcx 
  movq $200, %rdx 
  int $0x80

  movq $1, %rax
  movq $0, %rbx
  int $0x80
  
