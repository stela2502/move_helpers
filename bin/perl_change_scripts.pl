#!/usr/bin/perl

use strict;
use warnings;
use File::Basename;
use Getopt::Long;

# Define variables
my $file_path;
my $remove_string;
my @from_to;
my $help;

# Get command line options
GetOptions(
    "file=s" => \$file_path,
    "remove=s" => \$remove_string,
    "from_to=s{2}" => \@from_to,
    "help" => \$help,
);


sub help_str(){
	my $name = basename($0);
	return join("","\nA small program to remove lines matching (remove) or replace (from_to) strings in a text formated file (e.g. a script).\nAt least one of --remove or --from_to needs to be given.\nThis program only supports exact matches - no RegExp!\n",
		"\nUsage: $0 --file <file_path> [--remove <remove_string>] [--from_to <from> <to>]\nExample: $name --file <your_LS2_sbatch_script> --from_to \"lsens2018-3-3\" \"csens2024-3-2\" --remove dell \n\n" ) ;
}

if ($help){
	print help_str();
	exit 0;
}

# Check if either remove_string or from_to are provided
unless (defined $file_path && (defined $remove_string || @from_to)) {
    die help_str();
}

# Open the file for reading
open(my $fh, '<', $file_path) or die "Cannot open file '$file_path' for reading: $!";

# Read the entire file into an array
my @lines = <$fh>;

# Close the file handle
close($fh);

# Remove lines containing the specified string
if (defined $remove_string) {
    @lines = grep {!/\Q$remove_string/} @lines;
}

# Change lines if from_to option is provided
if (@from_to) {
    my ($from, $to) = @from_to;
    for my $i (0 .. $#lines) {
        $lines[$i] =~ s/\Q$from/$to/g;
    }
}

# Open the file for writing
open($fh, '>', $file_path) or die "Cannot open file '$file_path' for writing: $!";

# Write the modified data back to the same file
print $fh @lines;

# Close the file handle
close($fh);

print "File '$file_path' updated.\n";

