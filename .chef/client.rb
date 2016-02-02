current_dir = File.absolute_path(File.dirname(File.dirname(__FILE__)))
cookbook_path ["#{current_dir}/cookbooks", "#{current_dir}/vendor/cookbooks"]
