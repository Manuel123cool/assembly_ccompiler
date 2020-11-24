  .section .data
print_cmp_txt:
  .ascii "print(\""
  .section .bss
  .equ BUFFER_SIZE, 500
  .lcomm BUFFER_DATA, BUFFER_SIZE

  .section .text

  .type setupDataSection, @function
  .global setupDataSection
setupDataSection:
  pushq %rbp
  movq %rsp, %rbp

  pushq %rbx
  pushq %rcx
  pushq %rdx
  pushq %rsi
  pushq %rdi
  pushq %r8
  pushq %r9

  movq 16(%rbp), %rdi #adress of name
   
  xorq %rbx, %rbx #counter
  xorq %rcx, %rcx #address of line

start_read_line:
  incq %rbx

  pushq %rdi
  pushq %rbx
  call readLine
  addq $16, %rsp
  movq %rax, %rcx
 
  cmpq $0, %rax
  je end_read_line
  
  pushq %rax
  call countBuffer
  addq $8, %rsp

  pushq %rcx
  pushq %rax 
  call readPrint
  addq $16, %rsp

  movq %rax, %rsi

  movq $4, %rax 
  movq $1, %rbx 
  movq %rsi, %rcx 
  movq $20, %rdx 
  int $0x80

end_read_line:
  popq %r9
  popq %r8
  popq %rdi
  popq %rsi
  popq %rdx
  popq %rcx
  popq %rbx

  leave
  ret

  .type readPrint, @function
  .global readPrint
readPrint:
  pushq %rbp
  movq %rsp, %rbp
   
  pushq %rbx
  pushq %rcx
  pushq %rdx
  pushq %rsi
  pushq %rdi
  pushq %r8
  pushq %r9

  movq 24(%rbp), %rsi #address of line data
  movq 16(%rbp), %rdi #line length

  xorq %rax, %rax #return 
  cmp $9, %rdi
  jle end_fun

  xorq %rbx, %rbx #counter
  movq %rsi, %rcx #line address counter
  leaq print_cmp_txt, %rdx #to cmp string address counter
start_cmp_loop:
   movb (%rcx), %r8b 
   cmpb (%rdx), %r8b
   jne end_fun
   
   incq %rcx #increase counter
   incq %rdx
   incq %rbx
  
   cmpq $7, %rbx
   je end_cmp_loop
   
   jmp start_cmp_loop
    
end_cmp_loop:
  #put data into buffer
  xorq %rdx, %rdx #counter 
start_read_data:
   movb (%rcx), %r9b
   movb %r9b, BUFFER_DATA(, %rdx, 1)

   incq %rcx #increase counter
   incq %rdx
  
   cmpb $34, (%rcx)
   jne start_read_data
end_read_data: 
  leaq BUFFER_DATA, %rax
end_fun:
  popq %r9
  popq %r8
  popq %rdi
  popq %rsi
  popq %rdx
  popq %rcx
  popq %rbx

  leave
  ret


.type countBuffer, @function
countBuffer:
  pushq %rbp
  movq %rsp, %rbp  

  pushq %rdx
  pushq %rcx
  pushq %rbx
    
  movq 16(%rbp), %rbx

  xorq %rax, %rax #counter
  xorq %rdx, %rdx #parent
  xorq %rcx, %rcx #byte counter

start_count:
  movb (%rbx), %dl 
  incq %rcx
  incq %rbx
  cmpb $0, %dl 
  je dont_increase_counter
  movq %rcx, %rax 
dont_increase_counter:
  cmpq $200, %rcx
  jne start_count 
end_count_loop:
 
  popq %rbx
  popq %rcx
  popq %rdx

  leave
  ret
