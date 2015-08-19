# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Clinic.delete_all
clinic = Clinic.create([ practice_id: 145, name: "FYidoctors McKenzie Towne"])
clinic = Clinic.create([ practice_id: 244, name: "FYidoctors West Edmonton Mall"])
clinic = Clinic.create([ practice_id: 126, name: "Atrium Eye Care"])
