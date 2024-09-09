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

cif=file_io(sys.argv[1])
for i in range(len(cif)):
    line_a=cif[i].find("_cell_length_a")
    if line_a!=-1:
        a_exp=cif[i].split()[len(cif[i].split())-1]
        a_exp=ufloat_fromstr(a_exp).n
        b_exp=cif[i+1].split()[len(cif[i].split())-1]
        b_exp=ufloat_fromstr(b_exp).n
        c_exp=cif[i+2].split()[len(cif[i].split())-1]
        c_exp=ufloat_fromstr(c_exp).n
        alpha_exp=cif[i+3].split()[len(cif[i].split())-1]
        alpha_exp=ufloat_fromstr(alpha_exp).n
        beta_exp=cif[i+4].split()[len(cif[i].split())-1]
        beta_exp=ufloat_fromstr(beta_exp).n
        gamma_exp=cif[i+5].split()[len(cif[i].split())-1]
        gamma_exp=ufloat_fromstr(gamma_exp).n
        break



######### getting the experimental ##############

cry_out=file_io(sys.argv[2])

for i in reversed(range(len(cry_out)-1)):
    opt_geom=cry_out[i].find("FINAL OPTIMIZED GEOMETRY")
    if opt_geom!=-1:
        opt_line=i
        break

for j in range(i,len(cry_out)):
    cell=cry_out[j].find("CRYSTALLOGRAPHIC CELL (VOLUME=") ## try to find crystallographic cell
    if cell!=-1:
        line=j+2
        break

try:
    line
except NameError:
    for j in range(i,len(cry_out)): ## if not, cell parameters are the one from primitive cell
        cell=cry_out[j].find("PRIMITIVE CELL")
        if cell!=-1:
            line=j+2
            break

a_theo=float(cry_out[line].split()[0])
b_theo=float(cry_out[line].split()[1])
c_theo=float(cry_out[line].split()[2])
alpha_theo=float(cry_out[line].split()[3])
beta_theo=float(cry_out[line].split()[4])
gamma_theo=float(cry_out[line].split()[5])


####### calculate errors ###########

def get_err(theo,exp):
    err=((theo-exp)/exp)*100
    return err

print("Erros:\n err = (theo-exp)/exp * 100")
print('%.3f,%.3f,%.3f,%.3f,%.3f,%.3f'%(get_err(a_theo,a_exp),get_err(b_theo,b_exp),get_err(c_theo,c_exp),get_err(alpha_theo,alpha_exp),get_err(beta_theo,beta_exp),get_err(gamma_theo,gamma_exp)))
