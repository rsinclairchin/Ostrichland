require_relative 'entity.rb'
require_relative '../Map/map_zdrasvootyay.rb'
require_relative '../command.rb'
require_relative '../util.rb'
require_relative '../Attack/attack.rb'

class Player < Entity

  def initialize(name, max_hp = 100, hp = 100)
    super
    @max_hp = max_hp
    @hp = hp
    @map = Zdrasvootyay.new
    @location = Couple.new(1,5)
    @attacks = [Kick.new]
    update_player_map
  end

  attr_accessor :map, :location

  def move(direction)
    case direction
    when "w"
      if @map.tiles[@location.first][@location.second - 1].passable
        @location.second -= 1
        update_player_map
        prompt(self)
      else
        print "You can't go that way!\n\n"
        #print possible directions
      end
    when "e"
      if @map.tiles[@location.first][@location.second + 1].passable
        @location.second += 1
        update_player_map
        prompt(self)
      else
        print "You can't go that way!\n\n"
        #print possible directions
      end
    when "n"
      if @map.tiles[@location.first - 1][@location.second].passable
        @location.first -= 1
        update_player_map
        prompt(self)
      else
        print "You can't go that way!\n\n"
        #print possible directions
      end
    when "s"
      if @map.tiles[@location.first + 1][@location.second].passable
        @location.first += 1
        update_player_map
        prompt(self)
      else
        print "You can't go that way!\n\n"
        #print possible directions
      end
    end

  end

  #call after each move
  def update_player_map
    @map.tiles[@location.first][location.second].seen = true
    #corners
    @map.tiles[@location.first + 1][@location.second - 1].seen = true
    @map.tiles[@location.first - 1][@location.second - 1].seen = true
    @map.tiles[@location.first + 1][@location.second + 1].seen = true
    @map.tiles[@location.first - 1][@location.second + 1].seen = true
    #cardinal directions
    @map.tiles[@location.first][@location.second + 1].seen = true
    @map.tiles[@location.first][@location.second - 1].seen = true
    @map.tiles[@location.first - 1][@location.second].seen = true
    @map.tiles[@location.first + 1][@location.second].seen = true

    #TODO Uncomment
    if !(@map.tiles[@location.first][location.second].monsters.empty?)
      here = @map.tiles[@location.first][location.second]
      #20% chance of monster appearing
      monster_outcome = Random.rand(here.monsters.size * 5)
      if (monster_outcome < here.monsters.size)
        system("clear")
        battle(self, here.monsters[monster_outcome])
      end
    end
  end

  def print_player_map
    update_player_map
    puts "\nYou're in " + @map.name + "!\n\n"
    row_count = 0
    @map.tiles.each do |sub|
      #centers each row under the "welcome" sign
      for i in 1..(@map.name.length/2)
        print " "
      end
      col_count = 0
      sub.each do |tile|
        if tile.seen
          if tile.passable
            if row_count == @location.first && col_count == @location.second
              print "¶"
            else
              print "•"
            end
          else
            print "#"
          end
        else
          print " "
        end
        col_count += 1
      end
      row_count += 1
      puts ""
    end
    puts "\n• - passable space" +
         "\n# - impassable space" +
         "\n¶ - your location"
  end

  def attempt_run(monster)
    #the less hp a monster has, the higher prob. of run succeeding
    #variables for readability
    weakness = monster.hp/monster.max_hp
    chance = (weakness * 5).to_i
    if (Random.rand(chance) == 0)
      return true
    end
    return false
  end


  def player_died
    @location = @map.regen_location
    type("After being knocked out in battle, you wake up in #{@map.name}")
    type("Looks like you lost some gold...")
    sleep(2)
    @gold /= 2
    @hp = @max_hp
  end

end
