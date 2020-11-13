  .section .data
LINE_DONT_EXIST:
  .ascii "Line dosnt exist"
  .section .bss

  .global _start

  .section .text
_start:
  movq %rsp, %rbp 

  
  pushq 16(%rbp)
  call readNameInBuffer
  addq $8, %rsp

  pushq %rax
  pushq $7
  call readLine
  addq $16, %rsp
  
  movq %rax, %rsi
  movq $200, %rdi #buffer size
  cmpq $0, %rsi
  jne not_zero
  leaq LINE_DONT_EXIST, %rsi
  movq $16, %rdi 
not_zero:
  movq $4, %rax 
  movq $1, %rbx 
  movq %rsi, %rcx 
  movq %rdi, %rdx 
  int $0x80

  movq $1, %rax
  movq $0, %rbx
  int $0x80
  
