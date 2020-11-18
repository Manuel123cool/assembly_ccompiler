  .section .data
random_number:
  .ascii "1234"
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
  movb $4, %bh
  shlq $8, %rbx
  movb $2, %bl
  movb $8, %bh
  pushq %rbx
  call testCom
  addq $16, %rsp

  movq $1, %rax
  movq $0, %rbx
  int $0x80
  
