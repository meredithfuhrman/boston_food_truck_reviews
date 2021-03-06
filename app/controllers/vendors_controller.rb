class VendorsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorize_user!, only: [:destroy]

  def index
    if params[:search]
      @vendors = Vendor.search(params[:search]).order("created_at DESC").page(params[:page]).per(6)
      if @vendors.empty?
        flash[:notice] = "We didn't find anything"
      end
    elsif params[:search].nil?
      @vendors = Vendor.where(viewable: true).page(params[:page]).per(6)
    end
    @new_vendor = Vendor.new
    @approvals = Vendor.where(viewable: false)
    @pending_owners = Vendor.where(claimed_status: "Pending")
  end

  def show
    @vendor = Vendor.find(params[:id])
    @reviews = @vendor.reviews
    @review = Review.new
    @vote = Vote.new
    @comment = Comment.new
  end

  def create
    @vendor = Vendor.create(vendor_params)
    @vendor.viewable = false
    if @vendor.save
      flash[:notice] = "Vendor added. Pending review."
      redirect_to vendors_path
    else
      flash[:notice] = "Invalid entry"
      redirect_to :back
    end
  end

  def update
    @vendor = Vendor.find(params[:id])
    params["user"] = current_user
    if Vendor.approval(params) == "Vendor"
      Vendor.approve(@vendor)
      flash[:notice] = "Vendor Updated"
    elsif Vendor.approval(params) == "Ownership"
      flash[:notice] = Vendor.ownership_decision(params)
    end
    redirect_to vendors_path
  end

  def destroy
    Vendor.find(params[:id]).destroy
    flash[:notice] = "Vendor Deleted"
    redirect_to vendors_path
  end

  protected
  def vendor_params
    params.require(:vendor).permit(:vendor_name, :claimed_status)
  end
end
