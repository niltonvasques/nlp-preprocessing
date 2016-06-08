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

  def initialize(docs_path, out_path)
    @out_path = out_path
    @docs_path = docs_path
    puts "Preprocessing initialize #{path} #{@docs_path.size}"
  end

  def clean
    puts "clean called #{@docs_path.size}"
    docs = []

    progress = 0
    yield progress, "#{@docs_path.size} texts found"
    step = 100.0/@docs_path.size

    @docs_path.each do |doc|
      yield progress, "preprocessing #{doc}"
      text = File.read(doc).encode("UTF-8", invalid: :replace, undef: :replace, replace: '') 
      text = text.downcase.gsub(SANITIZE_REGEXP, '')
      text = text.gsub(PUNTUCTUATION_REGEXP, '')
      text = text.split(" ") - STOPWORDS 
      text = text.map{ |w| w.stem }
      docs << text

      #puts text.join(" ")
      #puts doc
      progress += step
    end
    progress += step
    yield progress, "preprocessing finished"

    matrix = TfIdf.new(docs)

    #puts matrix.tf_idf

    bag = docs.flatten.uniq.sort
    #puts bag.join(" ")

    puts "Output file created in #{@out_path}/dataset.out"

    progress = 0
    yield progress, "generating tf idf"
    tf_idf = matrix.tf_idf
    progress += 95

    yield progress, "saving results in #{@out_path}/dataset.out"
    File.open("#{@out_path}/dataset.out", "w") do |f|
      f.write "#{bag.size} #{docs.size}\n"
      f.write bag.join("\n")

      tf_idf.each do |doc|
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
    progress = 100
    yield progress, "finished!!"
  end
end
