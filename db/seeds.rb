# encoding: utf-8

puts "Seeding..."
db_config = ActiveRecord::Base.connection.instance_variable_get(:@config)
dump_filename = File.join(Rails.root, "db", "dump.sql")
system "psql #{db_config[:database]} < #{dump_filename}"
