class Category < ApplicationRecord
  has_many :posts, dependent: :nullify
end
