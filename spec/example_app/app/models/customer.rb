class Customer < ActiveRecord::Base
  has_many :orders

  validates :name, presence: true
  validates :email, presence: true

  KINDS = [
    :standard,
    :vip,
  ].freeze

  scope :subscribed, -> { where(email_subscriber: true) }
  scope :old, -> { where("created_at < ?", 3.years.ago) }

  def lifetime_value
    orders.map(&:total_price).reduce(0, :+)
  end
end
