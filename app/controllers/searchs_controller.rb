class SearchsController < ApplicationController
  skip_authorization_check

  def search
    if params[:search_class] == "all"
      @search_list = ThinkingSphinx.search(params[:q])
    else
      @search_list = params[:search_class].capitalize.constantize.search(params[:q])
    end
  end
end