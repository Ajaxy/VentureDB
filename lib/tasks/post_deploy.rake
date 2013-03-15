# encoding: utf-8

namespace :post_deploy do
  task create_connection_types: :environment do
    ConnectionType.create! source_class: 'Person', receiver_class: 'Company',
      direct_name: 'Акционер в', reverse_name: 'Акционер'
    ConnectionType.create! source_class: 'Person', receiver_class: 'Company',
      direct_name: 'Ивестор в', reverse_name: 'Инвестирует'
    ConnectionType.create! source_class: 'Person', receiver_class: 'Company',
      direct_name: 'Клиент в', reverse_name: 'Клиент'
    ConnectionType.create! source_class: 'Person', receiver_class: 'Company',
      direct_name: 'Консультант в', reverse_name: 'Консультирует'
    ConnectionType.create! source_class: 'Person', receiver_class: 'Company',
      direct_name: 'Преподаватель в', reverse_name: 'Преподаёт'
    ConnectionType.create! source_class: 'Person', receiver_class: 'Company',
      direct_name: 'Резидент в', reverse_name: 'Резидент'
    ConnectionType.create! source_class: 'Person', receiver_class: 'Company',
      direct_name: 'Управляет', reverse_name: 'Управляет'
    ConnectionType.create! source_class: 'Person', receiver_class: 'Company',
      direct_name: 'Участник в', reverse_name: 'Участвует'
    ConnectionType.create! source_class: 'Person', receiver_class: 'Company',
      direct_name: 'Участвовал при создании', reverse_name: 'Создавалась при участии',
      name: 'author'
    ConnectionType.create! source_class: 'Person', receiver_class: 'Company',
      direct_name: 'Учредитель в', reverse_name: 'Учредитель'
    ConnectionType.create! source_class: 'Person', receiver_class: 'Company',
      direct_name: 'Финалист в', reverse_name: 'Финалист'
    ConnectionType.create! source_class: 'Person', receiver_class: 'Company',
      direct_name: 'Эксперт в', reverse_name: 'Эксперт'
    ConnectionType.create! source_class: 'all', receiver_class: 'all',
      direct_name: 'Со-инвесторы', reverse_name: 'Со-инвесторы'
    ConnectionType.create! source_class: 'all', receiver_class: 'all',
      direct_name: 'Похожие', reverse_name: 'Похожие'
  end

  task move_authors_to_connections: :environment do
    type = ConnectionType.find_by_name('author')

    Project.joins(:authors).includes(:authors).where('company_id IS NOT NULL').each do |project|
      project.authors.each do |author|
        connection = project.company.from_connections.build
        connection.to = author
        connection.connection_type = type
        connection.save!
      end
    end
  end

  task fill_name_in_people: :environment do
    Person.all.each do |person|
      person.update_column(:name, [person.first_name, person.middle_name, person.last_name].compact.join(' '))
    end
  end

  task set_types_for_people: :environment do
    Investor.where(actor_type: 'Person').each do |investor|
      investor.actor.update_column(:type_id, 2) #buisiness_angel
    end

    Person.where(type_id: nil).update_all(type_id: 1)
  end
end
