require 'mechanize'

class Datagetter
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

  def submit_form
    @table.each do |body|
      outer_space_form = @page.form 
      object = outer_space_form.field_with(name: 'object').options.find { |option| option.text.strip == body[0] }
      unless object
        puts "!!!!!!THERE IS NO #{body[0]} !!!!!!!"
        next
      end
      object.select
      outer_space_form.field_with(name: 'coordinate').options[2].select #heliographic inertial
      outer_space_form.start_year = body[1]
      outer_space_form.start_day  = body[2]
      outer_space_form.stop_year  = body[3]
      outer_space_form.stop_day   = body[4]
      outer_space_form.radiobuttons_with(name: 'activity')[3].check

      @new_page = @agent.submit(outer_space_form)
      data_link = @new_page.links[0]
      if data_link.uri.scheme == "mailto"
        pp outer_space_form
        exit
      end
      @new_page = data_link.click
      space_array = @new_page.body.scan(/(\d{4}) \s*?(\d{1,3})\s*?(\+|-?[0-9]+\.[0-9]+)\s*?(\+|-?[0-9]+\.[0-9]+)\s*?(\+|-?[0-9]+\.[0-9]+)/)
      make_hash(body[0], space_array, 'planethash2.json')
    end
  end
  
  def make_hash(satellite_name, array, outputfile)
    hash = {name: satellite_name.gsub(/ /, '_').downcase!, years: {} }
    array.each do |line|
      unless hash[:years][line[0]]
        hash[:years][line[0]] = {}
      end
      hash[:years][line[0]][line[1]] = {'x' => line[2], 'y' => line[3], 'z' => line[4]}
    end
    open(outputfile, 'a') { |f|
      f.puts hash.to_json
    }
  end
end

data = Datagetter.new
data.submit_form