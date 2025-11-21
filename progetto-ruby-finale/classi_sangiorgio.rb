

class Sequence
    NUCLEOTIDES = ["A", "C", "G", "T"]
    
    # Initialize a Sequence
    # Params:
    # - sequence: String
    # - name: String, default to "unknown"
    # - min: Integer, minimum number of nucleotides, default to 5
    # - max: Integer, maximum number of nucleotides, default to 100
    #
    # "min" and "max" will be used only if sequence is "", generating a random
    # sequence with a minimum of "min" and a maximum of "max" nucleotides.
    def initialize(sequence, min = 5, max = 100, name = "unknown")
        if sequence == ""
            @sequence = random(min, max)
        else
            @sequence = sequence.split("")
        end
        
        @nome = name
    end
    
    def sequence
        @sequence
    end
    
    def to_s
        ">" + @nome + "\n" + @sequence.join
    end
    
    def get_sequence_string
        @sequence.join
    end
    
    def size
        @sequence.size
    end
    
    # Returns the complement of the sequence
    def complement
        complement_dict = {
        "A" => "T",
        "G" => "C",
        "C" => "G",
        "T" => "A",
        "-" => "-"
        }
        
        complement = []
        @sequence.size.times do |i|
            complement.push(complement_dict[@sequence[i]])
        end
        
        complement.join
    end
    
    private
    
    def random(min, max)
        len = rand(min..max)
        seqrandom = Array.new(len) { NUCLEOTIDES[rand(4)] }
        
        seqrandom
    end
end


class Matrix
    def initialize(m)
        @m = m
    end
    
    def Matrix.random(x, y, n)
        tabella = []
        x.times {
            riga = []
            y.times { riga.push(rand(n)) }
            tabella.push(riga)
        }
        return Matrix.new(tabella)
    end
    
    def Matrix.read(nome)
        tabella = []
        a = open(nome).readlines.each { |i|
            tabella.push(i.split("\t"))
        }
        return Matrix.new(tabella)
    end
    
    def matrix
        @m
    end
    
    def get(x, y)
        @m[x][y]
    end
    
    def set(x, y, n)
        @m[x][y] = n
    end
    
    def to_s
        s = ""
        @m.each { |i| s += i.join("\t") + "\n" }
        s + "\n"
    end
    
    def randomize(n)
        @m.each_index { |i|
            @m[i].each_index { |j|
                @m[i][j] = rand(n)
            }
        }
    end
    
    def read(nome)
        @m = []
        open(nome).readlines.each { |i|
            @m.push(i.split("\t").map { |j| j.to_i })
        }
    end
    
    def write(nome)
        f = open(nome, "w")
        f.write(to_s)
        f.close
    end
    
    def max
        return @m.map { |riga| riga.max }.max
    end
    
    def dup
        nuova_matrice = []
        @m.each { |riga| nuova_matrice.push(riga.dup) }
        return Matrix.new(nuova_matrice)
    end
    
    def max_indici
        massimo = 0
        imax = -1
        jmax = -1
        @m.size.times { |i|
            if @m[i].max > massimo
                massimo = @m[i].max
                jmax = @m[i].index(massimo)
                imax = i
            end
        }
        return [imax, jmax]
    end
end

class SubstitutionMatrix < Matrix
    AA = ['A', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'Y']
    
    def initialize(nome_file)
        read(nome_file)
    end
    
    def to_s
        s = ""
        s += "\n\t" + AA.join("\t") + "\n"
        @m.size.times { |i| s += AA[i] + "\t" + @m[i].join("\t") + "\n" }
        return s
    end
    
    def value(a1, a2)
        @m[AA.index(a1)][AA.index(a2)].to_i
    end
end

class AlignmentMatrix < Matrix
    def initialize(seq1, seq2)
        @s1 = seq1
        @s2 = seq2
        @m = []
        seq1.size.times { |i|
            riga = []
            seq2.size.times { |j|
                riga.push(seq1.sequence[i] == seq2.sequence[j] ? 1 : 0) # attenzione al .s
            }
            @m.push riga
        }
    end
    
    def to_s
        s = "\n\t" + @s2.sequence.join("\t") + "\n"
        @m.size.times { |i|
            s += @s1.sequence[i] + "\t" + @m[i].join("\t") + "\n"
        }
        return s
    end
    
    def similarity(sm)
        @s1.size.times { |i|
            @s2.size.times { |j|
                @m[i][j] = sm.value(@s1.sequence[i], @s2.sequence[j])
            }
        }
    end
    
    def fill(gp)
        @gp = gp
        1.upto(@m.size - 1) { |i|
            1.upto(@m[i].size - 1) { |j|
                @m[i][j] = [0, @m[i - 1][j - 1] + @m[i][j], @m[i - 1][j] + gp, @m[i][j - 1] + gp].max
            }
        }
    end
    
    def local(mi)
        i, j = max_indici
        a1 = []
        a2 = []
        while @m[i][j] > 0 and i > 0 and j > 0
            if get(i, j) == get(i - 1, j - 1) + mi.get(i, j)
                a1.unshift(@s1.sequence[i])
                a2.unshift(@s2.sequence[j])
                i = i - 1
                j = j - 1
            elsif get(i, j) == get(i, j - 1) + @gp
                a1.unshift("-")
                a2.unshift(@s2.sequence[j])
                j -= 1
            elsif get(i, j) == get(i - 1, j) + @gp
                a1.unshift(@s1.sequence[i])
                a2.unshift("-")
                i -= 1
            else
                puts "abbiamo un problema"
                exit
            end
        end
        return [a1, a2]
    end
end
