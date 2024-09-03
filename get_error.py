import sys
from pymatgen.core import Structure
import numpy as np

usage="\nUsage: python "+sys.argv[0]+" exp_cif.cif theo_cif.cif\nError is given in %, and it is calculated via:\n err=(theo-exp)/exp * 100"


#if len(sys.argv)!=3:
#    sys.exit(usage)

### getting experimental parameters
exp_cif=sys.argv[1]
exp_struc=Structure.from_file(exp_cif)

a_exp=exp_struc.lattice.a
b_exp=exp_struc.lattice.b
c_exp=exp_struc.lattice.c

alpha_exp=exp_struc.lattice.alpha
beta_exp=exp_struc.lattice.beta
gamma_exp=exp_struc.lattice.gamma

print(a_exp,b_exp,c_exp,alpha_exp,beta_exp,gamma_exp)

### getting theoretical parameters
"""
theo_cif=sys.argv[2]
theo_struc=Structure.from_file(theo_cif)

a_theo=theo_struc.lattice.a
b_theo=theo_struc.lattice.b
c_theo=theo_struc.lattice.c

alpha_theo=theo_struc.lattice.alpha
beta_theo=theo_struc.lattice.beta
gamma_theo=theo_struc.lattice.gamma

def calc_err(exp,theo):
    err=((theo-exp)/exp)*100

    return err

### errors::
#err=np.zeros(6)
err=np.array([calc_err(a_exp,a_theo),calc_err(b_exp,b_theo),calc_err(c_exp,c_theo),calc_err(alpha_exp,alpha_theo),calc_err(beta_exp,beta_theo),calc_err(gamma_exp,gamma_theo)])
print(err)

#if ele >=1 np.any>=1:
#    print("Warning
"""
