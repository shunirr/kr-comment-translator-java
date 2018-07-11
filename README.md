kr-comment-translater
==

This script detects Korean comments in Java (and Java like syntax language) file, and translates to English.

* Uses Google Translate API
  * Required a API token.
  * Required billing for Google.
  * More info: https://cloud.google.com/translate/?hl=ja

## How to install

Required ruby 2.x and bundler.

```sh
bundle install
```

## How to use

```sh
bundle exec ruby ./app.rb YOUR_GOOGLE_TOKEN KoreanCommentClass.java
```

### How to process some files.

You can use `find` command.

```sh
find ../korean_java_project/ -name *.java -exec bundle exec ruby ./app.rb {} \;
```

