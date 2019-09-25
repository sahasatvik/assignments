set title "Tree Diversity"
set ylabel "Unique species"
set xlabel "Abundance (log_2)"
set yrange [0:35]
set style data histogram
set style fill solid border -1
set term png size 1024,768
set output "tree_species_abundance.png"
plot "tree_species_abundance_data" using 2:xtic(1) title '' lc 2
