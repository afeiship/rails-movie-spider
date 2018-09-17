require 'nokogiri'
require 'open-uri'
require './lib/utilities/dytt_in_processor'
require './lib/utilities/dy2018_com_processor'


namespace :dy2018 do

  desc 'fetch pages'
  task :fetch_pages => :environment do

    Dy2018ComProcessor.latest_movie_pages.each do |item1|
      puts "grabbing at url: #{item1}"
      Spider::Page.create(
          key: Dy2018ComProcessor.key(item1),
          url: item1,
      )
    end

    Dy2018ComProcessor.gndy_movie_pages.each do |item2|
      puts "grabbing at url: #{item2}"
      Spider::Page.create(
          key: Dy2018ComProcessor.key(item2),
          url: item2,
      )
    end

    Dy2018ComProcessor.gndyy_movie_pages.each do |item3|
      puts "grabbing at url: #{item3}"
      Spider::Page.create(
          key: Dy2018ComProcessor.key(item3),
          url: item3,
      )
    end
  end


  desc 'fetch urls'
  task :fetch_urls => :environment do
    BaseProcessor.movie_urls Dy2018ComProcessor
  end

  desc "Fetch posts"
  task :fetch_posts => :environment do
    BaseProcessor.movie_posts Dy2018ComProcessor
  end


end
