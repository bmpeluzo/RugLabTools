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


def get_lat(cif_file):
    from pymatgen.core import Lattice, Structure

    cif=Structure.from_file(cif_file)
    lat_abc=str(cif.lattice.a)+' '+str(cif.lattice.b)+' '+str(cif.lattice.c)+' '

    for ang in cif.lattice.angles:
        if ang!=90:
            lat_ang=str(ang)+' '

    return lat_abc+lat_ang


def cif_io(cif_file):

    cif_lines=[]    
    with open(cif_file,'r') as cif:
        for line in cif:
            cif_lines.append(line)
    cif.close()

    return cif_lines

periodic_table = {
    'H': 1, 'He': 2, 'Li': 3, 'Be': 4, 'B': 5, 'C': 6, 'N': 7, 'O': 8, 'F': 9, 'Ne': 10,
    'Na': 11, 'Mg': 12, 'Al': 13, 'Si': 14, 'P': 15, 'S': 16, 'Cl': 17, 'Ar': 18, 'K': 19, 'Ca': 20,
    'Sc': 21, 'Ti': 22, 'V': 23, 'Cr': 24, 'Mn': 25, 'Fe': 26, 'Co': 27, 'Ni': 28, 'Cu': 29, 'Zn': 30,
    'Ga': 31, 'Ge': 32, 'As': 33, 'Se': 34, 'Br': 35, 'Kr': 36, 'Rb': 37, 'Sr': 38, 'Y': 39, 'Zr': 40,
    'Nb': 41, 'Mo': 42, 'Tc': 43, 'Ru': 44, 'Rh': 45, 'Pd': 46, 'Ag': 47, 'Cd': 48, 'Ag': 47,  # Silver (Argentum)
    'Cd': 48,  # Cadmium
    'In': 49,  # Indium
    'Sn': 50,  # Tin (Stannum)
    'Sb': 51,  # Antimony (Stibium)
    'Te': 52,  # Tellurium
    'I': 53,   # Iodine
    'Xe': 54,  # Xenon
    'Cs': 55,  # Caesium
    'Ba': 56,  # Barium
    'La': 57,  # Lanthanum
    'Ce': 58,  # Cerium
    'Pr': 59,  # Praseodymium
    'Nd': 60,  # Neodymium
    'Pm': 61,  # Promethium
    'Sm': 62,  # Samarium
    'Eu': 63,  # Europium
    'Gd': 64,  # Gadolinium
    'Tb': 65,  # Terbium
    'Dy': 66,  # Dysprosium
    'Ho': 67,  # Holmium
    'Er': 68,  # Erbium
    'Tm': 69,  # Thulium
    'Yb': 70,  # Ytterbium
    'Lu': 71, 'Hf': 72,  # Hafnium
    'Ta': 73,  # Tantalum
    'W': 74,   # Tungsten (Wolfram)
    'Re': 75,  # Rhenium
    'Os': 76,  # Osmium
    'Ir': 77,  # Iridium
    'Pt': 78,  # Platinum
    'Au': 79,  # Gold (Aurum)
    'Hg': 80,  # Mercury (Hydrargyrum)
    'Tl': 81,  # Thallium
    'Pb': 82,  # Lead (Plumbum)
    'Bi': 83,  # Bismuth
    'Po': 84,  # Polonium
    'At': 85,  # Astatine
    'Rn': 86,  # Radon
    'Fr': 87,  # Francium
    'Ra': 88,  # Radium
    'Ac': 89,  # Actinium
    'Th': 90,  # Thorium
    'Pa': 91,  # Protactinium
    'U': 92,   # Uranium
    'Np': 93,  # Neptunium
    'Pu': 94,  # Plutonium
    'Am': 95,  # Americium
    'Cm': 96,  # Curium
    'Bk': 97,  # Berkelium
    'Cf': 98,  # Californium
    'Es': 99,  # Einsteinium
    'Fm': 100, # Fermium
    'Md': 101, # Mendelevium
    'No': 102, # Nobelium
    'Lr': 103, # Lawrencium
    'Rf': 104, # Rutherfordium
    'Db': 105, # Dubnium
    'Sg': 106, # Seaborgium
    'Bh': 107, # Bohrium
    'Hs': 108, # Hassium
    'Mt': 109, # Meitnerium
    'Ds': 110, # Darmstadtium
    'Rg': 111, # Roentgenium
    'Cn': 112, # Copernicium
    'Nh': 113, # Nihonium
    'Fl': 114, # Flerovium
    'Mc': 115, # Moscovium
    'Lv': 116, # Livermorium
    'Ts': 117, # Tennessine
    'Og': 118} # Oganesson

def get_coord(cif_file):

    import pandas as pd
    from uncertainties import ufloat_fromstr
    
    cif=cif_io(cif_file)
    
    for line in range(len(cif)):
        x=cif[line].find('_atom_site_fract_x')  ##  find where the loop with fractional coordinates is
        if x!=-1: ## check for y
            y=cif[line+1].find('_atom_site_fract_y')
            if y!=-1: ## check for z
                z=cif[line+2].find('_atom_site_fract_z')
                if z!=-1: # keep scanning on file to start the coordinates
                    for line2 in range(line+3,len(cif)):  #### search for the coordinates
                        init=cif[line2].find('_')
                        if init==-1:
                            line_init=line2
                            for line3 in range(line2,len(cif)): ### search for a blank line or 'loop_' to mark the end of coordinates sections
                                if len(cif[line3])==1: ## we reached the end of coordinates                           
                                    line_end=line3
                                    break
                                else: ## alternative: #END
                                    end=cif[line3].find('END')
                                    if end!=-1:
                                        line_end=line3
                                        break
                                    end2=cif[line3].find('loop_') ### search for a _loop to mark the end of coordinates
                                    if end2!=-1:
                                        line_end=line3
                                        break
                            break
                    break
                else: ### warning: z not found
                    print('Warning! CIF file appears to do not have y coordinates')            
            else: ### warning: y not found
                print('Warning! CIF file appears to do not have y coordinates')

    coord=cif[line_init:line_end]

    for i in range(len(coord)):  ### building the dataframe
        coord[i]=coord[i].split()

    coord_df=pd.DataFrame(coord)
    coord_df=coord_df.iloc[:,1:5]
    #coord_df.drop(labels=[0,5,6,7,8,9,10,11,12,13,14],axis=1,inplace=True) # remove extra columns
    coord_df.replace(to_replace=periodic_table,inplace=True) # replace atomic symbols w/ atomic numbers
    for i in range(coord_df.shape[0]):
        coord_df.iloc[i,1]=ufloat_fromstr(coord_df.iloc[i,1]).n
        coord_df.iloc[i,2]=ufloat_fromstr(coord_df.iloc[i,2]).n
        coord_df.iloc[i,3]=ufloat_fromstr(coord_df.iloc[i,3]).n


    return coord_df

cif_file='/home/bmpeluzo/Dropbox/Rochester/Research/CIF/U_VI_hexakis_tert_butoxide.cif'

print(get_coord(cif_file))
from pymatgen.core import Structure

#def get_coord(cif_file)
#from pymatgen.core import Structure, Lattice

#cif=Structure.from_file('/home/bmpeluzo/Dropbox/Rochester/Research/CIF/BTBT.cif')
#print(dir(cif))
#print(cif.get_reduced_structure)
#print(Lattice.get_fractional_coords(cif))
#print(cif.frac_coords.CellType)






#print(bse.get_basis('6-311G(d,p)', elements=[6,1,16], fmt='crystal'))
