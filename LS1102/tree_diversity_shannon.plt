set title "Shannon Diversity"
unset xtics
unset ytics
set xrange [-1:20]
set yrange [-1:20]
set term png size 1124,1024
set output "tree_diversity_shannon.png"
plot 'tree_diversity_shannon' title '' palette pt 5 ps 7.21
