class Restaurant < ActiveRecord::Base
  has_many :reviews,
           -> { extending WithUserAssociationExtension },
           dependent: :restrict_with_exception, dependent: :destroy
  validates :name, length: { minimum: 3 }, uniqueness: true
  belongs_to :user

  # def build_review(attributes = {}, user)
  #   review = reviews.build(attributes)
  #   review.user = user
  #   review
  # end

  def average_rating
    return 'N/A' if reviews.none?
    # reviews.average(:rating)
    thing = reviews.inject(0) { |memo, review| memo + review.rating.to_f } / reviews.length
  end
end
