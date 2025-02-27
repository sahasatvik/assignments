set title "Jaccard Similarity"
set ylabel "Similarity"
set xlabel "Distance"
set yrange [0:1]
set term png size 1024,768
set output "tree_diversity_jaccard.png"
f(x) = c + m * x
fit f(x) 'tree_diversity_jaccard' using 1:2 via c, m
plot 'tree_diversity_jaccard' title '' pt 0 lc 2, f(x) title '' lw 2 lc 7
