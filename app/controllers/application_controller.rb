class ApplicationController < ActionController::Base
  
  before_action :logged?, :debug
  layout 'offline'
  
  
  def debug
#    flash[:blue] = '
#      Atualizamos a plataforma para melhor sua usabilidade.
#      Possui os mesmo recursos e com maior facilidade de acesso.
#      Qual dúvida ligue (42) 3626-2256.
    #'
    
#    NotificationMailer.with(
#      email: 'ribas.lucian@gmail.com',
#      url: 'https://mail.google.com/mail/u/0/#inbox/FMfcgxwDqTdPgjnjWjRkKmLjkPVKRFTn',
#    ).user_forgot_password.deliver!
#    
#    
#    return d 'ok'
  end
  
  
  
  def json message
    respond_to do |format|
      format.json  { render json: message.to_json }
    end
  end
  
  
  
  
  def d param
    # do something then render view for process_one
    render json: JSON.pretty_generate(JSON.parse(param.to_json))
  end

  
  def logged?
    
    namespace = controller_path.split('/').first
    
    if namespace == 'offline' && session[:entity] != nil
      redirect_to '/dashboard'
    end
    
    if namespace == 'online' && session[:entity] == nil
      flash[:red] = 'Você não está conectado.'
      redirect_to '/login'
    end

    #    if !session[:entity].nil?
    #    end

    #    is_login_route = (request.path == '/' || request.path == '/users/login')
    #    logged = session[:entity] != nil
    #
    #    # return d is_login_route
    #
    #    if is_login_route && logged
    #      redirect_to '/dashboards/primary'
    #    end
    #
    #    if !logged && !is_login_route
    #      redirect_to '/users/login'
    #    end
    
    
    if session[:entity] == nil
      return
    end
    
    
    
  end
  
  
end
