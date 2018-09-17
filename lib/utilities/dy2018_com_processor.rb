require './lib/utilities/base_processor'


class Dy2018ComProcessor < BaseProcessor

  # 1. 综合电影: https://www.dy2018.com/html/gndy/jddy/
  def self.gndy_movie_pages
    movie_pages(
        'https://www.dy2018.com/html/gndy/jddy/index.html',
        'https://www.dy2018.com/html/gndy/jddy/index_',
        2..246
    )
  end

  # 2. 经典电影: https://www.dy2018.com/html/gndy/jddyy/
  def self.gndyy_movie_pages
    movie_pages(
        'https://www.dy2018.com/html/gndy/jddyy/index.html',
        'https://www.dy2018.com/html/gndy/jddyy/index_',
        2..37
    )
  end


  # 3. 最新电影: https://www.dy2018.com/html/gndy/dyzz/
  def self.latest_movie_pages
    movie_pages(
        'https://www.dy2018.com/html/gndy/dyzz/index.html',
        'https://www.dy2018.com/html/gndy/dyzz/index_',
        2..300
    )
  end

  def self.get_page_urls doc
    doc.css('.co_content8 .ulink').map do |item|
      "https://www.dy2018.com/#{item.attribute('href')}"
    end
  end


  def initialize(doc)
    @doc = doc
    init_elements
  end

  def init_elements
    @title = @doc.css('.title_all h1').text
    @rate = @doc.css('.co_content8 .rank').text
    @release_date = @doc.css('.co_content8 .updatetime').text
    @cover = @doc.css('#Zoom p')[0].css('img').attribute('src')
    @content = @doc.css('#Zoom').text
    @attachments = @doc.css('td[style="WORD-WRAP: break-word"] a')
    @category = @doc.css('.co_content8 .position a')[0].text
  end

  def get_title
    result = @title.match(/(《(.*)》)/)
    result ? result[2] : @title
  end

  def get_rate
    @rate
  end

  def get_release_date
    @release_date.match(/发布时间：(.*)/)[1]
  end

  def get_cover
    @cover
  end

  def get_content
    if @content.include? '◎简　　介'
      @content = @content.split('◎简　　介')[1]
    end

    if @content.include? '◎影片截图'
      @content = @content.split('◎影片截图')[0]
    end

    # Process content:
    @content.gsub!(' ', '')
    @content.gsub!('　', '')
    @content.gsub!('　　', '')
    @content.gsub!(/[　 ]/, '')
    @content.gsub!('<br><br> <br> <br>', '')
    @content.gsub!('<br><br>', '')
    @content.gsub!(/(\s*?)<br>(\s.*?)/, '')
    @content.gsub!(/^<br>/, '')

    # Add p tag:
    @content_list = @content.split "\r\n"
    @content_list.map! do |item|
      unless item.empty?
        "<p>#{item}</p>"
      end
    end
    @content_list.join ''
  end


  def get_category_id
    cate_index = Dy2018ComProcessor.categories.index @category.strip
    if cate_index.nil?
      cate_index = 1
    end
    cate_index + 1
  end

  # class methods:
  def self.categories
    '其他
    喜剧片
    爱情片
    恐怖片
    科幻片
    战争片
    剧情片
    悬疑片
    动作片
    动画片
    犯罪片
    纪录片'.split
  end


  def get_attachments
    result = []
    @attachments.each do |att|
      result.push att.attribute('href')
    end
    result.join('\n')
  end


end