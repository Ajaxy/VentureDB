# encoding: utf-8

module InvestorActor
  extend ActiveSupport::Concern

  included do
    has_many :investors, as: :type
    has_many :investments, through: :investors
    
    has_many :investments, as: :investor_entity
    has_many :deals, through: :investments
    has_many :projects, through: :deals
    has_many :scopes, through: :projects
  end

  module ClassMethods
    def in_location(location)
      joins{locations}.where{(locations.lft >= location.lft) &
                             (locations.lft < location.rgt)}
    end

    def suggest(string)
      return scoped unless string.present?
      search = "%#{string}%".gsub('.','_')

      where{ name.like(search) }
    end

    def in_round(round)
      joins{deals.outer}.where{(deals.round_id == round) & (deals.published == true)}
    end

    def in_stage(stage)
      joins{deals.outer}.where{(deals.stage_id == stage) & (deals.published == true)}
    end

    def in_scope(scope)
      joins{deals.project.scopes}
        .where{deals.published == true}
        .where{(scopes.lft >= scope.lft) & (scopes.lft < scope.rgt)}
    end

    def in_scopes(scope_arr)
      joins{deals.project.scopes}
        .where{deals.published == true}
        .where{scopes.id.in scope_arr}
    end

    def in_rounds(rounds)
      joins{deals.outer}.where{(deals.round_id.in rounds) & (deals.published == true)}
    end

    def in_stages(stages)
      joins{deals.outer}.where{(deals.stage_id.in stages) & (deals.published == true)}
    end

    def in_types(types)
      ids = Investment::GRANT_INSTRUMENTS
      case types
      when '1'
        deal_types = joins{investments}.where{coalesce(investments.instrument_id, 0).not_in ids}
      when '2'
        deal_types = joins{investments}.where{investments.instrument_id.in ids}
      else
        scoped
      end
      deal_types.joins{deals.outer}.where{(deals.published == true)}
    end

    def from_date(from)
      joins{deals.outer}.where{deals.published == true}
        .where('? < investments.created_at', from)
    end

    def till_date(till)
      joins{deals.outer}.where{deals.published == true}
        .where('investments.created_at < ?', till)
    end

    def sort_type(type)
      case type
      when '1'
        order_by_investments
      when '2'
        order_by_name('ASC')
      end
    end

    def order_by_type(direction)
      order("type_id #{direction}")
    end

    def order_by_full_name(direction)
      order("full_name #{direction}")
    end

    def order_by_investments
      joins{deals.outer}.order("deals_count DESC")
    end
  end
end
