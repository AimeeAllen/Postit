# Models this is included in require a :slug column
# and to specify a value for sluggable_column :value
module Sluggable
  
  extend ActiveSupport::Concern

  included do
    before_save :generate_slug
    class_attribute :slug_based_on
  end

  def to_param
    self.slug
  end

  def generate_slug
    slug_prefix = non_unique_slug
    self.slug = unique_slug(slug_prefix)
  end

  def non_unique_slug
    (self.send(slug_based_on)).strip.gsub(/\W/,'-').gsub(/-+/,'-').downcase
  end

  def unique_slug(slug_prefix)
    objects_with_similar_slugs = self.class.where("slug like ?", "#{slug_prefix}%") - [self]
    if objects_with_similar_slugs.empty?
      slug_prefix
    else
      ordered_slug_suffixes = objects_with_similar_slugs.map{|m| m.slug.split("#{slug_prefix}")[1].to_i.abs}.sort
      new_suffix = ordered_slug_suffixes[-1].next
      slug_prefix += "-#{new_suffix}"
    end
  end

  module ClassMethods

    def sluggable_column(column_name)
      self.slug_based_on = column_name
    end

  end

end
