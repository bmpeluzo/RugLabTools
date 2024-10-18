#!/bin/bash
#

#### USER INPUT #####
job_name=example
input_name=true # True if you call your input something.d12


## Path to binary on Bluehive 
binary=/scratch/mruggie8_lab/software/CRYSTAL/CRYSTAL23_BARBARA/bin/bluehive_impi_nodebug/std/Pcrystal
#binary=/scratch/mruggie8_lab/software/CRYSTAL/CRY23_PUB/bin/bluehive_impi_nodebug/std/Pcrystal


###### CHECK IF THE JOB WAS SUBMITTED FROM HOME OR SCRATCH ####
sub_dir=$(pwd | cut -d/ -f2)
job_dir=$PWD

#set -x  #echo on
module load impi/2020.1 #Load the intel library (already exists on compute nodes)


# Generate random string for job storage on compute nodes to avoid conflicts
rand=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13; echo)
jobdir=/home/$USER/$rand
#jobdir=/home/$USER/$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13; echo)
remotebinary=$jobdir/Pcrystal

# copy input file to INPUT (in case your input is already called INPUT, comment out this line)
if [ "${input_name}" = true ]; then
	cp ${job_name}.d12 INPUT
fi

# Turn command line args into comma separated list for mpirun
printf -v joined '%s,' "$@"
hostlist=$(echo $joined | sed 's/,$//')

echo "Running $job_name in $jobdir on $hostlist"

# Loop over hosts and copy current directory to jobdir (and binary)
for host in $@; do
  ssh $host "mkdir $jobdir"
  scp  INPUT $host:$jobdir
  scp $binary $host:$remotebinary
# scp additional_input $host:$jobdir   #### comment this out if you have additional input files
done

# Write INPUT to the output

cat INPUT </dev/null &> $job_name.out

#
# Launch program on remote hosts
mpirun -ppn 24 -hosts $hostlist -wdir=$jobdir $remotebinary </dev/null &>> $job_name.out

### extra copy of the output with jobid

cp ${job_name}.out ${job_name}_$rand.out

# Copy files back to bluehive and remove jobdir from remote host

if [[ $sub_dir == "home" ]]; then
	out_dir=$SCRATCH/${job_name}_$rand
	echo "copying output to scratch"
elif [[ $sub_dir == "scratch" ]]; then
	out_dir=${PWD}/${job_name}_$rand
else
	out_dir=$SCRATCH/${job_name}_$rand
	echo "Unable to detect submission directory. Output files are located at $out_dir"
fi

mkdir -p ${out_dir}
mkdir -p ${out_dir}_tmp/

for host in $@; do
scp -r $host:$jobdir/* ${out_dir}_tmp/ && ssh $host "rm -rf $jobdir"
done

######### Keeping just essential files #######
out_files=(KAPPA.DAT POWER_C.DAT POWER.DAT SEEBECK.DAT SIGMA.DAT SIGMAS.DAT TDF.DAT OPTHESS.DAT OPTINFO.DAT XMETRO.COR BORN.DAT IRREFR.DAT IRDIEL.DAT ADP.DAT ELASINFO.DAT EOSINFO.DAT FINDSYM.DAT FREQINFO.DAT TENS_IR.DAT IRSPEC.DAT TENS_RAMAN.DAT RAMSPEC.DAT SCANPES.DAT VIBPOT.DAT MOLDRAW.DAT PCF.DAT INTEGRATED_PCF.DAT INTERPOL_PCF.DAT SCFOUT.LOG FREQUENCIES.DAT FREQPLOT.DAT HESSFREQ.DAT)

out_files2=(fort.34 fort.9 fort.20 fort.69 fort.98 fort.80 fort.13 fort.85 fort.90 fort.21 fort.75 fort.28)

cd ${out_dir}_tmp/
for file in $(ls); do
	if [[ " ${out_files[*]} " =~ [[:space:]]${file}[[:space:]] ]]; then
		if [ "${input_name}" = true ]; then
			file_name=${job_name}.${file}
		else
			file_name=${file}
		fi
	cp ${file} ${out_dir}/${file_name}
	fi
	if [[ " ${out_files2[*]} " =~ [[:space:]]${file}[[:space:]] ]]; then
		if [ "${input_name}" = true ]; then
			file_name=${job_name}.f$(ls $file | cut -d. -f2)
		else
			file_name=${file}
		fi
	cp ${file} ${out_dir}/${file_name}
	fi
	if [ "$file" = "GAUSSIAN.DAT" ]; then
		if [ "${input_name}" = true ]; then
			file_name=${job_name}.gjf
		else
			file_name=${file}
		fi
	cp ${file} ${out_dir}/${file_name}
	fi
	if [ "$file" = "GEOMETRY.CIF" ]; then
		if [ "${input_name}" = true ]; then
			file_name=${job_name}.cif
		else
			file_name=${file}
		fi
	cp ${file} ${out_dir}/${file_name}
	fi
done
cd ../

mv ${job_dir}/${job_name}_$rand.out ${out_dir}/
rm -r ${out_dir}_tmp/

