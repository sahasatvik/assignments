#!/usr/bin/env python3

import numpy as np

stu_marks = np.array([[40, 50, 60, 70], [70, 80, 90, 100], [55, 65, 75, 85]])
m, n = stu_marks.shape

# Student averages involve summing 'horizontally'
studentwise_avg = stu_marks.sum(axis=1) / n
# Subject averages involve summing 'vertically'
subjectwise_avg = stu_marks.sum(axis=0) / m

print("Marks : ")
print(stu_marks)
print("Student-wise average : ", studentwise_avg)
print("Subject-wise average : ", subjectwise_avg)
