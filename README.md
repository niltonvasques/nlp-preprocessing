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


#### Setup

    bundle install

#### Run

    ruby preprocessing.rb $DATASET_PATH > dataset.tfidf


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
