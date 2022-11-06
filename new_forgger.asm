#####################################################################
#
# CSC258H5S Fall 2021 Assembly Final Project
# University of Toronto, St. George
#
# Student: Yiteng Sun, 1006750810
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 5
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# 1. Display the number of lives remaining. (Easy Feature)
# 2. After final player death, display game over/retry screen. Restart the game if the¡°retry¡± option is chosen. (Easy Feature)
# 3. 
# 4. Add sound effects for movement,collisions, game end and reaching the goal area. (Hard Feature)
# 5. Display the player¡¯s score at the top of the screen. (Since there is limited place in my screen, I will show the score in Run I/O) (Hard Feature) 
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################
.data 
displayAddress: .word 0x10008000
SafeColor: .word 0x00ff00 # I choose safe color as green.
WaterColor: .word 0x0000ff # I choose water color as blue
RoadColor: .word 0x000000 # I choose road color as black
ForgColor: .word 0xff75da # pink is the forg color
LogColor: .word 0xc9860a # brown color 
CarColor: .word 0xff0000 # red color is my cars color
FinishColor: .word 0xffffff # white color is the signal color when the frog win the game.
LIVESBAR3_POSITION: .word 132, 136, 148, 152, 164, 168, 260, 264, 276, 280, 292, 296 # 3 lives bar position
LIVESBAR2_POSITION: .word 132, 136, 148, 152, 260, 264, 276, 280 # 2 lives bar position
LIVESBAR1_POSITION: .word 132, 136, 260, 264 # 1 life bar position
FORG_INITIAL_POSITION: .word 3648, 3660, 3776, 3780, 3784, 3788, 3908, 3912, 4032, 4036, 4040, 4044 # initial position. Notice: We will use it in our collision.
FORG_POSITION: .word 3648, 3660, 3776, 3780, 3784, 3788, 3908, 3912, 4032, 4036, 4040, 4044 #the current position of frog. Notice that it will vary by the keyboard control.
WATER_DETECTION: .word 1024, 1028, 1032, 1036, 1040, 1044, 1048, 1052, 1056, 1060, 1064, 1068, 1072, 1076, 1080, 1084, 1088, 1092, 1096, 1100, 1104, 1108, 1112, 1116, 1120, 1124, 1128, 1132, 1136, 1140, 1144, 1148, 1536, 1540, 1544, 1548, 1552, 1556, 1560, 1564, 1568, 1572, 1576, 1580, 1584, 1588, 1592, 1596, 1600, 1604, 1608, 1612, 1616, 1620, 1624, 1628, 1632, 1636, 1640, 1644, 1648, 1652, 1656, 1660
GOAL_AREA_DETECTION: .word 512, 516, 520, 524, 528, 532, 536, 540, 544, 548, 552, 556, 560, 564, 568, 572, 576, 580, 584, 588, 592, 596, 600, 604, 608, 612, 616, 620, 624, 628, 632, 636 # the position we want to use to detect the position of goal area. 
LOG1_POSITION: .word 1040, 1044, 1048, 1052, 1056, 1060, 1064, 1068, 1168, 1172, 1176, 1180, 1184, 1188, 1192, 1196, 1296, 1300, 1304, 1308, 1312, 1316, 1320, 1324, 1424, 1428, 1432, 1436, 1440, 1444, 1448, 1452
LOG2_POSITION: .word 1104, 1108, 1112, 1116, 1120, 1124, 1128, 1132, 1232, 1236, 1240, 1244, 1248, 1252, 1256, 1260, 1360, 1364, 1368, 1372, 1376, 1380, 1384, 1388, 1488, 1492, 1496, 1500, 1504, 1508, 1512, 1516
LOG3_POSITION: .word 1568, 1572, 1576, 1580, 1584, 1588, 1592, 1596, 1696, 1700, 1704, 1708, 1712, 1716, 1720, 1724, 1824, 1828, 1832, 1836, 1840, 1844, 1848, 1852, 1952, 1956, 1960, 1964, 1968, 1972, 1976, 1980
LOG4_POSITION: .word 1632, 1636, 1640, 1644, 1648, 1652, 1656, 1660, 1760, 1764, 1768, 1772, 1776, 1780, 1784, 1788, 1888, 1892, 1896, 1900, 1904, 1908, 1912, 1916, 2016, 2020, 2024, 2028, 2032, 2036, 2040, 2044
CAR1_POSITION: .word 2592, 2596, 2600, 2604, 2608, 2612, 2616, 2620, 2720, 2724, 2728, 2732, 2736, 2740, 2744, 2748, 2848, 2852, 2856, 2860, 2864, 2868, 2872, 2876, 2976, 2980, 2984, 2988, 2992, 2996, 3000, 3004
CAR2_POSITION: .word 2656, 2660, 2664, 2668, 2672, 2676, 2680, 2684, 2784, 2788, 2792, 2796, 2800, 2804, 2808, 2812, 2912, 2916, 2920, 2924, 2928, 2932, 2936, 2940, 3040, 3044, 3048, 3052, 3056, 3060, 3064, 3068
CAR3_POSITION: .word 3088, 3092, 3096, 3100, 3104, 3108, 3112, 3116, 3216, 3220, 3224, 3228, 3232, 3236, 3240, 3244, 3344, 3348, 3352, 3356, 3360, 3364, 3368, 3372, 3472, 3476, 3480, 3484, 3488, 3492, 3496, 3500
CAR4_POSITION: .word 3152, 3156, 3160, 3164, 3168, 3172, 3176, 3180, 3280, 3284, 3288, 3292, 3296, 3300, 3304, 3308, 3408, 3412, 3416, 3420, 3424, 3428, 3432, 3436, 3536, 3540, 3544, 3548, 3552, 3556, 3560, 3564
WELCOME_MESSAGE: .asciiz "\n WELCOME TO FROGGER!"
SCORE_MESSAGE: .asciiz "\n Your current total score is :"
SUCCESSFUL_MESSAGE: .asciiz "\n VICTORY! After this round your totalscore is: "
TOTAL_SCORE: .word 0
lives_now: .word 3

