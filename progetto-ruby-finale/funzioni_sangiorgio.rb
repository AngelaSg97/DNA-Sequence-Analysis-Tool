NUCLEOTIDES = ["A", "C", "G", "T"]
AA = ["A", "C", "D", "E", "F", "G", "H", "I", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "Y"]


# Counts the number of matches and mismatches between s1 and s2.
# Return an array [matches, mismatches]
def count_matches(s1, s2)
    matches = 0
    mismatches = 0
    s1.size.times { |i|
        matches += 1 if s1[i] == s2[i]
        mismatches += 1 if s1[i] == "-" or s2[i] == "-" or s1[i]!=s2[i]
    }
    
    [matches, mismatches]
end

# Checks if the string given is a valid sequence
# Params:
# - sequence: String
# - type: String, type of array to compare the sequence with,
#   it can be "n" for nucleotides, or everything else for aminos
#
# Returns a boolean
def check_sequence_string(sequence, type)
    if sequence.empty?
        false
    end
    
    if type == "n"
        arr = NUCLEOTIDES
    else
        arr = AA
    end
    
    sequence.size.times do |i|
        unless arr.include?(sequence[i])
            return false
        end
    end
    true
end

# Checks if the "path" is valid and returns the path type.
#
# Returns:
# - 1, if "path" is a path of a file .fasta or .txt
# - 2, if "path" is a folder
# - -1, if "path" is invalid
def check_path(path)
    if (path.end_with?(".fasta") or path.end_with?(".txt")) and File.exist?(path)
        1
    
    elsif path.end_with?("/") and File.exist?(path)
        2
    
    else
        -1
    end
end

# Reads sequences from file.
#
# Params:
# - filename: name of the file containing the sequences.
# A sequence MUST begin with '>' (optionally followed by its name) and a new line.
#
# Returns an array of String containing all the sequences written in "filename".
def read_seq_from_file(filename)
    if File.exist?(filename)
        ret_seqs = []
        seq = ""
        open(filename).readlines.each do |line|
            if line[0] == ">"
                if seq == "" # primo simbolo del file
                    next
                else
                    ret_seqs.push(seq)
                    seq = ""
                end
            else
                seq += line.chomp
            end
        end
        ret_seqs.push(seq)
        
        ret_seqs
    else
        puts "Error in read_seq_from_file: file not found."
    end
end

# Computes the identity score between two sequences considering the insertion and extension scores.
#
# Params:
# - seq_1: String
# - seq_2: String
# - insertion: Integer, insertion score
# - extention: Integer, extention score
#
# Returns the identity score.
def identity_score(seq_1, seq_2, insertion, extention)
    score = 0
    seq_1.size.times do |i|
        if seq_1[i] == seq_2[i]
            score += 1
        else
            penalty = 0
            penalty = insertion if seq_1[i] == "-" || seq_2[i] == "-"
            penalty = extention if i > 0 && ((seq_1[i] == "-" && seq_1[i - 1] == "-") || (seq_2[i] == "-" && seq_2[i - 1] == "-"))
            score -= penalty
        end
    end
    score
end

def stampa_allineamento(s1, s2)
    s = s1.join + "\n"
    s1.size.times { |i|
        if s1[i] == s2[i]
            s += "|"
        else
            s += " "
        end
    }
    s += "\n" + s2.join + "\n"
    return s
end

def stampa_matrice_con_sequenze(m, s1, s2)
    s = ("\t") + s2.join("\t") + "\n"
    m.size.times { |j|
        s += s1[j] + "\t" + m[j].join("\t") + "\n"
    }
    return s
end

def stampa_matrice_sostituzione(m)
    aa = ['A', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'Y']
    puts "\t" + aa.join("\t")
    m.size.times { |i|
        puts aa[i] + "\t" + m[i].join("\t")
    }
end

def matrice_identita(s1, s2)
    m = []
    s1.size.times { |i|
        m[i] = []
        s2.size.times { |j|
            if s1[i] == s2[j]
                m[i][j] = 1
            else
                m[i][j] = 0
            end
        }
    }
    return m
end




def matrice_allineamento (m, gp)
    1.upto(m.size - 1) { |i|
        1.upto(m[i].size - 1) { |j|
            v = [
            m[i - 1][j - 1] + m[i][j],
            m[i - 1][j] + gp,
            m[i][j - 1] + gp
            ]
            m[i][j] = v.max
        }
    }
end

def peptide_random(n, min, max = min)
    seq = []
    n.times {
        seq.push(Array.new(rand(min..max)) { aminoacido_random })
    }
    return seq
end

def aminoacido_random()
    ["A", "C", "D", "E", "F", "G", "H", "I", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "Y"][rand(20)]
end


def percentuale_identita(s1, s2)
    punteggio_identita(s1, s2) * 100.0 / s1.size #return sottointeso...
end



def matrice_max_indici(m)
    max=matrice_max(m)
    m.size.times{|i|
        m[i].size.times{ |j|
            return [i,j] if m[i][j]==max
        }
    }
end

def matrice_allineamento_locale (m,gp)
    1.upto(m.size-1){ |i|
        1.upto(m[i].size-1){ |j|
            v=[ 0, m[i-1][j-1]+ m[i][j], m[i-1][j]+gp, m[i][j-1]+gp]
            m[i][j]=v.max
        }
    }
end

def allinea_locale(m2,mi,s1,s2,gp)
    i,j=matrice_max_indici(m2)  # invece di i=m2.size-1  e j=m2[0].size-1
    a1=[]
    a2=[]
    while i>0 and j>0 and m2[i][j]>0 # aggiunto   m2[i][j]>0
        if  m2[i][j]==m2[i-1][j-1]+mi[i][j]
            a1.unshift(s1[i])
            a2.unshift(s2[j])
            i=i-1
            j=j-1
        elsif m2[i][j]==m2[i][j-1]+gp
            a1.unshift("-")
            a2.unshift(s2[j])
            j-=1
        elsif m2[i][j]==m2[i-1][j]+gp
            a1.unshift(s1[i])
            a2.unshift("-")
            i-=1
        else
            puts "abbiamo un problema in posizione #{i}-#{j}"
            exit
        end
    end
    return [a1,a2]
end


def punteggio_identita(sa, sb)
    val = 0
    sa.size.times { |i| val += 1 if sa[i] == sb[i] }
    return val
end
