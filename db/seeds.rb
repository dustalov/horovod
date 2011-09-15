# encoding: utf-8

users = User.create!([
  { :email => 'info1@fizteh.org', :admin => true,
    :surname => 'Surname1', :name => 'Name1', :squad => 'Фт-47081',
    :password => '123456', :password_confirmation => '123456' },
  { :email => 'info2@fizteh.org',
    :surname => 'Surname2', :name => 'Name2', :squad => 'Фт-47025',
    :password => '123456', :password_confirmation => '123456' },
  { :email => 'info3@fizteh.org',
    :surname => 'Surname3', :name => 'Name3', :squad => 'Фт-47081',
    :password => '123456', :password_confirmation => '123456' }
])

news = News.create!([
  { :body => 'Все бегом в профбюро!!',
    :user => users[1] },
  { :body => 'Придёт весь город, конечно же!11',
    :user => users[1] }
])

texts = Text.create!([
  { :body => 'Поздравляю любимый институт с праздником!', :user => users[2] },
  { :body => 'упи я незабуду тебя в армии', :user => users[1] },
  { :body => ':3', :user => users[0] }
])

photos = Photo.create!([
  { :attachment => File.open(File.join(Rails.root,
    'public', 'images', 'rails.png')), :user => users[2] }
])

audios = Audio.create!([
  { :attachment => File.open(File.join(Rails.root,
    'public', 'casc.mp3')), :user => users[0] }
])

videos = Video.create!([
  { :video_url => 'http://www.youtube.com/watch?v=qqXi8WmQ_WM',
    :body => 'ah yeah!', :user => users[2] }
])

Rating.transaction do
  Post.find_each do |post|
    users.each do |user|
      post.ratings.create :user => user
    end
  end
end