.text
main:
jal Background
jal loadElements
j Print_the_welcome_message
######################################################################
#Draw All The Elements
######################################################################
Background:
addi $a1, $zero, 0 #Our loop initial position is 0
li $t3, 1024 # Because our biggest area has the length of 8. We only focus on the biggest area.
addi $sp, $sp, -4
sw $ra, 0($sp)

Background_loop: 
beq $a1, $t3, END
jal drawSafe
jal drawWater
jal drawMiddlePlace
jal drawRoad
jal drawStartArea
addi $a1, $a1, 4 # draw the next pixel.
li $t3, 1024 # Because our biggest area has the length of 8. We only focus on the biggest area.
j Background_loop
END: lw $ra 0($sp) 
addi $sp, $sp, 4
jr $ra

drawSafe:
lw $t0, displayAddress
lw $t1, SafeColor
li $t2, 1020 # Our final point is at this pixel(address).
li $t5, 0 # Our Start Position
la $t3, ($a1) #since $t3 stores the current loop position
add $t2, $t2, $t0 # load the final point address
add $t5, $t5, $t3 # load the start address
add $t0, $t0, $t5 # load current position
sw $t1, ($t0) #draw the current pixel
jr $ra 

drawWater:
lw $t0, displayAddress
lw $t1, WaterColor
li $t2, 2044 # Our final point is at this pixel
li $t5, 1024 # Our start point is at this pixel
la $t3, ($a1) # the current loop position
add $t2, $t2, $t0
add $t5, $t5, $t0
add $t5, $t5, $t3
sw $t1, ($t5)
jr $ra

drawMiddlePlace:
lw $t0, displayAddress
lw $t1, SafeColor
li $t2, 2556 # Our final point is at this pixel
li $t5, 2048 # Our start point is at this pixel 
la $t3, ($a1)
bge $t3, 512, Quit # if $a1 exceeds our required line, just finish this program.
add $t2, $t2, $t0
add $t5, $t5, $t0
add $t5, $t5, $t3
sw $t1, ($t5)
Quit: jr $ra

drawRoad:
lw $t0, displayAddress
lw $t1, RoadColor
li $t2, 3580 # Our final pixel
li $t5, 2560 # Our start pixel
la $t3, ($a1)
add $t2, $t2, $t0
add $t5, $t5, $t0
add $t5, $t5, $t3
sw $t1, ($t5)
jr $ra

drawStartArea:
lw $t0, displayAddress
lw $t1, SafeColor
li $t2, 4092 # Our final pixel
li $t5, 3584 # Our start pixel
la $t3, ($a1)
bge $t3, 512, Finish # if $a1 exceeds our required line, just finish this program.
add $t2, $t2, $t0
add $t5, $t5, $t0
add $t5, $t5, $t3
sw $t1, ($t5)
Finish: jr $ra


loadElements: #For this function, add some new elements like Frog, 4 Logs and 4 Cars.
addi $sp, $sp, -4
sw $ra, 0($sp)
jal drawLivesBar
li $a3, 1
LogsLoop: beq $a3, 5, NextStep
jal drawLogs
addi $a3, $a3, 1
j LogsLoop
NextStep: li $a2, 1
CarsLoop: beq $a2, 5, EndStep
jal drawCars
addi $a2, $a2, 1
j CarsLoop
EndStep: jal drawForg
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

drawForg: # this function is for initialize a forg.
lw $t0, displayAddress
lw $t1, ForgColor
la $t2, FORG_POSITION
lw $t3, 0($t2)
add $t3, $t3, $t0
sw $t1, ($t3)
lw $t3, 4($t2)
add $t3, $t3, $t0
sw $t1, ($t3)
lw $t3, 8($t2)
add $t3, $t3, $t0
sw $t1, ($t3)
lw $t3, 12($t2)
add $t3, $t3, $t0
sw $t1, ($t3)
lw $t3, 16($t2)
add $t3, $t3, $t0
sw $t1, ($t3)
lw $t3, 20($t2)
add $t3, $t3, $t0
sw $t1, ($t3)
lw $t3, 24($t2)
add $t3, $t3, $t0
sw $t1, ($t3)
lw $t3, 28($t2)
add $t3, $t3, $t0
sw $t1, ($t3)
lw $t3, 32($t2)
add $t3, $t3, $t0
sw $t1, ($t3)
lw $t3, 36($t2)
add $t3, $t3, $t0
sw $t1, ($t3)
lw $t3, 40($t2)
add $t3, $t3, $t0
sw $t1, ($t3)
lw $t3, 44($t2)
add $t3, $t3, $t0
sw $t1, ($t3)
jr $ra

