# Article class
class Article < ApplicationRecord
  include AASM

  has_many :has_categories
  has_many :categories, through: :has_categories
  has_many :comments
  belongs_to :user

  validates :title, presence: true, uniqueness: true
  validates :body, presence: true, length: { minimum: 20 }
  before_create :set_visits_count

  after_create :save_categories

  # TODO: Verificar si es styles o style!
  has_attached_file :cover
  validates_attachment_content_type :cover, content_type: %r{/\Aimage\/.*\Z/}

  # Hace esto...
  scope :publisheds, -> { where(state: 'published') }
  # Es lo mismo que hacer esto:
  # def self.publisheds
  #  self.where(state: "published")
  # end
  scope :latests, -> { order('created_at DESC') }

  attr_writer :categories

  def update_visits_count
    update(visits_count: visits_count + 1)
  end

  aasm column: 'state' do
    state :in_draft, initial: true
    state :published

    event :publish do
      transitions from: :in_draft, to: :published
    end
    event :unpublish do
      transitions from: :published, to: :in_draft
    end
  end

  private

  def save_categories
    return unless @categories.nil?
    @categories.each do |category_id|
      HasCategory.create(article_id: id, category_id: category_id)
    end
  end

  def set_visits_count
    self.visits_count = 0
  end
end
