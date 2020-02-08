set title "pH vs Absorbance"
set ylabel "pH"
set grid
set xlabel "log(A/(A' - A))"
set term png size 1024,768
set output "pKin.png"
f(x) = m*x + c
fit f(x) "pKin_data" using (log($2/(0.7035 - $2))/log(10)):1 via m, c
set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 1 linewidth 1 \
    pointtype 2 pointsize 0.5
plot 'pKin_data' using (log($2/(0.7035 - $2))/log(10)):1 ps 2 title '', f(x) linestyle 1 title ''