drawLogs: # This function is for draw 4 logs
la $t9, ($a3)
beq $t9, 1, drawlog1
beq $t9, 2, drawlog2
beq $t9, 3, drawlog3
beq $t9, 4, drawlog4

drawlog1:
lw $t0, displayAddress
la $t1, LOG1_POSITION
lw $t2, LogColor
addi $t4, $zero, 0
j drawSingleObstacle

drawlog2:
lw $t0, displayAddress
la $t1, LOG2_POSITION
lw $t2, LogColor
addi $t4, $zero, 0
j drawSingleObstacle

drawlog3:
lw $t0, displayAddress
la $t1, LOG3_POSITION
lw $t2, LogColor
addi $t4, $zero, 0
j drawSingleObstacle

drawlog4:
lw $t0, displayAddress
la $t1, LOG4_POSITION
lw $t2, LogColor
addi $t4, $zero, 0
j drawSingleObstacle

drawCars:  # Draw this 4 cars
la $t8, ($a2)
beq $t8, 1, drawCar1
beq $t8, 2, drawCar2
beq $t8, 3, drawCar3
beq $t8, 4, drawCar4

drawCar1:
lw $t0, displayAddress
la $t1, CAR1_POSITION
lw $t2, CarColor
addi $t4, $zero, 0
j drawSingleObstacle

drawCar2:
lw $t0, displayAddress
la $t1, CAR2_POSITION
lw $t2, CarColor
addi $t4, $zero, 0
j drawSingleObstacle

drawCar3:
lw $t0, displayAddress
la $t1, CAR3_POSITION
lw $t2, CarColor
addi $t4, $zero, 0
j drawSingleObstacle

drawCar4:
lw $t0, displayAddress
la $t1, CAR4_POSITION
lw $t2, CarColor
addi $t4, $zero, 0
j drawSingleObstacle

drawSingleObstacle: # This function is for drawing our log or car, they have the same features.
beq $t4, 128, END1
lw $t3, 0($t1)
add $t3, $t3, $t0
sw $t2, ($t3)
addi $t1, $t1, 4
addi $t4, $t4, 4
j drawSingleObstacle
END1: jr $ra
#####################################################################
#Let the program sleep (in the main function)
#####################################################################
Sleep:
li $v0, 32 #let the function sleep for some second
la $a0, 200 # sleep for one second
syscall
jal Background # after sleeping, refresh the background, full elements and then load keyboard setting.
la $a1, lives_now
lw $a1, ($a1)
beq $a1, 0, Exit
jal loadElements
jal MovingElements
jal collision_detection
j KeyboardSetting
#####################################################################
#Keyboard Setting
#####################################################################
KeyboardSetting:
lw $t8, 0xffff0000
beq $t8, 1, keyboard_input
j Sleep

keyboard_input:
lw $t2, 0xffff0004
beq $t2, 0x61, respond_to_A
beq $t2, 0x73, respond_to_S
beq $t2, 0x64, respond_to_D
beq $t2, 0x77, respond_to_W
j Sleep

respond_to_A:
jal leftmove
j Sound1
j Sleep

leftmove:
# In this function, first we need to load the position of the frog
la $t0, FORG_POSITION
lw $t1, 0($t0) # this is the pixel we need to focus on. Actually, we can focus this leftmost column of pixels.
lw $t2, 4($t0)
lw $t3, 8($t0)
lw $t4, 12($t0)
lw $t5, 16($t0)
lw $t6, 20($t0)
lw $t7, 24($t0)
lw $t8, 28($t0)
lw $t9, 32($t0)
lw $s0, 36($t0)
lw $s1, 40($t0)
lw $s2, 44($t0) 
# the above process is load our frog position. the first run is load our initial position.
addi $s3, $zero, 0
addi $s4, $zero, 3712 # our maximum moving value should be 3712.
can_move1:beq $s3, $s4, moving1
beq $t1, $s3, stopmoving
addi $s3, $s3, 128
j can_move1
moving1: # since our frog is 4x4 size, once we press keyborad, the frog will move 4.
subi $t1, $t1, 16
sw $t1, 0($t0) # store the newly position to our forg position array.
subi $t2, $t2, 16
sw $t2, 4($t0)
subi $t3, $t3, 16
sw $t3, 8($t0)
subi $t4, $t4, 16
sw $t4, 12($t0)
subi $t5, $t5, 16
sw $t5, 16($t0)
subi $t6, $t6, 16
sw $t6, 20($t0)
subi $t7, $t7, 16
sw $t7, 24($t0)
subi $t8, $t8, 16
sw $t8, 28($t0)
subi $t9, $t9, 16
sw $t9, 32($t0)
subi $s0, $s0, 16
sw $s0, 36($t0)
subi $s1, $s1, 16
sw $s1, 40($t0)
subi $s2, $s2, 16
sw $s2, 44($t0)
jr $ra


