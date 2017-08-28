json.array! @restaurants do |restaurant|
  json.extract! restaurant, :id, :name, :address

  # json.id(restaurant.id)
  # json.name_address("#{restaurant.name} - #{restaurant.address}")
end
