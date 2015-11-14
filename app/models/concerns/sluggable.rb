# Models this is included in require a :slug column
module Sluggable
  
  extend ActiveSupport::Concern

  def to_param
    self.slug
  end

  def generate_slug(slug_based_on)
    slug_prefix = non_unique_slug(slug_based_on)
    self.slug = unique_slug(slug_prefix)
  end

  def non_unique_slug(slug_based_on)
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

end
