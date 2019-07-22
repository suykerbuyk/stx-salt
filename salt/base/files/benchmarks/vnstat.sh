nohup unbuffer vnstat --oneline --live -i enp2s0 --style 4 --json | ts | tee vnstat.out & 
