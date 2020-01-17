set title "Derivative of pH of Glycine vs Volume of NaOH"
set yrange [0:17]
set ylabel "d(pH)/dV"
set xlabel "Volume of NaOH (mL)"
set term png size 1024,768
set output "pH_volume_derivative.png"
set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 1 linewidth 1 \
    pointtype 2 pointsize 0.5
x0=NaN
y0=NaN
plot 'pH_volume_data' using (dx=$1-x0,x0=$1,$1-dx/2):(dy=$2-y0,y0=$2,dy/dx) title '' with linespoints
