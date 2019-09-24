set title "Tree Diversity"
set ylabel "Population size"
set xlabel "Species"
set style data histogram
set style fill solid border -1
set yrange [0:11000]
unset xtics
set term png size 1024,768
set output "tree_diversity.png"
plot 'tree_diversity_data' using 1:xtic(2) title '' lc 2
