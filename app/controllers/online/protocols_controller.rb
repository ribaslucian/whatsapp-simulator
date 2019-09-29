class Online::ProtocolsController < ApplicationController
  layout "online"

  def help
    @entity = Entity.find(session[:entity]['id'])
  end

  def help_send
    if params[:type_acronym_id].empty? || params[:message].empty?
      return redirect_to online_help_path, flash: { orange: 'Todos os campos devem ser preenchidos.' }
    end
    year = Date.today.year
    last_protocol = Protocol.select(:code).where("created_at::date >= '#{year}-01-01' AND created_at::date <= '#{year}-12-31'").order(created_at: :desc).first
    code = "001/#{year}"
    if !last_protocol.nil?
      code = "#{last_protocol.code.split("/")[0].to_i + 1}/#{year}".rjust(8, '0')
    end
    protocol = Protocol.create({
      code: code,
      applicant_entity_id: session[:entity]['id'],
      responsible_entity_id: 'b6417740-afb3-42db-bef0-ec0c0e9086ad',
      description: params[:message],
      type_acronym_id: params[:type_acronym_id],
      status_acronym_id: 60000,
      date_open: 'now()',
      registered_entity_id: 'b6417740-afb3-42db-bef0-ec0c0e9086ad'
    })

    if protocol.save
       NotificationMailer.with(
         name: protocol.responsible.name,
         email: 'contato@{email}.com',
         code: protocol.code,
         type: protocol.type,
         message: protocol.description,
         id: protocol.id
       ).protocol_assigned_email.deliver!
       
      return redirect_to online_help_path, flash: { green: 'Recebemos sua requisição! Vamos analisá-la e entramos em contato.' }
    else
      return redirect_to online_help_path, flash: { orange: 'Erro ao salvar requisição. Tente novamente.' }
    end
  end
end
