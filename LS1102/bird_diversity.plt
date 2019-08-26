set title "IISER Kolkata Birdlife"
set ylabel "Population size"
set xlabel "Species"
set style data histogram
set style fill solid border -1
set yrange [0:70]
set xtics rotate
set term png size 1024,768
set output "bird_diversity.png"
plot 'bird_diversity_data' using 1:xtic(2) title '' lc 2
