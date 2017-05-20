class GramsController < ApplicationController
  def new
    @gram = Gram.new
  end

  def index
  end

  def create
    @gram = Gram.create(gram_params)
    redirect_to root_path
  end

  private

  def gram_params
    params.require(:gram).permit(:message)
  end

end