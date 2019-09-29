class Api::AuthorizersController < ApplicationController

  def authorize

    # sleep 2;
    # return render json: {params: params}



    ## check requisition data integrity

      if !request.format.json?
        return render json: {error: true, message: 'bad'}
      end

      # if has beein request
      if !params.include?(:request)
        return render json: {error: true, message: 'missing_requisition_data'}
      end

      # required :identification_layer fields
      if !(['actions'] - params[:request].keys).empty?
        return render json: {error: true, message: 'missing_requested_fields'}
      end

      # if !ApiKey.exists?(uuid: params[:request][:key])
      #   return render json: {error: true, message: 'invalid_key'}
      # end

    # if there is at least one field of the :actions_layer
    # if !['find', 'create', 'update'].any? { |k| params[:request][:actions].has_key? k }
    #   return render json: {error: true, message: 'missing_actions_fields'}
    # end

    params.permit!
    results = include = {}

    params[:request][:actions].each do |model, options|
      results = model.classify.constantize

      options.each do |option, value|
        if option == 'include'
          if !['ActionController::Parameters', 'Array'].include?(value.class.name)
            (return render json: {error: true, message: 'invalid_include'})
          end

          value = value.to_h if value.class.name == 'ActionController::Parameters'
          results.includes include = value
        elsif options == 'joins'
          return render json: 'ok'
          results = result.joins(value.to_sym)
        else
          # null value is not a param
          results = (value.nil? || value == '') ? results.send(option) : results.send(option, value)
        end
      end
    end

    if results.kind_of? ApplicationRecord
      # results = {error: false}
    elsif results.kind_of? ActiveRecord::Relation
      results = {error: false, results: results}
    end

    # if results == false || results == {} || results == []
    #   include = {}
    # end

    return render json: results, include: include
  end

end
