class Student
  attr_accessor :name, :grade
  attr_reader :id
  def initialize(grade=9, name="Joe", id = nil)
    @name = name
    @grade = grade
    @id = id
  end 
  
  def self.create_table
    sql_create = "CREATE TABLE students (id INTEGER PRIMARY KEY, name TEXT, grade INTEGER)"
    DB[:conn].execute(sql_create)
  end
  
  def self.drop_table
    sql_delete = "DROP TABLE students"
    DB[:conn].execute(sql_delete)
  end 
  
  def save
    sql_insert = "INSERT INTO students (name, grade) VALUES (?,?)"
    DB[:conn].execute(sql_insert, @name, @grade)
    get_id = "SELECT last_insert_rowid() FROM students"
    @id = DB[:conn].execute(get_id).flatten[0]
  end
  
  def self.create(student_hash) 
    new_student = Student.new
    student_hash.each do |attr, value|
      new_student.send("#{attr}=", value)
    end
    new_student.save
    new_student
  end
  
  def self.new_from_db(row)
    new_student = self.new(row[0], row[1], row[2])
    new_student.save
  end
  
  def self.all
    all_students = []
    sql_all = "SELECT * FROM students"
    all_students = DB[:conn].execute(sql_all)
    all_students.each do |student|
      new_student = self.new_from_db(student)
      all_students << new_student
    end
  end
  
  def self.find_by_name(name)
    found = self.all.find{|student| student.name = name}
  end
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  
end
