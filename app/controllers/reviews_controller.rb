class ReviewsController < ApplicationController
  def create
    authenticate_user!
    @vendor = Vendor.find(params[:vendor_id])
    @review = @vendor.reviews.new(review_params)
    @review.user = current_user
    if @review.save
      flash[:notice] = 'Review added.'
      ReviewNotifier.new_review(@review).deliver_later
    else
      flash[:notice] = @review.errors.full_messages
    end
    redirect_to vendor_path(@vendor)
  end

  def destroy
    Review.find(params[:id]).destroy
    Vote.where(review_id: params[:id]).destroy_all
    Comment.where(review_id: params[:id]).destroy_all
    redirect_to "/vendors/#{params[:vendor_id]}"
  end

  private

  def review_params
    params.require(:review).permit(:vendor_id, :body, :rating, :user_id)
  end
end
