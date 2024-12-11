#!/bin/bash
# Тестування конвергенції енергії відсікання.
for ecut in 20 22 24 26 30 35 40 45 50 55 60 65 70 75 80; do
    cat > ecut.$ecut.in << EOF
&CONTROL
calculation = 'scf'
pseudo_dir = '../pseudo/'
outdir = '../tmp/'
prefix = 'CrSSe'
/

&SYSTEM
ibrav = 4
a = 3.185188839
c = 10.0
nat = 3
ntyp = 3
occupations = 'smearing'
smearing = 'mv'
degauss = 0.02
ecutwfc = ${ecut}
/

&ELECTRONS
mixing_beta = 0.7
conv_thr = 1.0D-6
/

ATOMIC_SPECIES
Cr 51.996 cr_pbe_v1.5.uspp.F.UPF
S  32.066 s_pbe_v1.4.uspp.F.UPF
Se 78.96  Se_pbe_v1.uspp.F.UPF
ATOMIC_POSITIONS (crystal)
Cr   0.0000000000   0.0000000000   0.5000000000
S    0.3333333333   0.6666666667   0.4217548051
Se   0.3333333333   0.6666666667   0.5782450789
K_POINTS (automatic)
10 10 1 0 0 0
EOF
    mpirun -np 4 pw.x < ecut.$ecut.in > ecut.$ecut.out
    awk '/!/ {printf"%d %s\n",'$ecut',$5}' ecut.$ecut.out >> calc-ecut.dat
done
