require 'mechanize'

class Datagetter
  def initialize
    @agent = Mechanize.new
    @page = @agent.get('http://omniweb.gsfc.nasa.gov/coho/helios/heli.html')
    @table = (@page.root / :pre).text.scan(/\s*(.*?)\s*(\d{4})  (\d{3}) - (\d{4})  (\d{3})/)
  end

  def submit_form
    i = 0
    @table.each do |body|
      outer_space_form = @page.form 
      outer_space_form.field_with(name: 'object').options[i].select
      outer_space_form.start_year = body[1]
      outer_space_form.start_day  = body[2]
      outer_space_form.stop_year  = body[3]
      outer_space_form.stop_day   = body[4]
      outer_space_form.radiobuttons_with(name: 'activity')[3].check
      i += 1
      @new_page = @agent.submit(outer_space_form)
      puts "Link #{i}"
      puts @new_page = @new_page.links[0]
      space_array = @new_page.body.scan(/(\d{4}) \s*?(\d{1,3})\s*?(\+|-?[0-9]+\.[0-9]+)\s*?(\+|-?[0-9]+\.[0-9]+)\s*?(\+|-?[0-9]+\.[0-9]+)/)
      make_hash(body[i], space_array, 'planethash2.json')
    end
  end
  
  def make_hash(satellite_name, array, outputfile)
    hash = {name: satellite_name, years: {} }
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