class Api::V1::RestaurantsController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User, except: %i[index show]

  before_action :set_restaurant, except: %i[index create]
  def index
    if params[:search].present?
      @restaurants = policy_scope(Restaurant).where('name ILIKE ?', "%#{params[:search]}%")
    else
      @restaurants = policy_scope(Restaurant).per_page(20).page(params[:page])
    end
  end

  def show; end

  def update
    if @restaurant.update(restaurant_params)
      render :show
    else
      render_error
    end
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user = current_user
    authorize @restaurant

    if @restaurant.save
      render :show
    else
      render_error
    end
  end

  def destroy
    @restaurant.destroy

    # render nothing: true
    head :no_content
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
    authorize @restaurant
  end

  def restaurant_params
    params.require(:restaurant).permit(:name, :address)
  end

  def render_error
    render json: { errors: @restaurant.errors.full_messages },
           status: :unprocessable_entity
  end
end
