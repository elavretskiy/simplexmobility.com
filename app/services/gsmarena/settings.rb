class Gsmarena::Settings
  @root_page = 'http://www.gsmarena.com'
  @brands_page = 'http://www.gsmarena.com/makers.php3'
  @brands_css = '.st-text table'
  @pagination_css = '.nav-pages'
  @phones_css = '.makers'
  @phone_css = '.main-review'
  @table_class = 'table table-bordered table-responsive'

  @search_page = 'http://www.gsmarena.com/results.php3?sQuickSearch=yes&sName='
  @search_css = '.search-results'

  class << self
    attr_accessor :root_page, :brands_page, :brands_css, :pagination_css,
                  :phones_css, :phone_css, :table_class, :search_page,
                  :search_css

    def load(page, url = nil)
      case page
      when :brands
        { url: @brands_page, css: @brands_css }
      when :pagination
        { url: url, css: @pagination_css }
      when :phones
        { url: url, css: @phones_css }
      when :phone
        { url: url, css: @phone_css }
      when :search
        { url: "#{@search_page}#{url}", css: @search_css }
      end
    end
  end
end
