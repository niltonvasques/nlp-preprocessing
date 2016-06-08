require 'shoes'

Shoes.setup do
  gem 'stopwords'
  gem 'rwordnet'
  gem 'tf_idf'
  gem 'fast-stemmer'
  gem 'ruby-stemmer'
end

require './preprocessing'


Shoes.app do 

  title "NLP Preprocessing Tool"

  def answer(v)
    @folder.replace v.inspect
  end

  def show_progress
    @pf.show
  end

  def show_terminated
    @terminated = false
    alert("The process has terminated!")
  end

  @started = false
  @terminated = false
  stack(margin: 12) do
    #para "Enter the path of text files"
    @folder = para "."
    flow do
      button "Select folder with docs" do
        answer ask_open_folder
        #alert(edit.text)
        #nlp = Preprocessing.new(ARGV[0])
        #nlp.clean
      end
    end
    button "Preprocessing texts" do
      path = @folder.text
      path = path[1..path.size-2]
      nlp = Preprocessing.new(path)

      show_progress

      Thread.new do 
        @started = true
        nlp.clean 
        @pf.hide
        @terminated = true
        @started = false
      end
    end
    @pf = flow do
      @p = progress width: 1.0
    end
    @pf.hide
  end
  animate do |i|
    @p.fraction = (i % 100) / 100.0 if @started
    show_terminated if @terminated
  end
end
