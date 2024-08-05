def build_k(cif_file,max_dens=12):
    from pymatgen.core import Lattice, Structure
    import numpy as np
    import os

    k_out=open('k_points.dat','w+')
    cif=Structure.from_file(cif_file)
    rec_lat=cif.lattice.reciprocal_lattice._matrix

    k_points=np.zeros((max_dens,3),dtype=int)

    ##build array with k-points
    for k in range(1,max_dens+1):
        k_x=int(k*np.linalg.norm(cif.lattice.reciprocal_lattice._matrix,axis=1)[0])
        k_y=int(k*np.linalg.norm(cif.lattice.reciprocal_lattice._matrix,axis=1)[1])
        k_z=int(k*np.linalg.norm(cif.lattice.reciprocal_lattice._matrix,axis=1)[2])
        if 0 in [k_x,k_y,k_z]:
            continue
        else:
            k_points[k-1,:]=[k_x,k_y,k_z]
            k_out.write('%d %d %d\n' %(k_x,k_y,k_z))
    k_out.close()

    ## remove any element with zeros:
    for i,k in enumerate(k_points):
        if np.all(k):
            continue
        else:
            k_points=np.delete(k_points,i,0)

    return k_points


def get_lat(cif_file)
    from pymatgen.core import Lattice, Structure

    cif=Structure.from_file('/home/bmpeluzo/Dropbox/Rochester/Research/CIF/BTBT.cif')
    lat_abc=str(cif.lattice.a)+' '+str(cif.lattice.b)+' '+str(cif.lattice.c)+' '

    for ang in cif.lattice.angles:
        if ang!=90:
            lat_ang=str(ang)+' '

    return lat_abc+lat_ang


periodic_table = {
    'H': 1, 'He': 2, 'Li': 3, 'Be': 4, 'B': 5, 'C': 6, 'N': 7, 'O': 8, 'F': 9, 'Ne': 10,
    'Na': 11, 'Mg': 12, 'Al': 13, 'Si': 14, 'P': 15, 'S': 16, 'Cl': 17, 'Ar': 18, 'K': 19, 'Ca': 20,
    'Sc': 21, 'Ti': 22, 'V': 23, 'Cr': 24, 'Mn': 25, 'Fe': 26, 'Co': 27, 'Ni': 28, 'Cu': 29, 'Zn': 30,
    'Ga': 31, 'Ge': 32, 'As': 33, 'Se': 34, 'Br': 35, 'Kr': 36, 'Rb': 37, 'Sr': 38, 'Y': 39, 'Zr': 40,
    'Nb': 41, 'Mo': 42, 'Tc': 43, 'Ru': 44, 'Rh': 45, 'Pd': 46, 'Ag': 47, 'Cd': 48} ### need to continue

#import basis_set_exchange as bse

#print(bse.get_basis('STO-3G', elements=[6], fmt='crystal'))
