  .section .data

  .section .bss

  .section .text

  .type testCom, @function
  .global testCom
testCom:
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
  pushq %rax

  movq 24(%rbp), %rcx
  movq 16(%rbp), %rbx

  call testSection
  #redo register
  popq %rax
  popq %rdi
  popq %rsi
  popq %rdx
  popq %rcx
  popq %rbx
  popq %r8
  popq %r9
  
  leave
  ret  


  .type testSection, @function
testSection:
  pushq %rbp
  movq %rsp, %rbp

  cmpb $0, %bl
  jne end_test_section  
    
  cmpb $0, %bh
  je call_section_data

  cmpb $1, %bh
  je call_section_bss

  cmpb $2, %bh
  je call_section_text

call_section_data:
  call write_section_data
  jmp end_test_section

call_section_bss:
  call write_section_bss
  jmp end_test_section

call_section_text:
  call write_section_text
  jmp end_test_section

end_test_section:
  leave
  ret  
