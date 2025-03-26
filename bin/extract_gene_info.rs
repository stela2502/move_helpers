use std::collections::HashSet;
use std::env;
use std::fs::File;
use std::io::{self, BufRead, Write};
use std::path::Path;

fn usage() {
    println!("Usage: extract_gene_info -i <input_file> -o <output_file>");
    println!("  -i <input_file>   : Path to the input GTF file (must exist)");
    println!("  -o <output_file>  : Path to the output file (will be created)");
    std::process::exit(1);
}

fn main() -> io::Result<()> {
    // Parse command-line arguments
    let args: Vec<String> = env::args().collect();
    if args.len() != 5 {
        usage();
    }

    let mut infile = String::new();
    let mut outfile = String::new();

    // Parse input arguments
    for i in 0..args.len() {
        if args[i] == "-i" {
            infile = args[i + 1].clone();
        } else if args[i] == "-o" {
            outfile = args[i + 1].clone();
        }
    }

    if infile.is_empty() || outfile.is_empty() {
        usage();
    }

    // Open input file
    let file = File::open(infile)?;
    let reader = io::BufReader::new(file);

    // Create a HashSet to store unique gene_id and gene_name pairs
    let mut unique_pairs = HashSet::new();

    for line in reader.lines() {
        let line = line?;
        if line.contains("gene_id") && line.contains("gene_name") {
            // Extract gene_id and gene_name using simple regex-style parsing
            if let (Some(gene_id), Some(gene_name)) = extract_gene_info(&line) {
                // Add the pair to the HashSet (automatically handles uniqueness)
                unique_pairs.insert((gene_id, gene_name));
            }
        }
    }

    // Open output file
    let mut output_file = File::create(&outfile)?;

    // Write the unique gene_id and gene_name pairs to the output file
    for (gene_id, gene_name) in unique_pairs {
        writeln!(output_file, "{}\t{}", gene_id, gene_name)?;
    }

    println!("Extraction complete! Output written to: {}", &outfile);
    Ok(())
}

// Extract gene_id and gene_name from a line of GTF file
fn extract_gene_info(line: &str) -> (Option<String>, Option<String>) {
    let gene_id_tag = "gene_id \"";
    let gene_name_tag = "gene_name \"";

    let gene_id = extract_tag_value(line, gene_id_tag);
    let gene_name = extract_tag_value(line, gene_name_tag);

    (gene_id, gene_name)
}

// Helper function to extract the value of a tag (e.g., gene_id or gene_name)
fn extract_tag_value(line: &str, tag: &str) -> Option<String> {
    if let Some(start) = line.find(tag) {
        let start = start + tag.len();
        if let Some(end) = line[start..].find("\"") {
            return Some(line[start..start + end].to_string());
        }
    }
    None
}
