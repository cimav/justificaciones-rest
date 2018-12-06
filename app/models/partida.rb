class Partida < ApplicationRecord

  attr_accessor :texto

  def texto
    "#{self.id} #{self.nombre}"
  end

end
