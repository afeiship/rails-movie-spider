require 'nokogiri'
require 'open-uri'
require './lib/utilities/base_processor'
require './lib/utilities/dytt_in_processor'

namespace :spider do

  desc "reset pages"
  task :reset_pages => :environment do
    BaseProcessor.reset Page
  end


  desc "reset urls"
  task :reset_urls => :environment do
    BaseProcessor.reset Url
  end

end
