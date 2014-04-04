require 'mechanize'
require 'json_conversion.rb'

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
      outer_space_form.start_day = body[2]
      outer_space_form.stop_year = body[3]
      outer_space_form.stop_day = body[4]
      outer_space_form.radiobuttons_with(name: 'activity')[3].check
      i += 1
      #you need to submit the form now, and call the scraping and json methods in here
    end
  end
end