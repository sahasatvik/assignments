#!/usr/bin/env python3

"""
Read name (e.g. kripa), year of joining (e.g. 2020), course id (e.g. MS),
student id (e.g. 1234) and gener- ate the IISER email id in the format
name-lastTwoDigitsOfYearOfJoining-courseId-studentId@iiserkol.ac.in (e.g.
kripa20MS1234). You must first store these fields (e.g. name) in a list and use
‘join’ operation to convert the list to a string from which the email id will
be generated.
"""

name = input("Enter your name : ")
year = input("Enter your year of joining : ")
courseid = input("Enter your course id : ")
studentid = input("Enter your student id : ")
email = "-".join([name, year[-2:], courseid, studentid]) + "@iiserkol.ac.in"
print(f"Your email is {email}.")
