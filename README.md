## NLP Preprocessing Tool

A tool for preprocessing text data with canonical text mining techniques.

![Preprocessing Tool](https://github.com/niltonvasques/nlp-preprocessing/blob/master/assets/app.png)

#### Tasks

* Sanitize texts
* Remove punctuaction
* Remove stopwords
* Stemming
* Format data into TF-IDF
* Output result in contest problems format


#### Usage 

    bundle install

```ruby
  require './preprocessing'
  docs_path = Dir.glob("/tmp/dataset/*.txt")  

  nlp = Preprocessing.new(docs_path, "/tmp", stemming: false)

  nlp.clean do |progress, message|
    puts "#{progress}% - #{message}"
  end
```

#### GUI Mode

##### From binaries for Linux 

[preprocessing-x86-64.run](https://github.com/niltonvasques/nlp-preprocessing/releases/download/v0.1.0/nlp-preprocessing-x86_64.run)

##### From binaries for Windows 
[preprocessing.exe](https://github.com/niltonvasques/nlp-preprocessing/releases/download/v0.1.0/preprocessing.exe)

##### From source

Download and install [Shoes](http://shoesrb.com/downloads/) and run

    shoes gui.rb


#### Output format

*N* is the number of terms 
*M* is the number of documents


    N M
    term1
    term2
    ...
    termN
    value11 value12 ... value1N
    value21 value22 ... value2N
    ...
    valueM1 valueM2 ... valueMN
