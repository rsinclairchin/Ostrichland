class Tile

	def initialize(passable, events = [], monsters = [])
		@passable = passable
		@seen = false
		#@description = description
		@events = events
		@monsters = monster
	end

	attr_accessor :passable, :seen, :events, :monsters

end
