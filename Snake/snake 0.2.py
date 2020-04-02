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

SnakeIMG = pygame.image.load('snake.png')
FOODIMG = pygame.image.load('food.png')

def snake(x,y):
    gameDisplay.blit(SnakeIMG,(x,y))

def food(foodx,foody):
    gameDisplay.blit(FOODIMG,(foodx,foody))
    
def game_loop():
    x =  (display_width * 0.45)
    y = (display_height * 0.45)
    foodx = random.randint(0,80)*8
    foody = random.randint(0,60)*8

    #direction = 0
    x_change = 0
    y_change = 0
    snake_speed = 0
    end = False
    while not end:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                end = True

            ############################
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_LEFT:
                    x_change = -8
                elif event.key == pygame.K_RIGHT:
                    x_change = 8
                elif event.key == pygame.K_UP:
                    y_change = -8
                elif event.key == pygame.K_DOWN:
                    y_change = 8

            if event.type == pygame.KEYUP:
                if event.key == pygame.K_LEFT or event.key == pygame.K_RIGHT:
                    x_change = 0
                elif event.key == pygame.K_UP or event.key == pygame.K_DOWN:
                    y_change = 0
            ######################

        ##
        x += x_change
        y += y_change
       ##         
        gameDisplay.fill(black)
        snake(x,y)
        food(foodx,foody)

        if x == foodx and y == foody :
            foodx = random.randint(0,80)*8
            foody = random.randint(0,60)*8
                
        pygame.display.update()
        clock.tick(60)
game_loop()
pygame.quit()
quit()
