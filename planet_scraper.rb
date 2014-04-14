require 'mechanize'

class Planet_data_getter
  def initialize
    @agent = Mechanize.new
    @page = @agent.get('http://omniweb.gsfc.nasa.gov/coho/helios/planet.html')
    @planet_array = ["venus", "mars", "jupiter", "saturn", "uranus", "neptune", "earth", "mercury"]
  end

  def submit_form
    for n in (0..7)
      planet_form = @page.form
      planet_form.field_with(name: 'planet').options[n].select
      planet_form.radiobuttons_with(name: 'activity')[0].check
      planet_form.start_year = 1959
      planet_form.start_day  = 1
      planet_form.stop_year  = 2019
      planet_form.stop_day   = 365
      @new_page = @agent.submit(planet_form)
      data = (@new_page.root / :pre).text.scan(/(\d{4}) \s*?(\d{1,3})\s*?(\+|-?[0-9]+\.[0-9]+)\s*?(\+|-?[0-9]+\.[0-9]+)\s*?(\+|-?[0-9]+\.[0-9]+)\s*?(\+|-?[0-9]+\.[0-9]+)\s*?(\+|-?[0-9]+\.[0-9]+)\s*?(\+|-?[0-9]+\.[0-9]+)/)
      make_hash(@planet_array[n], data, 'trighash.json')
    end
  end

  def make_hash(satellite_name, array, outputfile)
    hash = {name: satellite_name, years: {} }
    array.each do |line|
      unless hash[:years][line[0]]
        hash[:years][line[0]] = {}
      end
      hash[:years][line[0]][line[1]] = {'x' => x_cartesian(line[7], line[2]), 'y' => y_cartesian(line[7], line[2]), 'z' => z_cartesian(line[5], line[2])}
    end
    open(outputfile, 'a') { |f|
      f.puts hash.to_json
    }
  end

  def y_cartesian(hg_lon, au)
    Math.sin(hg_lon.to_f * Math::PI/180) * au.to_f
  end

  def x_cartesian(hg_lon, au)
    Math.cos(hg_lon.to_f * Math::PI/180) * au.to_f
  end

  def z_cartesian(hg_lat, au)
    Math.sin(hg_lat.to_f * Math::PI/180) * au.to_f
  end
end

planet_data = Planet_data_getter.new

planet_data.submit_form