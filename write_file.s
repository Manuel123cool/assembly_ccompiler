  .section .data
heap_begin:
  .quad 0
current_break:
  .quad 0

  .section .bss
  .equ BUFFER_SIZE, 5
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
 
  #chack if heap data is needed
  call countBuffer
  movq %r8, %r9
  addq %rax, %r9
  cmpq $BUFFER_SIZE, %r9
  jl no_need_heap 
  call doHeap 
  jmp end_of_appending2
no_need_heap:
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
  leaq BUFFER_DATA, %rdi
end_of_appending2:
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
  movq %rdi, %rcx 
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

  .type doHeap, @function
doHeap:
  pushq %rbp
  movq %rsp, %rbp  

  #save register
  pushq %r8
  pushq %rbx
  pushq %rcx
  pushq %rdx
  pushq %rsi
  pushq %rdi

  #first time get heap
  cmpq $0, current_break
  jne first_check
  movq $45, %rax 
  movq $0, %rbx
  int $0x80
  movq %rax, heap_begin 

  movq $1000, %rcx
  addq heap_begin, %rcx 
  movq $45, %rax 
  movq %rcx, %rbx
  int $0x80
  movq %rax, current_break 
   
  call zeroHeap
first_check:
  #check if heap enouph
  #load in memory
  movq $5, %rax 
  movq %rsi, %rbx 
  movq $0, %rcx 
  movq $0666, %rdx 
  int $0x80

  movq %rax, %r9

  movq $3, %rax 
  movq %r9, %rbx 
  movq heap_begin, %rcx 
  #get size
  movq current_break, %rsi
  subq %rcx, %rsi
  #get size end
  movq %rdi, %rdx 
  int $0x80

  call countHeap 
  
  addq %r8, %rax
  cmpq %rsi, %rax
  jge get_more_heap 
 
  cmpq %rsi, %rax
  jl end_heap_pending 

get_more_heap:
  movq $1000, %rcx
  addq current_break, %rcx 
  movq $45, %rax 
  movq %rcx, %rbx
  int $0x80
  movq %rax, current_break
 
  call zeroHeap
  
  jmp first_check 
end_heap_pending:

  #apend data
  popq %rdi
  xorq %rdx, %rdx #parent
  xorq %rsi, %rsi #counter
  
  movq heap_begin, %rbx
  subq %r8, %rax
  addq %rax, %rbx

start_append1:

  movb (%rdi), %dl
  movb %dl, (%rbx)
  incq %rbx
  incq %rdi
  incq %rsi

  cmpq %rsi, %r8
  je end_of_appending1
  jmp start_append1
 
end_of_appending1:
  xorq %r9, %r9
  addq %r8, %rax
  movq %rax, %r9

  movq heap_begin, %rdi
  #redo register
  popq %rsi
  popq %rdx
  popq %rcx
  popq %rbx
  popq %r8

  leave
  ret 

  .type zeroHeap, @function
zeroHeap:
  pushq %rbp
  movq %rsp, %rbp  
    
  pushq %rdx

  movq heap_begin, %rdx

start_zeroring:
  movb $0, (%rdx)   
  incq %rdx
  cmpq current_break, %rcx
  je end_zeroring
  jmp start_zeroring
end_zeroring:

  popq %rdx

  leave
  ret

  .type countHeap, @function
countHeap:
  pushq %rbp
  movq %rsp, %rbp  

  pushq %rdx
  pushq %rcx
  pushq %rdi
  pushq %rbx
    
  xorq %rax, %rax #counter
  xorq %rdx, %rdx #parent
  movq heap_begin, %rcx #byte counter
  xorq %rbx, %rbx #real counter

start_count1:
  movb (%rcx), %dl 
  incq %rcx
  incq %rbx
  cmpb $0, %dl 
  je dont_increase_counter1
  movq %rbx, %rax 
dont_increase_counter1:
  cmpq current_break, %rcx
  jne start_count1 
end_count_loop1:
  
  popq %rbx
  popq %rdi
  popq %rcx
  popq %rdx

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
  
