class Employee

  attr_reader :name, :title, :salary
  attr_accessor :boss

  def initialize(attributes = {})
    defaults = {
      :title => "Coder",
      :salary => 100_000
    }
    attributes = defaults.merge(attributes)


    @name = attributes[:name]
    @title = attributes[:title]
    @salary = attributes[:salary]
    @boss = nil
  end

  def bonus(multiplier)
    bonus = @salary * multiplier
  end

end

class Manager < Employee
  attr_reader :subordinates

  def initialize(subordinates, attributes)
    super(attributes)
    @subordinates = subordinates
    set_bosses
  end

  def bonus(multiplier)
    total_salary = 0
    employee_queue = [self]
    until employee_queue.empty?
      current_employee = employee_queue.shift
      total_salary += current_employee.salary
      if current_employee.methods.include?(:subordinates)
        employee_queue += current_employee.subordinates
      end
    end
    total_salary * multiplier
  end

  def set_bosses
    @subordinates.each do |subordinate|
      subordinate.boss = self
    end
  end


end