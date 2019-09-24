set title "Tree Diversity"
set ylabel "Unique species"
set xlabel "Individuals"
set yrange [0:210]
set xrange [0:101000]
set xtics 10000
set ytics 10
set term png size 1024,768
set output "tree_species_individual.png"
g(x) = c * log(x * k)
c = 200
k = 100
fit g(x) "tree_species_individual_data" using 1:2:3 yerrors via c, k
plot "tree_species_individual_data" with yerrorbars lc 2 pt 7 title '', g(x) lw 2 lc 7 title ''
