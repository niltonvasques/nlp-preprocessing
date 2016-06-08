require 'tf_idf'
#require 'fast_stemmer'
#require 'lingua/stemmer'
require 'stemmer'

SANITIZE_REGEXP = /(\+|\^|{|}|`|'|\"|‘|’|\/|\\|~|#|%|=|@|_|\(|\)|[0-9]|\$|&|\[|\]|<|>|\||\*)/
PUNTUCTUATION_REGEXP = /(\.|,|:|;|\?|!)/

PATH=ARGV[0]
STOPWORDS = File.read("stopwords.txt").encode("UTF-8", invalid: :replace,
                                              undef: :replace, replace:
                                              '').downcase.gsub!(SANITIZE_REGEXP,
                                                                 '').split(" ")
class Preprocessing 

  def initialize(docs_path, out_path, options = {} )
    @default = {stemming: true, punctuation: true, stopwords: true, sanitize: true}
    @default.merge!(options)
    @out_path = out_path
    @docs_path = docs_path
    puts "Preprocessing initialize #{@docs_path.size}"
  end

  def clean(&code_block)
    puts "clean called #{@docs_path.size}"
    preprocessing{ |p,m| yield p, m }
    export{ |p,m| yield p, m }
  end

  def preprocessing
    @docs = []

    progress = 0
    yield progress, "#{@docs_path.size} texts found"
    step = 100.0/@docs_path.size

    @docs_path.each do |doc|
      yield progress, "preprocessing #{doc}"
      text = File.read(doc).encode("UTF-8", invalid: :replace, undef: :replace, replace: '') 
      text = text.downcase
      text = text.gsub(SANITIZE_REGEXP, '') if @default[:sanitize]
      text = text.gsub(PUNTUCTUATION_REGEXP, '') if @default[:punctuation]
      text = text.split(" ")
      text = text - STOPWORDS  if @default[:stopwords]
      text = text.map{ |w| Stemmer.stem_word(w) } if @default[:stemming]
      #text = text.map{ |w| Lingua.stemmer(w) } if @default[:stemming]
      @docs << text

      #puts text.join(" ")
      #puts doc
      progress += step
    end
  end

  def export(&code_block) 

    matrix = TfIdf.new(@docs)

    #puts matrix.tf_idf

    bag = @docs.flatten.uniq.sort
    #puts bag.join(" ")

    puts "Output file created in #{@out_path}/dataset.tf_idf"

    progress = 0
    code_block.call progress, "generating tf idf"
    tf_idf = matrix.tf_idf
    progress += 95

    code_block.call progress, "saving results in #{@out_path}/dataset.tf_idf"
    File.open("#{@out_path}/dataset.tf_idf", "w") do |f|
      f.write "#{bag.size} #{@docs.size}\n"
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
    code_block.call progress, "finished!!"
  end
end

#p = Preprocessing.new(Dir.glob("../datasets/changelogs/*"),".")
#p.clean do |p,m|
#  puts "#{p} #{m}"
#end
