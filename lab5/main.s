lw      $1 0x0 $zero
lw      $2 0x1 $zero
add     $3,$1,$2
sub     $4,$2,$1
and     $5,$1,$2
or      $6,$1,$2
addi    $7,$1,0x1
andi    $8,$1,0x8
ori     $9,$1,0xf3
slt     $10,$2,$1
sll     $11,$1,0x2
srl     $12,$1,0x2
sw      $12 0x3 $zero 
beq     $1,$1,0x2       # to jal
nop
nop
jal     0x15            # to jr
j       0x15            # to jr
nop
nop
nop
jr      $ra             # to j

