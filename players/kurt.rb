module SneakySnake

  def move
    return [:attack, killable.first] unless killable.empty?
    return [:attack, select_victim] if 
      players.length == 1 || 
      stats[:health] >= @player.max_health || 
      rand > 0.85
    [:rest]
  end

  def to_s
    "Sneaky Snake"
  end

  private

  # All players that's alive, sorted by level (highest first)
  def players
    Game.world[:players]
      .select{ |p| p != self && p.to_s != "rat" }
      #.sort{ |a,b| a.stats[:experience] <=> b.stats[:experience] }
  end

  def killable
    players.select{|p| killable?(p)}
  end
 
  def killable?(player)
    player.stats[:health] <= stats[:strength] - player.stats[:defense] / 2
  end

  def select_victim
    if @last_victim.nil? or not @last_victim.alive
      @last_victim = players.max{|p| p.stats[:experience]}
    end

    @last_victim
  end

end