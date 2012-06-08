# encoding: utf-8

require 'open-uri'
require 'nokogiri'

class MovieSyncer
  attr_accessor :movies, :place

  def initialize(options)
    self.place = options.delete(:place)
    self.movies = options.delete(:movies)
  end

  def sync
    movies.each do |title, seances|
      if (movie = find_movie_by(title.squish))
        showings = movie.showings.where(:place => place)
        seances.each do |seance|
          seance.each do |k,v| v.squish! if v.is_a?(String) end
          showing = showings.find_or_initialize_by_hall_and_starts_at_and_price_min(:hall => seance.delete(:hall),
                                                                                    :starts_at => seance.delete(:starts_at),
                                                                                    :price_min => seance.delete(:price_min))
          showing.update_attributes! seance
        end
      end
    end

  end

  private
    def find_movie_by(title)
      Movie.find_by_title(title) || find_similar_movie_by(title)
    end

    def find_similar_movie_by(title)
      similar_movies = Movie.search{fulltext(title){fields(:title)}}.results
      if similar_movies.one?
        puts "Найден похожий фильм '#{title}' -> '#{similar_movies.first.title}'"
      else
        puts "Не могу найти фильм '#{seance[:title]}'"
      end
      similar_movies.first
    end
end

namespace :sync do
  desc "Sync movie seances from http://fakel.tomsknet.ru"
  task :fakel => :environment do
    page = Nokogiri::HTML(open('http://fakel.tomsknet.ru/film_timetable.html'))
    movies = {}
    page.css('table tr:nth-child(2) td:nth-child(3) table table').each do |day_node|
      rows = day_node.css('tr').to_a
      day, month, year = rows.shift.text.match(/(\d{2})\.(\d{2})\.(\d{4})/)[1..3]
      rows.each do |seance|
        columns = seance.css('td').map(&:text)
        hour, minute = columns[0].match(/(\d{2}):(\d{2})/)[1..2]
        starts_at  = Time.local(year, month, day, hour, minute)
        title, format = columns[1].match(/(.*)\((.*?)\)\s*/)[1..2]
        price_min = columns[2].to_i
        hall = '3D' if format !~ /обычный/
        movies[title] ||= []
        movies[title] << {starts_at: starts_at, hall: hall, price_min: price_min}
      end
    end

    MovieSyncer.new(:place => "Факел", :movies => movies).sync
  end

  task :kinomax => :environment do
    host = 'http://kinomax.tomsk.ru'
    url = "#{host}/timetable/"
    movies = {}

    timetable = Nokogiri::HTML(open(url).read).css('.filminfo_calendar_date > a')
    bar = ProgressBar.new(timetable.count)
    p 'Парсинг сеансов Киномакса'

    timetable.each do |day_tile|
      day_schedule_path = day_tile.attribute('href').value
      date = day_schedule_path.match(/\d{4}-\d{2}-\d{2}/)
      day_schedule_page = Nokogiri::HTML(open(host+day_schedule_path).read)

      day_schedule_page.css('.сinemainfo_schedule_film').each do |row|
        title = row.css('a').text.squish
        three_d = title.match(/\(?3D\)?/)
        title = title.gsub(/\s\(?3D\)?|\(?2D\)?/,'').squish
        movies[title] ||= []
        seanses = row.parent.parent.css('.сinemainfo_schedule_tr2')
        seanses.each do |seans|
          hall  = seans.css('.сinemainfo_schedule_hall').text
          times = seans.css('.сinemainfo_schedule_time > span')
          times.each do |time|
            starts_at = time.css('b').text.gsub(/(\d\d)$/,':\1')
            prices = time.css('font').text.gsub(/\(|\)/,'').squish.split(' ')
            price_min = prices.min.to_i
            price_max = prices.max == prices.min ? 0 : prices.max.to_i
            movies[title] << {:starts_at => "#{date} #{starts_at}".to_datetime, :hall => [hall, three_d].join(' ').squish, :price_min => price_min, :price_max => price_max }
          end
        end
      end
      bar.increment!
    end

    MovieSyncer.new(:place => "Киномакс", :movies => movies).sync
  end
end
