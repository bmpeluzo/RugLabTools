# bluehive

## runcry.sh

set permissions:

chmod 777 runcry.sh



Update the .bashrc/.zshrc file:

alias runcry='/home/bteixeir/scr/runcry.sh'

syntax:
`runcry -j *job_name* -c *number_of_cores* -p *partition*`



required flags:

-j job name 

-c number of cores (between 1 and the max number of cores in the node)

-p cluster partition (teraeth, vermont)



optional flags:

-r project - project name for a better organization

-n number of nodes. Default: 1

-f additional file e.g. file1.f9, file2.f33...

-F additional file e.g. FREQINFO.DAT

-v version. Options: original, barbara. Default: barbara


to use the vermont paertition:

`-p vermont1` set of nodes: bhx[0111-0129] total of 19 nodes
`-p vermont2` set of nodes: bhx[0131-0136] total of 6 nodes
