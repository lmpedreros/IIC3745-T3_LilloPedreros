class ApplicationController < ActionController::Base
  # Clase base para todos los controladores de la aplicación.
  #
  # Aquí puedes agregar métodos y comportamientos comunes a todos los controladores.
  #
  # @see ActionController::Base
  # @abstract

  # Rescata la excepción CanCan::AccessDenied y maneja la respuesta en consecuencia.
  #
  # Si se produce un AccessDenied, se envía una respuesta JSON con estado "forbidden".
  # Si la solicitud es HTML, se redirige al path raíz y se muestra una alerta al usuario.
  #
  # @param [CanCan::AccessDenied] exception La excepción CanCan::AccessDenied lanzada.
  # @return [void]
  #
  # @example
  #   rescue_from CanCan::AccessDenied do |exception|
  #     # Manejo de la excepción...
  #   end
  #
  rescue_from CanCan::AccessDenied do |_exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to root_path, alert: 'No estás autorizado para acceder a esta página' }
    end
  end
end
