require 'open-uri'

class LyricsParser
  include Singleton

  def initialize()
  end

  # Returns a hash to be rendered as JSON
  def get_lyrics(url)
    doc = Nokogiri::HTML(open(url))
    lyrics = doc.css('.lyrics').children[3].children.text.split("\n")
    puts lyrics
    formatted_lyrics = format_lyrics_for_HTML(lyrics)
    {:lyrics => formatted_lyrics}
  end

  private

  def format_lyrics_for_HTML(lyrics)
    lyrics.map do |line|
      if line == ""
        "<br>"
      else
        line
      end
    end
  end

end
