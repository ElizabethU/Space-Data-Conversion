def make_arrays(datafile)
  output = []
  input = File.read(datafile).split("\n")
  input.each do |line|
    output << line.split
  end
  output
end

def make_hash(datafile)
  hash = {}
  make_arrays('planetdata.txt').each do |line|
    unless hash[line[0]]
      hash[line[0]] = {}
    end
    hash[line[0]][line[1]] = {x: line[2], y: line[3], z: line[4]}
  end
  puts hash
end

make_hash('planetdata.txt')