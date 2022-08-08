class Manage::TagsController < Manage::BaseController
  def index
  end

  def show
  end

  def new
  end

  def create
    if @tag.save
      redirect_to manage_tag_path(@tag)
    else
      render 'new'
    end
  end

  def update
    if @tag.update(tag_params)
      redirect_to manage_tag_path(@tag)
    else
      render 'edit'
    end
  end

  def edit
  end

  def destroy
    @tag.destroy
    redirect_to manage_tags_path
  end

  private
    def tag_params
      params.require(:tag).permit(:name)
    end
end