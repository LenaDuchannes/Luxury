class ItemsController < ApplicationController
  before_action :set_items, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:index, :show]
  def index
    # raise
    @items = policy_scope(Item)
    if params[:category].present? && params[:query].present?
      # @items = policy_scope(Item.where(category: params[:category]))
      @items = @items.search_by_name(params[:query]).where(category: params[:category])
    elsif params[:query].present?
      @items = @items.search_by_name(params[:query])
    elsif params[:category].present?
      @items = @items.where(category: params[:category])
      # @items = policy_scope(Item.where(brand: "%#{params[:brand]}%", category: params[:category]))
    end
  end

  def show
    @rental = Rental.new
    authorize @item
  end

  def new
    @item = Item.new
    authorize @item
  end

  def create
    @item = Item.new(item_params)
    authorize @item
    @item.user = current_user
    if @item.save
      redirect_to item_path(@item)
    else
      render :new
    end
  end

  def edit
    authorize @item
  end

  def update
    authorize @item
    if @item.update
      redirect_to item_path(@item)
    else
      render :edit
    end
  end

  def destroy
    authorize @item
    @item.destroy
    redirect_to items_path
  end

  private

  def set_items
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :category, :brand, :price, :description, :address, :user_id, :photo)
  end
end
