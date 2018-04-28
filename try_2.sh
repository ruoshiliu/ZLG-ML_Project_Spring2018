#!/bin/bash  # KEEP

# specify the Q run in; MODIFY based on the output of 'q'
# so you can submit to an underused Q
#$ -q mrsec.q

# the qstat job name; this name -> $JOB_NAME variable
# MODIFY to reflect your run
#$ -N testqsub

# use the real bash shell - KEEP
#$ -S /bin/bash

# execute the job out of the current dir and direct the error
# (.e) and output (.o) to the same directory ...
# Generally, KEEP, unless you have good reason NOT to use it.
#$ -cwd

# ... Except, in this case, merge the output (.o) and error (.e) into one file
# If you're submitting LOTS of jobs, this halves the filecount and also allows
# you to see what error came at what point in the job.
# KEEP unless there's
# good reason NOT to use it.
#$ -j y

#!! NB: that the .e and .o files noted above are the STDERR and STDOUT, not necessarily
#!! the programmatic output that you might be expecting.  That output may well be sent to
#!! other files, depending on how the app was written.

# You may use the following email notifications ONLY IF you're NOT using array jobs.
# If you're using array jobs !!ABSOLUTELY DO NOT USE email notification!!

# mail me ( ${USER} will pick up YOUR user name. ) Generally, KEEP
#$ -M ${ruoshiliu}@brandeis.edu

# when the job (b)egins, (e)nds
# MODIFY, based on what you want to be notified about

# BUT !!NEVER!!EVER!! USE THIS FOR AN ARRAY JOB
#$ -m be

# for the 2 settings below, you should first run your application behind
# '/usr/bin/time -v' to determine about how much time and memory it requires.
# obviously, the 1st time you won't know what it will take.

# also, see: https://hpc.oit.uci.edu/HPC_USER_HOWTO.html#SGE_script_params
# for some useful SGE directives

# if your program will or can use multiple cores via threading, OpenMP,
# or other parallel operations, reserve the number of cores here.
# make sure it can use the cores; otherwise omit.
# MODIFY (see <https://hpc.oit.uci.edu/running-jobs#_batch_jobs> for more options)
#$ -pe openmp 16

# reserve this much RAM at the start of the job
# MODIFY
#$ -l mem_size=64G


###### END SGE PARAMETERS  ######

###### BEGIN BASH CODE  ######
#  no more hiding them behind '#$'

# KEEP to identify which server the job ended up, in case there was a problem
echo "Running on `hpc64.brandeis.edu`"

# NOTE1: if a bash variable can /possibly/ be misinterpreted in a string,
# use the 'braced' version of it: ${VAR} instead of $VAR

# NOTE2: DOUBLE quotes ("") allow variable substitution
#        SINGLE quotes ('') do not.
# in the uncommented line below, "${USER}" would substituted for your username,
# 'hjm' for example, but '$USER' or even '${USER}' would not - it would
# be passed thru as a literal $USER or ${USER}
# The line below is a an example; it really has no valid use in real life.
# Also: $USER is a freebie environment variable; it is always defined as your login name.
# MODIFY or DELETE
ME="${ruoshiliu}"

# set a temporary output dir on the LOCAL /scratch filesystem (so data doesn't
# cross the network). NOTE: no spaces around the '='
# the diff between TMPDIR and TMPRUNDIR is that TMPDIR is where any TEMPORARY files
# are written and TMPRUNDIR is where the output files are left (which then
# have to be copied back to 'safe' storage.) Generally, KEEP.
TMPDIR=/scratch/${ruoshiliu}

# We'll name the job subdir the same as the jobname (set above with '#$ -N ..')
# Generally, KEEP
TMPRUNDIR=${TMPDIR}/${JOB_NAME}

# set an input directory (where your input data is - $HOME is a universal variable)
# Often, you'll be getting your data from one of the distributed filesystems,
# so $HOME may not be appropriate. MODIFY for the particular run.
INDIR=${HOME}/kaggle

# and final results dir in one place (where your output will stay long-term)
# As above, MODIFY
FINALDIR=${HOME}/kaggle

# this is where you keep your MD5 checksums locally, altho they'll need to be copied
# elsewhere to be safe (see below) 
MD5SUMDIR=${HOME}/kaggle/copy

# make output dirs in the local /scratch and in data filesystem
# I assume that the INDIR already exists with the data in it.
mkdir -p $TMPRUNDIR $FINALDIR $MD5SUMDIR

# load the required module; this is a fake application module load guppy/2.3.44

# and execute this command.  Note: this is an FAKE COMMAND and FAKE OPTIONS; your app will
# have different names for these directories or you may have to specify them in a dotfile.
# it's useful to break the execution line into readable chunks by ending a section
# with a continuation char (\) which MUST be the LAST character on the line
# (no following spaces)
# also note that the command is prefixed by '/usr/bin/time -v'.
# This records the actual runtime and memory usage of the command which is useful to
# figure out what Qs and servers to use.  You should do this with all your significant commands
# (but not utilities like 'ls')

/usr/bin/time -v guppy --input=${INDIR}/try_1.py \
--outdir=${TMPRUNDIR}  \
--scratchdir=${TMPDIR} \
--topo=flat --tree --color=off --density=sparse

# get a datestamp, useful for tagging the filenames created.  KEEP.
DATESTAMP=`date +%Y-%m-%d:%H:%M:%S` # no spaces in case we need that format

# after it finishes, tar/gzip up all the data. KEEP.
TARBALL=${TMPDIR}/${JOBNAME}-${DATESTAMP}-guppy.tar.gz
tar -czf $TARBALL $TMPRUNDIR

# and move the tarball to its final resting place. KEEP.
mv $TARBALL $FINALDIR

# and THIS IS IMPORTANT!! Clean up behind you. KEEP.
rm -rf $TMPDIR

