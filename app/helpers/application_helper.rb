module ApplicationHelper
  def sort_categories_by_name!(categories)  
    categories.sort!{|x,y| x.name <=> y.name}
  end

  def welformatted_url(url)
    url.starts_with?('http://','https://') ? url : "http://#{url}"
  end

  def formatted_datetime(datetime)
    datetime.in_time_zone(timezone_to_use).strftime("on %e %B %Y at %l:%M%p %Z")
  end

  def timezone_to_use
    (logged_in? && !current_user.timezone.blank?) ? current_user.timezone : Time.zone.name
  end

  def votes_id_tag(voteable_object)
    "#{voteable_object.class.to_s.downcase}_#{voteable_object.id}_votes"
  end

  def display_vote_number(voteable_object)
    pluralize(voteable_object.number_of_votes, 'vote')
  end

  def vote_path(voteable_object)
    case voteable_object.class.to_s
    when 'Comment'
      [:vote, voteable_object.post, voteable_object]
    when 'Post'
      [:vote, voteable_object]
    end
  end
end
