# encoding: utf-8

class NewsCell < Cell::Rails
  def recent
    @news = options[:news]
    render
  end
end
