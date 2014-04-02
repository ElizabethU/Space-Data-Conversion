def make_arrays(datafile)
  output = []
  input = File.read(datafile).split("\n")
  input.each do |line|
    output << line.split
  end
  puts output
end

make_arrays('planetdata.txt')