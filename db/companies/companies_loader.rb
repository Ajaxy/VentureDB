# encoding: utf-8

class Loader
  COLUMNS = %w[id name scope description creation_date contacts offices
               web founders employees direction profit investments - - -
               - - - suppliers competitors experience competitions accelerators
               need_for_investments]

  attr_reader :data
  attr_reader :errors

  def initialize(data)
    @data       = OpenStruct.new Hash[COLUMNS.zip(data)].except("-")
    @errors     = []
    @companies  = Company.all
  end

  def load!
    project = Project.where(name: data.name).first

    if project
      company = project.company || project.build_company

      company.creation_date         = parse_creation_date
      company.contacts              = parse_contacts
      company.employees             = data.employees
      company.founders              = data.founders
      company.direction             = data.direction

      project.investments_string    = data.investments
      project.suppliers             = data.suppliers
      project.competitors           = data.competitors
      project.experience            = data.experience
      project.competitions          = data.competitions
      project.accelerators          = data.accelerators
      project.need_for_investments  = data.need_for_investments

      project.save!(validate: false)
    else
      errors << "Не удалось найти проект: #{data.name.inspect}"
    end

    if errors.any?
      puts "##{data.id}"
      puts errors
    end
  end

  private

  def parse_contacts
    [data.contacts, data.offices, data.web].compact.join("\n")
  end

  def parse_creation_date
    parse_date(data.creation_date)
  end

  def parse_date(string)
    Date.parse(string)
  rescue
    errors << "Не удалось разобрать дату: #{string.inspect}"
    nil
  end
end
