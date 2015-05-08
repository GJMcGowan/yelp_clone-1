class RestaurantsController < ApplicationController
  before_action :authenticate_user!, :except => [:index, :show]

  def index
    @restaurants = Restaurant.all
  end

  def new
    @restaurant = Restaurant.new
  end

  def restaurant_params
    params.require(:restaurant).permit(:name)
  end

  def create
    @restaurant = current_user.restaurants.new(restaurant_params)
    if @restaurant.save
      redirect_to restaurants_path
    else
      render 'new'
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    @params = @restaurant.user_id
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.user_id == current_user.id
      @restaurant = Restaurant.find(params[:id])
    else
      flash[:notice] = 'You can only edit stuff you made'
      redirect_to '/restaurants'
    end
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    @restaurant.update(restaurant_params)
    redirect_to '/restaurants'
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.user_id == current_user.id
      @restaurant.destroy
      flash[:notice] = 'Restaurant deleted succesfully'
      redirect_to '/restaurants'
    else
      flash[:notice] = 'You can only delete stuff you made'
      redirect_to '/restaurants'
    end
  end
end
