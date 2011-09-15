xml.instruct!
xml.feed :xmlns => "http://www.w3.org/2005/Atom" do
  xml.title 'Хоровод 2010: Лучшие поздравления', :type => "text"
  xml.generator "Horovod", :uri => "http://horovod-2010.ru/"
  xml.link :href => thebest_url(:format => :atom), :rel => "self"
  xml.link :href => recent_url(:format => :atom), :rel => "alternate"
  xml.subtitle 'Поздравь свой университет!!', :type => "text"
  @posts.each do |post|
    xml.entry do
      xml.title "Поздравление №#{post.id}"
      xml.link :href => post_url(post),
               :type => 'text/html',
               :rel => 'alternate'
      xml.id post.id
      xml.content post.body, :type => "html"
      xml.published post.created_at(:xmlschema)
    end
  end
end
