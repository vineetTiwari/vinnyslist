class Listing < ActiveRecord::Base

  belongs_to :category
  belongs_to :subcategory 
  belongs_to :user
  validates :user_id, presence: true

  geocoded_by :full_address
  after_validation :geocode

  def full_address
    [city, state, zipcode].join(', ')
  end

  def self.search(params)
    listings = Listing.where(category_id: params[:category].to_i)
    if params[:search].present?
      listings = listings.where("title ilike ? or description ilike ?", "%#{params[:search]}%", "%#{params[:search]}%")
    end
    if params[:location].present?
      listings = listings.near(params[:location], 1)
    end
    listings
  end 

end