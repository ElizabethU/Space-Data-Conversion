require 'mechanize'

class Seedmaker
  def initialize
    @agent = Mechanize.new
    @page = @agent.get('http://omniweb.gsfc.nasa.gov/coho/helios/heli.html')
    @table = (@page.root / :pre).text.scan(/\s*(.*?)\s*(\d{4})  (\d{3}) - (\d{4})  (\d{3})/)
    trouble = @table.find {|name,| name == "PIONEER 11"}
    trouble[2] = trouble[2].to_i + 1
    artemis1 = @table.find {|name,| name == "ARTEMIS-P1(THEMIS-B)" }
    artemis1[0] = "Artemis-P1"
    artemis2 = @table.find {|name,| name == "ARTEMIS-P2(THEMIS-C)" }
    artemis2[0] = "Artemis-P2"
    earth = @table.find {|name,| name == "EARTH (IMP8,etc *)" }
    earth[0] = "EARTH (IMP8,etc)"
    mars = @table.find {|name,| name == "MARS SCIENCE LAB." }
    mars[0] = "Mars Science Lab."
    mars = @table.find {|name,| name == "VENUS (PVO *)" }
    mars[0] = "VENUS (PVO)"
    @table.slice!(15)
    @table.slice!(21)
    @table.slice!(24)
  end

  def format_to_hash
    array = []
    @table.each do |body|
      array << {name: body[0].gsub(/ /, '_').downcase!, diameter: 0.5, color: '#ffffff', x: 0, y: 0, z: 0, current: true }
    end
    open('planetdata.txt', 'a') { |f|
      f.puts array
    }
  end
end

seeds = Seedmaker.new
seeds.format_to_hash