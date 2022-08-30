class BrandsController < ApplicationController
  # before_action :set_brand, only: %i[show edit update destroy]

  def create
    @brand = Brand.new(brand_params)
    if @brand.save
      flash[:notice] = "Brand Created!"
      redirect_to brands_path
    else
      flash[:notice] = "Brand Not Created..."
      puts brand.errors.messages
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @brands = Brand.all
  end

  private

  def brand_params
    params.require(:brand).permit(:name)
  end

  # method useful for show edit update and destroy
  # def set_brand
  #   @brand = Brand.find(params[:id])
  # end
end
