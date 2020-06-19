class Justificacion < ApplicationRecord

  belongs_to :tipo
  belongs_to :moneda
  belongs_to :partida

  has_many :proveedores

  belongs_to :creador, class_name: 'Empleado',  foreign_key: :creador_id
  belongs_to :autorizo, class_name: 'Empleado',  foreign_key: :autorizo_id
  belongs_to :elaboro, class_name: 'Empleado',  foreign_key: :elaboro_id
  belongs_to :asesor, class_name: 'Empleado',  foreign_key: :asesor_id

  attr_accessor :biensServicios, :creador_cuenta_cimav

  mount_uploaders :anexos, AnexoUploader
  serialize :anexos

  def biensServicios
    if bien_servicio == 0
      return 'bienes'
    end
    return 'servicios'
  end

  def mostrar72
    [14,17].include?(self.tipo.fraccion) ? "y 72" : ""
  end

  def creador_cuenta_cimav
    creador.cuenta_cimav
  end


end