respond_to_D:
jal rightmove
j Sound1
j Sleep

rightmove:
# In this function, first we need to load the position of the frog
la $t0, FORG_POSITION
lw $t1, 0($t0)
lw $t2, 4($t0) # this is the pixel we need to focus on.
lw $t3, 8($t0)
lw $t4, 12($t0)
lw $t5, 16($t0)
lw $t6, 20($t0)
lw $t7, 24($t0)
lw $t8, 28($t0)
lw $t9, 32($t0)
lw $s0, 36($t0)
lw $s1, 40($t0)
lw $s2, 44($t0) 
# the above process is load our frog position. the first run is load our initial position.
addi $s3, $zero, 124 # since we focus on the right area of our frog.
addi $s4, $zero, 3836 # Since at that time our maximum moving value should be 3836.
can_move2: beq $s3, $s4, moving2
beq $t2, $s3, stopmoving
addi $s3, $s3, 128
j can_move2
moving2:
addi $t1, $t1, 16
sw $t1, 0($t0) # store the newly position to our forg position array.
addi $t2, $t2, 16
sw $t2, 4($t0)
addi $t3, $t3, 16
sw $t3, 8($t0)
addi $t4, $t4, 16
sw $t4, 12($t0)
addi $t5, $t5, 16
sw $t5, 16($t0)
addi $t6, $t6, 16
sw $t6, 20($t0)
addi $t7, $t7, 16
sw $t7, 24($t0)
addi $t8, $t8, 16
sw $t8, 28($t0)
addi $t9, $t9, 16
sw $t9, 32($t0)
addi $s0, $s0, 16
sw $s0, 36($t0)
addi $s1, $s1, 16
sw $s1, 40($t0)
addi $s2, $s2, 16
sw $s2, 44($t0)

jr $ra


respond_to_S:
jal downmove
j Sound1
j Sleep

downmove:
# In this function, first we need to load the position of the frog
la $t0, FORG_POSITION
lw $t1, 0($t0)
lw $t2, 4($t0) # this is the pixel we need to focus on.
lw $t3, 8($t0)
lw $t4, 12($t0)
lw $t5, 16($t0)
lw $t6, 20($t0)
lw $t7, 24($t0)
lw $t8, 28($t0)
lw $t9, 32($t0)
lw $s0, 36($t0)
lw $s1, 40($t0)
lw $s2, 44($t0)
addi $s3, $zero, 3584
addi $s4, $zero, 3712
can_move3: beq $s3, $s4, moving3
beq $t2, $s3, stopmoving
addi $s3, $s3, 4 # (3712-3584)/4 = 32 steps.
j can_move3
moving3:
addi $t1, $t1, 512
sw $t1, 0($t0) # store the newly position to our forg position array.
addi $t2, $t2, 512
sw $t2, 4($t0)
addi $t3, $t3, 512
sw $t3, 8($t0)
addi $t4, $t4, 512
sw $t4, 12($t0)
addi $t5, $t5, 512
sw $t5, 16($t0)
addi $t6, $t6, 512
sw $t6, 20($t0)
addi $t7, $t7, 512
sw $t7, 24($t0)
addi $t8, $t8, 512
sw $t8, 28($t0)
addi $t9, $t9, 512
sw $t9, 32($t0)
addi $s0, $s0, 512
sw $s0, 36($t0)
addi $s1, $s1, 512
sw $s1, 40($t0)
addi $s2, $s2, 512
sw $s2, 44($t0)
sub_score: # the function that calculate the score of player
la $a0, TOTAL_SCORE
lw $a1, ($a0)
subi $a1, $a1, 20
sw $a1, ($a0)
jr $ra


respond_to_W:
jal upmove
j Sound1
j Sleep

upmove:
# In this function, first we need to load the position of the frog
la $t0, FORG_POSITION
lw $t1, 0($t0)
lw $t2, 4($t0) 
lw $t3, 8($t0)
lw $t4, 12($t0)
lw $t5, 16($t0)
lw $t6, 20($t0)
lw $t7, 24($t0)
lw $t8, 28($t0)
lw $t9, 32($t0) # this is the pixel we need to focus on
lw $s0, 36($t0)
lw $s1, 40($t0)
lw $s2, 44($t0)
addi $s3, $zero, 0
addi $s4, $zero, 508
can_move4: beq $s3, $s4, moving4
beq $t9, $s3, stopmoving
addi $s3, $s3, 4
j can_move4
moving4:
subi $t1, $t1, 512
sw $t1, 0($t0) # store the newly position to our forg position array.
subi $t2, $t2, 512
sw $t2, 4($t0)
subi $t3, $t3, 512
sw $t3, 8($t0)
subi $t4, $t4, 512
sw $t4, 12($t0)
subi $t5, $t5, 512
sw $t5, 16($t0)
subi $t6, $t6, 512
sw $t6, 20($t0)
subi $t7, $t7, 512
sw $t7, 24($t0)
subi $t8, $t8, 512
sw $t8, 28($t0)
subi $t9, $t9, 512
sw $t9, 32($t0)
subi $s0, $s0, 512
sw $s0, 36($t0)
subi $s1, $s1, 512
sw $s1, 40($t0)
subi $s2, $s2, 512
sw $s2, 44($t0)
add_score: # the function that calculate the score of player
la $a0, TOTAL_SCORE
lw $a1, ($a0)
addi $a1, $a1, 20
sw $a1, ($a0)
jr $ra

