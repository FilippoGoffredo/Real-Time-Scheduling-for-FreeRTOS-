$DATA << EOD
#Task start end
1 1 2
2 7 8
EOD

set terminal png size 1920,1080
set output "main.png"

set xrange [-1:]
set yrange [0:5.5]
set xtics scale 2, 1.0
set ytics scale 2, 1.0
set mxtics 5
set xtics ("86" 1.0, "87" 2.0, "92" 7.0, "93" 8.0)
set ytics("Task1" 1.0, "Task2" 2.0)
set grid x y
unset key
set title "{/=15 20000Hz, 100 ticks delay, NO preemption, NO timeslicing}\n\n{/:5 tasks with same priority}"
set border 3

set style arrow 1 filled size screen 0.01, 30 fixed lt 10 lw 4
#lw = line weight

plot $DATA using 2 : 1 : ($3-$2) : (0.0) with vector as 1,\
     $DATA using 2 : 1 : 1 with labels right offset -2
