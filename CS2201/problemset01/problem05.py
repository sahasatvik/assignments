#!/usr/bin/env python3

"""
Consider a list (rollnos) containing roll numbers of 20MS students in the
format 20MSid (e.g. 20MS145, here id = 145). Use list comprehension to store
the roll nos in rollnos in a list ‘GroupA’ where id < 150 and store the rest in
another list ‘GroupB’. Print the contents of GroupA and GroupB.
"""

rollnos = ["20MS001", "20MS123", "20MS149", "20MS150", "20MS151", "20MS172"]

groupA = [s for s in rollnos if int(s[4:]) < 150]
groupB = [s for s in rollnos if s not in groupA]

print("Roll numbers : ", rollnos)
print("Group A : ", groupA)
print("Group B : ", groupB)
