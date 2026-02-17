class Egresosdetalle < ApplicationRecord
  belongs_to :egreso
  belongs_to :user
  belongs_to :centroscosto
  belongs_to :eproveedorescompra
  belongs_to :eproveedorestemegreso

  def conceptodesc
    if self.eproveedorescompra_id
      pp = Eproveedorescompra.find(self.eproveedorescompra_id)
      if pp.eproveedor_id.to_i == self.egreso.eproveedor_id.to_i
        return 'Abono causación de Factura: ' + self.eproveedorescompra.nro_factura.to_s + ' Fecha: ' + self.eproveedorescompra.fecha.to_s
      else
        return pp.proveedor.nombrecompletor.to_s + '<br/>Abono causación de Factura: ' + self.eproveedorescompra.nro_factura.to_s + ' Fecha: ' + self.eproveedorescompra.fecha.to_s
      end
    else
      return self.concepto.to_s
    end
  end
end
