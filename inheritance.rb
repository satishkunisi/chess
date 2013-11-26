class Employee
  attr_accessor :salary, :boss
  attr_reader :name, :title

  def initialize(name, title, salary, boss = nil)
    @name, @title, @salary, @boss = name, title, salary, boss
  end

  def bonus(multiplier)
    @salary * multiplier
  end
end

class Manager < Employee
  attr_reader :employees

  def initialize(name, title, salary, boss, employees)
    super(name, title, salary, boss)
    @employees = employees
    set_boss
  end



  def bonus(multiplier)
    total = 0
    @employees.each do |employee|
      if employee.class == Manager
        total += employee.salary + employee.bonus(1)
        p "total #{total}"
      else
        total += employee.salary
        p "total after adding emploee sal #{total}"
      end

    end

    total * multiplier
  end

  private
  def set_boss
    @employees.map { |employee| employee.boss = self }
  end

end


e1 = Employee.new("Fong1", "normal", 100)
e2 = Employee.new("Fong2", "normal", 100)
e3 = Employee.new("Fong3", "normal", 100)

m = Manager.new("Satish", "manager", 200, nil, [e1,e2,e3])

m2 = Manager.new("Satish", "manager", 200, nil, [m])


p m2.bonus(1)