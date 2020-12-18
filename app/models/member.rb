class Member < ActiveRecord::Base
  STORE_DIR = 'photos'
  STORE_PATH = File.join(Rails.root, "public", STORE_DIR)
  Dir.mkdir(STORE_PATH) unless Dir.exists?(STORE_PATH)

  def file= file
    doc_type = file.original_filename.split('.').last
    location = File.join(STORE_DIR, file.original_filename)
    self.photo = location
    File.open(File.join(STORE_PATH, file.original_filename), "wb") { |f| 
      f.write(file.read) }
  end
end
