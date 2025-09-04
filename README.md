DNA Sequence Analysis Tool
This Ruby project is an interactive tool for analyzing DNA sequences. The program can generate complementary strands and perform sequence alignments, while also calculating an identity score.

Key Features
The tool offers several functionalities, accessible through an interactive menu:

Complementary Sequence Generation: You can input a single nucleotide sequence (via keyboard, file, or generated randomly), and the program will calculate and print its complementary strand.

Sequence Alignment: This function allows the alignment of two or more amino acid sequences (input via keyboard, file, or generated randomly). The program finds the pair with the highest identity score and, upon request, displays the alignment, the scoring matrix, and the number of matches and mismatches.

Data Handling: The program can read sequences from .fasta or .txt files, handling both single files and entire folders.

Requirements
To run this project, you need to have Ruby installed on your system.

File Structure
The project is divided into multiple files for organized code:

sangiorgio.rb: This is the main file that manages the interactive menu and the program's flow.

funzioni_sangiorgio.rb: Contains various utility functions, such as sequence validation, file reading, and identity score calculation.

classi_sangiorgio.rb: Defines the classes for managing sequences (Sequence), matrices (Matrix), and alignment and substitution matrices (AlignmentMatrix and SubstitutionMatrix).

sm.txt: This file contains the substitution matrix used for sequence alignment.

How to Run the Program
Make sure all files (sangiorgio.rb, funzioni_sangiorgio.rb, classi_sangiorgio.rb, and sm.txt) are in the same folder.

Open your terminal or command prompt.

Navigate to the project directory.

Run the main file with the command:

Bash

ruby sangiorgio.rb
Follow the on-screen instructions to use the tool.