stopmoving: jr $ra

######################################################
#Moving the logs and cars automatically
######################################################
MovingElements: 
# the general function of moving the elements in this game. It is quite similar to load objects
addi $sp, $sp, -4
sw $ra 0($sp)
li $a3, 1
movinglogs: beq $a3, 5, nextstep # when $a3 turns to 5, it means all the logs moving quietly :)
jal moveslogs
addi $a3, $a3, 1
j movinglogs
nextstep: li $a2, 1
movingcars: beq $a2, 5, finishmoving #similarly, when $a2 turns to 5, it means all the cars moving quietly.
jal movescars
addi $a2, $a2, 1
j movingcars
finishmoving: lw $ra 0($sp)
addi $sp, $sp, 4
jr $ra


moveslogs:
la $t0, 0($a3)
beq $t0, 1, movelog1
beq $t0, 2, movelog2
beq $t0, 3, movelog3
beq $t0, 4, movelog4

movelog1:
la $t1, LOG1_POSITION
li $t3, 0 # Loop accumulator
li $t2, 128 # Since the length of log is 8. but we want to go through all the address of log1.Thus it will be 128
j shiftlog1

shiftlog1: beq $t3, $t2, endloop1
add $t4, $t3, $t1 # find the current address in the array.
lw $t5, ($t4) # then load the current address.
addi $t6, $t5, 4 # Then the log will shift right by 4 bits.
sw $t6, ($t4) # store the new address at the original position.
addi $t3, $t3, 4 # move to the next address.
beq $t6, 1152, margin_move1 # the rightmost barrier are 1152, 1280, 1408, 1536.
beq $t6, 1280, margin_move1
beq $t6, 1408, margin_move1
beq $t6, 1536, margin_move1
j shiftlog1
margin_move1:
subi $t6, $t6, 128 # when hit the rightmost margin, then it will show up at leftmost margin
sw $t6, ($t4)
j shiftlog1
endloop1: jr $ra

movelog2:
la $t1, LOG2_POSITION
li $t3, 0 # Loop accumulator
li $t2, 128 # Since the length of log is 8. but we want to go through all the address of log1.Thus it will be 128
j shiftlog2

shiftlog2:
beq $t3, $t2, endloop2
add $t4, $t3, $t1 # find the current address in the array.
lw $t5, ($t4) # then load the current address.
addi $t6, $t5, 4 # Then the log will shift right by 4 bits.
sw $t6, ($t4) # store the new address at the original position.
addi $t3, $t3, 4 # move to the next address.
beq $t6, 1152, margin_move2 # the rightmost barrier are 1152, 1280, 1408, 1536.
beq $t6, 1280, margin_move2
beq $t6, 1408, margin_move2
beq $t6, 1536, margin_move2
j shiftlog2
margin_move2:
subi $t6, $t6, 128 # when hit the rightmost margin, then it will show up at leftmost margin
sw $t6, ($t4)
j shiftlog2
endloop2: jr $ra

movelog3:
la $t1, LOG3_POSITION
li $t3, 0
li $t2, 128
j shiftlog3and4

movelog4:
la $t1, LOG4_POSITION
li $t3, 0
li $t2, 128
j shiftlog3and4

shiftlog3and4:
beq $t3, $t2, endloop3
add $t4, $t3, $t1 # also, find the current address in the array
lw $t5, ($t4) # load the current address 
subi $t6, $t5, 4 #At this time(also for log4), we will let the log shift left.
sw $t6, ($t4) #store the new address to the relevant location.
addi $t3, $t3, 4
beq $t6, 1532, margin_move3 #the leftmost barrier position will be 1532, 1660, 1788, 1916
beq $t6, 1660, margin_move3
beq $t6, 1788, margin_move3
beq $t6, 1916, margin_move3
j shiftlog3and4
margin_move3:
addi $t6, $t6, 128 # when hit the leftmost margin, it will show up at the rightmost margin
sw $t6, ($t4)
j shiftlog3and4
endloop3: jr $ra

movescars:
la $t0, 0($a2)
beq $t0, 1, movecar1
beq $t0, 2, movecar2
beq $t0, 3, movecar3
beq $t0, 4, movecar4

movecar1:
la $t1, CAR1_POSITION
li $t3, 0
li $t2, 128
j shiftcar1and2

movecar2:
la $t1, CAR2_POSITION
li $t3, 0
li $t2, 128
j shiftcar1and2

