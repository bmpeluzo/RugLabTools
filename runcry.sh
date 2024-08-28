#! /bin/bash

while getopts j:c:r:f:F:n:p:v: flag
do
	case ${flag} in
		j ) job_id=${OPTARG};;
		c ) cores=${OPTARG};;
		r ) proj=${OPTARG};;
		n) nodes=${OPTARG};;
		p) part=${OPTARG};;
		f) fort_file=${OPTARG};;
		F) other_file=${OPTARG};;
		v) version=${OPTARG};;
	esac
done

########## setting default values #############3
if [ -z $nodes ]; then
	nodes=1
fi

if [[ $part == vermont1 || $part == vermont2 || $part == vermont12 ]]; then
	job_dir='/local_scratch/${SLURM_JOB_ID}'
	if [ -z $proj ]; then
		storg_dir='${SCRATCH}/${SLURM_JOB_ID}'
	else
		storg_dir='${SCRATCH}/'${proj}'/${SLURM_JOB_ID}'
	fi
else
	if [ -z $proj ]; then
	job_dir='${SCRATCH}/${SLURM_JOB_ID}'
	else
	job_dir='${SCRATCH}/'${proj}'/${SLURM_JOB_ID}'
	fi
fi

if [ -z $version ]; then
#	version='/scratch/mruggie8_lab/software/CRYSTAL/CRYSTAL_BARBARA/CRY23/bin/bluehive_impi_nodebug/std/Pcrystal'
	version='Pcrystal'
	# while I do not have CRY23 on my own version
else
	case ${version} in
	'original') version='Pcrystal';;
	'barbara') version='/scratch/mruggie8_lab/software/CRYSTAL/CRYSTAL_BARBARA/CRY23/bin/bluehive_impi_nodebug/std/Pcrystal'
	esac
fi

############## checking for required flags ############
if [ -z $job_id ]; then
	echo "Job name not specified"
	exit
elif [ -z $cores ]; then
	echo "Number of cores not specified"
	exit
elif [ -z $part ]; then
	echo "Partition not specified"
	exit
else
	if [[ $part == vermont1 ]]; then
		echo "#!/bin/bash
#SBATCH -p ${part[@]:0:${#part}-1} -t 30-0:00:00 -o ${job_id}.out
#SBATCH -N ${nodes} --ntasks-per-node=${cores} --mem=0 
#SBATCH --exclude=bhx[0131-0136]" > ${job_id}.sbatch
	elif [[ $part == vermont2 ]]; then
		echo "#!/bin/bash
#SBATCH -p ${part[@]:0:${#part}-1} -t 30-0:00:00 -o ${job_id}.out
#SBATCH -N ${nodes} --ntasks-per-node=${cores} --mem=0 
#SBATCH --exclude=bhx[0111-0129]" > ${job_id}.sbatch
	elif [[ $part == vermont0 ]]; then
		echo "#!/bin/bash
#SBATCH -p ${part[@]:0:${#part}-1} -t 30-0:00:00 -o ${job_id}.out
#SBATCH -N ${nodes} --ntasks-per-node=${cores} --mem=0 
#SBATCH --exclude=bhx[0112-0129,0131-0136]" > ${job_id}.sbatch
	elif [[ $part == vermont12 ]]; then
		echo "#!/bin/bash
#SBATCH -p ${part[@]:0:${#part}-2} -t 30-0:00:00 -o ${job_id}.out
#SBATCH -N 2 --ntasks-per-node=${cores} --mem=0 
#SBATCH --exclude=bhx[0111-0128,0131-0135]" > ${job_id}.sbatch

	elif [[ $part == teraeth ]]; then
		echo "#!/bin/bash
#SBATCH -p ${part} -t 30-0:00:00 -o ${job_id}.out
#SBATCH -N ${nodes} --ntasks-per-node=${cores} --mem=0 -C Gold6448Y,ib " > ${job_id}.sbatch
	fi
	echo "module load /scratch/mruggie8_lab/software/modulefiles/crystal/cry23_nodebug

job_dir=${job_dir}
mkdir -p \${job_dir}

cp ${job_id}.d12 \${job_dir}/INPUT 

########## copying additional input files ###############

if [ -e ${job_id}.f9 ]; then
	cp ${job_id}.f9 \${job_dir}/fort.9
