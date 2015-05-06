require 'spec_helper'

describe Restaurant, type: :model do
  it { is_expected.to have_many :reviews }

  xit 'should also remove associated review when deleted' do
    restaurant = Restaurant.new
    example_review = Review.new
    restaurant.reviews << example_review
    restaurant.destroy
    expect(example_review.destroyed?).to eq true
  end

  it { should have_many(:reviews).dependent(:destroy) }

  it 'is not valid with a name of less than three characters' do
    restaurant = Restaurant.new(name: "kf")
    expect(restaurant).to have(1).error_on(:name)
    expect(restaurant).not_to be_valid
  end
end