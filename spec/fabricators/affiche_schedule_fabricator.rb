Fabricator(:affiche_schedule) do
  starts_on '2012-06-01'
  ends_on '2012-06-05'
  starts_at '11:00'
  ends_at '17:00'
  place 'place'
  hall 'hall'
  price_min 100
end
