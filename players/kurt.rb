module SneakySnake

  def move
    return [:attack, killable] unless killable.nil?
    return [:attack, select_victim] if 
      players.length == 1 || 
      stats[:health] >= @player.max_health || 
      rand > 0.9
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
      #.sort{ |a,b| b.stats[:experience] <=> a.stats[:experience] }
  end

  def killable
    dying = players.select{|p| killable?(p)}
    dying[rand(dying.count - 1)]
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