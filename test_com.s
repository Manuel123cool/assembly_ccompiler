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

  movq 32(%rbp), %rsi #buffer address
  movq 24(%rbp), %rcx #name address
  movq 16(%rbp), %rbx #data settings

  call testSection
  call testStart
  call testMov
  call testAscii
  call testLabel

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


  .type testStart, @function
testStart:
  pushq %rbp
  movq %rsp, %rbp

  cmpb $1, %bl
  jne end_test_section1  
  call write_start    
end_test_section1:
  leave
  ret  


  .type testMov, @function
testMov:
  pushq %rbp
  movq %rsp, %rbp

  cmpb $2, %bl
  jne end_test_section2  
  call write_move    
end_test_section2:
  leave
  ret  

  .type testAscii, @function
testAscii:
  pushq %rbp
  movq %rsp, %rbp

  cmpb $3, %bl
  jne end_test_section3  
  call write_ascii    
end_test_section3:
  leave
  ret  

  .type testLabel, @function
testLabel:
  pushq %rbp
  movq %rsp, %rbp

  cmpb $4, %bl
  jne end_test_section4  
  call writeLabel    
end_test_section4:
  leave
  ret  
