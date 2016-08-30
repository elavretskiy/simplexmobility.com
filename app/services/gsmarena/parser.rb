require 'nokogiri'
require 'open-uri'

class Gsmarena::Parser
  def initialize(html, page)
    @html = html
    @page = page
    @settings = Gsmarena::Settings
  end

  def parse
    @html.blank? ? [] : send("parse_#{@page}")
  end

  private

  def parse_brands
    @html.css('td').map do |item|
      count = item.css('a span')[0].text
      {
        name: item.css('a')[0].text.sub(count, ''),
        url: "#{@settings.root_page}/#{item.css('a')[0]['href']}"
      }
    end
  end

  def parse_pagination
    @html.css('a').map { |item| "#{@settings.root_page}/#{item['href']}" }
  end

  def parse_phones
    @html.css('li').map do |item|
      {
        name: item.css('a')[0].text,
        url: "#{@settings.root_page}/#{item.css('a')[0]['href']}"
      }
    end
  end

  def parse_phone
    @html.search('.article-info-line', '#user-comments', '.sub-footer', '.note',
                 '.specs-spotlight-features').remove
    html_to_system_style
    @html.search('table').each { |t| t['class'] = @settings.table_class }
    encode_text(@html.to_html)
  end

  def parse_search
    @html.search('.review-header', '.st-text .note').remove
    html_to_system_style
    @html.to_html
  end

  def html_to_system_style
    @html.xpath('//script').remove
    @html.xpath('//style').remove
    @html.search('a').each { |t| t['href'] = "#{@settings.root_page}/#{t['href']}" }
    @html.search('a').each { |t| t['target'] = '_blank' }
  end

  def encode_text(text)
    begin
      cleaned = text.dup.force_encoding('utf-8')
      unless cleaned.valid_encoding?
        cleaned = text.encode('utf-8', 'Windows-1251')
      end
      cleaned
    rescue EncodingError
      text.encode!('utf-8', invalid: :replace, undef: :replace)
    end
  end
end