shiftcar1and2:
beq $t3, $t2, endloop4
add $t4, $t3, $t1 # find the current address in the array.
lw $t5, ($t4) # then load the current address.
addi $t6, $t5, 4 # Then the car will shift right 1 pixel by 4 bits.
sw $t6, ($t4) # store the new address at the original position.
addi $t3, $t3, 4 # move to the next address.
beq $t6, 2688, margin_move4 # the rightmost barrier are 2688, 2816, 2944, 3072
beq $t6, 2816, margin_move4
beq $t6, 2944, margin_move4
beq $t6, 3072, margin_move4
j shiftcar1and2
margin_move4:
subi $t6, $t6, 128 # when hit the rightmost margin, then it will show up at leftmost margin
sw $t6, ($t4)
j shiftcar1and2
endloop4: jr $ra

movecar3:
la $t1, CAR3_POSITION
li $t3, 0
li $t2, 128
j shiftcar3and4

movecar4:
la $t1, CAR4_POSITION
li $t3, 0
li $t2, 128
j shiftcar3and4

shiftcar3and4:
beq $t3, $t2, endloop5
add $t4, $t3, $t1 # also, find the current address in the array
lw $t5, ($t4) # load the current address 
subi $t6, $t5, 4 #At this time(also for log4), we will let the log shift left.
sw $t6, ($t4) #store the new address to the relevant location.
addi $t3, $t3, 4
beq $t6, 3068, margin_move5 #the leftmost barrier position will be 3068, 3196, 3324, 3452
beq $t6, 3196, margin_move5
beq $t6, 3324, margin_move5
beq $t6, 3452, margin_move5
j shiftcar3and4
margin_move5:
addi $t6, $t6, 128 # when hit the leftmost margin, it will show up at the rightmost margin
sw $t6, ($t4)
j shiftcar3and4
endloop5: jr $ra

#######################################################
#Collision detection
#######################################################
collision_detection:
addi $sp, $sp, -4
sw $ra, 0($sp)
jal carsdetection
jal logsdetection
jal GoalAreaDetection
enddetection: lw $ra 0($sp)
addi $sp, $sp, 4
jr $ra

carsdetection:
la $t0, FORG_POSITION
lw $t1, 0($t0) # top left corner of the frog, we need to check its position.
lw $t2, 4($t0) # top right corner of the frog, we need to check its position too.
la $t3, CAR1_POSITION
la $t4, CAR2_POSITION
la $t5, CAR3_POSITION
la $t6, CAR4_POSITION
la $t7, 0 #loop accumulator
generalcardetection:beq $t7, 128, finishchecking
add $s0, $t3, $t7 #load the current position of the car1
lw $s0, ($s0)
add $s1, $t4, $t7 #load the current position of the car2
lw $s1, ($s1)
add $s2, $t5, $t7 #load the current position of the car3
lw $s2, ($s2)
add $s3, $t6, $t7 #load the current position of the car4
lw $s3, ($s3)
beq $s0, $t1, initializefrog #when hit the target, move to initial position
beq $s0, $t2, initializefrog #when hit the target, move to initial position.
beq $s1, $t1, initializefrog #when hit the target, move to initial position
beq $s1, $t2, initializefrog #when hit the target, move to initial position.
beq $s2, $t1, initializefrog #when hit the target, move to initial position
beq $s2, $t2, initializefrog #when hit the target, move to initial position.
beq $s3, $t1, initializefrog #when hit the target, move to initial position
beq $s3, $t2, initializefrog #when hit the target, move to initial position.
addi $t7, $t7, 4
j generalcardetection
initializefrog:
la $t9, FORG_INITIAL_POSITION # load the initial position
lw $t8, 0($t9) # load the initial position of pixel 1
sw $t8, 0($t0) # store the initial position to our current position of pixel 1. The following operations are the same.
lw $t8, 4($t9)
sw $t8, 4($t0)
lw $t8, 8($t9)
sw $t8, 8($t0)
lw $t8, 12($t9)
sw $t8, 12($t0)
lw $t8, 16($t9)
sw $t8, 16($t0)
lw $t8, 20($t9)
sw $t8, 20($t0)
lw $t8, 24($t9)
sw $t8, 24($t0)
lw $t8, 28($t9)
sw $t8, 28($t0)
lw $t8, 32($t9)
sw $t8, 32($t0)
lw $t8, 36($t9)
sw $t8, 36($t0)
lw $t8, 40($t9)
sw $t8, 40($t0)
lw $t8, 44($t9)
sw $t8, 44($t0)
la $a0, lives_now # at this time, we will decrease the lives by 1
lw $a1, ($a0)
subi $a1, $a1, 1
sw $a1, ($a0) # decrese 1.
Print_the_score_message1:
li $v0, 4
la $a0, SCORE_MESSAGE
syscall
li $v0, 1
lw $a1, TOTAL_SCORE
move $a0, $a1
syscall
j Sound2
j finishchecking
finishchecking:
jr $ra

