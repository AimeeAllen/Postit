class AddSlugToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :slug, :string
    Post.all.each {|post| post.save}
  end
end
