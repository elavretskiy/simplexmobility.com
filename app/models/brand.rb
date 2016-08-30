# == Schema Information
#
# Table name: brands
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  url        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Brand < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :url, presence: true

  scope :index, -> { order(:name) }

  def self.create_for(brands)
    names = Brand.pluck(:name)
    brands.each { |brand| Brand.create(brand) if !names.include?(brand[:name]) }
  end
end
