# Pong
# ==================================
# Author: Joshua Potter
# Date: 04/19/2015


# Data Memory
# ----------------------------------
# Note the board has a limited amount of space, so we try and make everything
# as compact as possible.
.data 0x2000



# Instruction Memory
# ----------------------------------
# Be sure to set memory configuration Compact, Text at 0
# Note data memory is offset at 0x2000, screen memory at 0x4000, and keyboard at 0x6000
.text 0x0000
	add 	$0, $0, $0		# NOP
	addi	$sp, $0, 0x203c		# top of the stack is the word at address [0x203c - 0x203f]
init:
	addi 	$s0, $0, 1		# x velocity
	addi 	$s1, $0, 40		# y velocity
	addi	$s2, $0, 580		# Ball Location
	addi	$s3, $0, 42		# Left Paddle Top Left
	addi	$s4, $0, 928		# Right Paddle Top Left
	addi	$s5, $0, 0xup		# Up Button
	addi	$s6, $0, 0xdown		# Down Button
	addi	$s7, $0, 0xspacebar	# Spacebar
start:
	lw 	$t0, 0x6000($0)		# Check if spacebar pressed
	bne 	$t0, $s7, main
	addi	$a0, $0, 1200
main:					# Main Game Loop
	jal	clear
	jal	update_ball
	jal	update_comp
	jal	update_player		
	jal	draw
	j	main
end:
	j	end			# No syscalls to exit
		
	
clear:					# Reset up to $a0 screen locations to white
	addi	$sp, $sp, -4
	sw	$a0, 0($sp)
	addi	$t0, $0, 4
clear_loop:
	addi	$t1, $a0, 0x4000	# Screen memory begins at 0x4000
	addi	$a0, $a0, -1
	sw	$t0, 0($t1)
	bne	$a0, $0, reset_loop
clear_end:
	lw	$a0, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra
	
	
draw:					# Draws the ball and paddles
	addi 	$t0, $s3, 0		# Top left corners of each paddle
	addi	$t1, $s4, 0
	addi	$t2, $0, 6		# Paddles are of height 7 characters
draw_paddles:
	sw 	$0, 0($t0)		# Black character code is 0
	sw	$0, 0($t1)
	addi	$t0, $t0, 40
	addi	$t1, $t1, 40
	addi	$t2, $t2, -1
	bne	$t2, $0, draw_paddles
draw_ball:
	sw	$s2, 0($t0)
	jr	$ra
	
	
update_ball:
	add	$s2, $s2, $s0		# Reposition's ball
	add	$s2, $s2, $s1
	jr	$ra
	
	
update_comp:				# Reposition's computer's paddle
	jr	$ra
	
	
update_player:				# Repositions player's paddle
	addi	$a0, $0, 0		# Set so the paddle/ball doesn't move
	lw	$t0, 0x6000($0)
	beq	$t0, $s5, updatep_up 
	beq	$t0, $s6, updatep_down
updatep_move:
	add	$s3, $s3, $a0		# Move player's paddle
	jr	$ra
updatep_up:
	addi	$a0, $0, -40
	j updatep_move
updatep_down:
	addi	$a0, $0, 40
	j updatep_move
	
	
pause:
	addi	$sp, $sp, -8
	sw	$ra, 4($sp)
	sw	$a0, 0($sp)
	sll     $a0, $a0, 16
	beq	$a0, $0, pse_done
pse_loop:
	addi    $a0, $a0, -1
	bne	$a0, $0, pse_loop
pse_done:
	lw	$a0, 0($sp)
	lw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jr	$ra
