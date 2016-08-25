class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    if alreadyReviewed?(@restaurant)
      flash[:notice] = 'Restaurant already reviewed'
      redirect_to '/restaurants'
    else
      @review = Review.new
    end
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = @restaurant.reviews.build_with_user(review_params, current_user)
    if @review.save
      redirect_to '/restaurants'
    else
      if @review.errors[:user]
        redirect_to '/restaurants', alert: 'You have already reviewed this restaurant'
      else
        render :new
      end
    end
  end

  private

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end

  def alreadyReviewed?(restaurant)
    @restaurant = Restaurant.find(params[:restaurant_id])
    current_user.has_reviewed?(@restaurant)
  end



end