fi

if [ -e BASISSET.DAT ]; then
	cp BASISSET.DAT \${job_dir}/
fi

if [ -e ${job_id}.f65 ]; then
	cp ${job_id}.f65 \${job_dir}/fort.65
fi

if [ -e ${job_id}.f75 ]; then
	cp ${job_id}.f75 \${job_dir}/fort.75
fi

if [ -e ${job_id}.f77 ]; then
	cp ${job_id}.f77 \${job_dir}/fort.77
fi


if [ -e ${job_id}.f21 ]; then
	cp ${job_id}.f21 \${job_dir}/fort.21
fi

if [ -e ${job_id}.f20 ]; then
	cp ${job_id}.f20 \${job_dir}/fort.20
fi


if [ -e ${job_id}.f34 ]; then
	cp ${job_id}.f34 \${job_dir}/fort.34
fi

if [ -e ${job_id}.f13 ]; then
	cp ${job_id}.f13 \${job_dir}/fort.13
fi

if [ -e ${job_id}.f80 ]; then
	cp ${job_id}.f80 \${job_dir}/fort.80
fi

if [ -e ${job_id}.freqinfo ]; then
	cp ${job_id}.freqinfo \${job_dir}/FREQINFO.DAT
fi

if [ -e ${job_id}.tensraman ]; then
	cp ${job_id}.tensraman \${job_dir}/TENS_RAMAN.DAT
fi

if [ -e ${job_id}.tensir ]; then
	cp ${job_id}.tensir \${job_dir}/TENS_IR.DAT
fi

if [ -e ${job_id}.vibpot ]; then
	cp ${job_id}.vibpot \${job_dir}/VIBPOT.DAT
fi

if [ -e ${job_id}.born ]; then
	cp ${job_id}.born \${job_dir}/BORN.DAT
fi

if [ -e ${job_id}.elasinfo ]; then
	cp ${job_id}.elasinfo \${job_dir}/ELASINFO.DAT
fi

if [ -e ${job_id}.eosinfo ]; then
	cp ${job_id}.eosinfo \${job_dir}/EOSINFO.DAT
fi

if [ -e ${job_id}.scanpes ]; then
	cp ${job_id}.scanpes \${job_dir}/SCANPES.DAT
fi

if [ -e ${job_id}.opthess ]; then
	cp ${job_id}.opthess \${job_dir}/OPTHESS.DAT
fi

if [ -e ${job_id}.optinfo ]; then
	cp ${job_id}.optinfo \${job_dir}/OPTINFO.DAT
fi

if [ -e ${job_id}.hessopt ]; then
	cp ${job_id}.hessopt \${job_dir}/HESSOPT.DAT
fi
" >> ${job_id}.sbatch


# It defaults to read files from units with the same name as the input, In case the user wants to specify an additional FORT file to be read:

