class Online::DashboardsController < ApplicationController
  layout 'online'
  
  def primary
    @name_first = session[:entity]['name'].upcase().strip().split(' ')[0]
    @name_last = session[:entity]['name'].upcase().strip().sub(@name_first, '').strip()[0..20]
  end
end
