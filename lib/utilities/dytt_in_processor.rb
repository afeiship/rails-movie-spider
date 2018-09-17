require './lib/utilities/base_processor'

class DyttInProcessor < BaseProcessor
  def initialize(doc)
    @doc = doc
    init_elements
  end

  def init_elements
    @title = @doc.css('.main .body .title').text
    @meta = @doc.css('.main .body .meta').text
    @content = @doc.css('.main .body .c-body').inner_html
    @cover_script = @doc.css('script')[3].text
    @attachments = @doc.css('.download a.btn-downLoad')
    @category = @doc.css('.breadcrumb a').text
  end


  def get_release_date
    @meta.match(/更新时间：(.*)\s+/)[1]
  end

  def get_rate
    result = @meta.match(/豆瓣评分：(.*)/)
    result[1] if result
  end

  def get_title
    result = @title.match(/(《(.*)》)/)
    result ? result[2] : @title
  end


  def get_content
    if @content.include? '◎简　　介'
      @content = @content.split('◎简　　介')[1]
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
    @content_list = @content.split '<br>'
    @content_list.map! do |item|
      "<p>#{item}</p>"
    end
    @content_list.join ''
  end

  def get_cover
    result = @cover_script.match(/src = '(.*?)';/)
    result[1] if result
  end

  def get_attachments
    result = []
    @attachments.each do |att|
      result.push att.attribute('href')
    end
    result.join('\n')
  end

  def get_category_id
    cate_index = DyttInProcessor.categories.index @category.strip
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

  # get page urls:
  def self.get_page_urls(doc)
    doc.css('.list-body .row h1 a').map do |item|
      item.attribute('href')
    end
  end

end