set title "pH of Glycine vs Volume of NaOH"
set ylabel "pH"
set grid
set xlabel "Volume of NaOH (mL)"
set term png size 1024,768
set output "pH_volume.png"
set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 1 linewidth 1 \
    pointtype 2 pointsize 0.5
plot 'pH_volume_data' using 1:2 title '' with linespoints linestyle 1
