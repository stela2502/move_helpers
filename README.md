# Move Heplers

Move helpers is a bundle of small scripts that should help with normal data handling on a (secure) Linux system.
It is meant for normal users to handleaccess rights to files and folders, but there are also some bioinformatic goodies included.

All scripts will write a help string if called without options. All but **rust-geo-prep**. That one will just parse your whole folder structure ;-)

## Access Rights

 1. **allow_group_access.sh** is a bash script that adds group rights; r-x for folders and r-- to files.
    this should be usful if you want to share data read only with people from a cretain group.
 2. **fix_owner.sh** will change the group of the files in the folder and also change access rights to read only.
 
## Backup

  1. **file_copy_tool** will savely copy files that match to a pattern from one folder to another.
     When run the second time this tool will replace all files in the source folder by soft links.
     This mean it is only a backup tool if run once. If run twice it is a way to separate your raw data from the scripts.
  2. **revert_links** will revert the second step of the file_copy_tool.

## SLURM jobs

 1. **create_sbatch.sh** will create a sbatch script from your command.

## Bioinformatics

Later on it also gained some common usful bioinformatics scripts:

  1. **extract_gene_info** will collect all gene_id to gene_name connections in the gtf file you let it process.
  2. **perl_change_scripts.pl** can e.g. be used to lift your sbatch scripts from AURORA to COSMOS:
  ``perl_change_scripts.pl --remove dell --from_to "lsens2018-3-3" "csens2024-3-2"``
  3. **rust-geo-prep** will collect all fastq.gz files in the directory structure - calculate md5 sums for them and put them into
  GEO prepared tables. See https://github.com/stela2502/rust-geo-prep for more info.

