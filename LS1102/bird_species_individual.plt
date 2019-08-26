set title "IISER Kolkata Birdlife"
set ylabel "Unique species"
set xlabel "Individuals"
set yrange [0:35]
set xrange [0:280]
set xtics 10
set ytics 5
set term png size 1024,768
set output "bird_species_individual.png"
g(x) = c * (1 - a * exp(-x/k))
c = 32
k = 50
fit g(x) 'bird_species_individual_data' via c, k, a
plot "bird_species_individual_data" with yerrorbars lc 2 pt 7 title '', g(x) lw 2 lc 7 title ''
