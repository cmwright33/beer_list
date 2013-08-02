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
 doc = Nokogiri::HTML(open('http://beeradvocate.com/lists/top'))

## Find the links for the top 250 beers in beer advocates beer list put groupings of link##
l = doc.css('span a').map { |link| link['href'] }
# beer_list = []
a = []
# l.each_slice(3) {|a| beer_list << a}
l.each_slice(3) do |x| a << x end

## Find the Img of the beer
# doc = Nokogiri::HTML(open('http://beeradvocate.com/beer/profile/27039/16814'))
# img_srcs = doc.css('img').map{ |i| i['src'] }
# img = img_srcs.first
# l = doc.css('td').search(/im\/beers\/[0-9]/)

# img = l.search('a').first['href']

binding.pry