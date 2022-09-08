# db/seeds.rb
# BRANDS SEED
puts "Destroying Brands..."
Brand.destroy_all
puts "Creating Brands..."

brand_1 = {name: "Agip"}
brand_2 = {name: "Esso Express"}
brand_3 = {name: "Avia"}
brand_4 = {name: "Total"}
brand_5 = {name: "BP"}
brand_6 = {name: "Casino"}

[brand_1, brand_2, brand_3, brand_4, brand_5, brand_6].each do |attributes|
  brand = Brand.create!(attributes)
  puts "Created #{brand.name}"
end
puts "All Brands created!"

# USERS SEED
puts "Destroying Users..."
User.destroy_all
puts "Creating users..."

user_1 = {first_name: "Joao", last_name: "Henriques", email: "joao@mail.com", password: "123456", fuel_preference: "Gazole", brand: Brand.first, capacity: 40, brand_preference: "Agip"}
user_2 = {first_name: "Jean", last_name: "User", email: "user_1@example.com", password: "123456", fuel_preference: "SP95", brand: Brand.first, capacity: 40}
user_3 = {first_name: "Lisa", last_name: "User", email: "user_2@example.com",  password: "123456", fuel_preference: "SP95", brand: Brand.first, capacity: 40}
user_4 = {first_name: "Louis", last_name: "User", email: "user_3@example.com", password: "123456", fuel_preference: "SP98", brand: Brand.second, capacity: 40}
user_5 = {first_name: "Lara", last_name: "User", email: "user_4@example.com", password: "123456", fuel_preference: "Gazole", brand: Brand.second, capacity: 40}
user_6 = {first_name: "Liam", last_name: "User", email: "user_5@example.com", password: "123456", fuel_preference: "Gazole", brand: Brand.third, capacity: 40}
user_7 = {first_name: "Gary", last_name: "User", email: "user_6@example.com", password: "123456", fuel_preference: "E10", brand: Brand.fourth, capacity: 40}

[user_1, user_2, user_3, user_4, user_5, user_6, user_7].each do |attributes|
  user = User.create!(attributes)
  puts "Created #{user.first_name}"
end
puts "All Users created!"

# LOCATIONS SEED
puts "Destroying Favorite Locations..."
Location.destroy_all
puts "Creating Locations..."

location_1 = {name: "Home", user: User.first, address: "1 Rue Pegoud, 69150 Décines-Charpieu, France", latitude: "45.76713301470537", longitude: "4.959789493946997"}
location_2 = {name: "Work", user: User.first, address: "2 Rue Fleury Neuvesel, 69700 Givors, France", latitude: "45.58539006010262", longitude: "4.762810462890701"}
location_3 = {name: "Mum & Dad", user: User.first, address: "10 Av. des Cévennes, 48800 Villefort, France", latitude: "44.43856576465387", longitude: "3.932240153021491"}
location_4 = {name: "Home", user: User.second, address: "13 Rue Madon, 13005 Marseille, France", latitude: "43.29667257187408", longitude: "5.399781812516283"}
location_5 = {name: "Work", user: User.second, address: "3 Bd Jean Jaurès, 13400 Aubagne, France", latitude: "43.292300579654885", longitude: "5.569254851398037"}
location_6 = {name: "Football Club", user: User.second, address: "3 Bd Michelet, 13008 Marseille, France", latitude: "43.270471323410916", longitude: "5.395881194760889"}
location_7 = {name: "Home", user: User.third, address: "25 Av. de la Libération, 45000 Orléans, France", latitude: "47.920936908714", longitude: "1.90235335236189"}
location_8 = {name: "Work", user: User.third, address: "4 Av. Jean Moulin, 75014 Paris, France", latitude: "48.82787900614562", longitude: "2.326180163752327"}
location_9 = {name: "Gym Club", user: User.third, address: "47 Rte d'Orléans, 45380 Chaingy, France", latitude: "47.87954526107604", longitude: "1.798558848521771"}

[location_1, location_2, location_3, location_4, location_5, location_6, location_7, location_8, location_9].each do |attributes|
  location = Location.create!(attributes)
  puts "Created #{location.name}"
end
puts "All Locations created"
puts "Finished!"
