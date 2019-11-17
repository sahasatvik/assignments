set title "Absorption curve for BSA"
set ylabel "Absorbance"
set xlabel "Concentration (mg/L)"
set yrange [0:0.6]
set term png size 1024,768
set output "photospectrometry_protein.png"
f(x) = m * x
fit f(x) 'photospectrometry_protein_data' using ($1/1.8):2 via m
plot 'photospectrometry_protein_data' using ($1/1.8):2 title '' lc 2 pt 5, f(x) title '' lw 2 lc 7
