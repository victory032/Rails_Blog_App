class Comment < ApplicationRecord
  belongs_to :author_id
  belongs_to :post_id
end
