# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# (1..10).each do |tc_id|
#   rand_num = rand(2)
#   t = TestCase.create({
#     name: "test case #{tc_id}",
#     feature_name: "test_active_resource_#{rand_num}",
#     feature_file_path: "./test_active_resource#{rand_num}.feature",
#     register_at: Time.now,
#     tc_id: tc_id,
#     warden_project_id: 1
#   })
# end

require 'yaml'
yml_dictional =  '../etc/test_case_map.yml'
test_cases_info = YAML::load_file(yml_dictional)

test_cases_info[:tc_map].each do |tc_id, tc|

  warden_project = WardenProject.find_or_create_by_name(tc[0])

  # unless warden_project = WardenProject.find_by_name(tc[0])
  #   warden_project = WardenProject.create({
  #     name: tc[0]
  #   })
  # end

  TestCase.create({
    name: tc[2],
    feature_name: tc[1],
    feature_file_path: "./#{tc[0]}/#{tc[1]}",
    register_at: Time.now,
    tc_id: tc_id,
    warden_project: warden_project
  })

end
