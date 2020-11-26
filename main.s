  .section .data
random_number:
  .ascii " hallo"
  .section .bss


  .section .text
  .global _start
_start:
  movq %rsp, %rbp 
  
  pushq 16(%rbp)
  call readNameInBuffer
  addq $8, %rsp

  pushq %rax
  call setupDataSection
  addq $8, %rsp

  pushq 16(%rbp)
  call readNameInBuffer
  addq $8, %rsp

  pushq %rax
  call doPrint
  addq $8, %rsp

  movq $1, %rax
  movq $0, %rbx
  int $0x80
  
