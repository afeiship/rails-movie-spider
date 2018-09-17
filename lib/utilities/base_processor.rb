class BaseProcessor

  # get url key for db:
  def self.key url
    paths = url.split '/'
    paths.last
  end

  def self.reset model
    model.all.each do |item|
      item.grabbed = false
      item.save
    end
  end

  def self.movie_pages index, url_prefix, range, suffix = '.html'
    pages = [index]
    range.each do |item|
      pages.push "#{url_prefix}#{item}#{suffix}"
    end
    pages
  end

  def self.movie_urls processor_class
    Page.all.each do |page|
      unless page.grabbed
        doc = Nokogiri::HTML(open(page.url, :read_timeout => 5))
        urls = processor_class.get_page_urls doc

        urls.each do |url|
          Url.create(
              url: url.to_s,
              key: BaseProcessor.key(url.to_s),
          )
        end
        page.grabbed = true
        page.save
      end
    end
  end

  def self.movie_posts processor_class
    threads = Url.all.each_slice(25).map do |urls|
      Thread.new do
        urls.each do |sp_url|
          url = sp_url.url
          unless sp_url.grabbed
            begin
              doc = Nokogiri::HTML(open(url, read_timeout: 5))
              processor = processor_class.new doc
            rescue
              puts "skip url:-> #{url}"
              next
            end

            puts "start_at:#{url}"

            Post.create(
                key: sp_url.key,
                title: processor.get_title,
                release_date: processor.get_release_date,
                cover: processor.get_cover,
                rate: processor.get_rate,
                content: processor.get_content,
                attachments: processor.get_attachments,
                category_id: processor.get_category_id
            )
          end

          sp_url.grabbed = true
          sp_url.save
        end
      end
    end

    puts "threads.size---->:#{threads.size}"
    threads.each(&:join)
  end


end