logsdetection:
la $t0, FORG_POSITION
lw $t1, 0($t0) # we need to use this position to judge whether it reaches to the water area
lw $t2, 4($t0) # we need to use $t1, $t2 to judge whether it stays at the log
la $t3, WATER_DETECTION
li $t4, 0 # loop accumulator
water_detection: beq $t4, 256, end_detection
add $t5, $t3, $t4
lw $t5, ($t5) # load the current water position to $t5.
beq $t1, $t5, continue
addi $t4, $t4, 4
j water_detection
continue: addi $a1, $zero, 0 #accumulator for next function
la $t4, LOG1_POSITION
la $t5, LOG2_POSITION
la $t6, LOG3_POSITION
la $t7, LOG4_POSITION
generallogdetection: 
lw $t8, 0($t4)
lw $t9, 4($t4)
lw $s0, 8($t4)
lw $s1, 12($t4)
lw $s2, 16($t4)
beq $t1, $t8, FrogMoveRight
beq $t1, $t9, FrogMoveRight
beq $t1, $s0, FrogMoveRight
beq $t1, $s1, FrogMoveRight
beq $t1, $s2, FrogMoveRight
lw $t8, 0($t5)
lw $t9, 4($t5)
lw $s0, 8($t5)
lw $s1, 12($t5)
lw $s2, 16($t5)
beq $t1, $t8, FrogMoveRight
beq $t1, $t9, FrogMoveRight
beq $t1, $s0, FrogMoveRight
beq $t1, $s1, FrogMoveRight
beq $t1, $s2, FrogMoveRight
lw $t8, 0($t6)
lw $t9, 4($t6)
lw $s0, 8($t6)
lw $s1, 12($t6)
lw $s2, 16($t6)
beq $t1, $t8, FrogMoveLeft
beq $t1, $t9, FrogMoveLeft
beq $t1, $s0, FrogMoveLeft
beq $t1, $s1, FrogMoveLeft
beq $t1, $s2, FrogMoveLeft
lw $t8, 0($t7)
lw $t9, 4($t7)
lw $s0, 8($t7)
lw $s1, 12($t7)
lw $s2, 16($t7)
beq $t1, $t8, FrogMoveLeft
beq $t1, $t9, FrogMoveLeft
beq $t1, $s0, FrogMoveLeft
beq $t1, $s1, FrogMoveLeft
beq $t1, $s2, FrogMoveLeft
j Initializefrog
FrogMoveRight: beq $a1, 48, end_detection
lw $t8, FORG_POSITION($a1)
addi $t8, $t8, 4
sw $t8, FORG_POSITION($a1)
addi $t9, $t8, 8
beq $t9, 1148, Initializefrog
addi $a1, $a1, 4
j FrogMoveRight
FrogMoveLeft: beq $a1, 48, end_detection
lw $t8, FORG_POSITION($a1)
subi $t8, $t8, 4
add $t9, $t8, $zero # store the t8 to t9
sw $t8, FORG_POSITION($a1)
beq $t9, 1536, Initializefrog
addi $a1, $a1, 4
j FrogMoveLeft
Initializefrog:
la $t9, FORG_INITIAL_POSITION # load the initial position
lw $t8, 0($t9) # load the initial position of pixel 1
sw $t8, 0($t0) # store the initial position to our current position of pixel 1. The following operations are the same.
lw $t8, 4($t9)
sw $t8, 4($t0)
lw $t8, 8($t9)
sw $t8, 8($t0)
lw $t8, 12($t9)
sw $t8, 12($t0)
lw $t8, 16($t9)
sw $t8, 16($t0)
lw $t8, 20($t9)
sw $t8, 20($t0)
lw $t8, 24($t9)
sw $t8, 24($t0)
lw $t8, 28($t9)
sw $t8, 28($t0)
lw $t8, 32($t9)
sw $t8, 32($t0)
lw $t8, 36($t9)
sw $t8, 36($t0)
lw $t8, 40($t9)
sw $t8, 40($t0)
lw $t8, 44($t9)
sw $t8, 44($t0)
la $a2, lives_now # at this time, we will decrease the lives by 1
lw $a3, ($a2)
subi $a3, $a3, 1
sw $a3, ($a2) # decrese 1.
Print_the_score_message2:
li $v0, 4
la $a0, SCORE_MESSAGE
syscall
li $v0, 1
lw $a1, TOTAL_SCORE
move $a0, $a1
syscall
j Sound2
j end_detection
end_detection: jr $ra

