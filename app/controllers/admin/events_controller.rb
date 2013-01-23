# encoding: utf-8

class Admin::EventsController < Admin::BaseController
  before_filter :find_event, only: [:show, :edit, :update, :destroy]

  def index
    scope    = paginate Event.scoped
    @events  = PaginatingDecorator.decorate scope
  end

  def show
    render :edit
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(permitted_params.event)

    if @event.save
      redirect_to [:admin, @event], notice: "Мероприятие успешно добавлено."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @event.update_attributes(permitted_params.event)
      redirect_to [:admin, @event], notice: "Событие успешно обновлено."
    else
      render :edit
    end
  end

  private

  def find_event
    @event = Event.find(params[:id])
  end
end
