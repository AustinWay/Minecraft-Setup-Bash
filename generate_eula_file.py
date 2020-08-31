import os
import time
from colorama import Fore, Back, Style 
from datetime import datetime
from os import path

def write_file():
    f = open("eula.txt", "w")
    f.write("#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).\n")
    f.write(str(time))
    f.write("eula=true")
    f.close()

now = datetime.now()
time = now.strftime("#%c\n")

if path.exists("eula.txt") == True:
    try:
        write_file()
    except:
        print(Fore.RED + "Error: File either does not exist or unable to write to file!")
        print(Style.RESET_ALL) 
else: 
    print(Fore.YELLOW + "Creating and writing eula.txt file")
    print(Style.RESET_ALL) 
    write_file()

f = open("eula.txt", "r")
print(f.read())