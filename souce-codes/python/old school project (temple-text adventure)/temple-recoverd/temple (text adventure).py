inventory = []
import time



def start():

    print("""
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
              joe planet limited
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
all righs resveved(C) do not copy
or sell this game
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


     
     ¦ ¦
  ---+ +---
  ---+ +---
     ¦ ¦ 
   --------------------------------------
""")
    time.sleep(3)
    print("""
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 ******wellcome to temple******
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
""")

    time.sleep(2)
    print("""




   
   
       -------------
        <__press__>
        <  start  >
       -------------
""")
    
    c = input("tipe run to start  ")
    if c == "run":
        print ("""this is a
textadventure game. you are a
urban explorer exporing a
abandoned temple but it is
notreally abandoned good
look!""")
#def howtoplay():
    print("""how to play

n=north
s=south
e=east
w=west
i=inventory
m=move
o=open
k=kill
u=up
d=down
r=read
t=take
H=HELP""")



    print("""

you wake up
lieing on the wet grass with
pain in your right leg. you
have no bellongins with you. 
""")
    nouthoftemple()

def nouthoftemple():
    print (""" 
you are north of the temple.
south of you there stands a
temple  but there is no
entrens. the walls a coverd
in vines  """)

    c=input("")
    if c == "u":
        topoftemple()

    elif c =="E":
        eastoftemple()

    elif c =="w":
        westoftemple()

    elif c =="n":
        forrest()

    elif c == "i":
         print (inventory)

    elif c == "s":
        print (""" you ran into the
               wall of the temple and
               got knock out
                  ***you died***
                  """)
    
        
def forrest():
    print  (""" """)

def westoftemple():
    print("""
you are now west of the temple
there is no entres here to the
east there is the temple to
the west there is a forest""")
    mtb=str()
    if "mtb" in inventory:
        print("""there is a dead spot
              of land were a book was""")
    else:
        print("""there is a book here called
my travel book""")

mtb=input()
if mtb == "t":
    inventory.append("mtb")
    print ("""you now have my trave book""")
elif mtb == "r":
    print("""        ***MY TRAVLE BOOK***



  """)
    
def eastoftemple():
    print("""you are east of the temple
             the""")

def topoftemple():
    print("""you are at the
top of the temple """)
    sword=str(input())
    if "sword" in inventory:
        print("")
    else:
        print("""a rapped
objet is lying here with the
side closest to you is open
the rapped item is a sword""")
    if sword == "t":
            inventory.append("sword")
            print (" you now have a sword")
    else:
        print ("")
    
    

    c1=input("")
    if c1 == "d":
        nouthoftemple()

    elif c1== "e":
         print("""runing off a temple
not a good plan and you can not fly
and survive a 1000 feet fall. 
              ***you died***""")
         
    elif c1== "w":
        print("""runing off a temple
not a good plan and
you can not fly
and survive a 1000 feet fall. 
              ***you died***""") 
      
    elif c1== "s":
        print("""runing off a temple
not a good plan and you can not fly
and survive a 1000 feet fall. 
              ***you died***""") 
        
    elif c1== "n":
        print("""runing off a temple
not a good plan and you can not fly
and survive a 1000 feet fall. 
              ***you died***""") 
    elif c1== "u":
        secretzone1()
        
    elif c1 == "i":
        print ("""items you have """)
        print (inventory)
    else:
        print ("""you can not go that way

""")
        topoftemple()
def secretzone1 ():
    print (""" welcome to the ivisable room

~~~------------~~~
***(secretzone)***
~~~------------~~~





you have reach a higher under standing of my
game


(!)achevent unlocked *(air climber)*

you can see the outside temple form
here but the inside remans hidden



                    /-------------[FORREST]-----------\\
                   /                  |                \        
              [forrest]       [north of temple]     [FORREST]
                 /           /                 \          |
        [forrest]---[westoftempe]   [east of temple]-   [gate ]----¬
         |                 \                 /          /          |
         |                  [south of temple]          /           |
        /                             |               /            |
       /     /----[island north]      |              /             |
      |     /               /  \      |             /  [tickit]--[port]
[west beach]               /    [south beach]------/       /
            \--[island south]                             /    
                                                         /
                                                        /
                                                {CRUSE BOAT}

""")


    
start()  
