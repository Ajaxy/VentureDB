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
      direct_name: 'Участвовал при создании', reverse_name: 'Создавалась при участии'
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
    type = ConnectionType.find_by_direct_name('Участвовал при создании')

    Project.joins(:authors).includes(:authors).where('company_id IS NOT NULL').each do |project|
      project.authors.each do |author|
        connection = project.company.from_connections.build
        connection.to = author
        connection.connection_type = type
        connection.save!
      end
    end
  end
end
