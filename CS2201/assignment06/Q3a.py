#!/usr/bin/env python3

import pandas as pd

students = ['Alice', 'Bob', 'Carol']
marks = {
    'Mathematics'   : [10, 20, 30],
    'Literature'    : [15, 25, 10],
    'History'       : [ 5, 23, 28]
}

df = pd.DataFrame(marks, index=students)
print("Initial data")
print(df)

# Insert row
df.loc['David'] = [7, 11, 19]

# Insert column with sum along the first axis
df['Sum'] = df.sum(axis=1)

print("Final data")
print(df)
