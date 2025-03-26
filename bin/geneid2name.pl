#!/usr/bin/perl

use strict;
use warnings;

# Check if the file path is provided as an argument
die "Usage: $0 <gtf_or_gff_file> [transcript_id gene_name]\n" if @ARGV < 1 || @ARGV > 3;

# Extract the file path from the argument
my $file_path = shift;

# Determine file type based on extension
my $file_type;
if ($file_path =~ /\.gtf$/i) {
    $file_type = 'gtf';
} elsif ($file_path =~ /\.gff$/i) {
    $file_type = 'gff';
} else {
    die "Unsupported file format. Please provide a GTF or GFF file.\n";
}

# Get optional gene_name and transcript_id from command line arguments
my $transcript_id = $ARGV[0] || "transcript_id";
my $gene_name = $ARGV[1] || "gene_name";

# Open the file for reading
open(my $fh, "<", $file_path) or die "Could not open file '$file_path' $!";

# Initialize a hash to store gene_id and gene_name combinations
my %gene_info;

# Read the file line by line
while (my $line = <$fh>) {
    chomp $line;

    # Skip lines starting with #
    next if $line =~ /^#/;

    # Split the line into fields
    my @fields = split /\t/, $line;

    # Extract gene_id and gene_name from GTF or GFF attributes field
    my ($gene_id, $gene_name) = get_gene_info($fields[8], $file_type, $gene_name, $transcript_id);

    # Add the gene_id and gene_name combination to the hash
    if ($gene_id && $gene_name) {
        $gene_info{$gene_id} = $gene_name;
    }
}

# Close the file handle
close($fh);

# Print gene_id and gene_name combinations separated by a tab
foreach my $gene_id (keys %gene_info) {
    my $str ="$gene_id\t$gene_info{$gene_id}";
    $str =~ s/"//g; 
    print "$str\n";
}

# Subroutine to extract gene_id and gene_name from GTF or GFF attributes field
sub get_gene_info {
    my ($attributes, $file_type, $gene_name, $transcript_id) = @_;
    my ($gene_id, $gene_name_value);
    
    # Extract gene_id and gene_name based on file type
    if ($file_type eq 'gtf') {
        # For GTF, attributes are space-separated pairs
        my @pairs = split /; */, $attributes;
        foreach my $pair (@pairs) {
            my ($key, $value) = split / /, $pair, 2;
            if ($key eq $transcript_id) {
                $gene_id = $value;
            } elsif ($key eq $gene_name) {
                $gene_name_value = $value;
            }
        }
    } elsif ($file_type eq 'gff') {
        # For GFF, attributes are key-value pairs separated by '='
        my @pairs = split /,/, $attributes;
        foreach my $pair (@pairs) {
            my ($key, $value) = split /=/, $pair;
            if ($key eq $transcript_id) {
                $gene_id = $value;
            } elsif ($key eq $gene_name) {
                $gene_name_value = $value;
            }
        }
    }
    
    # Remove leading and trailing quotes if present
    $gene_name_value =~ s/^\"|\"$//g if defined $gene_name_value;

    return ($gene_id, $gene_name_value);
}

