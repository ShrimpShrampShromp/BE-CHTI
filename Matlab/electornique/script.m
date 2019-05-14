clear all;
close all;

f1 = tf(1, [8.976e-12 2.783e-6 1]);
f2 = tf(1, [1.948e-12 2.502e-7 1]);

bode(f1)
bode(f2)