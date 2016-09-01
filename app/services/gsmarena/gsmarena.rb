class Gsmarena::Gsmarena
  def initialize(page, urls = nil)
    @page = page
    @urls = urls
    @loader = Gsmarena::Loader.new(@page)
  end

  def parse
    send("parse_#{@page}")
  ensure
    @loader.try(:reset_session)
  end

  private

  def parse_brands
    html = @loader.load
    brands = Gsmarena::Parser.new(html, @page).parse
    Brand.create_for(brands)
  end

  def parse_pagination
    html = @loader.load(@urls)
    [@urls] + Gsmarena::Parser.new(html, @page).parse
  end

  def parse_phones
    @urls.map do |url|
      html = @loader.load(url)
      Gsmarena::Parser.new(html, @page).parse
    end.flatten
  end

  def parse_phone
    html = @loader.load(@urls)
    Gsmarena::Parser.new(html, @page).parse
  end

  def parse_search
    html = @loader.load(@urls)
    Gsmarena::Parser.new(html, @page).parse
  end
end
