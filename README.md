# Bioinformatic Sequence Analysis tool (Ruby)

This project is a suite of Ruby scripts for **bioinformatic sequence analysis**, including tools for **DNA complement generation** and **protein sequence alignment**.  
The tools can process sequences provided manually, read from files, or be generated randomly.

---

## Features

### Sequence Complement Tool
Generates the **complementary sequence** for a given DNA sequence.

- **Input**: A single nucleotide sequence (`A, C, G, T`).
- **Input Methods**:
  - **Manual Typing**: Enter the sequence directly in the terminal.
  - **File Upload**: Load a `.fasta` or `.txt` file.  
    Format requirement: the first line starts with `>`, followed by the sequence on a new line.
  - **Random Generation**: Generate a random nucleotide sequence with a defined length range.
- **Output**: The complementary DNA sequence.

---

### Sequence Alignment Tool
Performs a **local alignment** of two or more amino acid sequences and calculates their **identity score**.  
The program identifies the **best-aligned pair** among all possible combinations.

- **Input**: Two or more amino acid sequences.
- **Input Methods**:
  - **Manual Typing**: Enter sequences directly.
  - **File Upload**: Load sequences from a `.fasta`/`.txt` file or from multiple files in a folder.  
    Each sequence must begin with `>`.
  - **Random Generation**: Generate a specified number of random amino acid sequences with a user-defined length range.
- **Alignment Parameters**: User must provide insertion and extension scores for the alignment algorithm.
- **Output**:
  - **Identity Score**: Numeric value of the alignment score.
  - **Identity Percentage**: Proportion of identical residues.
  - **Alignment Display**: Visual representation with matches, mismatches, and gaps.
  - **Dot Matrix**: Graphical matrix showing identical residues between sequences.
  - **Matches & Mismatches**: Count of aligned residues.

---

## Technical Details

The project is implemented in **Ruby** and structured into the following components:

- **`sangiorgio.rb`**: Main executable providing a CLI for selecting and running tools.
- **`funzioni_sangiorgio.rb`**: Utility functions for validation, file handling, scoring, and visualization.
- **`classi_sangiorgio.rb`**: Custom classes:
  - `Sequence` – sequence management
  - `Matrix` – general matrix handling
  - `SubstitutionMatrix` – amino acid scoring
  - `AlignmentMatrix` – alignment computations
- **`sm.txt`**: Example substitution matrix used in protein alignment (required for scoring).

---

## How to Run

1. **Clone the repository**:
   ```bash
   git clone <repository_url>
   cd <repository_name>
---

2. **Ensure Ruby is installed**:
      ```bash
   ruby -v

---

3. **Run the main script**:
    ```bash
   
    ruby sangiorgio.rb

---



