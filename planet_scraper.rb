require 'mechanize'

class planet_data_getter
  def initialize
    @agent = Mechanize.new
    @page = @agent.get('http://omniweb.gsfc.nasa.gov/coho/helios/planet.html')
    @planet_array = ["Venus", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune", "Earth", "Mercury"]
  end

  def submit_form
    for n in range(0..8)
      planet_form = @page.form
      planet_form.field_with(name: 'planet').options[n].select
      planet_form.radiobuttons_with(name: 'activity')[0].check
      planet_form.start_year = 1959
      planet_form.start_day  = 1
      planet_form.stop_year  = 2019
      planet_form.stop_day   = 365
      @new_page = @agent.submit(planet_form)
      data = (@new_page.root / :pre).text.scan(/(\d{4}) \s*?(\d{1,3})\s*?(\+|-?[0-9]+\.[0-9]+)\s*?(\+|-?[0-9]+\.[0-9]+)\s*?(\+|-?[0-9]+\.[0-9]+)\s*?(\+|-?[0-9]+\.[0-9]+)\s*?(\+|-?[0-9]+\.[0-9]+)\s*?(\+|-?[0-9]+\.[0-9]+)/)
    end
  end
end