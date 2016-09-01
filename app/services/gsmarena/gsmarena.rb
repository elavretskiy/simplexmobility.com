class Gsmarena::Gsmarena
  def initialize(page, *urls)
    @page = page
    @urls = urls.flatten
  end

  def parse
    send("parse_#{@page}")
  ensure
    @loader.try(:reset_session)
  end

  private

  def parse_page
    @urls.present? ? parse_urls : parse_url
  end

  def parse_urls
    @urls.map { |url| parse_url(url) }.flatten
  end

  def parse_url(url = nil)
    html = Gsmarena::Loader.new(@page, url).load
    Gsmarena::Parser.new(html, @page).parse
  end

  def parse_brands
    brands = parse_page
    Brand.create_for(brands)
  end

  def parse_pagination
    urls = parse_page
    @urls + urls
  end

  def method_missing(method_sym)
    parse_page
  end
end
