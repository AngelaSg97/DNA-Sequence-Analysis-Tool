=begin
OBJECTIVE:
The project focuses on the generation of a complementary sequence and the alignment of sequences with identity score calculation.

OPERATIONS:
The tool has the capability to process sequences of various types, which can be provided as input via a file, typed from the keyboard, or randomly generated.

  -Complement Case: The user will input a nucleotide sequence, and the complement of that sequence will be generated.
  
  -Alignment Case: The user will input two (or more) amino acid sequences which will be processed to:

        -Print the alignment.
        
        -Print the score matrix (or dot plot/matrix).
        
        -Print the number of matches and mismatches.

All of this will be done after the identity score between the two highest-scoring sequences has been calculated.

=end




require_relative "funzioni_sangiorgio.rb"
require_relative "classi_sangiorgio.rb"

loop do
    puts "Do you want to find the complement of a sequence, make an alignment or exit the program? [C/a/e]"
    job_type = gets.chomp.downcase
    
    # Case complement.
    # Single sequence as input is allowed.
    if job_type == "c" or job_type.empty? # default
        loop do
            # check string input
            checks = true
            output = nil
            
            puts "Do you want to insert sequences by typing, file or random? [T/f/r]"
            input_type = gets.chomp.downcase
            
            if input_type == "t" or input_type.empty? # default
                puts "Type the nucleotide sequence:"
                input_sequence = gets.chomp.upcase
                
                # check if input string is valid, then create Sequence instance
                if check_sequence_string(input_sequence, "n")
                    output = Sequence.new(input_sequence)
                else
                    puts "Error: sequence not valid."
                    checks = false
                end
            
            elsif input_type == "f"
                loop do
                    # Multiple line print without indentation
                    hint =
                    <<~EOS
                    Enter the path of a SINGLE file in which the sequence is.
                    Note: the sequence in file MUST begin with '>' (optionally followed by its name) and a new line, e.g.

                    >
                    CCACTAGAGTAGCGCCCGAAGGTGTTACTCCCCG
                    AACACACACATCCTGAGCGAAACAATAGCCCTCGA
                    AGATTAAGTTAAAAATTGGCACTT\n
                    EOS
                    
                    puts hint
                    
                    input_path = gets.chomp
                    # check if file exists, then create Sequence instance
                    if check_path(input_path) == 1
                        sequence_str = (read_seq_from_file(input_path)).join
                        if check_sequence_string(sequence_str, "n")
                            new_sequence = Sequence.new(sequence_str)
                            output = new_sequence
                            
                            checks = true
                            break
                        else
                            puts "Error: not a nucleotide sequence."
                        end
                    else
                        puts "Error: path not valid."
                        checks = false
                    end
                end
            
            elsif input_type == "r"
                puts "Min sequence length:"
                min_value = gets.chomp.to_i
                puts "Max sequence length:"
                max_value = gets.chomp.to_i
                output = Sequence.new("", min = min_value, max = max_value)
            
            else
                puts "Error: invalid input."
            end
            
            if checks
                # Evaluate complement of the sequence
                print "Complement of \n#{output.get_sequence_string}\nis\n#{output.complement}\n\n"
                break
            end
        end
        
        # Case alignment.
        # Two or more sequences as input are allowed.
    elsif job_type == "a"
        sequences = [] # array of Sequence
        loop do
            puts "Do you want to insert sequences by typing, file or random? [T/f/r]"
            input = gets.chomp.downcase
            
            if input == "t" or input.empty? # default
                seq_num = 0
                loop do
                    puts "How many sequences do you want to align?"
                    seq_num = gets.chomp.to_i
                    
                    if seq_num < 2
                        puts "Error: sequence number must be at least 2."
                    else
                        break
                    end
                end
                
                i = 0
                while i < seq_num
                    puts "Enter sequence number #{i + 1}:"
                    input_sequence = gets.chomp.upcase
                    # check if sequence is valid, then create a Sequence instance for each given input
                    if check_sequence_string(input_sequence, "a")
                        new_seq = Sequence.new(input_sequence)
                        sequences.push(new_seq)
                        i += 1
                    else
                        puts "Error: sequence not valid."
                    end
                end
                
                break
            elsif input == "f"
                valid_path = -1
                
                loop do
                    hint =
                    <<~EOS
                    Enter the path of the file (or folder containing the files) in which sequences are.
                    Note: each sequence in files MUST begin with '>' (optionally followed by its name) and a new line, e.g.

                    >Q2J166_RHOP2 (Q2J166)
                    IDVSALDKLMPGWREDETCPLKTHVEDDHFYVMTADKAYKVPGIMVPPMLNNHKNFIGS
                    LGDLCRWLGPKAEELGVEIYPGFAATEVLYNGEVRGIATGDMGIGRDGQPKDSFTRG
                    MELLGKYTLFARGSLAKQLIAKYKLDKDSDPPKFGIGLKEVWEIDPAKHRKGRIAH\n
                    EOS
                    
                    puts hint
                    
                    file_path = gets.chomp
                    
                    valid_path = check_path(file_path)
                    
                    if valid_path > 0
                        seq_strings = []
                        # path is valid and it is a single file
                        if valid_path == 1
                            seq_strings = read_seq_from_file(file_path)
                        else
                            # path is valid and it is a folder
                            Dir.children(file_path).each do |filename|
                                valid_file = check_path(file_path + filename)
                                if valid_file == 1
                                    seq_strings.concat(read_seq_from_file(file_path + filename)) # concat of sequences of different files
                                end
                            end
                        end
                        
                        # check if file(s) contain(s) at least 2 sequences.
                        if seq_strings.size >= 2
                            seq_strings.size.times do |i|
                                new_seq = Sequence.new(seq_strings[i])
                                sequences.push(new_seq)
                            end
                            break
                        else
                            puts "Error: insufficient number of sequences, must be at least 2."
                        end
                    else
                        puts "Error: path not valid."
                    end
                end
                
                break
            elsif input == "r"
                loop do
                    puts "How many sequences do you want to generate?"
                    seq_num = gets.chomp.to_i
                    
                    if seq_num >= 2
                        puts "Min sequence length:"
                        min = gets.chomp.to_i
                        puts "Max sequence length:"
                        max = gets.chomp.to_i
                        
                        seq_strings = peptide_random(seq_num, min, max)
                        
                        seq_strings.size.times do |i|
                            new_seq = Sequence.new(seq_strings[i].join)
                            sequences.push(new_seq)
                        end
                        break
                    else
                        puts "Error: sequence number must be at least 2."
                    end
                end
                break
            else
                puts "Error: invalid input."
            end
        end
        
        # array "sequences" is populated, now proceed with its evaluation
        puts "Enter the insertion score:"
        insertion = gets.chomp.to_i
        puts "Enter the extension score:"
        extention = gets.chomp.to_i
        
        # get all possible combinations of sequences
        seq_combinations = sequences.combination(2).to_a
        
        max_score = nil
        max_sequence_1 = seq_combinations[0][0]
        max_sequence_2 = seq_combinations[0][1]
        
        # from all combinations, get the pair of sequences that have the max identity score
        # and save those sequences in variables
        seq_combinations.each do |pair|
            score = identity_score(pair[0].get_sequence_string, pair[1].get_sequence_string, insertion, extention)
            if max_score.nil? || score > max_score
                max_score = score
                max_sequence_1 = pair[0]
                max_sequence_2 = pair[1]
            end
        end
        
        percentage_id = percentuale_identita(max_sequence_1.get_sequence_string, max_sequence_2.get_sequence_string).round(2)
        
        scores =
        <<~EOS
        \nMax identity score: #{max_score}
        Identity percentage: #{percentage_id}%\n
        Related to sequences:
        #{max_sequence_1}
        #{max_sequence_2}\n
        EOS
        
        puts scores
        
        loop do
            actions =
            <<~EOS
            Actions:
            1. print the alignment
            2. print the dots matrix
            3. print the matches and mismatches numbers
            4. exit
            EOS
            
            puts actions
            
            job_type_2 = gets.chomp.to_i
            
            case job_type_2
                when 1
                    mat = AlignmentMatrix.new(max_sequence_1, max_sequence_2)
                    mat.similarity(SubstitutionMatrix.new("sm.txt"))
                    
                    mat_cp = mat.dup
                    mat.fill(insertion)
                    all = mat.local(mat_cp)
                    puts stampa_allineamento(all[0], all[1])
                
                when 2
                    mat_id_obj = Matrix.new(matrice_identita(max_sequence_1.get_sequence_string, max_sequence_2.get_sequence_string))
                    puts "Dots matrix:"
                    puts stampa_matrice_con_sequenze(mat_id_obj.matrix, max_sequence_1.sequence, max_sequence_2.sequence)
                    
                when 3
                    matches, mismatches = count_matches(max_sequence_1.get_sequence_string, max_sequence_2.get_sequence_string)
                    puts "Number of matches: #{matches}\nNumber of mismatches: #{mismatches}"
                
                when 4
                    break
                
                else
                    print "Error: number not valid\n"
            end
        end
    elsif job_type == "e"
        puts "Bye."
        break
    else
        print "Error: input not valid \n"
    end
end
