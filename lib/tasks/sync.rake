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
    puts "#{place}: импорт сеансов"
    bar = ProgressBar.new(movies.values.map(&:count).sum)
    movies.each do |title, seances|
      if (movie = find_movie_by(title.squish)) && (cinematheatre = find_similar_cinematheatre_by(place.squish))
        showings = Showing.where(:id => Showing.search{with(:affiche_id, movie.id); fulltext(place){fields(:place, :organization_title)}; paginate(:per_page => '100000')}.results.map(&:id))

        seances.each do |seance|
          seance.each do |k,v| v.squish! if v.is_a?(String) end

          unless showing = showings.find_by_hall_and_starts_at_and_price_min(seance[:hall],
                                                                             seance[:starts_at],
                                                                             seance[:price_min])
            showing = Showing.new(:hall => seance[:hall],
                                  :starts_at => seance[:starts_at],
                                  :price_min => seance[:price_min],
                                  :affiche_id => movie.id).tap do |s|

              if place =~ /Факел/
               s.place = 'Факел, центр досуга и спорта'
               s.organization_id = 315
              else
               s.place = cinematheatre.title
               s.organization_id = cinematheatre.id
              end
            end
            showing.save!
          end

          showing.update_attributes! seance
          bar.increment!
        end
      else
        bar.increment! seances.count
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
        puts "Не могу найти фильм '#{title}'"
      end
      similar_movies.first
    end

    def find_similar_cinematheatre_by(cinema_title)
      similar_cinematheatre = Organization.search{fulltext(cinema_title){fields(:title)}; fulltext('Кинотеатры'){fields(:category)}}.results
      if similar_cinematheatre.one?
        puts "Найден похожий кинотеатр '#{cinema_title}' -> '#{similar_cinematheatre.first.title}'"
      else
        puts "Кинотеатр '#{cinema_title}' не найден"
      end
      similar_cinematheatre.first
    end
end

namespace :sync do
  desc "Sync movie seances from http://fakel.tomsknet.ru"
  task :fakel => :environment do
    page = Nokogiri::HTML(open('http://fakel.tomsknet.ru/film_timetable.html'))
    puts 'Факел: парсинг'
    movies = {}
    day_nodes = page.css('table tr:nth-child(2) td:nth-child(3) table table')
    bar = ProgressBar.new(day_nodes.count)
    day_nodes.each do |day_node|
      rows = day_node.css('tr').to_a
      day, month, year = rows.shift.text.match(/(\d{2})\.(\d{2})\.(\d{4})/)[1..3]
      rows.each do |seance|
        columns = seance.css('td').map(&:text)
        hour, minute = columns[0].match(/(\d{2}):(\d{2})/)[1..2]
        starts_at  = Time.local(year, month, day, hour, minute)
        title = columns[1].gsub('(обычный формат)', '')
        price_min = columns[2].to_i
        movies[title] ||= []
        movies[title] << {starts_at: starts_at, price_min: price_min}
      end
      bar.increment!
    end

    MovieSyncer.new(:place => "Факел", :movies => movies).sync
  end

  desc "Sync movie seances from http://kinomax.tomsk.ru"
  task :kinomax => :environment do
    host = 'http://kinomax.tomsk.ru'
    url = "#{host}/schedule/"
    movies = {}

    timetable = Nokogiri::HTML(open(url).read).css('.tableTabContainer a')
    bar = ProgressBar.new(timetable.count)
    puts 'Киномакс: парсинг'

    timetable.each do |day_tile|
      day_schedule_path = day_tile.attribute('data-url').value
      date = day_schedule_path.match(/\d{2}.\d{2}.\d{4}/)
      day_schedule_page = Nokogiri::HTML(open(host+day_schedule_path).read)

      day_schedule_page.css('h2.sectionHeader2').each do |hall_html|
        hall  = hall_html.text
        hall_html.next_element.css('div.hallContainer').each do |film|
          title = film.css('h3 a').text.squish
          three_d = title.match(/\(?3D\)?/)
          title = title.gsub(/\s\(?3D\)?|\(?2D\)?/,'').squish
          movies[title] ||= []
          film.css('a.timeLineItem').each do |seans|
            next if seans['class'].match(/session-already-past/)
            time = seans.css('u').first.text
            seans_id = seans['href'].match(/\d+/)
            prices = day_schedule_page.css("#sessionTooltip-#{seans_id}").first.css('table.sessionTooltipTable').first.css('td.tal')[1].text
            price_min = prices.match(/\d+/).to_a.map(&:to_i).min
            price_max = prices.match(/\d+/).to_a.map(&:to_i).max
            movies[title] << {
              :starts_at => Time.zone.parse("#{date} #{time}"),
              :hall => [hall, three_d].join(' ').squish,
              :price_min => price_min,
              :price_max => price_max }
          end
        end
      end
      bar.increment!
    end

    MovieSyncer.new(:place => "Киномакс", :movies => movies).sync
  end

  desc "Sync movie seances from http://kinomir.tom.ru"
  task :kinomir => :environment do
    host = 'http://kinomir.tom.ru'
    url = "#{host}/schedule/"
    movies = {}

    timetable = Nokogiri::HTML(open(url).read).css('.schedule a')
    bar = ProgressBar.new(timetable.count)
    puts 'Киномир: парсинг'

    timetable.each do |day_tile|
      day_schedule_path = day_tile.attribute('href').value
      date = day_schedule_path.match(/\d{2}.\d{2}.\d{4}/)
      day_schedule_page = Nokogiri::HTML(open(host+day_schedule_path).read)
      day_schedule_page.css('.raspisanie-table').each do |table|
        hall = table.css('thead tr td:first h1').text
        table.css('tbody tr .content').each do |seance|
          title = seance.css('h1 a').text
          three_d = title.match(/((?:в 3D)|3D)/).try(:[], 1)
          title = title.gsub(/((?:в 3D)|3D)/,'').squish
          movies[title] ||= []
          seance.parent.parent.parent.parent.css('td:nth-child(2) > div > div').each do |i|
            if i['class'] == 'show-time'
              time = i.css('a').text
              amount = i.next_element.css('table td:nth-child(2)').text
              movies[title] << {:starts_at => Time.zone.parse("#{date} #{time}"), :hall => [hall, three_d].join(' ').squish, :price_min => amount.to_i }
            end
          end
        end
      end
      bar.increment!
    end

    MovieSyncer.new(:place => "Киномир", :movies => movies).sync
  end
end

task :sync => ['sync:fakel', 'sync:kinomax', 'sync:kinomir']
