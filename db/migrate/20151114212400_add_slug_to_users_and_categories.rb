class AddSlugToUsersAndCategories < ActiveRecord::Migration
  def change
    add_column :users, :slug, :string
    add_column :categories, :slug, :string

    User.all.each {|user| user.save}
    Category.all.each {|category| category.save}
  end
end
