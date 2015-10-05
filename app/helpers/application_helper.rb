module ApplicationHelper
  def sort_categories_by_name!(categories)  
    categories.sort!{|x,y| x.name <=> y.name}
  end

  def welformatted_url(url)
    url.starts_with?('http://','https://') ? url : "http://#{url}"
  end

  def formatted_datetime(datetime)
    datetime.strftime("on %e %B %Y at %l:%M%p")
  end
end
