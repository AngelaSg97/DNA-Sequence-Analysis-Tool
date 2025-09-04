This project is a suite of Ruby scripts for bioinformatic sequence analysis, including DNA complement generation and protein sequence alignment. The tools can process sequences provided by the user, read from files, or generated randomly.

Features
Sequence Complement Tool
This tool generates the complementary sequence for a given DNA sequence.

Input: A single nucleotide sequence (A, C, G, T).

Input Methods:

Manual Typing: Enter the sequence directly.

File Upload: Read the sequence from a .fasta or .txt file. The file format requires the sequence to start with a > followed by the sequence on a new line.

Random Generation: Generate a random nucleotide sequence with a specified minimum and maximum length.

Output: The complementary DNA sequence.

Sequence Alignment Tool
This tool performs a local alignment of two or more amino acid sequences and calculates their identity score. The program identifies the pair of sequences with the highest identity score among all combinations.

Input: Two or more amino acid sequences.

Input Methods:

Manual Typing: Enter sequences directly.

File Upload: Read sequences from a .fasta or .txt file, or from multiple files within a folder. Each sequence in the file must begin with a >.

Random Generation: Generate a specified number of random amino acid sequences with a defined length range.

Alignment Parameters: The user must provide a score for insertions and extensions for the alignment algorithm.

Output: The detailed analysis of the best-aligned sequence pair includes:

Identity Score: The calculated score for the optimal alignment.

Identity Percentage: The percentage of identical characters in the alignment.

Alignment Display: A visual representation of the local alignment, showing matches, mismatches, and gaps.

Dot Matrix: A matrix displaying the locations of identical amino acids between the two sequences.

Matches & Mismatches: A count of the number of matches and mismatches in the final alignment.

Technical Details
The project is built using Ruby and is structured into three main files:

sangiorgio.rb: The main executable file that provides a command-line interface for the user to select and run different tools.

funzioni_sangiorgio.rb: Contains a collection of functions for sequence validation, file handling, score calculation, and alignment display.

classi_sangiorgio.rb: Defines custom classes for managing sequences (Sequence), matrices (Matrix), substitution matrices (SubstitutionMatrix), and alignment matrices (AlignmentMatrix).

sm.txt: A sample substitution matrix used for amino acid scoring. This file is critical for the alignment function.

How to Run
Clone the repository.

Make sure you have Ruby installed on your system.

Execute the main script from your terminal:

Bash ruby sangiorgio.rb
Follow the on-screen prompts to choose an operation and provide your input.
