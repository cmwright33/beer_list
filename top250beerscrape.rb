require 'nokogiri'
require 'open-uri'
require 'pry'



class Beer
  attr_accessible :name, :beer_url, :image_url, :brewery, :style, :abv, :available

  def intialize(name, beer_url, image_url, brewery, style, abv, available)

    @name = name
    @image_url = image_url
    @style = style
    @brewery = brewery
    @abv = abv
    @available = available
    @pairings = pairings
  end

  def get_beer_list
    doc = Nokogiri::HTML(open('http://beeradvocate.com/lists/top'))
    l = doc.css('span a').map { |link| link['href'] }
    beer_links = []
    l.each_slice(3) {|a| beer_links << a}
    beer_link.each {|link| a_beer_page << link.first}
  end

  def define_beer(a_beer_page)
    a_beer_page.each do |link|
      url = Nokogiri::XML(open("http://beeradvocate.com#{link}"))
      a_new_beer = Beer.new
      a_new_beer.name = url.xpath("//*[@id='content']/div/div/div/div/div[2]/h1/text()").text
      a_new_beer.image_url = url.xpath("//*[@id='baContent']/table[1]/tbody/tr/td[1]/div[1]/img").text
      a_new_beer.brewery = url.xpath("//*[@id='baContent']/table[1]/tbody/tr/td[2]/table/tbody/tr[2]/td/a[1]/b").text
      a_new_beer.stlye = url.xpath("//*[@id='baContent']/table[1]/tbody/tr/td[2]/table/tbody/tr[2]/td/a[5]/b").text
      # remove &nbsp from abv to normalize data and maybe turn it back to integer?
      a_new_beer.abv = url.xpath("//*[@id='baContent']/table[1]/tbody/tr/td[2]/table/tbody/tr[2]/td/text()[3]").text.gsub(/&nbsp/,'')
      # remove &nbsp from availble and normalize string... maybe we change this to boolean??
      a_new_beer.available = url.xpath("//*[@id='baContent']/table[1]/tbody/tr/td[2]/table/tbody/tr[2]/td/text()[4]").text.gsub(/&nbsp/,'')
      a_new_beer.pairings = url.xpath("//*[@id='baSidebar']/div[3]/div/text()").text.gsub(/[\n\t?]/, '').delete("[]()")


      a_new_beer.save
    end
  end
end


    # doc = Nokogiri::HTML(open('http://beeradvocate.com/lists/top'))
    # l = doc.css('span a').map { |link| link['href'] }
    # beer_link = []
    # l.each_slice(3) {|a| beer_link << a}
    # a_beer_page = []
    # beer_link.each {|link| a_beer_page << link.first}





# top_beers = []

doc = Nokogiri::XML(open('http://beeradvocate.com/lists/top'))

a = doc.xpath('//span[@color="#666666"]/a').map { |link| link['href'] }
# # top 250 beers at beer advocate
# doc = Nokogiri::HTML(open('http://beeradvocate.com/lists/top'))

# ## Find the links for the top 250 beers in beer advocates beer list put groupings of link##
# l = doc.css('span a').map { |link| link['href'] }
# beer_list = []
# a = []
#  l.each_slice(3) {|a| beer_list << a}
# l.each_slice(3) do |x| a << x end











## Find the Img of the beer
# beer_img = Nokogiri::HTML(open('http://beeradvocate.com/beer/profile/27039/16814'))
# img_srcs = beer_img.css('img').map{ |i| i['src'] }
# img = img_srcs.first

## pairings
# beer_pairings = doc.css('div.secondaryContent')[3].children.text
# food= pairings.gsub(/[\n\t?]/, '').delete("[]()")


## beer search terms
# beer_terms = Nokogiri::HTML(open('http://www.tasteyourbeer.com/researchterms.php'))

# terms = beer_terms.css('strong').children.text.split(' ')

# # Beer Style #########NOT DONE!
# beer_style= Nokogiri::HTML(open('http://beeradvocate.com/beer/style'))
# style = beer_style.css('tr')
# style.children.text.delete('\n ')

binding.pry