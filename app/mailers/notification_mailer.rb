class NotificationMailer < ApplicationMailer
  require 'socket'
 
  def protocol_assigned_email
    @name = params[:name]
    # ip=Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
    @url = 'http://ec2-52-67-140-241.sa-east-1.compute.amazonaws.com' #ip.ip_address if ip
    @url  << ":3000/protocols/#{params[:id]}"
    @protocol = params[:code]
    @message = params[:message]
    @type = params[:type]
    mail to: params[:email], subject: "Protocolo #{@protocol} (Área Web)"
  end
 
  def user_forgot_password
    @params = params
    mail to: params[:email], subject: "Recuperar senha Liv"
  end
end
