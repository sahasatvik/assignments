set title "Absorption curve for DNA"
set ylabel "Absorbance"
set xlabel "Concentration (mg/L)"
set yrange [0:0.6]
set term png size 1024,768
set output "photospectrometry_dna.png"
f(x) = m * x
g(x) = n * x
fit f(x) 'photospectrometry_dna_data' using (50/$1):2 via m
fit g(x) 'photospectrometry_dna_data' using (50/$1):3 via n
set key at 8,0.57
plot 'photospectrometry_dna_data' using (50/$1):2 title 'Normal DNA' lc 7 pt 5, f(x) title 'Normal DNA (Best fit)' lw 2 lc 7, 'photospectrometry_dna_data' using (50/$1):3 title 'Denatured DNA' lc 3 pt 5, g(x) title 'Denatured DNA (Best fit)' lw 2 lc 6
