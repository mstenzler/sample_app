def full_title(page_title)
  base_title = "Crafted Crowd"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end