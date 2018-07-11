kr-comment-translater
==

This script detects Korean comments in java/kotlin file, and adds comments of Japanese translation and English translation.

* Korean to English
  * Uses Google Translate API (for public)
    * BE CAREFUL: In this mode, comments in the source code are sent to Google.
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
bundle exec ruby ./app.rb YOUR_GOOGLE_TOKEN]KoreanCommentClass.java
```

### How to process some files.

You can use `find` command.

```sh
find ../korean_java_project/ -name *.java -exec bundle exec ruby ./app.rb {} \;
```

