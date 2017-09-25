class Pokemon
  attr_accessor :id, :name, :type, :db, :hp
  @@all = []

  def initialize(id:, name:, type:, db:)
    @id = id
    @name = name
    @type = type
    @db = db
    @@all << self
  end

  def self.save(name, type, database)
    database.execute("INSERT INTO pokemon (name, type) VALUES (?, ?)", name, type)
  end

  def self.all
    @@all
  end

  def self.find(pokemon_id, database)
    sql = <<-SQL
            SELECT * FROM pokemon WHERE id = ?
          SQL

    results = database.execute(sql, pokemon_id).flatten
    info = {
      id: results[0],
      name: results[1],
      type: results[2],
      db: database
    }
    pokemon = Pokemon.new(info)
    pokemon.hp = results[3] if results[3]
    pokemon
  end

  def alter_hp(new_hp, database)
    sql = "UPDATE pokemon SET hp = ? WHERE id = ?"
    database.execute(sql, new_hp, self.id)
    self.hp = new_hp
  end
end
