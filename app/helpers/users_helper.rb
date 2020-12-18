module UsersHelper
  def level_image(level)
    if 0 <= level && level < 500
      'vb1.png'
    elsif 500 <= level && level < 2000  
      'vb2.png'
    elsif 2000 <= level && level < 10000  
      'vb3.png'
    elsif 10000 <= level && level < 50000  
      'vb4.png'
    elsif 50000 <= level
      'vb5.png'
    end
  end
    
  def level_title(level)
    if 0 <= level && level < 500
      Setting.levels.bronze
    elsif 500 <= level && level < 2000  
      Setting.levels.silver
    elsif 2000 <= level && level < 10000  
      Setting.levels.gold
    elsif 10000 <= level && level < 50000  
      Setting.levels.platinum
    elsif 50000 <= level
      Setting.levels.diamond
    end
  end
end
