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

  pushq $29
  pushq %rax
  pushq $LINE_DATA
  call writeLine
  addq $24, %rsp
  
  movq $1, %rax
  movq $0, %rbx
  int $0x80
  
