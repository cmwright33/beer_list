require 'pismo'
require 'nokogiri'
require 'open-uri'
require 'pry'



class Beer
  # attr_accessible :name, :beer_url, :image_url, :brewery, :style, :abv, :available

  def intialize(name, beer_url, image_url, brewery, style, abv, available, pairings, ba_ratings)

    @name = name
    @image_url = image_url
    @style = style
    @brewery = brewery
    @abv = abv
    @available = available
    @pairings = pairings
  end

  def get_beer_list
    # open the beer top 250 beer list
    doc = Nokogiri::HTML(open('http://beeradvocate.com/lists/top'))
    # pull out the
    l = doc.css('span a').map { |link| link['href'] }
    # create the beer links, I may use these later
    beer_links = []
    # slice the links into an array within an array
    l.each_slice(3) {|a| beer_links << a}
    # create the single beer page
    @a_beer_page = []
    # add the first link to get the individual beer page
    beer_link.each {|link| @a_beer_page << link.first}
  end


  #dumby link
  link = "/beer/profile/27039/16814"

  def define_beer(a_beer_page)
     # Interate through the individual beer link array
    a_beer_page.each_with_index do |link, index|
      # add the link to the nokogiri call
      url = Nokogiri::HTML(open("http://beeradvocate.com#{link}"))
      # create a beer object
      a_new_beer = Beer.new
      # add the name to the object
      a_new_beer.name = url.xpath("//*[@id='content']/div/div/div/div/div[2]/h1/text()").text
      # get the img from the target and added to the image url
      picture_target = url.xpath("//*[@id='baContent']/table[1]/tbody/tr/td[1]/div[1]/img/@src").text
      a_new_beer.image_url = "http://beeradvocate.com#{picture_target}"
      # adds the brewery name
      a_new_beer.brewery = url.xpath("//*[@id='baContent']/table[1]/tr/td[2]/table/tr[2]/td/a[1]/b").text
      # add the style/s of beer
      a_new_beer.stlye = url.xpath("//*[@id='baContent']/table[1]/tr/td[2]/table/tr[2]/td/a[5]/b").text
      # add the beer abv
      a_new_beer.abv = url.xpath("//*[@id='baContent']/table[1]/tr/td[2]/table/tr[2]/td/text()[7]").text.delete("|" "%").tr('^A-Za-z0-9.', '').to_f
      # add the availablity to the beer
      a_new_beer.available = url.xpath("//*[@id='baContent']/table[1]/tr/td[2]/table/tr[2]/td/text()[9]").text.tr('^A-Za-z0-9', "")
      # create a ratings scheme if you have any conflict in search criteria
      a_new_beer.ba_ratings = 251 - index
      # save the information
      a_new_beer.save

      pairing = Pairings.new

      pairings = url.xpath("//*[@id='baSidebar']/div[3]/div/text()").text.gsub(/[\n\t?]/, '').delete("[](),/;").split(" ")

      binding.pry

    end
  end
end


  def get_pairings(a_beer_page)
    a_beer_page.each do |link|
      # create a new pairing
      a_new_pairing = Pairings.new
      # go to the location of the pairings, scrub the info and cut the pairings into an array
      pairings = url.xpath("//*[@id='baSidebar']/div[3]/div/text()").text.gsub(/[\n\t?]/, '').delete("[](),/;").split(" ")
      # adds a new pairing
      pairings.each do |food_type|
        a_new_pairing.name = food_type
        a_new_pairing.save
      end

    end
  end








## building keyword models

