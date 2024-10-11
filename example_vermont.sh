#!/bin/bash
#

#### USER INPUT #####
job_name=example
input_name=false # True if you call your input something.d12

## Path to binary on Bluehive 
binary=/scratch/mruggie8_lab/software/CRYSTAL/CRYSTAL23_BARBARA/bin/bluehive_impi_nodebug/std/Pcrystal
#binary=/scratch/mruggie8_lab/software/CRYSTAL/CRY23_PUB/bin/bluehive_impi_nodebug/std/Pcrystal


###### CHECK IF THE JOB WAS SUBMITTED FROM HOME OR SCRATCH ####
sub_dir=$(pwd | cut -d/ -f2)

#set -x  #echo on
module load impi/2020.1 #Load the intel library (already exists on compute nodes)


# Generate random string for job storage on compute nodes to avoid conflicts
rand=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13; echo)
jobdir=/home/$USER/$rand
#jobdir=/home/$USER/$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13; echo)
remotebinary=$jobdir/Pcrystal

echo $rand

# copy input file to INPUT (in case your input is already called INPUT, comment out this line)
if [ ${input_name} = true ]; then
	cp ${job_name}.d12 INPUT
fi

# Turn command line args into comma separated list for mpirun
printf -v joined '%s,' "$@"
hostlist=$(echo $joined | sed 's/,$//')

echo "Running in $jobdir on $hostlist"

# Loop over hosts and copy current directory to jobdir (and binary)
for host in $@; do
  ssh $host "mkdir $jobdir"
  scp  INPUT $host:$jobdir
  scp $binary $host:$remotebinary
# scp additional_input $host:$jobdir   #### comment this out if you have additional input files
done


#
# Launch program on remote hosts
mpirun -ppn 24 -hosts $hostlist -wdir=$jobdir $remotebinary </dev/null &> $job_name.out

### extra copy of the output with jobid

cp ${job_name}.out ${job_name}_$rand.out

# Copy files back to bluehive and remove jobdir from remote host
if [[ $sub_dir == "home" ]]; then
	out_dir=$SCRATCH/${job_name}_$rand
	echo "copying output to scratch"
elif [[ $sub_dir == "scratch" ]]; then
	out_dir=${job_name}_$rand
else
	out_dir=$SCRATCH/${job_name}_$rand
	echo "Unable to detect submission directory. Output files are located at $out_dir"
fi


mkdir -p ${out_dir}
cd ${out_dir}/

for host in $@; do

scp -r $host:$jobdir ./$host && ssh $host "rm -rf $jobdir"
done

