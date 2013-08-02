require 'nokogiri'
require 'open-uri'
require 'pry'



# doc = Nokogiri::HTML(open('http://beeradvocate.com/lists/top'))


# doc.css('span '). each do |title|
# #   # put the text of the title
#   puts title.text
# end

# p doc.xpath('//span[@color="#666666"]/a').map { |link| link['href'] }
# top 250 beers at beer advocate
# doc = Nokogiri::HTML(open('http://beeradvocate.com/lists/top'))

## Find the links for the top 250 beers in beer advocates beer list put groupings of link##
# l = doc.css('span a').map { |link| link['href'] }
# beer_list = []
# a = []
# # l.each_slice(3) {|a| beer_list << a}
# l.each_slice(3) do |x| a << x end

## Find the Img of the beer
beer_img = Nokogiri::HTML(open('http://beeradvocate.com/beer/profile/27039/16814'))
img_srcs = beer_img.css('img').map{ |i| i['src'] }
img = img_srcs.first

## pairings
# beer_pairings = doc.css('div.secondaryContent')[3].children.text
# food= pairings.gsub(/[\n\t?]/, '').delete("[]()")


## beer search terms
beer_terms = Nokogiri::HTML(open('http://www.tasteyourbeer.com/researchterms.php'))

terms = beer_terms.css('strong').children.text.split(' ')

# Beer Style #########NOT DONE!
beer_style= Nokogiri::HTML(open('http://beeradvocate.com/beer/style'))
style = beer_style.css('tr')
style.children.text.delete('\n ')

binding.pry