def keywords
  #example dumby link
  link = "/beer/profile/27039/16814"

  #base url for all profiles searched
  url = Nokogiri::XML(open("http://beeradvocate.com#{link}"))

  #this is our individual review xpath. this is where we'll preform the search
  comment_content = url.xpath("//*[@id='rating_fullview_content_2']")

  #this is our dumby search criteria
  word_list = ["citrus", "fruit"]

  #we downcase the useful_content and set it to string so that the material is easier to access
  #we preform regex scrub
  #we test if the values are in the word list (not functional at the moment)
  #if word exists in word_list we check to see if word matchs a key in match_words hash.
  #if it does we increment the number by 1, else we add the word as key and set the value to 1
  matched_words = {}
  words = []
    useful_content = comment_content.to_s.downcase.gsub(/\<[^\>]{1,100}\>/, '').gsub(/\.+\s+/, ' ').gsub(/\&\w+\;/, '').scan(/(\b|\s|\A)([a-z0-9][a-z0-9\+\.\'\+\#\-\\]*)(\b|\s|\Z)/i).map{ |ta1| ta1[1] }.compact.each do |word|
    if word_list.include?(word)
            if matched_words.has_key?(word)
               matched_words[word] += 1
            else
               matched_words[word] = 1
            end
        else
          "this won't work"
        end
    end
end


match_words.each do |flavor_name, strength|
  a_flavor = Flavor.new
  a_flavor.name = matched_words[flavor_name]
  a_association = Name.new()
  end




["earthy", "peppery", "botanic", 'pithy', 'dry', "beerries", "orchard fruit", "woody", "elderflower", "hedgerow", "herbal", "grassy"]





# string = "Can. Hazy, yellow/straw liquid small to medium white/light off-white head.
# Aroma of fresh hops, citrus grapefruit, citrus, cereal malt, lemon grass, orange peel,
# tangerines and blackberries. Awesome. Taste is dry and medium to, grass high bitter with
# lots of fresh, hoppy notes of grass, grapefruit and tangerine. Medium bodied with
# nice carbonation. Very well brewed DIPA. Love the fresh hoppy notes."


# new_array_of_string = string.delete("\n" "," ".").split(" ")

# matched_words = {}
# word_list = ["citrus", "fruit", "grass"]

# new_array_of_string.each do |word|

#   if word_list.include?(word)
#       if matched_words.has_key?(word)
#         matched_words[word] += 1
#       else
#         matched_words[word] = 1
#       end
#   else
#     "this wont work"
#   end
# end






# new_document = Pismo::Document.new("http://beeradvocate.com/beer/profile/1199/19960")

# new_document.keywords

# def keywords(options = {})
#   options = { :stem_at => 20, :word_length_limit => 15, :limit => 20, :remove_stopwords => true, :minimum_score => 2 }.merge(options)

#   words = {}

#   # Convert doc to lowercase, scrub out most HTML tags, then keep track of words
#   cached_title = title.to_s
#   content_to_use = body.to_s.downcase + " " + description.to_s.downcase

#   # old regex for safe keeping -- \b[a-z][a-z\+\.\'\+\#\-]*\b
#   content_to_use.downcase.gsub(/\<[^\>]{1,100}\>/, '').gsub(/\.+\s+/, ' ').gsub(/\&\w+\;/, '').scan(/(\b|\s|\A)([a-z0-9][a-z0-9\+\.\'\+\#\-\\]*)(\b|\s|\Z)/i).map{ |ta1| ta1[1] }.compact.each do |word|
#     next if word.length > options[:word_length_limit]
#     word.gsub!(/^[\']/, '')
#     word.gsub!(/[\.\-\']$/, '')
#     next if options[:hints] && !options[:hints].include?(word)
#     words[word] ||= 0
#     words[word] += (cached_title.downcase =~ /\b#{word}\b/ ? 5 : 1)
#   end

#   # Stem the words and stop words if necessary
#   d = words.keys.uniq.map { |a| a.length > options[:stem_at] ? a.stem : a }
#   s = Pismo.stopwords.map { |a| a.length > options[:stem_at] ? a.stem : a }

#   words.delete_if { |k1, v1| v1 < options[:minimum_score] }
#   words.delete_if { |k1, v1| s.include?(k1) } if options[:remove_stopwords]
#   words.sort_by { |k2, v2| v2 }.reverse.first(options[:limit])
# end





# doc = Nokogiri::HTML(open('http://beeradvocate.com/lists/top'))
# l = doc.css('span a').map { |link| link['href'] }
# beer_link = []
# l.each_slice(3) {|a| beer_link << a}
# a_beer_page = []
# beer_link.each {|link| a_beer_page << link.first}


# top_beers = []

# doc = Nokogiri::XML(open('http://beeradvocate.com/lists/top'))

# a = doc.xpath('//span[@color="#666666"]/a').map { |link| link['href'] }
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