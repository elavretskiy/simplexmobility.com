require 'capybara/poltergeist'
require 'capybara'
require 'capybara/dsl'
require 'nokogiri'
require 'open-uri'

class Gsmarena::Loader
  include Capybara::DSL

  def initialize(page)
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, debug: false)
    end

    Capybara.javascript_driver = :poltergeist
    Capybara.current_driver = :poltergeist

    @settings = Gsmarena::Settings
    @page = page
  end

  def reset_session
    @session.try(:reset!)
  end

  def load(page = nil, url = nil)
    load_html_for(page || @page, url)
  end

  private

  def load_html_for(page, url = nil)
    params = @settings.load(page, url)
    page = Nokogiri::HTML(open(params[:url]))
    page.css(params[:css])
  end

  def load_ajax_for(page, url = nil)
    params = @settings.load(page, url)
    page = scrape do |page|
      visit params[:url]
      wait_for_ajax
      Nokogiri::HTML.parse(page.html)
    end
    page.css(params[:css])
  end

  def scrape
    yield page
  end

  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end
end
