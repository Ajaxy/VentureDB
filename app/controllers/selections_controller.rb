class SelectionsController < CabinetController
  before_filter :access, only: %w[edit update destroy]

  # GET /selections/new
  # GET /selections/new.json
  def new
    @selection = Selection.new

    respond_to do |format|
      format.html { render 'form' }
      format.json { render json: @selection }
    end
  end

  # GET /selections/1/edit
  def edit
    render 'form'
  end

  # POST /selections
  # POST /selections.json
  def create
    @selection = Selection.new(permitted_params.selection)
    @selection.user = current_user

    respond_to do |format|
      if @selection.save
        format.html { redirect_to :deals, notice: 'Selection was successfully created.' }
        format.json { render json: @selection, status: :created, location: @selection }
      else
        format.html { render action: "new" }
        format.json { render json: @selection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /selections/1
  # PATCH/PUT /selections/1.json
  def update
    respond_to do |format|
      if @selection.update_attributes(permitted_params.selection)
        format.html { redirect_to :deals, notice: 'Selection was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @selection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /selections/1
  # DELETE /selections/1.json
  def destroy
    @selection.destroy

    render json: { status: :ok }
  end

  private

  def access
    @selection = Selection.find(params[:id])
    redirect_to :deals if @selection.user != current_user
  end
end