require 'shoes'

Shoes.setup do
  gem 'stopwords'
  gem 'rwordnet'
  gem 'tf_idf'
  gem 'fast-stemmer'
  gem 'ruby-stemmer'
end

require './preprocessing'


WIDTH = 600
HEIGHT = 400
MARGIN = 50

Shoes.app width: WIDTH, height: HEIGHT do 

  def answer(v)
    @folder.text = v.inspect
  end
  def ans_out(v)
    @out_folder.text =  v.inspect
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
  @progress = 0
  @message = ""

  stack(margin: 50) do
    title "NLP Preprocessing Tool"
    #para "Enter the path of text files"
    stack margin: 10 do
      flow do
        @folder = edit_line text: ".", width: "60%"
        button "Select folder with docs", width: "40%" do
          answer ask_open_folder
        end
      end
      flow do
        check; para "txt", margin_right: 30
        check; para "data", margin_right: 30 
      end
      flow do
        @out_folder = edit_line text: ".", width: "60%"
        button "Select output folder", width: "40%" do
          ans_out ask_open_folder
        end
      end
      flow do
        check; para "remove punctuation", margin_right: 30
        check; para "stemming", margin_right: 30 
        check; para "remove stopwords", margin_right: 30 
        check; para "tf_idf", margin_right: 30 
      end
    end
    m_left = (WIDTH-2*MARGIN) / 2
    m_left -= 100
    stack margin_left: m_left, width: 100 do
      @btn_start = button "Preprocessing texts", fill: "#9B7" do
        return if @started
        path = @folder.text
        path = path[1..path.size-2] if path =~ /"/
        out_path = @out_folder.text
        out_path = out_path[1..out_path.size-2] if out_path =~ /"/
        docs_path = Dir.glob(path+"/*")
        nlp = Preprocessing.new(docs_path, out_path)

        show_progress

        Thread.new do 
          @started = true
          nlp.clean do |progress,message|
            puts "#{progress} #{message}"
            @progress = progress
            @message = message
          end
          @pf.hide
          @terminated = true
          @started = false
        end
      end
    end

    @pf = flow do
      @p = progress width: 1.0
      @log = para @message
    end
    @pf.hide
  end
  animate do |i|
    if @started
      @p.fraction = (@progress % 100) / 100.0
      @log.replace @message
    end
    show_terminated if @terminated
  end
end
