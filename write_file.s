  .section .data
  .section .bss
  .equ BUFFER_SIZE, 500
  .lcomm BUFFER_DATA, BUFFER_SIZE

  .section .text

  .type writeLine, @function
  .global writeLine
writeLine:
  pushq %rbp
  movq %rsp, %rbp

  #save register
  pushq %r9
  pushq %r8
  pushq %rbx
  pushq %rcx
  pushq %rdx
  pushq %rsi
  pushq %rdi

  movq 32(%rbp), %r8 #line length
  movq 24(%rbp), %rsi #address of name
  movq 16(%rbp), %rdi #address of line

  #read data into buffer
  #open file
  movq $5, %rax 
  movq %rsi, %rbx 
  movq $0, %rcx 
  movq $0666, %rdx 
  int $0x80

  movq %rax, %r9

  movq $3, %rax 
  movq %r9, %rbx 
  leaq BUFFER_DATA, %rcx 
  movq $BUFFER_SIZE, %rdx 
  int $0x80
 
  #chack if stack data is needed
  call countBuffer
  movq %r8, %r9
  addq %rax, %r9
  cmpq $BUFFER_SIZE, %r9
  jl no_need_stack 

no_need_stack:
  xorq %rbx, %rbx #count
  xorq %rdx, %rdx #parent
start_append:
  #append line to data
  movb (%rdi), %dl
  movb %dl, BUFFER_DATA(, %rax, 1) 
    
  #increase counter
  incq %rbx 
  incq %rax
  incq %rdi   

  cmp %rbx, %r8
  je end_of_appending
  jmp start_append 
end_of_appending:
  #open file
  movq $5, %rax 
  movq %rsi, %rbx 
  movq $03101, %rcx 
  movq $0666, %rdx 
  int $0x80

  movq %rax, %rsi
  #write file
  movq $4, %rax 
  movq %rsi, %rbx 
  movq $BUFFER_DATA, %rcx 
  movq %r9, %rdx 
  int $0x80

  #redo register
  popq %rdi
  popq %rsi
  popq %rdx
  popq %rcx
  popq %rbx
  popq %r8
  popq %r9
 
  leave
  ret


  .type countBuffer, @function
countBuffer:
  pushq %rbp
  movq %rsp, %rbp  

  pushq %rdx
  pushq %rcx
    
  xorq %rax, %rax #counter
  xorq %rdx, %rdx #parent
  xorq %rcx, %rcx #byte counter

start_count:
  movb BUFFER_DATA(, %rcx, 1), %dl 
  incq %rcx
  cmpb $0, %dl 
  je dont_increase_counter
  movq %rcx, %rax 
dont_increase_counter:
  cmpq $BUFFER_SIZE, %rcx
  jne start_count 
end_count_loop:

  popq %rcx
  popq %rdx

  leave
  ret
  
