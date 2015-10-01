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
	addi	$s2, $0, 620		# Ball Location
	addi	$s3, $0, 41		# Left Paddle Top Left
	addi	$s4, $0, 958		# Right Paddle Top Left
	addi	$s5, $0, 0x0075		# Up Button
	addi	$s6, $0, 0x0072		# Down Button
	addi	$s7, $0, 0x0029		# Spacebar
	addi	$t7, $0, 4		# Used to color the background
start:
	lw 	$t0, 0x6000($0)		# Check if spacebar pressed
	bne 	$t0, $s7, start
main:					# Main Game Loop
	addi	$a0, $0, 20		# Pause for a fifth of a second
	jal	pause
	addi	$a0, $0, 1200		# Clear 1200 screen locations
	jal	clear
	jal	update_ball
	jal	update_comp
	jal	update_player
	jal	draw
	jal	game_over		# Check if should stop
	bne	$v0, $0, end
	j	main
end:
	lw 	$t0, 0x6000($0)		# Allow restarting
	bne 	$t0, $s7, init
	j	end			# No syscalls to exit
		
	
clear:					# Reset up to $a0 screen locations to white
	addi	$sp, $sp, -4
	sw	$a0, 0($sp)
	add	$t0, $0, $t7
clear_loop:
	addi	$a0, $a0, -1
	addi	$t1, $a0, 0x4000	# Screen memory begins at 0x4000
	sw	$t0, 0($t1)
	bne	$a0, $0, clear_loop
clear_end:
	lw	$a0, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra
	
	
draw:					# Draws the ball and paddles
	addi 	$t0, $s3, 0		# Top left corners of each paddle
	addi	$t1, $s4, 0
	addi	$t2, $0, 6		# Paddles are of height 7 characters
draw_paddles:
	sw 	$0, 0x4000($t0)		# Black character code is 0
	sw	$0, 0x4000($t1)
	addi	$t0, $t0, 40
	addi	$t1, $t1, 40
	addi	$t2, $t2, -1
	bne	$t2, $0, draw_paddles
draw_ball:
	sw	$0, 0x4000($s2)
	jr	$ra
	
	
update_ball:
	add	$t6, $s2, $s0		# Find future ball's position
	add	$t6, $t6, $s1
	addi	$t0, $0, 7
	add	$t1, $0, $s3
	add	$t2, $0, $s4
updx_ball:				# Go through paddle positions and check
	beq	$t6, $t1, updx_reverse	# for a collision
	beq	$t6, $t2, updx_reverse
	addi	$t1, $t1, 40
	addi	$t2, $t2, 40
	addi	$t0, $t0, -1
	bne	$t0, $0, updx_ball
	j	updy_ball
updx_reverse:
	sub	$s0, $0, $s0
	slt	$t0, $0, $s0
	beq	$t0, $0, updx_1
	j	updx_2
updx_1:
	addi 	$t7, $0, 1
	j	updy_ball
updx_2:
	addi	$t7, $0, 2
updy_ball:
	slt	$t0, $0, $t6		# Check if out top of screen
	beq	$t0, $0, updy_reverse
	addi	$t0, $0, 1200		# Check if out bottom of screen
	slt	$t0, $t0, $t6
	beq	$t0, $0, upd_ball_done
updy_reverse:
	sub	$s1, $0, $s1
upd_ball_done:
	add	$s2, $s2, $s0
	add	$s2, $s2, $s1
	jr 	$ra
	
	
update_comp:				# Reposition's computer's paddle
	addi	$a0, $0, 0
	slt	$t0, $s2, $s4
	beq	$t0, $0, updatec_down
	j	updatec_up
updatec_move:
	add	$s4, $s4, $a0
	jr	$ra
updatec_up:
	addi	$t0, $0, 78
	beq	$s4, $t0, updatec_move
	addi	$a0, $0, -40
	j	updatec_move
updatec_down:
	addi	$t0, $0, 958
	beq	$s4, $t0, updatec_move
	addi	$a0, $0, 40
	j	updatec_move
	
	
update_player:				# Repositions player's paddle
	addi	$a0, $0, 0		# Set so the paddle/ball doesn't move
	lw	$t0, 0x6000($0)
	beq	$t0, $s5, updatep_up 
	beq	$t0, $s6, updatep_down
updatep_move:
	add	$s3, $s3, $a0		# Move player's paddle
	jr	$ra
updatep_up:		
	addi	$t0, $0, 41		# Check if reached the top
	beq	$s3, $t0, updatep_move
	addi	$a0, $0, -40
	j updatep_move
updatep_down:
	addi	$t0, $0, 921		# Check if reached the bottom
	beq 	$s3, $t0, updatep_move 
	addi	$a0, $0, 40
	j updatep_move
	
	
game_over:
	addi	$v0, $0, 0
	addi	$t0, $0, 29
	addi	$t1, $0, 0
	addi	$t2, $0, 39
game_loop:
	beq	$s2, $t1, game_lost
	beq	$s2, $t2, game_lost
	addi	$t0, $t0, -1
	addi	$t1, $t1, 40
	addi	$t2, $t2, 40
	bne	$t0, $0, game_loop
	j	game_on
game_lost:
	addi	$v0, $v0, 1
game_on:
	jr	$ra
	
	
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
