# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
%w[Admin Moderator AuthenticatedUser].each do |rname|
	r = Role.new
	r.name = rname
	r.save
end

%w[Combat Roleplay Funny Event].each do |evname|
	cat = Category.new
	cat.name = evname
	cat.save
end

["Aardwolf", "Achaea", "Aetolia", "Avalon", "BatMUD", "Imperian", "Lithmeria", "Lusternia", "Midnight Sun II"].each do |gname|
	gs = Game.new
	gs.name = gname
	gs.save
end
