require 'mechanize'
require 'json_conversion.rb'

class Datagetter
  def initialize
    @agent = Mechanize.new
    @page = @agent.get('http://omniweb.gsfc.nasa.gov/coho/helios/heli.html')
    @table = (@page.root / :pre).text.scan(/\s*(.*?)\s*(\d{4})  (\d{3}) - (\d{4})  (\d{3})/)
  end

end