if [ -z ${fort_file} ]; then
	echo "User did not specify additional f input files"
	else
	file_name=$(ls ${fort_file} | cut -d. -f1)
	file_ext=$(ls ${fort_file} | cut -d. -f2)
	let size=${#file_ext} ## accessing the number of characters in the extension string
	new_ext=$(echo ${file_ext[@]:1:${size}})
	echo "You gave me ${fort_file}, I will copy this file as fort.${new_ext}"
	echo "cp ${fort_file} \${job_dir}/fort.${new_ext} " >> ${job_id}.sbatch
fi
 
# Other additional files:

if [ -z ${other_file} ]; then
	echo "User did not specify additional input files"
	else
	echo "Copying ${other_file} to job directory"
	echo "cp ${other_file} \${job_dir}/" >> ${job_id}.sbatch
fi



#################################################################################

############################## Running CRYSTAL #####################################

echo "cd \${job_dir}

cat INPUT

echo \"Job ID: \${SLURM_JOB_ID}\"

export I_MPI_PMI_LIBRARY=/software/slurm/current/lib/libpmi.so

#srun  /scratch/mruggie8_lab/software/CRYSTAL/CRYSTAL_BARBARA/CRY23/bin/bluehive_impi_nodebug/std/Pcrystal

srun ${version}


################## copying output files ########################

if [ -e KAPPA.DAT ]
then
   cp KAPPA.DAT \${SLURM_SUBMIT_DIR}/${job_id}.KAPPA.DAT
fi

if [ -e POWER_C.DAT ]
then
   cp POWER_C.DAT \${SLURM_SUBMIT_DIR}/${job_id}.POWER_C.DAT
fi

if [ -e POWER.DAT ]
then
   cp POWER.DAT \${SLURM_SUBMIT_DIR}/${job_id}.POWER.DAT
fi

if [ -e SEEBECK.DAT ]
then
   cp SEEBECK.DAT \${SLURM_SUBMIT_DIR}/${job_id}.SEEBECK.DAT
fi

if [ -e SIGMA.DAT ]
then
   cp SIGMA.DAT \${SLURM_SUBMIT_DIR}/${job_id}.SIGMA.DAT
fi

if [ -e SIGMAS.DAT ]
then
   cp SIGMAS.DAT \${SLURM_SUBMIT_DIR}/${job_id}.SIGMAS.DAT
fi

if [ -e TDF.DAT ]
then
   cp TDF.DAT \${SLURM_SUBMIT_DIR}/${job_id}.TDF.DAT
fi

if [ -e fort.34 ]
then
   cp fort.34 \${SLURM_SUBMIT_DIR}/${job_id}.f34
fi

if [ -e fort.9 ]
then
   cp fort.9 \${SLURM_SUBMIT_DIR}/${job_id}.f9
fi

if [ -e fort.20 ]
then
   cp fort.20 \${SLURM_SUBMIT_DIR}/${job_id}.f20
fi

if [ -e OPTHESS.DAT ]
then
   cp OPTHESS.DAT \${SLURM_SUBMIT_DIR}/${job_id}.opthess
fi

if [ -e OPTINFO.DAT ]
then
   cp OPTINFO.DAT \${SLURM_SUBMIT_DIR}/${job_id}.optinfo
fi

if [ -e XMETRO.COR ]
then
   cp XMETRO.COR \${SLURM_SUBMIT_DIR}/${job_id}.xmetro
fi

if  [ -e BORN.DAT ]
then
   cp BORN.DAT \${SLURM_SUBMIT_DIR}/${job_id}.born
fi

if  [ -e IRREFR.DAT ]
then
   cp IRREFR.DAT \${SLURM_SUBMIT_DIR}/${job_id}.irrefr
fi

if  [ -e IRDIEL.DAT ]
then
   cp IRDIEL.DAT \${SLURM_SUBMIT_DIR}/${job_id}.irdiel
fi

if [ -e ADP.DAT ]
then
   cp ADP.DAT \${SLURM_SUBMIT_DIR}/${job_id}.adp
fi

if [ -e ELASINFO.DAT ]
then
   cp ELASINFO.DAT \${SLURM_SUBMIT_DIR}/${job_id}.elasinfo
fi

if [ -e EOSINFO.DAT ]
then
   cp EOSINFO.DAT \${SLURM_SUBMIT_DIR}/${job_id}.eosinfo
fi

if [ -e GEOMETRY.CIF ]
then
   cp GEOMETRY.CIF \${SLURM_SUBMIT_DIR}/${job_id}.cif
fi

if [ -e GAUSSIAN.DAT ]
then
   cp GAUSSIAN.DAT \${SLURM_SUBMIT_DIR}/${job_id}.gjf
fi

if [ -e FINDSYM.DAT ]
then
   cp FINDSYM.DAT \${SLURM_SUBMIT_DIR}/${job_id}.FINDSYM
fi

if ls \${TMPDIR}/opt* &>/dev/null
then
  mkdir \${SLURM_SUBMIT_DIR}/${job_id}.optstory &> /dev/null
  for file in \${TMPDIR}/opt*
  do
     cp \$file \${SLURM_SUBMIT_DIR}/${job_id}.optstory
  done
fi


if [ -e fort.69 ]
then
   cp fort.69 \${SLURM_SUBMIT_DIR}/${job_id}.f69
fi

if [ -e fort.98 ]
then
   cp fort.98 \${SLURM_SUBMIT_DIR}/${job_id}.f98
fi

if [ -e fort.80 ]
then
   cp fort.80 \${SLURM_SUBMIT_DIR}/${job_id}.f80
fi

if [ -e fort.13 ]
then
   cp fort.13 \${SLURM_SUBMIT_DIR}/${job_id}.f13
fi

if [ -e fort.85 ]
then
   cp fort.85 \${SLURM_SUBMIT_DIR}/${job_id}.f85
fi

if [ -e fort.90 ]
then
   cp fort.90 \${SLURM_SUBMIT_DIR}/${job_id}.f90
fi

if [ -e fort.21 ]
then
   cp fort.21 \${SLURM_SUBMIT_DIR}/${job_id}.f21
fi

if [ -e fort.75 ]
then
   cp fort.75 \${SLURM_SUBMIT_DIR}/${job_id}.f75
fi

if [ -e FREQINFO.DAT ]
then
   cp FREQINFO.DAT \${SLURM_SUBMIT_DIR}/${job_id}.freqinfo
fi

if [ -e TENS_IR.DAT ]
then
   cp TENS_IR.DAT \${SLURM_SUBMIT_DIR}/${job_id}.tensir
fi

if [ -e IRSPEC.DAT ]
then
   cp IRSPEC.DAT \${SLURM_SUBMIT_DIR}/${job_id}.IRSPEC.DAT
fi

if [ -e TENS_RAMAN.DAT ]
then
   cp TENS_RAMAN.DAT \${SLURM_SUBMIT_DIR}/${job_id}.tensraman
fi

if [ -e RAMSPEC.DAT ]
then
   cp RAMSPEC.DAT \${SLURM_SUBMIT_DIR}/${job_id}.RAMSPEC.DAT
fi

if [ -e SCANPES.DAT ]
then
   cp SCANPES.DAT \${SLURM_SUBMIT_DIR}/${job_id}.scanpes
fi

if [ -e VIBPOT.DAT ]
then
   cp VIBPOT.DAT \${SLURM_SUBMIT_DIR}/${job_id}.vibpot
fi

if [ -e MOLDRAW.DAT ]
then
   cp MOLDRAW.DAT \${SLURM_SUBMIT_DIR}/${job_id}.mol
fi

if [ -e fort.92 ]
then
   cp fort.92 \${SLURM_SUBMIT_DIR}/${job_id}.com
fi

if [ -e fort.33 ]
then
   cp fort.33 \${SLURM_SUBMIT_DIR}/${job_id}.xyz
fi

#----------------------------------------------------
# OUTPUT FILES generated from MOLDYN MODULE
# see library moldyn.f90, module Moldyn

if [ -e PCF.DAT ]
then
   cp PCF.DAT \${SLURM_SUBMIT_DIR}/PCF_${job_id}.DAT
fi

if [ -e INTEGRATED_PCF.DAT ]
then
   cp INTEGRATED_PCF.DAT \${SLURM_SUBMIT_DIR}/INTEGRATED_PCF_${job_id}.DAT
fi

if [ -e INTERPOL_PCF.DAT ]
then
   cp INTERPOL_PCF.DAT \${SLURM_SUBMIT_DIR}/INTERPOL_PCF_${job_id}.DAT
fi

if [ -e SCFOUT.LOG ]
then
   cp SCFOUT.LOG \${SLURM_SUBMIT_DIR}/${job_id}.out2
fi

if [ -e FREQUENCIES.DAT ]
then
   cp FREQUENCIES.DAT \${SLURM_SUBMIT_DIR}/FREQUENCIES_${job_id}.DAT
fi

if [ -e FREQPLOT.DAT ]
then
   cp FREQPLOT.DAT \${SLURM_SUBMIT_DIR}/FREQPLOT_${job_id}.DAT
fi

if [ -e HESSFREQ.DAT ]
then
   cp HESSFREQ.DAT \${SLURM_SUBMIT_DIR}/${job_id}.hessfreq
fi
# ---------------------------------------------------- 

cd \${SLURM_SUBMIT_DIR}/

cp ${job_id}.out ${job_id}_${SLURM_JOB_ID}.out ##### make a copy or the output to avoid overwriting
cp ${job_id}.out \${job_dir}/${job_id}_${SLURM_JOB_ID}.out

" >> ${job_id}.sbatch

fi

if [[ $part == vermont1 || $part == vermont2 || $part == vermont12 ]]; then
	echo "cp -r * $storg_dir" >> ${job_id}.sbatch
fi

sbatch ${job_id}.sbatch
