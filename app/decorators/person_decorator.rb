class PersonDecorator < ApplicationDecorator
  def type
    Person::TYPES[source.type_id]
  end
end
