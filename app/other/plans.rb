#encoding: utf-8

class Plans
  class << self
    PARAMS = {
        1 => {
            title: 'demo',
            title_ru: 'Демо',
            duration: 14.days,
            connections: 1,
            profiles: 25,
            downloads: 3,
            support_mins: 0,
            monitoring: true,
            mailing: false,
            api: false
        },
        2 => {
            title: 'group',
            title_ru: 'Группа',
            connections: 1,
            profiles: 200,
            downloads: 100,
            support_mins: 0,
            monitoring: true,
            mailing: true,
            api: false
        },
        3 => {
            title: 'business',
            title_ru: 'Бизнес',
            connections: 5,
            profiles: 500,
            downloads: 250,
            support_mins: 30 * 60,
            monitoring: true,
            mailing: true,
            api: false
        },
        4 => {
            title: 'corporate',
            title_ru: 'Корпорация',
            connections: -1,
            profiles: -1,
            downloads: -1,
            support_mins: -1,
            monitoring: true,
            mailing: true,
            api: true
        }
    }

    def get(id)
      @_storage ||= {}
      @_storage[id] ||= self.new(PARAMS[id])
    end

    def active?(user)
      user.plan && user.plan_ends_at && user.plan_ends_at > Time.now
    end

    def can_connect?(user)
      active?(user) && user.used_connections < get(user.plan).connections
    end

    def can_see_profile?(user)
      active?(user) && user.used_profiles_access < get(user.plan).profile
    end

    def can_download?(user)
      active?(user) && user.used_downloads < get(user.plan).download
    end

    def can_use_support?(user)
      active?(user) && user.used_support_mins < get(user.plan).support_mins
    end

    def can_access_monitoring?(user)
      active?(user) && get(user.plan).monitoring
    end

    def can_access_mailing?(user)
      active?(user) && get(user.plan).mailing
    end

    def can_access_api?(user)
      active?(user) && get(user.plan).api
    end

    def for_select
      unless @for_select
        @for_select = {}
        PARAMS.each do |i, param|
          next if i == 1
          @for_select[param[:title_ru]] = i
        end
      end

      @for_select
    end
  end

  MONTHS = {
      '1' => '1 месяц',
      '3' => '3 месяца',
      '6' => '6 месяцев',
      '12' => '1 год',
      '24' => '2 года',
  }

  def initialize(params)
    @params = params
  end

  def method_missing(m)
    @params[m]
  end
end