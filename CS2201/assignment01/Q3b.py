#!/usr/bin/env python3

def ret_grades(marks):
    '''
    Returns the grade achieved based on the marks scored.
    Assumes integer marks.
    '''

    m = int(marks)
    if m >= 90:
        return 'A+'
    elif m >= 80:
        return 'A'
    elif m >= 70:
        return 'B+'
    elif m >= 60:
        return 'B'
    elif m >= 50:
        return 'C'
    elif m >= 40:
        return 'D'
    else:
        return 'F'

marks = dict()

# Get the total number of entries to input
n = int(input("Enter the number of students: "))
print()

# Store all entries (ids, marks) in the 'marks' dictionary
for i in range(n):
    student_id = input("Enter the student id: ")
    marks_1 = input("Enter the marks in CS1101: ")
    marks_2 = input("Enter the marks in CS2202: ")
    print()

    marks[student_id] = (marks_1, marks_2)


grades = dict()

# Store the corresponding grades in the 'grades' dictionary
for student_id, (marks_1, marks_2) in marks.items():
    grades[student_id] = (ret_grades(marks_1), ret_grades(marks_2))

# Show the grades
print("Grades (CS1101, CS2201): ")
for student_id, (grade_1, grade_2) in grades.items():
    print(f"{student_id}\t {grade_1:3s} {grade_2:3s}")
print()

# Gather ids of students with all 'A+' entries
superlative = [student_id for student_id in grades if grades[student_id] == ('A+', 'A+')]
print("ID's of students with A+ in both subjects: " + ", ".join(superlative))
