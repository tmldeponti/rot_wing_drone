paparazzi_lim = [0,9600];
pwm_lim = [1000,2000];
pwm=[30,40,50,60,70,80,90,100]*diff(pwm_lim)/100+pwm_lim(1);
pprz = diff(paparazzi_lim)/diff(pwm_lim)*(pwm-pwm_lim(1))+paparazzi_lim(1);
thrust= [250,470,780,1120,1480,1990,2490,2750]*9.81/1000;%
pprz_q = linspace(0,9600);
[polycoeffs, poly_T] = poly_gen(pprz,thrust,1,pprz_q,0);
mass = 2.339132*1; %kg
effect = polycoeffs(1)/mass;

