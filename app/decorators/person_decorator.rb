class PersonDecorator < ApplicationDecorator
  def type
    Person::TYPES[source.type_id]
  end

  def edit_path
    if source.investor?
      [:edit, :admin, investors.first]
    else
      super
    end
  end
end
