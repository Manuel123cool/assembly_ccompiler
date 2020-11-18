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
  
  
  pushq $random_number
  pushq %rax
  xorq %rbx, %rbx
  xorq %rdx, %rdx
  movb $2, %dh 
  shlq $32, %rdx
  orq %rdx, %rbx

  movb $6, %bh
  shlq $8, %rbx
  movb $2, %bl
  movb $9, %bh
  pushq %rbx
  call testCom
  addq $16, %rsp

  movq $1, %rax
  movq $0, %rbx
  int $0x80
  
