import random
END=0
print("""
█▓▒░welcome to the number guessing game░▒▓█
█▓▒░where you will have to guess my    ░▒▓█
█▓▒░number in as little guesses as     ░▒▓█
█▓▒░posible.                           ░▒▓█
█▓▒░                                   ░▒▓█
█▓▒░the number is between 1 and 100.   ░▒▓█
█▓▒░if you enter a number that is out  ░▒▓█
█▓▒░of range then it will still count  ░▒▓█
█▓▒░that guess so try not to do that.  ░▒▓█
█▓▒░                                   ░▒▓█
█▓▒░                                   ░▒▓█
█▓▒░                                   ░▒▓█""")
while END != "END":
    X=0
    AInum=random.randint(1,100)
    counter=-1
    while X != 1:
        counter= counter+1
        if counter is 1:
            print("█▓▒░1 guess made                       ░▒▓█")
        elif counter < 10:
            print("█▓▒░",counter,"guesses made                    ░▒▓█")
        else:
            print("█▓▒░",counter,"guesses made                   ░▒▓█")
        guess = int(input("█▓▒░guess my number "))
        print ("█▓▒░",guess)
              
        if guess > 100:
            print("█▓▒░guess can not be larger than 100   ░▒▓█")
        elif guess < 1:
            print("█▓▒░guess can not be lower than 1      ░▒▓█")
        else:
            if guess < AInum:
                print("█▓▒░your guess is lower then my number ░▒▓█")
            elif guess > AInum:
                print("█▓▒░your guess is higher then my number░▒▓█")
            else:
                X=1
                END=input("""█▓▒░correct                            ░▒▓█
█▓▒░                                   ░▒▓█
█▓▒░would yo like to play again - press░▒▓█
█▓▒░enter or type END """)
                
