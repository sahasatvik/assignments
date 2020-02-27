#!/usr/bin/env sh

# Clean previous build
rm dat_simple_60_hist dat_compound_60_hist dat_simple_60_means dat_compound_60_means

# Calculate histogram data
cat dat_simple_60 | awk '{print $4}' | ./tree_canopy_classes.py > dat_simple_60_hist
cat dat_compound_60 | awk '{print $4}' | ./tree_canopy_classes.py > dat_compound_60_hist
# Build histogram
gnuplot tree_canopy_histogram.plt

# Calculate averages per tree
for i in `seq 1 5`; do cat dat_simple_60 | grep S_$i | awk '{ printf $4 "\n"}' | ./mean_std.py >> dat_simple_60_means; done
for i in `seq 1 5`; do cat dat_compound_60 | grep C_$i | awk '{ printf $4 "\n"}' | ./mean_std.py >> dat_compound_60_means; done

echo 'Simple leaves :'
cat dat_simple_60_means
echo 'Overall :'
cat dat_simple_60 | awk '{ printf $4 "\n"}' | ./mean_std.py
echo

echo 'Compound leaves :'
cat dat_compound_60_means
echo 'Overall :'
cat dat_compound_60 | awk '{ printf $4 "\n"}' | ./mean_std.py
