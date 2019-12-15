# Loads all the files
Dir[File.join(__dir__, '/admin_tasks', '*.rb')].each do |file|
  require file
end