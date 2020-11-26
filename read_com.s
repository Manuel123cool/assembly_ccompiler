  .section .data
print_cmp_txt:
  .ascii "print(\""
exe_s:
  .ascii "exe.s\0"
new_line:
  .ascii "\n"
  .section .bss
  .equ BUFFER_SIZE, 500
  .lcomm BUFFER_DATA, BUFFER_SIZE

  .equ PRINT_LABEL_SIZE, 5
  .lcomm PRINT_LABEL, PRINT_LABEL_SIZE
  .section .text

  .type setupDataSection, @function
  .global setupDataSection
setupDataSection:
  pushq %rbp
  movq %rsp, %rbp

  pushq %rax
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

  #print data section
  xorq %rdx, %rdx #input arguments
  pushq $0
  pushq $exe_s
  movb $0, %dl 
  movb $0, %dh 
  pushq %rdx
  call testCom
  addq $24, %rsp
  #print data section end

start_read_line:
  incq %rbx

  #setup label 
  movq %rbx, %rdx
  addq $48, %rdx
  xorq %rsi, %rsi #input arguments
  movb $108, PRINT_LABEL(, %rsi, 1)
  incq %rsi
  movb %dl, PRINT_LABEL(, %rsi, 1)
  #setup label end

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
  movq %rax, %r9 #holds length

  pushq %rcx
  pushq %rax 
  call readPrint
  addq $16, %rsp

  cmpq $0, %rax
  je not_print
  
  #print label
  xorq %rdx, %rdx #input arguments
  pushq $PRINT_LABEL 
  pushq $exe_s
  movb $4, %dl 
  movb $0, %dh 

  movl $2, %r8d
  shlq $32, %r8
  orq %r8, %rdx
  pushq %rdx
  call testCom
  addq $24, %rsp
  #print label end
  call printNewLine
  #print ascii
  xorq %rdx, %rdx #input arguments
  pushq %rax 
  pushq $exe_s
  movb $3, %dl 
  movb $0, %dh 

  subq $9, %r9
  shlq $32, %r9
  orq %r9, %rdx
  pushq %rdx
  call testCom
  addq $24, %rsp
  #end print ascii
  call printNewLine
not_print:
  jmp start_read_line
  
end_read_line:
  popq %r9
  popq %r8
  popq %rdi
  popq %rsi
  popq %rdx
  popq %rcx
  popq %rbx
  popq %rax

  leave
  ret

  .type doPrint, @function
  .global doPrint
doPrint:
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

  #print text section
  xorq %rdx, %rdx #input arguments
  pushq $0
  pushq $exe_s
  movb $0, %dl 
  movb $2, %dh 
  pushq %rdx
  call testCom
  addq $24, %rsp
  #end print test section
  #print start
  xorq %rdx, %rdx #input arguments
  pushq $0
  pushq $exe_s
  movb $1, %dl 
  movb $0, %dh 
  pushq %rdx
  call testCom
  addq $24, %rsp
  #end print start

  xorq %rbx, %rbx #counter
  xorq %rcx, %rcx #address of line
start_print_txt: 
  incq %rbx

  #setup label 
  movq %rbx, %rdx
  addq $48, %rdx
  xorq %rsi, %rsi #input arguments
  xorq %rsi, %rsi #input arguments
  movb $9, PRINT_LABEL(, %rsi, 1)
  incq %rsi
  movb $36, PRINT_LABEL(, %rsi, 1)
  incq %rsi
  movb $108, PRINT_LABEL(, %rsi, 1)
  incq %rsi
  movb %dl, PRINT_LABEL(, %rsi, 1)
  #setup label end

  pushq %rdi
  pushq %rbx
  call readLine
  addq $16, %rsp
  movq %rax, %rcx

  cmpq $0, %rax
  je end_print_txt

  pushq %rax
  call countBuffer
  addq $8, %rsp
  movq %rax, %r9 #holds length

  pushq %rcx
  pushq %rax 
  call readPrint
  addq $16, %rsp

  cmpq $0, %rax
  je not_print

  #print 4 into rax 
  xorq %rdx, %rdx #input arguments
  xorq %r9, %r9 
  pushq $0 
  pushq $exe_s
  movb $4, %dh 
  shlq $8, %rdx
  movb $8, %dh 
  movb $2, %dl 
   
  movb $0, %r9b
  shlq $8, %r9
  shlq $32, %r9
  orq %r9, %rdx
  pushq %rdx
  call testCom
  addq $24, %rsp
  #end print 4 into rax
  call printNewLine  

  #print descriptor in rbx 
  xorq %rdx, %rdx #input arguments
  xorq %r9, %r9 
  pushq $0 
  pushq $exe_s
  movb $1, %dh 
  shlq $8, %rdx
  movb $8, %dh 
  movb $2, %dl 
   
  movb $1, %r9b
  shlq $8, %r9
  shlq $32, %r9
  orq %r9, %rdx
  pushq %rdx
  call testCom
  addq $24, %rsp
  #end print desciptor
  call printNewLine  
  #print label in rcx 
  xorq %rdx, %rdx #input arguments
  xorq %r9, %r9 
  pushq $PRINT_LABEL
  pushq $exe_s
  movb $4, %dh 
  shlq $8, %rdx
  movb $9, %dh 
  movb $2, %dl 
   
  movb $3, %r9b
  shlq $8, %r9
  shlq $32, %r9
  orq %r9, %rdx
  pushq %rdx
  call testCom
  addq $24, %rsp
  #end print label
  call printNewLine  
  #print size in rdx 
  xorq %rdx, %rdx #input arguments
  xorq %r9, %r9 
  pushq $PRINT_LABEL
  pushq $exe_s
  movb $4, %dh 
  shlq $8, %rdx
  movb $9, %dh 
  movb $2, %dl 
   
  movb $3, %r9b
  shlq $8, %r9
  shlq $32, %r9
  orq %r9, %rdx
  pushq %rdx
  call testCom
  addq $24, %rsp
  #end print size into rdx
  call printNewLine  



not_print2:
  jmp start_print_txt
end_print_txt:
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
   xorq %r8, %r8
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

.type printNewLine, @function
printNewLine:
  pushq %rbp
  movq %rsp, %rbp  
  
  pushq %rax

  #print new line
  pushq $1
  pushq $exe_s
  pushq $new_line
  call writeLine
  addq $24, %rsp
  #end print new line

  pop %rax

  leave
  ret
