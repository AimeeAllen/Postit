class CreatePostCategories < ActiveRecord::Migration
  create_table :post_categories do |t|
    t.integer :post_id, :category_id, index: true
    t.timestamps
  end
end
