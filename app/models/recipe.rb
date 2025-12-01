# == Schema Information
#
# Table name: recipes
#
#  id           :bigint           not null, primary key
#  description  :string
#  ingredients  :string
#  instructions :string
#  servings     :integer
#  source_url   :string
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  creator_id   :integer
#
class Recipe < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :ingredients, presence: true
  validates :instructions, presence: true
  validates :servings, presence: true
  validates :creator_id, presence: true

  belongs_to :creator, required: true, class_name: "User", foreign_key: "creator_id"
end
