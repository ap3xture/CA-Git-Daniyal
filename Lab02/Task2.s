#a =x21,  x = x20
li x22, 15  #b      
li x23, 7   #c    
li x5, 1           

li x20, 0
beq x20, x5, case_1
li x6, 2          
beq x20, x6, case_2
li x7, 3       
beq x20, x7, case_3
li x8, 4     
beq x20, x8, case_4
j default 
case_1:
    add x21, x22, x23  
    j exit      

case_2:
    sub x21, x22, x23 
    j exit

case_3:
    srli x21, x22, 1
    j exit

case_4:
    slli x21, x22, 1
    j exit

default:
    li x21, 0
    j exit   
exit: