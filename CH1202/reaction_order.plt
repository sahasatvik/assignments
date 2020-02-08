set ylabel "Volume of thiosulphate (mL)"
set grid
set xlabel "Time (s)"

set title "Volume of thiosulphate vs Time (Bottle 1)"
set term png size 1024,768
set output "reaction_order_bottle_1.png"
f(x) = m*x + c
fit f(x) "reaction_order_bottle_1" using 1:2 via m, c
plot 'reaction_order_bottle_1' using 1:2 ps 2 pt 2 lc 2 title '', f(x) lw 1 lc 2 title ''

set title "Volume of thiosulphate vs Time (Bottle 2)"
set term png size 1024,768
set output "reaction_order_bottle_2.png"
f(x) = m*x + c
fit f(x) "reaction_order_bottle_2" using 1:2 via m, c
plot 'reaction_order_bottle_2' using 1:2 ps 2 pt 2 lc 2 title '', f(x) lw 1 lc 2 title ''

set title "Volume of thiosulphate vs Time (Bottle 3)"
set term png size 1024,768
set output "reaction_order_bottle_3.png"
f(x) = m*x + c
fit f(x) "reaction_order_bottle_3" using 1:2 via m, c
plot 'reaction_order_bottle_3' using 1:2 ps 2 pt 2 lc 2 title '', f(x) lw 1 lc 2 title ''

set title "Volume of thiosulphate vs Time (Bottle 4)"
set term png size 1024,768
set output "reaction_order_bottle_4.png"
f(x) = m*x + c
fit f(x) "reaction_order_bottle_4" using 1:2 via m, c
plot 'reaction_order_bottle_4' using 1:2 ps 2 pt 2 lc 2 title '', f(x) lw 1 lc 2 title ''
