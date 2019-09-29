class Online::UsersController < ApplicationController
  
  layout 'online'
  
  def logout
    session[:entity] = nil
    redirect_to '/login'
  end
  
  def profile
    
    @entity = Entity.find(session[:entity]['id'])
    
    @entity.build_email if @entity.email.nil?
    @entity.build_phone if @entity.phone.nil?
    
    @form = {password_edit: false}
    
    # identification data
    @name_first = session[:entity]['name'].upcase().strip().split(' ')[0]
    @name_last = session[:entity]['name'].upcase().strip().sub(@name_first, '').strip()[0..20]
  end
  
  def profile_update
    
    params.permit!
    params[:entity][:email_attributes][:mean_acronym_id] = 36000
    params[:entity][:phone_attributes][:mean_acronym_id] = 36001

    @entity = Entity.select(:id).find(session[:entity]['id'])
    @entity.assign_attributes params[:entity]
    
    if @entity.valid?
      if @entity.save!
        redirect_to '/profile', flash: { green: 'Dados atualizados.' }
      else
        redirect_to '/profile', flash: { red: 'Ocorreu um erro, tente novamente mais tarde.' }
      end
    else
      # identification data
      @name_first = session[:entity]['name'].upcase().strip().split(' ')[0]
      @name_last = session[:entity]['name'].upcase().strip().sub(@name_first, '').strip()[0..20]
      
      flash[:orange] = 'Verifique o formulário.'
      render 'profile'
    end
  end
  
  def update_password
    @user = UpdatePassword.new
    
    if request.post?
      params.permit!
      
      @user = UpdatePassword.find_by_entity_id(session[:entity]['id'])
      @user.assign_attributes(params[:update_password])
      
      if @user.valid?
        
        user = User.find_by("(password_sha1 = '#{Digest::SHA1.hexdigest(params[:update_password]['password_raw'])}' OR password_md5 = '#{Digest::MD5.hexdigest(params[:update_password]['password_raw'])}') AND entity_id = '#{session[:entity]['id']}'")
        if !user
          flash[:red] = 'Senha atual não confere. <br/> Verifique todos os campos.'
          return render 'update_password'
        end
        
        user.password_raw = ''
        user.password_md5 = Digest::MD5.hexdigest(params[:update_password]['password_new'])
        user.password_sha1 = Digest::MD5.hexdigest(params[:update_password]['password_new'])
        user.save!
        redirect_to '/profile', flash: { green: 'Dados atualizados.' }
      else
        flash[:orange] = 'Verifique o formulário e preencha os campos novamente.'
      end
      
    end
  end
  
end
