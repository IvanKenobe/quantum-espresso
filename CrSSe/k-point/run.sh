#!/bin/bash
# Convergence test of k-points grid.
# Set a variable k-point from 4 to 14.
for k in 4 5 6 7 8 9 10 11 12 13 14; do

# Make input file for the SCF calculation.
# k-points grid is assigned by variable n.
cat > kpoint.$k.in << EOF
&CONTROL
calculation = 'scf'
pseudo_dir  = '../pseudo/'
outdir      = '../tmp/'
prefix      = 'CrSSe'
/
&SYSTEM
ibrav       = 4
a           = 3.185188839
c           = 10
nat         = 3
ntyp        = 3
occupations = 'smearing'
smearing    = 'mv'
degauss     = 0.02
ecutwfc     = 40
/
&ELECTRONS
mixing_beta = 0.7
conv_thr    = 1.0D-6
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
${k} ${k} 1 0 0 0
EOF

# Run pw.x for SCF calculation.
mpirun -np 4 pw.x <kpoint.$k.in>kpoint.$k.out
# Write the number of k-points (= k*k*1) and
# the total energy in calc-kpoint.dat
awk '/!/ {printf"%d %s\n",'$k*$k',$5}' kpoint.$k.out >> calc-kpoint.dat
# End of for loop.
done
