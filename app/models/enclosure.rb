# == Schema Information
#
# Table name: enclosures
#
#  id         :integer          not null, primary key
#  file       :string           default(""), not null
#  ware_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Enclosure < ActiveRecord::Base
  #belongs_to :member

  mount_uploader :file, EnclosureUploader
end
