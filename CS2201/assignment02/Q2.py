#!/usr/bin/env python3

sentence = input("Enter some space separated words : ")
words = sentence.split()                        # Split into words (trailing spaces automatically removed)
reversed_sentence = " ".join(words[::-1])       # Join the words, in reverse order
print(reversed_sentence)
