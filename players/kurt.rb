module Kurt

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
    killable.max{|p| p.stats[:experience]}
  end

  def move
    return [:attack, killable.first] unless killable.empty?
    return [:attack, players.first] if players.length == 1 || stats[:health] >= 100
    [:rest]
  end

  def to_s
    "Kurt"
  end

end