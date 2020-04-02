import pygame

pygame.init()

display_width = 640
display_height = 480

gameDisplay = pygame.display.set_mode((display_width,display_height))
pygame.display.set_caption('test')

black = (0,0,0)
white = (255,255,255)

clock = pygame.time.Clock()
crashed = False
#got = False
gameDisplay.fill(black)

SnakeIMG = pygame.image.load('snake.png')
def snake(x,y):
    gameDisplay.blit(SnakeIMG, (x,y))

x =  (display_width * 0.45)
y = (display_height * 0.45)
#direction = 0
x_change = 0
y_change = 0
snake_speed = 0

while not crashed:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            crashed = True

        ############################
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_LEFT:
                x_change = -5
            elif event.key == pygame.K_RIGHT:
                x_change = 5
            elif event.key == pygame.K_UP:
                y_change = -5
            elif event.key == pygame.K_DOWN:
                y_change = 5

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
        
    pygame.display.update()
    clock.tick(60)

pygame.quit()
quit()
