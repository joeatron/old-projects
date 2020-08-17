#------------------------------------------
#Joes_music_player ver 0.2 18:32 12/06/2020
#------------------------------------------
#imports
from tkinter import *
import tkinter as tk
#Lists
songs = []
#music
current = ("music/76.mp3")                      #test music
#variables (varname = fals or 0)
end = 0
songnum = 0
choice = 0                                      #action variable
#window data
mainWindow = tk.Tk()
mainWindow.title("Joes_music_player")           #window name
mainWindow.geometry("300x100")                  #window size
mainWindow.config(bg="black")                   #window colour
#music play back data
    
#main loop

#controls
play = Button(mainWindow, text = ">")       #makes buttons and puts text on them
play.place(x=40, y=60)                      # X and Y of button
palse = Button(mainWindow, text = "||")
palse.place(x=60, y=60)
    
rewind = Button(mainWindow, text = "<<")
rewind.place(x=78, y=60)

forward = Button(mainWindow, text = ">>")
forward.place(x=106, y=60)

skip = Button(mainWindow, text = ">|")
skip.place(x=134, y=60)

back = Button(mainWindow, text = "|<")
back.place(x=157, y=60)

def play():
    print("test")


mainWindow.mainloop()
print("test")
