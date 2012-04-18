module WeaponOfAssDestruction
  def to_s
    "Weapon Of Ass Destruction"
  end
  
  def move
    #Kill all the monsters if there is no enemies left
    return [:attack, monsters.first] unless enemies.count > 0 && monsters.count == 0
    
    #Attack if only one enemy left
    return [:attack, enemies.first] unless enemies.count > 1
    
    #Beeing week is a huge threat
    return [:rest] if self.stats[:health] < 100
    
    #Attack preferred enemy to try to avoid beeing the only leader
    return [:attack, preferredEnemyTargets.first] unless preferredEnemyTargets.first.stats[:experience] > self.stats[:experience]
    
    #Attack a killable enemy if exits
    return [:attack, killableEnemyTargets.first] unless killableEnemyTargets.count == 0
    
    #Attack a monster if exists
    return [:attack, monsters.first] unless monsters.count == 0
    
    #Default attack preferred enemy if health is 100
    return [:attack, preferredEnemyTargets.first]
  end
  
  private
  
  # Return killable enemy targets sorted by experience desc, name
  def killableEnemyTargets
    e = enemies.select{ |e| killable?(e) }
    return e.empty? ? e : e.sort{ |a,b| (b.stats[:experience] == a.stats[:experience]) ? (a.to_s <=> b.to_s) : (b.stats[:experience] <=> a.stats[:experience]) }
  end 
  
  #Wether enemy is killable or not
  def killable?(enemy)
    self.stats[:strength] - (enemy.stats[:defense] / 2) >= enemy.stats[:health]
  end
  
  # Returns prefered enemy targets sorted by experience desc, name
  def preferredEnemyTargets
    enemies.sort{ |a,b| (b.stats[:experience] == a.stats[:experience]) ? (a.to_s <=> b.to_s) : (b.stats[:experience] <=> a.stats[:experience]) }
  end
  
  # List of players
  def enemies
    Game.world[:players].select{ |p| p != self && p.class != Monster }
  end
  
  # List of monsters
  def monsters
    Game.world[:players].select{ |p| p != self && p.class == Monster }
  end
end