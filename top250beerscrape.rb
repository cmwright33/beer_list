require 'pismo'
require 'nokogiri'
require 'open-uri'
require 'pry'



class Beer
  # attr_accessible :name, :beer_url, :image_url, :brewery, :style, :abv, :available

  def intialize(name, beer_url, image_url, brewery, style, abv, available, pairings, ratings)

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
    @beer_links = []
    l.each_slice(3) {|a| beer_links << a}
    @a_beer_page = []
    beer_link.each {|link| @a_beer_page << link.first}
  end


  #dumby link
  link = "/beer/profile/27039/16814"

  def define_beer(a_beer_page)
    a_beer_page.each_with_index do |link, index|
      url = Nokogiri::XML(open("http://beeradvocate.com#{link}"))
      a_new_beer = Beer.new
      a_new_beer.name = url.xpath("//*[@id='content']/div/div/div/div/div[2]/h1/text()").text
      picture_target = url.xpath("//*[@id='baContent']/table[1]/tbody/tr/td[1]/div[1]/img/@src").text
      a_new_beer.image_url = "http://beeradvocate.com#{picture_target}"
      a_new_beer.brewery = url.xpath("//*[@id='baContent']/table[1]/tr/td[2]/table/tr[2]/td/a[1]/b").text
      a_new_beer.stlye = url.xpath("//*[@id='baContent']/table[1]/tr/td[2]/table/tr[2]/td/a[5]/b").text
      # need to remove string elements from abv to normalize data and maybe turn it back to float?
      a_new_beer.abv = url.xpath("//*[@id='baContent']/table[1]/tr/td[2]/table/tr[2]/td/text()[7]").text.gsub(/|% /, '').to_f
      # need to remove string elements from availble and normalize string... maybe we change this to boolean??
      a_new_beer.available = url.xpath("//*[@id='baContent']/table[1]/tr/td[2]/table/tr[2]/td/text()[9]").text.gsub(/&nbsp/,'')
      a_new_beer.pairings = url.xpath("//*[@id=\"baSidebar\"]/div[3]/div/text()").text.gsub(/[\n\t?]/, '').delete("[]()")
      a_new_beer.ratings = 251 - index

      a_new_beer.save
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
    useful_content = comment_content.to_s.downcase.gsub(/\<[^\>]{1,100}\>/, '').gsub(/\.+\s+/, ' ').gsub(/\&\w+\;/, '').scan(/(\b|\s|\A)([a-z0-9][a-z0-9\+\.\'\+\#\-\\]*)(\b|\s|\Z)/i).map{ |ta1| ta1[1] }.compact.each do |word|
    next if word.length > 15
      word.gsub!(/^[\']/, '')
      word.gsub!(/[\.\-\']$/, '')
    next if word_list.include?(word) && matched_words.has_key?(word)
          matched_words[word] += 1
        elsif word_list.include?(word) && !(matched_words.has_key?(word))
          matched_words[word] = 1
        else
          "nothing to do here"
      end
    end
end







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