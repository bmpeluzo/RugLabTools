from pymatgen.core import Lattice, Structure
import numpy as np

cif_file='/home/bmpeluzo/Dropbox/Rochester/Research/CIF/BTBT.cif'

def build_k(cif_file,max_dens=12):
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
            print('%d %d %d' %(k_x,k_y,k_z))

    ## remove any element with zeros:
    for i,k in enumerate(k_points):
        if np.all(k):
            continue
        else:
            k_points=np.delete(k_points,i,0)

    return k_points
