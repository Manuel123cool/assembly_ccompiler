  .section .data
  .section .bss
  .equ BUFFER_SIZE, 500
  .lcomm BUFFER_DATA, BUFFER_SIZE

  .equ LINE_SIZE, 200
  .lcomm LINE_DATA, LINE_SIZE 

  .equ NAME_SIZE, 200
  .lcomm NAME_DATA, NAME_SIZE 
  .section .text

  .type readLine, @function
  .global readLine
readLine:
  pushq %rbp
  movq %rsp, %rbp

  pushq %rbx
  pushq %rcx
  pushq %rdx
  pushq %rsi
  pushq %rdi
  pushq %r8

  movq 24(%rbp), %rsi #address of name
  movq 16(%rbp), %rdi #line number 

  #open file
  movq $5, %rax 
  movq %rsi, %rbx 
  movq $0, %rcx 
  movq $0666, %rdx 
  int $0x80

  xorq %r8, %r8 #line counter
  xorq %rsi, %rsi #line byte counter

start_read: 
  movq %rax, %r9

  movq $3, %rax 
  movq %r9, %rbx 
  leaq BUFFER_DATA, %rcx 
  movq $BUFFER_SIZE, %rdx 
  int $0x80

  cmpq $0, %rax
  jle end_read 

  #read into line buffer
  xorq %rbx, %rbx #byte counter 
  xorq %rdx, %rdx #byte parent

start_line_read:
  movb BUFFER_DATA(, %rbx, 1), %dl #dl child of %rdx 
  cmpb $10, %dl
  jne not_reset 
  xorq %rsi, %rsi
  incq %r8
  #clear rest of line buffer if not destination
  cmpq %rdi, %r8
  je end_read # finish if destination
  call clearLineBuffer 
  
  incq %rbx #skip new line
  jmp start_line_read
not_reset:
  movb %dl, LINE_DATA(, %rsi, 1) 
  
  incq %rbx #increase counter
  incq %rsi 

  cmpq $BUFFER_SIZE, %rbx
  je start_read
  jmp start_line_read

end_read:
  xorq %rax, %rax
  cmpq %rdi, %r8
  jne not_reach_line 
  leaq LINE_DATA, %rax
not_reach_line:
  cmpq $0, %rax
  jne not_reach_line2
  xorq %rax, %rax
not_reach_line2: 

  popq %r8
  popq %rdi
  popq %rsi
  popq %rdx
  popq %rcx
  popq %rbx
  
  leave
  ret

# for some unknown reason open file syscall dosnt allow command line
# argument

  .type readNameInBuffer, @function
  .global readNameInBuffer
readNameInBuffer:
  pushq %rbp
  movq %rsp, %rbp

  #save variable
  pushq %rbx

  xorq %rax, %rax
  xorq %rbx, %rbx
  movq 16(%rbp), %rax  
start:
  movb (%rax), %sil
  movb %sil, NAME_DATA(, %rbx, 1)
  incq %rax
  incq %rbx
  cmpb $0, (%rax)
  je end
  jmp start 
end:
  movb (%rax), %sil
  movb %sil, NAME_DATA(, %rbx, 1)

  leaq NAME_DATA, %rax 

  popq %rbx

  leave
  ret

  .type clearLineBuffer, @function
clearLineBuffer:
  pushq %rbp
  movq %rsp, %rbp

  pushq %rbx #save variable

  xorq %rbx, %rbx
start_clear_loop:  
  movb $0, LINE_DATA(, %rbx, 1) 
  incq %rbx 
  cmpq $LINE_SIZE, %rbx
  je end_clear_loop
  jmp start_clear_loop
end_clear_loop:
  popq %rbx

  leave 
  ret
