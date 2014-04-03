require 'json'

def make_arrays(datafile)
  output = []
  input = File.read(datafile).split("\n")
  input.each do |line|
    output << line.split
  end
  output
end

def make_hash(satellite_name, datafile, outputfile)
  hash = {name: satellite_name, years: {} }
  make_arrays('planetdata.txt').each do |line|
    unless hash[:years][line[0]]
      hash[:years][line[0]] = {}
    end
    hash[:years][line[0]][line[1]] = {'x' => line[2], 'y' => line[3], 'z' => line[4]}
  end
  open(outputfile, 'a') { |f|
    f.puts hash.to_json
  }
end

make_hash("Galileo", 'planetdata.txt', 'planethash.json')