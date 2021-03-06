class Admin::Settings::PostTypesController < Admin::SettingsController

  before_action :set_post_type, only: ['show','edit','update','destroy']

  def index

    @post_types = current_site.post_types

    @post_types = @post_types.paginate(:page => params[:page], :per_page => current_site.admin_per_page)

  end

  def show

  end

  def edit
    admin_breadcrumb_add("#{t('admin.button.edit')}")
  end


  def update

    if @post_type.update(params[:post_type])
      @post_type.set_options_from_form(params[:meta]) if params[:meta].present?
      flash[:notice] = t('admin.post_type.message.updated')
      redirect_to action: :index
    else
      render 'edit'
    end
  end


  def create
    data_term = params[:post_type]
    @post_type = current_site.post_types.new(data_term)
    if @post_type.save
      @post_type.set_options_from_form(params[:meta]) if params[:meta].present?
      flash[:notice] = t('admin.post_type.message.created')
      redirect_to action: :index
    else
      render 'edit'
    end
  end

  def destroy
    flash[:notice] = t('admin.post_type.message.deleted') if @post_type.destroy

    redirect_to action: :index
  end

  private


  def set_post_type
      begin
        @post_type = current_site.post_types.find_by_id(params[:id])
      rescue
        flash[:error] = t('admin.post_type.message.error')
        redirect_to admin_path
      end

  end

end
