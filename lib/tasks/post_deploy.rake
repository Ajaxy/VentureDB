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
      investor.actor.update_column(:type_id, 2) #business_angel
    end

    Person.where(type_id: nil).update_all(type_id: 1)
  end


  task move_projects_to_companies: :environment do
    Project.all.each do |project|
      company             = project.company || Company.new
      company.name        = project.name
      company.description = project.description
      company.type_id     = Company::TYPE_INNOVATION_ID
      company.save!
      project.update_column(:company_id, company.id)
    end
  end

  task move_scopes_and_locations_from_project_to_company: :environment do
    Project.all.each do |project|
      company = project.company

      project.project_scopes.each do |project_scope|
        company.company_scopes.create! scope_id: project_scope.scope_id
      end

      project.location_bindings.each do |project_location_binding|
        company.location_bindings.create! location_id: project_location_binding.location_id
      end
    end
  end

  task set_investor_type_id_for_non_project_companies: :environment do
    Company.where(type_id: nil).each do |company|
      type_id = company.project.present? ?
        Company::TYPE_INNOVATION_ID : Company::TYPE_INVESTOR_ID
      company.update_column :type_id, type_id
    end
  end

  task update_company_ids_in_deals: :environment do
    Deal.all.each do |deal|
      deal.update_column(:company_id, deal.project.company.id)
    end
  end

  task create_more_connection_types: :environment do
    ConnectionType.create! source_class: 'Person', receiver_class: 'Company',
      direct_name: 'Член органов управления', reverse_name: 'Член органов управления'
    ConnectionType.create! source_class: 'Person', receiver_class: 'Company',
      direct_name: 'Эксперт среди сотрудников и участников', reverse_name: 'Эксперт среди сотрудников и участников'
    ConnectionType.create! source_class: 'all', receiver_class: 'all',
      direct_name: 'Партнер', reverse_name: 'Партнер'
    ConnectionType.create! source_class: 'all', receiver_class: 'all',
      direct_name: 'Член ассоциации', reverse_name: 'Член ассоциации'
    ConnectionType.create! source_class: 'all', receiver_class: 'all',
      direct_name: 'Исследования и публикации', reverse_name: 'Исследования и публикации'
    ConnectionType.create! source_class: 'all', receiver_class: 'all',
      direct_name: 'Дочернее сообщество', reverse_name: 'Дочернее сообщество'
    ConnectionType.create! source_class: 'all', receiver_class: 'all',
      direct_name: 'Учредитель', reverse_name: 'Учредитель'
    ConnectionType.create! source_class: 'all', receiver_class: 'all',
      direct_name: 'Дургая связь', reverse_name: 'Дургая связь'
  end

  task add_employee_connection_type: :environment do
    ConnectionType.create! source_class: 'Person', receiver_class: 'Company',
      direct_name: 'Сотрудник в', reverse_name: 'Сотрудник'
  end
end
