module SneakySnake

  def players
    Game.world[:players].select{ |p| p != self }
  end

  def killable
    players.select{|p| killable?(p)}
      .sort{|a,b| a.stats[:experience] <=> b.stats[:experience]}
  end
 
  def is_killable?(player)
    player.stats[:health] <= stats[:strength] - player.stats[:defense] / 2
  end

  def select_victim
    players.max{|p| p.stats[:experience]}
    #players.min{|p| p.stats[:health]}
  end

  def move
    return [:attack, killable.first] unless killable.empty?
    return [:rest] if stats[:health] < 80
    return [:attack, select_victim] if 
      players.length == 1 || 
      stats[:health] >= 100 || 
      rand > 0.75
    [:rest]
  end

  def to_s
    "Sneaky Snake"
  end

end