import sys
from pymatgen.core import Structure
import numpy as np
from uncertainties import ufloat_fromstr

usage="\nUsage: python "+sys.argv[0]+" exp_cif.cif opt_output.out\nError is given in %, and it is calculated via:\n err=(theo-exp)/exp * 100"


#if len(sys.argv)!=3:
#    sys.exit(usage)


######## file i/o ##########
def file_io(file):
    file_name=open(file,'r') ##sys.argv[1],'r')
    file_lines=[]

    for i in file_name:
        file_lines.append(i)
    file_name.close()

    return file_lines


### getting experimental parameters

for i in range(len(file_io(sys.argv[1]))):
    line_a=file_io(sys.argv[1])[i].find("_cell_length_a")
    if line_a!=-1:
        a_exp=file_io(sys.argv[1])[i].split()[len(file_io(sys.argv[1])[i].split())-1]
        a_exp=ufloat_fromstr(a_exp).n
        b_exp=file_io(sys.argv[1])[i+1].split()[len(file_io(sys.argv[1])[i].split())-1]
        b_exp=ufloat_fromstr(b_exp).n
        c_exp=file_io(sys.argv[1])[i+2].split()[len(file_io(sys.argv[1])[i].split())-1]
        c_exp=ufloat_fromstr(c_exp).n
        alpha_exp=file_io(sys.argv[1])[i+3].split()[len(file_io(sys.argv[1])[i].split())-1]
        alpha_exp=int(alpha_exp)
        beta_exp=file_io(sys.argv[1])[i+4].split()[len(file_io(sys.argv[1])[i].split())-1]
        beta_exp=int(beta_exp)
        gamma_exp=file_io(sys.argv[1])[i+5].split()[len(file_io(sys.argv[1])[i].split())-1]
        gamma_exp=int(gamma_exp)
        break

######### getting the experimental ##############

for i in range(len(file_io(sys.argv[2]))):
    opt_geom=file_io(sys.argv[2])[i].find("FINAL OPTIMIZED GEOMETRY")
    if opt_geom!=-1:
        print(file_io(sys.argv[2])[i])
        for j in range(i,len(file_io(sys.argv[2]))):
            cell=file_io(sys.argv[2])[j].find("CRYSTALLOGRAPHIC CELL")
            print(file_io(sys.argv[2])[j])
            if cell!=-1:
                print(file_io(sys.argv[2])[j+2])
