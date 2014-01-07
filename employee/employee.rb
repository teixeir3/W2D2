class Employee

  attr_reader :name, :title, :salary, :boss

  def initialize(attributes)
    @name = attributes[:name]
    @title = attributes[:title]
    @salary = attributes[:salary]
    @boss = attributes[:boss]
  end

  def bonus(multiplier)

  end

end

class Manager < Employee
  attr_reader :subordinates

  def initialize(subordinates, attributes)
    super(attributes)
    @subordinates = subordinates
  end



end