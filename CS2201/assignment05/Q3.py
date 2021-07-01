#!/usr/bin/env python3

import sys

def push(l, e):
    l.append(e)

def pop(l):
    e = l[-1]
    del l[-1]
    return e

def peek(l):
    return l[-1]

def isEmpty(l):
    return len(l) == 0


str_ = input("Enter a string with parentheses : ")
# Store the correspondence between closing and opening parentheses
parentheses = {
    ')' : '(',
    ']' : '[',
    '}' : '{'
}

stack = []
for c in str_:
    # Push opening parenthesis
    if c in parentheses.values():
        push(stack, c)
    # Pop closing parenthesis (if matching)
    elif c in parentheses.keys():
        # Mismatched parenthesis or too many closing parenthesis
        if isEmpty(stack) or peek(stack) != parentheses[c]:
            print("Invalid parenthesization")
            sys.exit()
        pop(stack)

# Make sure all opening parentheses have been closed
if isEmpty(stack):
    print("Valid parenthesization")
else:
    print("Invalid parenthesization")
