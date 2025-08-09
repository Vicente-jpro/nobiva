class House < ApplicationRecord
  include ActiveModel::Dirty

  include EnumsConcerns

  attr_accessor :province_code, :city_code
  
  
  belongs_to :location
  accepts_nested_attributes_for :location

  belongs_to :dimention
  accepts_nested_attributes_for :dimention

  belongs_to :address
  accepts_nested_attributes_for :address

  has_many_attached :house_images
  
  has_many :profile_houses, dependent: :destroy
  has_many :profiles, through: :profile_houses
  has_many :favorite_houses, dependent: :destroy

  validates_presence_of :address, :dimention, :price, :title, :description
 
  JOIN_CITIES_AND_PROVINCES = "JOIN cities ON cities.id = addresses.city_id JOIN provinces ON provinces.id = cities.province_id"
 



  def self.find_houses_by_user(user)
    House.joins(:address)
        .joins(JOIN_CITIES_AND_PROVINCES)   
        .joins("JOIN profile_houses ON profile_houses.house_id = houses.id") 
        .joins("JOIN profiles ON profiles.id = profile_houses.profile_id")     
        .joins(:profiles)
        .joins("JOIN users ON users.id = profiles.user_id")
        .where("users.id = #{user.id}")
        .order(id: :desc)
  end

  def self.find_by_profile(profile)
     House.joins(:profile_houses)
          .where("profile_houses.profile_id = #{profile.id}")
  end
  

  def self.find_all
    House.includes(:address, :dimention, :location)
  end

  def self.find_all_pending
    House.includes(:address, :dimention, :location).where(pending: true)
  end

  def self.find_house_by_user(user, house)
    House.joins(:address)
         .joins(:profiles)
         .joins(JOIN_CITIES_AND_PROVINCES)  
         .where("profiles.user_id = #{user.id} and houses.id = #{house.id}")
         .order(id: :desc)
  end

  def self.find_by_id(id_house)
    House.joins(:address)
    .joins(JOIN_CITIES_AND_PROVINCES)  
    .joins(:profiles)
    .where("houses.id = #{id_house} ")
    .take
  end

  
  scope :rent, -> { where("type_negotiation <> 23") }

  scope :buy, -> { where("type_negotiation = 23") }


  def self.search_by(house_params)
    House.joins(:address)
         .joins(:dimention)
         .joins(:location)
         .joins(JOIN_CITIES_AND_PROVINCES)     
         .where(room: house_params[:room])
         .or(House.where('LOWER(title) LIKE ?', "%#{house_params[:title].downcase if house_params[:title].present? }%"))
         .or(House.where("living_room = #{house_params[:living_room] if house_params[:living_room].present? }") )
         .or(House.where("kitchen = #{house_params[:kitchen] if house_params[:kitchen].present?}"  ))
         .or(House.where("condition = #{house_params[:condition] if house_params[:condition].present?}"))
         .and(House.where("type_negotiation = #{house_params[:type_negotiation] if house_params[:type_negotiation].present?}" ))
         .or(House.where("price > 10 and price <= #{house_params[:price] if house_params[:price].present?}"))
         .or(House.where("tipology = #{house_params[:tipology] if house_params[:tipology].present?}" ))
         .and(House.where("property_type = #{house_params[:property_type] if house_params[:property_type].present?}" ))
         .and(House.where("provinces.id = #{house_params[:province_code] if house_params[:province_code].present?}" ))
         .and(House.where("cities.id = #{house_params[:city_code] if house_params[:city_code].present? }"))
         .or(House.where(location_id: house_params[:location]))
         .order(:title)
  end


  def self.search_advanced_by(house_params)
    House.joins(:address)
         .joins(:dimention)
         .joins(:location)
         .joins(JOIN_CITIES_AND_PROVINCES)     
         .where(room: house_params[:room])
         .or(House.where('LOWER(title) LIKE ?', "%#{house_params[:title].downcase if house_params[:title].present? }%"))
         .or(House.where(living_room: house_params[:living_room]) )
         .or(House.where(yard: house_params[:yard]))
         .or(House.where(kitchen: house_params[:kitchen]))
         .or(House.where(balcony: house_params[:balcony]))
         .and(House.where(condition: house_params[:condition]))
         .and(House.where(type_negotiation: house_params[:type_negotiation]))
         .and(House.where("price > 10 and price <= #{house_params[:price] if house_params[:price].present?}"))
         .or(House.where(garage: house_params[:garage]))
         .or(House.where(pool: house_params[:pool]))
         .and(House.where(tipology: house_params[:tipology]))
         .or(House.where(next_by: house_params[:next_by]))
         .and(House.where(furnished: house_params[:furnished]))
         .and(House.where(property_type: house_params[:property_type]))
         .and(House.where("provinces.id = #{house_params[:province_code] if house_params[:province_code].present?}" ))
         .and(House.where("cities.id = #{house_params[:city_code] if house_params[:city_code].present? }"))
         .or(House.where(dimention_id: house_params[:dimention_id]))
         .or(House.where(location_id: house_params[:location]))
         .order(:title)
  end

end