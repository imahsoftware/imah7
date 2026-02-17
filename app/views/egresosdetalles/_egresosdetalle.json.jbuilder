json.extract! egresosdetalle, :id, :egreso_id, :concepto, :cantidad, :valor_unitario, :iva, :valor_iva, :subtotal, :total, :user_id, :retencion, :retecre, :claseretencion, :centroscosto_id, :eproveedorescompra_id, :created_at, :updated_at
json.url egresosdetalle_url(egresosdetalle, format: :json)
