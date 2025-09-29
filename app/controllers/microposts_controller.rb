class MicropostsController < ApplicationController
	before_action :logedin_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

	def create
    @micropost =  current_user.microposts.build(require_field)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
    	flash[:success] = "post upload"
    	redirect_to root_url
    else
    	@feed_items = current_user.feed.paginate(page: params[:page])
    	render 'static_pages/home', status: :unprocessable_content
    end 
	end 

	def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
	end 

	private
	def require_field
		params.require(:micropost).permit(:content, :image)
	end 

	def logedin_user
    unless logedin?
      user_rquest_otherpage_store
      flash[:alert] = "first login"
      redirect_to login_path
    end 
  end 

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end
