set title "Conductance vs Volume of NaOH"
set ylabel "Conductance (mS)"
set grid
set xlabel "Volume of NaOH (mL)"
set term png size 1024,768
set output "conductometry.png"
set sample 1000
set xrange [0:13]
set yrange [0.8:3.6]
t = 6.1
f(x) = x>t? m*x + a : n*x + b
g(x) = m*x + a
h(x) = n*x + b
fit f(x) "conductometry_data" using 1:2 via m, n, a, b
plot 'conductometry_data' using 1:2 title '' pt 3 ps 1 lc 2, g(x) title '' lc 6, h(x) title '' lc 6 lw 0.5
