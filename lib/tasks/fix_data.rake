# encoding: utf-8

task :fix_data => :environment do
  p "FIX SalonCenter category"
  pb = ProgressBar.new(SalonCenter.count)

  SalonCenter.find_each do |salon_center|
    category = salon_center.category.dup

    category.gsub!('SPA-салон', 'SPA-салоны')
    category.gsub!('парикмахерская', 'Парикмахерские')
    category.gsub!('ногтевая студия', 'Ногтевые студии')
    category.gsub!('тату-салон', 'Тату-салоны')
    category.gsub!('студия загара', 'Студии загара')
    category.gsub!('массажный салон', 'Массажные салоны')
    category.gsub!('визаж-студия', 'Визаж-студии')

    salon_center.update_attributes! category: category

    salon_center.organization.index
    pb.increment!
  end

  p "FIX CarSalesCenter feature offer"
  pb = ProgressBar.new(CarSalesCenter.count)
  CarSalesCenter.find_each do |car_sales_center|
      feature = car_sales_center.feature.dup

      feature.gsub!('Новые', 'новые')
      feature.gsub!('С пробегом', 'с пробегом')

      offer = car_sales_center.offer.dup

      offer.gsub!('Кредит', 'кредит')
      offer.gsub!('Лизинг', 'лизинг')
      offer.gsub!('Расрочка', 'рассрочка')
      offer.gsub!('Сервисное обслуживание', 'сервисное обслуживание')
      offer.gsub!('Продажа запчастей', 'продажа запчастей')

      car_sales_center.update_attributes! feature: feature, offer: offer
      car_sales_center.organization.index
      pb.increment!
  end
end
