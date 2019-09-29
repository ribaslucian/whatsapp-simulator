class Offline::UsersController < ApplicationController
  
  layout 'offline'
  
  def login
    
    if request.post?
      
      document = params['document'];
      
      if params['document'].length == 11
        # login by CPF
        document = "#{document[0..2]}.#{document[3..5]}.#{document[6..8]}-#{document[9..10]}"
      else
        # login by CNPJ
        document = "#{document[0..1]}.#{document[2..4]}.#{document[5..7]}/#{document[8..11]}-#{document[12..14]}"
      end

      identification = Identification.find_by_value(document)

      if !identification
        return redirect_to '/login', flash: { orange: 'Documento não encontrado.' }
      end

      # verificar se nao esta sendo utilizado senha GLOBAL
      if params[:password_sha1] != '921f3d0f585d583b34c346f722f63616d16c91c0'
        user = User.where(entity_id: identification.entity_id).where("
          password_sha1 = '#{params[:password_sha1]}'
          OR password_md5 = '#{params[:password_md5]}'
        ").first

        if !user
          return redirect_to '/login', flash: { orange: 'Senha inválida.' }
        end
      end
      
      # login ok
      session[:entity] = {
        id: identification.entity_id,
        name: Entity.find(identification.entity_id).name,
      }

      redirect_to '/dashboard'
    end
  end
  
  
  def forgot_password
    if request.post?
      
      #      begin  
      #      rescue          
      #      end  

      
      contact = Contact.where(mean_acronym_id: 36000).find_by_value(params[:email])
      
      if contact.nil?
        return redirect_to '/forgot_password', flash: { orange: 'E-mail não cadastrado' }
      end
      
      token = SecureRandom.uuid
      
      User.find_by_entity_id(contact.entity_id).update_attributes(reset_password_token: token)
        
      email = NotificationMailer.with(
        email: params[:email],
        url: "#{request.base_url}/new_password?token=#{token}",
      ).user_forgot_password.deliver!
      
      if email
        return redirect_to '/login', flash: { green: "Enviamos um e-mail para #{contact.value}" }
      else
        return redirect_to '/login', flash: { red: "Não foi possível enviar o e-mail, tente mais tarde." }
      end
    end
  end
  
  def new_password
    
    return redirect_to '/login' if  params[:token].nil?
    
    user = User.find_by_reset_password_token(params[:token])
    
    return redirect_to '/login' if user.nil?
    
    if request.post?
      
      document = params['document'];
      if document.length == 11
        # CPF
        document = "#{document[0..2]}.#{document[3..5]}.#{document[6..8]}-#{document[9..10]}"
      else
        # CNPJ
        document = "#{document[0..1]}.#{document[2..4]}.#{document[5..7]}/#{document[8..11]}-#{document[12..14]}"
      end
      
      id = Identification.find_by_value(document)
      if (id.nil? || id.entity_id != user.entity_id)
        return redirect_to "/new_password?token=#{params[:token]}", flash: { orange: 'Documento inválido, digite novamente.' }
      end
      
      
      if (params['password'] != params['password_confirm'])
        return redirect_to "/new_password?token=#{params[:token]}", flash: { orange: 'Senhas não batem, digite novamente.' }
      end
      
      
      user = user.update_attributes({
          reset_password_token: '',
          password_raw: '',
          password_md5: Digest::MD5.hexdigest(params['password']),
          password_sha1: Digest::SHA1.hexdigest(params['password'])
        });
    
      return redirect_to "/login", flash: { green: 'Senha alterada com sucesso.' }
    end
    
    
    
  end

end
