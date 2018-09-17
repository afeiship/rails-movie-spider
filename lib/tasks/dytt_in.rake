require 'nokogiri'
require 'open-uri'
require './lib/utilities/base_processor'
require './lib/utilities/dytt_in_processor'

namespace :dytt_in do

  desc "Fetch pages"
  task :fetch_pages => :environment do
    BaseProcessor.movie_pages(
        'https://www.dytt.in/1',
        'https://www.dytt.in/',
        2...60,
        ''
    ).each do |item|
      Page.create(
          key: BaseProcessor.key(item),
          url: item,
      )
    end
  end

  desc "Fetch urls"
  task :fetch_urls => :environment do
    BaseProcessor.movie_urls DyttInProcessor
  end


  desc "Fetch posts"
  task :fetch_posts => :environment do
    BaseProcessor.movie_posts DyttInProcessor
  end

end
