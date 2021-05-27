#!/usr/bin/env python3

"""
Write a program that will ask for user name and password on the terminal. If
the user gives the correct username and correct password it should print a
welcome message on the screen (use ‘break’); otherwise, it will print "Invalid
credentials! Try again!" and ask for the username and password again. The loop
will continue until the correct credentials are inputted.
"""

username = "sahasatvik"
password = "correcthorsebatterystaple"

while True:
    username_in = input("Enter your username : ")
    password_in = input("Enter your password : ")
    if username_in == username and password_in == password:
        break
    else:
        print("Invalid credentials! Try again.")

print(f"Welcome, {username}!")
