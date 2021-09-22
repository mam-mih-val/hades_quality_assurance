#!/bin/bash

format='+%Y/%m/%d-%H:%M:%S'

date $format

job_num=$(($SLURM_ARRAY_TASK_ID))

filelist=$lists_dir/$(ls $lists_dir | sed "${job_num}q;d")

cd $output_dir
mkdir -p $job_num
cd $job_num

while read line; do
    echo $line >> list.txt
done < $filelist
echo >> list.txt

source /etc/profile.d/modules.sh
module use /cvmfs/it.gsi.de/modulefiles/
module load compiler/gcc/9.1.0
module load boost/1.71.0_gcc9.1.0

echo "loading " $ownroot
source $ownroot

echo "executing $build_dir/run_qa -i list.txt -o output.root --tree-name hades_analysis_tree"
$build_dir/run_qa -i list.txt -o output.root --tree-name hades_analysis_tree

echo JOB FINISHED!