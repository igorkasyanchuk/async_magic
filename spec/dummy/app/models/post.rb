class Post < ApplicationRecord
  async
  def self.class_async_method
    sleep(1)
    "Class method completed"
  end

  async
  def self.failing_class_method
    raise "Something went wrong"
  end

  async
  def expensive_operation
    sleep 1
    "Done"
  end

  async
  def failing_async_method
    raise "Something went wrong"
  end

  def normal_method
    "normal result"
  end
end
