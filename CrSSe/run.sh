#!/bin/bash
# Встановлюємо змінну sf для функцій зміщення.
for sf in fd gauss mp mv; do

# Встановлюємо змінну se для енергій зміщення.
for se in 0.005 0.010 0.015 0.020 0.025 0.030 0.035 0.040; do

# Створюємо вхідний файл для розрахунку SCF.
cat > $sf.$se.in << EOF
&CONTROL
calculation = 'scf '
pseudo_dir = '../pseudo/'
outdir = '../tmp/'
prefix = 'CrSSe'
/
&SYSTEM
ibrav = 4
a = 3.185188839
c = 10
nat = 3
ntyp = 3
occupations = 'smearing'
smearing = '$sf'
degauss = $se
ecutwfc = 40
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
12 12 1 0 0 0
EOF
# Запускаємо pw.x для розрахунку SCF.
mpirun -np 4 pw.x <$sf.$se.in> $sf.$se.out

# Записуємо назви функцій зміщення, енергії зміщення та загальні енергії
awk -v var="$sf" '/!/ {printf"%-6s %1.3f %s\n",var ,'$se ',$5}' $sf.$se.out >> calc-smearing.dat
# Кінець циклу для sf.
done
# Кінець циклу для se.
done
