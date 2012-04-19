#         ___
#     (V)(°w°)(V)
#     | |/\_/\| |
#     \__  /  __/
#       | |°  |
#   Dr. | |   |
module Zoidberg
  def to_s
    return "Zoidberg" unless (/game\.rb/ =~ caller[0]).nil?
    
    #Randomize name for other oponents
    random_name = ""
    random_chars = ("m".."z").to_a
    1.upto(rand(5..15)){ |l| random_name += random_chars[rand(0..(random_chars.count-1))] }
    return random_name.capitalize
  end
  
  def move
    #Hide move from oponents
    return [:rest] if (/game\.rb/ =~ caller[0]).nil?
    
    #Kill all the monsters if there is no enemies left
    return [:attack, monsters.first] unless enemies.count > 0 && monsters.count == 0
    
    #Attack if only one enemy left
    return [:attack, enemies.first] unless enemies.count > 1
    
    #Make sure to keep the health up to prevent attacks cause of weakness
    return [:rest] if self.stats[:health] < max_health
    
    #Attack preferred enemy to try to avoid beeing the only leader
    return [:attack, preferred_enemy] unless preferred_enemy.stats[:experience] > self.stats[:experience]
    
    #Attack a preffered killable enemy if exists
    return [:attack, preferred_killable_enemy] unless preferred_killable_enemy.nil?
    
    #Attack a preferred monster if exists
    return [:attack, preferred_monster] unless preferred_monster.nil?
    
    #Default attack preferred enemy
    return [:attack, preferred_enemy]
  end
  
  private
  
  # Return a preferred enemy sorted by experience desc, name
  def preferred_enemy
    e = enemies.sort{ |a,b| (b.stats[:experience] == a.stats[:experience]) ? (a.to_s <=> b.to_s) : (b.stats[:experience] <=> a.stats[:experience]) }
    return e.empty? ? nil : e.first
  end
  
  # Return preferred killable enemy that others unlikely will attack
  def preferred_killable_enemy
    e = enemies.select{ |e| killable?(e) }
    return e[rand(1..(e.count-2))] unless e.count <= 2
    return e.last unless e.count == 0
  end
  
  # Return a preferred monster that others unlikely will attack
  def preferred_monster
    return monsters[rand(1..(monsters.count-2))] unless monsters.count <= 2
    return monsters.last unless monsters.count == 0
  end
  
  # List of players
  def enemies
    Game.world[:players].select{ |p| p != self && p.class != Monster }
  end
  
  # List of monsters
  def monsters
    Game.world[:players].select{ |p| p != self && p.class == Monster }
  end
  
  #Wether enemy is killable or not
  def killable?(enemy)
    self.stats[:strength] - (enemy.stats[:defense] / 2) >= enemy.stats[:health]
  end
  
  # Calculates max health
  def max_health
    max_health = 100
    1.upto(self.stats[:level]){ |i| max_health += (i+1)*5 }
    return max_health
  end
end