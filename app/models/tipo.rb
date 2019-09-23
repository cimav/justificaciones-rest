class Tipo < ApplicationRecord

  attr_accessor :romano
  attr_accessor :texto

  def romano
    case fraccion
      when 0
        "--"
      when 1
        "I"
      when 3
        "III"
      when 5
        "V"
      when 7
        "VII"
      when 14
        "XIV"
      when 15
        "XV"
      when 17
        "XVII"
    end
  end

  def texto
    self.romano + " " + self.code
  end

end
