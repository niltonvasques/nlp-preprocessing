require 'tf_idf'

SANITIZE_REGEXP = /('|\"|‘|’|\/|\\)/
PUNTUCTUATION_REGEXP = /(\.|,|:|;|\?|!|\(|\)|[0-9]|\$|&|\[|\]|<|>)/

PATH="/home/niltonvasques/ownCloud/Dropbox/Experimentos-NILTON/testes_AvaliacaoDescritoresHierarquico/BASES/NewYorkTimes/NewYorkTimes"
STOPWORDS = File.read("stopwords.txt").encode("UTF-8", invalid: :replace,
                                              undef: :replace, replace:
                                              '').downcase.gsub!(SANITIZE_REGEXP,
                                                                 '').split(" ")


docs_path = Dir.glob("#{PATH}/*/*")

docs = []

docs_path.each do |doc|
  text = File.read(doc).encode("UTF-8", invalid: :replace, undef: :replace, replace: '') 
  text = text.downcase.gsub(SANITIZE_REGEXP, '')
  text = text.downcase.gsub(PUNTUCTUATION_REGEXP, '')
  text = text.downcase.split(" ") - STOPWORDS 
  docs << text

  #puts text.join(" ")
  #puts doc
end


matrix = TfIdf.new(docs)

#puts matrix.tf_idf

bag = docs.flatten.uniq.sort
#puts bag.join(" ")

puts " #{bag.size} #{docs.size}"
puts bag

matrix.tf_idf.each do |doc|
  first = true
  bag.each do |word|
    print " " unless first
    if doc.include? word
      print doc[word]
    else
      print "0.00"
    end
    first = false
  end
  print "\n"
end
