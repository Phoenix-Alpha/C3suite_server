module Response
  def json_response(object, include = {}, status = :ok)
    render json: object.as_json(include: include), status: status
  end
end