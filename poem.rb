# By Bill Winnett
# Bwinnett12@gmail.com
# A short little script to gather the poem of the day from the poetry foundation
# I use this when I start up my machine as part of my welcome

require 'open-uri'
require 'net/http'
require 'json'
require 'httparty'
require 'nokogiri'

# Shortened acronym pfw for poetry foundation website
# Fetches the poem of the day (URL link)
html_pfw = open("https://www.poetryfoundation.org/poems/poem-of-the-day")
response_pfw = Nokogiri::HTML(html_pfw)
url_potd = response_pfw.css("div#mainContent.o-site-bd div.o-wrapper div.c-tier.c-mix-tier_offsetAsymmetricalShort
article.o-article div.o-article-bd div.o-grid div.o-grid-col.o-grid-col_9of12 div.o-vr.o-vr_6x div.o-grid
div.o-grid-col.o-grid-col_12of12 div.c-feature a.c-txt.c-txt_minimalCta")

# URL is mashed into sever other titles
url_potd = url_potd.to_s.split('"')[1]

# Fetches the Html of the real link
html = open(url_potd)
response = Nokogiri::HTML(html)

# The raw_poem is placed at a very special place within the html
raw_poem = response.css("div.o-site div#mainContent.o-site-bd div.o-wrapper
div.c-tier.c-mix-tier_offsetAsymmetricalShort article.o-article div.o-article-bd
div.o-vr.o-vr_9x div.o-grid div.o-grid-col.o-grid-col_9of12.o-mix-grid-col_offset1of12
div.o-vr.o-vr_12x div.c-feature div.c-feature-bd div.o-poem")

# The title based of css
title = response.css("body div.o-site div#mainContent.o-site-bd div.o-wrapper
div.c-tier.c-mix-tier_offsetAsymmetricalShort article.o-article div.o-article-bd div.o-vr.o-vr_9x div.o-grid
div.o-grid-col.o-grid-col_9of12.o-mix-grid-col_offset1of12 div.o-vr.o-vr_12x
div.c-feature div.c-feature-hd h1.c-hdgSans.c-hdgSans_2.c-mix-hdgSans_inline").text.strip

# The author based on css
author = response.css("div.o-site div#mainContent.o-site-bd div.o-wrapper div.c-tier.c-mix-tier_offsetAsymmetricalShort article.o-article div.o-article-bd div.o-vr.o-vr_9x div.o-grid div.o-grid-col.o-grid-col_9of12.o-mix-grid-col_offset1of12 div.o-vr.o-vr_12x div.c-feature div.c-feature-sub.c-feature-sub_vast div span.c-txt.c-txt_attribution a")
author = author.text

t = Time.now

# Information for what we are about to read
puts "Poem of the day for " <<  t.strftime("%A %B %d, %Y").to_s
puts title
puts "By " << author
puts "\n"

# The completed poem to be added onto
poem = ""

# Iterates through each line and cleans up the html
raw_poem.to_s.split(/\n/).each { |line|
  # Some lines are poetically designed to be spaces, a boolean for those occasions
  space = false

  # This was found during line breaks... Indicates that this is a line
  if line.include? "div style"
    space = true
  end

  # Cleans line by removing anything between brackets
  line = line.gsub(/<.*?>/, '')
  poem << line

  # If the line was empty and it wasn't supposed to be, skip it. else, print a line
  if line.to_s.strip.empty?
    if space
      poem << "\n"
    else
      next
    end
  end

  puts line
}
