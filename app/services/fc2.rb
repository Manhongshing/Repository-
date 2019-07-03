class Fc2
  require 'open-uri'

  attr_reader :title
  attr_reader :duration
  attr_reader :available

  def initialize(url)
    page = Nokogiri::HTML(open(url))
    if page.css('meta[@itemprop="name"]').empty?
      @available = false
    else
      @title = page.css('meta[@itemprop="name"]').attr('content').value
      @duration = page.css('meta[@property="video:duration"]')
                  .attr('content').value
      @available = @title.include?('Removed') ? false : true
    end
  rescue OpenURI::HTTPError
    @available = false
  rescue
    # 上のパスを書き直したら false を返すようにする
    @available = true
  end

  def available?
    @available
  end

  class << self
    module Constants
      # FC2からのスクレイピングのパス
      ADULT_SEARCH_URL = 'http://video.fc2.com/a/search/video/?keyword=&page='
      NORMAL_SEARCH_URL = 'http://video.fc2.com/search/video/?keyword=&page='
      VIDEO_PATH = '//li[@class="c-boxList-111_video"]'
      TITLE_PATH = './div/a[@class="c-boxList-111_video_ttl popd"]'
      DURATION_PATH = './div/a/span[@class="c-videoLength-101"]'
      URL_PATH = './div/a[@class="popd"]'
      IMAGE_URL_PATH = './div/a/div/div[@class="c-image-101_image"]'
      VIEWS_PATH = './div/div/div/span[@class="nmb"]'
      FAVS_PATH = './div/div/div[@class="item album"]/span[@class="nmb"]'
      AUTHORITY_PATH = './div/div/div/div/div[@class="c-label-200"]/span'
    end
    include Constants

    def scrape(kind, from, to)
      adult_flg = (kind == 'adult')
      url = adult_flg ? ADULT_SEARCH_URL : NORMAL_SEARCH_URL
      from.upto(to) do |i|
        begin
          create_50_records(Nokogiri::HTML(open(url + i.to_s)), adult_flg)
        rescue
          next
        end
      end
    end

    def create_50_records(page, adult_flg)
      50.times do |j|
        next unless video_exists_on_fc2?(page.xpath(VIDEO_PATH)[j], adult_flg)
        params = scrape_params(page.xpath(VIDEO_PATH)[j], adult_flg)

        video = Video.find_by_title(params[:title])
        if video.present?
          video.update(params)
        else
          Video.create(params)
        end
      end
    end

    def scrape_params(elm, adult_flg)
      params = {}
      params[:title] = elm.xpath(TITLE_PATH).first.content
      params[:duration] = elm.xpath(DURATION_PATH).first.content
      params[:url] = elm.xpath(URL_PATH).first['href'] + '/'
      params[:image_url] = elm.xpath(IMAGE_URL_PATH).first[:style].match(/\((.+)\);/)[1]
      params[:views] = elm.xpath(VIEWS_PATH)[0].content.delete(',').to_i
      params[:bookmarks] = elm.xpath(FAVS_PATH)[0].content.to_i
      params[:morethan100min] = (params[:duration].length == 6)
      params[:adult] = adult_flg
      params
    end

    def video_exists_on_fc2?(elm, adult_flg)
      min_favs = adult_flg ? 30 : 2
      (elm.xpath(FAVS_PATH)[0] &&
        elm.xpath(FAVS_PATH)[0].content.to_i >= min_favs &&
          elm.xpath(AUTHORITY_PATH)[0].content == '全員')
    end
  end
end
