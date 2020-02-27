set title "Tree Canopy Efficiency"
set ylabel "Number of samples"
set xlabel "Dark/Light ratio"
set style data histogram
set style histogram cluster gap 1
set style fill solid 1 border -1
set boxwidth 1
set term png size 1024,768
set output "tree_canopy_efficiency.png"
plot "dat_compound_60_hist" using 2:xtic(1) title 'Compound leaves' lc 2, "dat_simple_60_hist" using 2:xtic(1) title 'Simple leaves' lc 3