GoalAreaDetection:
la $t0, FORG_POSITION
lw $t1, 0($t0) # we only need leftmost pixel of frog to detect whether it reaches the goal area.
la $t2, GOAL_AREA_DETECTION # load the pixel that we want to check to judge whether the frog reaches the goal area.
li $t3, 0 # give a loop accumulator.
generalgoalareadetection: beq $t3, 128, end_checking
add $t4, $t2, $t3 #store the current goal area checking point to $t4.
lw $t4, ($t4) #load the current goal area checking point to $t4
beq $t4, $t1, drawthing
addi $t3, $t3, 4
j generalgoalareadetection
drawthing: j draw_signal
j initialize
draw_signal: lw $t5, FinishColor
lw $t6, displayAddress
add $t4, $t4, $t6
sw $t5, ($t4)
addi $t4, $t4, 4
sw $t5, ($t4)
addi $t4, $t4, 4
sw $t5, ($t4)
addi $t4, $t4, 4
sw $t5, ($t4) # draw the first row of the singal display
addi $t4, $t4, 128
sw $t5, ($t4)
subi $t4, $t4, 4
sw $t5, ($t4)
subi $t4, $t4, 4
sw $t5, ($t4)
subi $t4, $t4, 4
sw $t5, ($t4) # draw the second row of the singal display
addi $t4, $t4, 128
sw $t5, ($t4)
addi $t4, $t4, 4
sw $t5, ($t4)
addi $t4, $t4, 4
sw $t5, ($t4)
addi $t4, $t4, 4
sw $t5, ($t4) # draw the third row of the singal display
addi $t4, $t4, 128
sw $t5, ($t4)
subi $t4, $t4, 4
sw $t5, ($t4)
subi $t4, $t4, 4
sw $t5, ($t4)
subi $t4, $t4, 4
sw $t5, ($t4) # draw the fourth row of the singal display
initialize:
la $t9, FORG_INITIAL_POSITION # load the initial position
lw $t8, 0($t9) # load the initial position of pixel 1
sw $t8, 0($t0) # store the initial position to our current position of pixel 1. The following operations are the same.
lw $t8, 4($t9)
sw $t8, 4($t0)
lw $t8, 8($t9)
sw $t8, 8($t0)
lw $t8, 12($t9)
sw $t8, 12($t0)
lw $t8, 16($t9)
sw $t8, 16($t0)
lw $t8, 20($t9)
sw $t8, 20($t0)
lw $t8, 24($t9)
sw $t8, 24($t0)
lw $t8, 28($t9)
sw $t8, 28($t0)
lw $t8, 32($t9)
sw $t8, 32($t0)
lw $t8, 36($t9)
sw $t8, 36($t0)
lw $t8, 40($t9)
sw $t8, 40($t0)
lw $t8, 44($t9)
sw $t8, 44($t0)
add_successful_score:
la $a0, TOTAL_SCORE
lw $a1, ($a0)
add $a1, $a1, 100
sw $a1, ($a0)
Print_the_score_message3:
li $v0, 4
la $a0, SUCCESSFUL_MESSAGE
syscall
li $v0, 1
lw $a1, TOTAL_SCORE
move $a0, $a1
syscall
j Sound4
j end_checking
end_checking: jr $ra

##########################################################
# Add some new features
# 1): A lives bar that have 3 lives (which means 3 chances.)
##########################################################
drawLivesBar: 
lw $t0, displayAddress
lw $t1, ForgColor
li $t3, 0 # loop accumulator
la $a0, lives_now
lw $a0, ($a0) # check lives number
beq $a0, 3, looplivesbar3
beq $a0, 2, looplivesbar2
beq $a0, 1, looplivesbar1
beq $a0, 0, finishlivesbar
looplivesbar3: beq $t3, 48, finishlivesbar
lw $t4, LIVESBAR3_POSITION($t3)
add $t4, $t4, $t0 # load the current position of lives bar
sw $t1, ($t4) # draw one pixel of lives bar
addi $t3, $t3, 4
j looplivesbar3
looplivesbar2: beq $t3, 32, finishlivesbar
lw $t4, LIVESBAR2_POSITION($t3)
add $t4, $t4, $t0 # load the current position of lives bar
sw $t1, ($t4) # draw one pixel of lives bar
addi $t3, $t3, 4
j looplivesbar2
looplivesbar1: beq $t3, 16, finishlivesbar
lw $t4, LIVESBAR1_POSITION($t3)
add $t4, $t4, $t0 # load the current position of lives bar
sw $t1, ($t4) # draw one pixel of lives bar
addi $t3, $t3, 4
j looplivesbar1
finishlivesbar: jr $ra

############################
# 2) Add Sound to our game :)
############################
Sound1: # Sound Effect for easy movement
li $v0, 31
li $t1, 72
li $t2, 1000
li $t3, 5
li $t4, 64
move $a0, $t1
move $a1, $t2
move $a2, $t3
move $a3, $t4
syscall
j Sleep

Sound2: # Sound Effect for collision.
li $v0, 31
li $a0, 70
li $a1, 1000
li $a2, 7
li $a3, 32
syscall
j Sleep

Sound4: # Sound for the goal area reaching
li $v0, 31
li $a0, 69
li $a1, 1000
li $a2, 7
li $a3, 64
syscall
j Sleep

#######################################
# 3) Print the score and string message.
#######################################
Print_the_welcome_message:
li $v0, 4
la $a0, WELCOME_MESSAGE
syscall 
j KeyboardSetting

##########################################
# 4) Add the exit and restart our game
##########################################
Exit:
jal Background # when the game is finished. Redraw background once again,
li $v0, 31 # When the game comes to an end, have the sound effect.
li $a0, 65
li $a1, 1000
li $a2, 5
li $a3, 40
syscall
lw $t9, 0xffff0000
beq $t9, 1, k_input
j Exit
k_input:
lw $t0, 0xffff0004
beq $t0, 0x72, Restart
j Exit
Restart:
la $a0, TOTAL_SCORE
lw $a1, ($a0)
li $a1, 0 # set our score to 0
sw $a1, ($a0)
la $a2, lives_now
lw $a3, ($a2)
addi $a3, $zero, 3 # set our lives to 3 again
sw $a3, ($a2)
j main # Restart the game.
