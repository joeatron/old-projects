import pygame
import random

pygame.init()

display_width = 640
display_height = 480

gameDisplay = pygame.display.set_mode((display_width,display_height))
pygame.display.set_caption('snake')

black = (0,0,0)
white = (255,255,255)
snake_width = 8

clock = pygame.time.Clock()
end = False
#got = False
gameDisplay.fill(black)
#----------------
#Sprites
#----------------
SnakeIMG = pygame.image.load('snake.png')
FOODIMG = pygame.image.load('food.png')

def snake(x,y):
    gameDisplay.blit(SnakeIMG,(x,y))

def food(foodx,foody):
    gameDisplay.blit(FOODIMG,(foodx,foody))

#----------------
#Main loop
#----------------
def game_loop():
    x =  (display_width * 0.45)
    y = (display_height * 0.45)
    foodx = random.randint(0,80)*8
    foody = random.randint(0,60)*8


    direction = 0
    x_change = 0
    y_change = 0
    snake_speed = 0
    end = False
    while not end:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                end = True
#----------------
#Move
#----------------
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_LEFT:
                    direction = 0
                    #x_change = -8
                elif event.key == pygame.K_RIGHT:
                    direction = 180
                    #x_change = 8
                elif event.key == pygame.K_UP:
                    direction = 90
                    #y_change = -8
                elif event.key == pygame.K_DOWN:
                    direction = 270
                    #y_change = 8
                    
            if event.type == pygame.KEYUP:
                if event.key == pygame.K_LEFT or event.key == pygame.K_RIGHT:
                    x_change = 0
                elif event.key == pygame.K_UP or event.key == pygame.K_DOWN:
                    y_change = 0
                    
            if direction == 0:
                x_change = -8
                y_change = 0
            elif direction == 180:
                x_change = 8
                y_change = 0
            elif direction == 90:
                y_change = -8
                x_change = 0
            elif direction == 270:
                y_change = 8
                x_change = 0

            if x == 640:
                end = True
            elif x == 0:
                end = True
            elif y == 480:
                end = True
            elif y == 0:
                end = True

#----------------
#
#----------------        
        x += x_change
        y += y_change       
        gameDisplay.fill(black)
        snake(x,y)
        food(foodx,foody)
#----------------
#Events
#----------------
        if x == foodx and y == foody :
            foodx = random.randint(0,80)*8
            foody = random.randint(0,60)*8
#----------------
#Frame update
#----------------                
        pygame.display.update()
        clock.tick(30)
#----------------
#End
#----------------
game_loop()
pygame.quit()
quit()
