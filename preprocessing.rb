require 'tf_idf'
require 'fast_stemmer'

SANITIZE_REGEXP = /('|\"|‘|’|\/|\\|~|#|%|=|@|_)/
PUNTUCTUATION_REGEXP = /(\.|,|:|;|\?|!|\(|\)|[0-9]|\$|&|\[|\]|<|>|\|)/

PATH=ARGV[0]
STOPWORDS = File.read("stopwords.txt").encode("UTF-8", invalid: :replace,
                                              undef: :replace, replace:
                                              '').downcase.gsub!(SANITIZE_REGEXP,
                                                                 '').split(" ")
class Preprocessing 

  def initialize(path)
    @docs_path = Dir.glob(path+"/*")
    puts "Preprocessing initialize #{path} #{@docs_path.size}"
  end

  def clean
    puts "clean called #{@docs_path.size}"
    docs = []

    @docs_path.each do |doc|
      text = File.read(doc).encode("UTF-8", invalid: :replace, undef: :replace, replace: '') 
      text = text.downcase.gsub(SANITIZE_REGEXP, '')
      text = text.gsub(PUNTUCTUATION_REGEXP, '')
      text = text.split(" ") - STOPWORDS 
      text = text.map{ |w| w.stem }
      docs << text

      #puts text.join(" ")
      #puts doc
    end

    matrix = TfIdf.new(docs)

    #puts matrix.tf_idf

    bag = docs.flatten.uniq.sort
    #puts bag.join(" ")

    File.open("dataset.out", "w") do |f|
      f.write "#{bag.size} #{docs.size}\n"
      f.write bag.join("\n")

      matrix.tf_idf.each do |doc|
        first = true
        bag.each do |word|
          f.write " " unless first
          if doc.include? word
            f.write doc[word]
          else
            f.write "0.00"
          end
          first = false
        end
        f.write "\n"
      end
    end
  end
end

