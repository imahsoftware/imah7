class Archivo < ApplicationRecord
  belongs_to :user
  has_attached_file :documentos
  validates_attachment_content_type :documentos, content_type: /\A*\/.*\Z/
  validates_attachment_size :documentos, :less_than => 15000.kilobytes, :message=>"El tamaño del archivo no puede ser superior de 10 Megabytes"

  def self.import(path, is_portafolio, archivoId, *args)
    # MARK 3
    archivo = Archivo.find(archivoId)
    migracion = Migracion.where(["nombre_resultado = '#{archivo.migracion.to_s}'"]).first
    validaCaracteres = migracion.valida.split(",") rescue nil
    headers = []
    migracion.migracionescampos.order("orden asc").each do |m|
      headers << m.campo
    end
    spreadsheet = Roo::Spreadsheet.open(path)
    migrep = []
    spreadsheet.each_with_index do |row, idx|
      next if idx == 0 # skip header row
      # create hash from headers and cells
      #puts idx
      user_data = Hash[[headers, row].transpose]
      user_data["user_id"] = archivo.user_id
      user_data["archivo_id"] = archivo.id
      if args[0] == 'TAREASACTIVIDADES'
        user_data["tarea_id"] = args[1].to_i
      end

      if ['migracionesreportes','migracionescrmes','migracionesnuevos'].include?(migracion.nombre_resultado.to_s)
        user_data["portafolio_id"] = archivo.portafolio_id.to_s
      end
      if migracion.nombre_resultado.to_s == 'migracionessedes'
        user_data["contrato_id"] = archivo.datoid
      end
      validaCaracteres.each do |d|
        user_data[d.to_s] = mdlRemoveCaracter(user_data[d.to_s]).to_s
      end
      #puts user_data
      if migracion.nombre_resultado.to_s == 'migracionesreportes'
        migra = Migracionesreporte.new(user_data)
      elsif migracion.nombre_resultado.to_s == 'migracionescrmes'
        migra = Migracionescrm.new(user_data)
      elsif migracion.nombre_resultado.to_s == 'migracionesnuevos'
        migra= Migracionesnuevo.new(user_data)
      elsif migracion.nombre_resultado.to_s == 'migracionesinsumos'
        migra= Migracionesinsumo.new(user_data)
      elsif migracion.nombre_resultado.to_s == 'migracionesrodamientos'
        migra= Migracionesrodamiento.new(user_data)
      elsif migracion.nombre_resultado.to_s == 'migracionesnovedades'
        migra = Migracionesnovedad.new(user_data)
      elsif migracion.nombre_resultado.to_s == 'migracionessupervisores'
        migra = Migracionessupervisor.new(user_data)
      elsif migracion.nombre_resultado.to_s == 'migracionescontratos'
        migra = Migracionescontrato.new(user_data)
      elsif migracion.nombre_resultado.to_s == 'migracionesprorrogas'
        migra = Migracionesprorroga.new(user_data)
      elsif migracion.nombre_resultado.to_s == 'migracionesterminaciones'
        migra = Migracionesterminacion.new(user_data)
      elsif migracion.nombre_resultado.to_s == 'migracionespersonas'
        migra = Migracionespersona.new(user_data)
      elsif migracion.nombre_resultado.to_s == 'migracionespersonas2'
        migra = Migracionespersona.new(user_data)
      elsif migracion.nombre_resultado.to_s == 'migracionesexamenes'
        migra = Migracionesexamen.new(user_data)
      elsif migracion.nombre_resultado.to_s == 'migracionesestados'
        migra = Migracionesestado.new(user_data)
      elsif migracion.nombre_resultado.to_s == 'migracionescuentas'
        migra = Migracionescuenta.new(user_data)
      elsif migracion.nombre_resultado.to_s == 'migracionestelefonos'
        migra = Migracionestelefono.new(user_data)
      elsif migracion.nombre_resultado.to_s == 'migracionesactividades'
        migra = Migracionesactividad.new(user_data)
      elsif migracion.nombre_resultado.to_s == 'migracionestallas'
        migra = Migracionestalla.new(user_data)
      elsif migracion.nombre_resultado.to_s == 'migracionessedes'
        migra = Migracionessede.new(user_data)
      end
      migrep << migra
      #puts user_data
      next
    end
    if migracion.nombre_resultado.to_s == 'migracionesreportes'
      imported_obj = Migracionesreporte.import migrep, recursive: true, validate: false
    elsif migracion.nombre_resultado.to_s == 'migracionescrmes'
      imported_obj = Migracionescrm.import migrep, recursive: true, validate: false
    elsif migracion.nombre_resultado.to_s == 'migracionesnuevos'
      imported_obj = Migracionesnuevo.import migrep, recursive: true, validate: false
    elsif migracion.nombre_resultado.to_s == 'migracionesinsumos'
      imported_obj = Migracionesinsumo.import migrep, recursive: true, validate: false
    elsif migracion.nombre_resultado.to_s == 'migracionesrodamientos'
      imported_obj = Migracionesrodamiento.import migrep, recursive: true, validate: false
    elsif migracion.nombre_resultado.to_s == 'migracionesnovedades'
      imported_obj = Migracionesnovedad.import migrep, recursive: true, validate: false
    elsif migracion.nombre_resultado.to_s == 'migracionessupervisores'
      imported_obj = Migracionessupervisor.import migrep, recursive: true, validate: false
    elsif migracion.nombre_resultado.to_s == 'migracionescontratos'
      imported_obj = Migracionescontrato.import migrep, recursive: true, validate: false
    elsif migracion.nombre_resultado.to_s == 'migracionesprorrogas'
      imported_obj = Migracionesprorroga.import migrep, recursive: true, validate: false
    elsif migracion.nombre_resultado.to_s == 'migracionesterminaciones'
      imported_obj = Migracionesterminacion.import migrep, recursive: true, validate: false
    elsif migracion.nombre_resultado.to_s == 'migracionespersonas'
      imported_obj = Migracionespersona.import migrep, recursive: true, validate: false
    elsif migracion.nombre_resultado.to_s == 'migracionespersonas2'
      imported_obj = Migracionespersona.import migrep, recursive: true, validate: false
    elsif migracion.nombre_resultado.to_s == 'migracionesexamenes'
      imported_obj = Migracionesexamen.import migrep, recursive: true, validate: false
    elsif migracion.nombre_resultado.to_s == 'migracionesestados'
      imported_obj = Migracionesestado.import migrep, recursive: true, validate: false
    elsif migracion.nombre_resultado.to_s == 'migracionescuentas'
      imported_obj = Migracionescuenta.import migrep, recursive: true, validate: false
    elsif migracion.nombre_resultado.to_s == 'migracionestelefonos'
      imported_obj = Migracionestelefono.import migrep, recursive: true, validate: false
    elsif migracion.nombre_resultado.to_s == 'migracionesactividades'
      imported_obj = Migracionesactividad.import migrep, recursive: true, validate: false
    elsif migracion.nombre_resultado.to_s == 'migracionestallas'
      imported_obj = Migracionestalla.import migrep, recursive: true, validate: false
    elsif migracion.nombre_resultado.to_s == 'migracionessedes'
      imported_obj = Migracionessede.import migrep, recursive: true, validate: false
    end
  end

  def self.importcce(path, is_portafolio, archivoId)
    @archivo = Archivo.find(archivoId)
    name =  @archivo.documentos_file_name
    extensionarchivo = name.slice(name.rindex("."), name.length).downcase
    if extensionarchivo == ".xlsx" or extensionarchivo == ".xls" or extensionarchivo == ".xlsb"
      spreadsheet = Roo::Spreadsheet.open(path, extension: extensionarchivo)
      spreadsheet.sheets.each do |sheet|
        #puts 'name... ' + name.to_s
        if ['INSUMOS','MAQUINARIA'].include?(sheet)
          hoja = spreadsheet.sheet(sheet)
          cant = 0
          i = 0
          f = 0
          c = 0
          migrep = []
          while f <= 250
            if hoja.row(f)[0].to_s != "" and hoja.row(f)[0].to_s != "ITEM" and hoja.row(f)[4].to_f > 0
              if hoja.row(f)[0].to_i > 0
                idinsumo = Insumo.where(id_cce_2023: hoja.row(f)[0].to_i)[0].id rescue nil
              end
              cargue = Migracionesinsumo.new(contrato_id:@archivo.datoid, archivo_id:@archivo.id, user_id:@archivo.user_id,
                                             insumo_id: idinsumo, #hoja.row(f)[0],
                                             cantidad_mensual: hoja.row(f)[4].to_f,
                                             precio_unitario: hoja.row(f)[5].to_f,
                                             descuento: (hoja.row(f)[6].to_f * 100),
                                             precio_condescuento: hoja.row(f)[7].to_f,
                                             total: hoja.row(f)[7].to_f)
              migrep << cargue
            end
            f = f + 1
          end
          imported_obj = Migracionesinsumo.import migrep, recursive: true, validate: false
        end
      end
    end
  end

  def self.importncce(path, is_portafolio, archivoId)
    @archivo = Archivo.find(archivoId)
    name =  @archivo.documentos_file_name
    extensionarchivo = name.slice(name.rindex("."), name.length).downcase
    if extensionarchivo == ".xlsx" or extensionarchivo == ".xls" or extensionarchivo == ".xlsb"
      spreadsheet = Roo::Spreadsheet.open(path, extension: extensionarchivo)
      spreadsheet.sheets.each do |sheet|
        #puts 'name... ' + name.to_s
        hoja = spreadsheet.sheet(sheet)
        cant = 0
        i = 0
        f = 0
        c = 0
        migrep = []
        while f <= 250
          if hoja.row(f)[0].to_s != ""
            cargue = Migracionesinsumo.new(contrato_id:@archivo.datoid, archivo_id:@archivo.id, user_id:@archivo.user_id,
                                           item: hoja.row(f)[0],
                                           cantidad_mensual: hoja.row(f)[1].to_f,
                                           precio_unitario: hoja.row(f)[2].to_f)
            migrep << cargue
          end
          f = f + 1
        end
        imported_obj = Migracionesinsumo.import migrep, recursive: true, validate: false
      end
    end
  end


=begin
  def self.import(path, is_portafolio, archivoId)
    # MARK 3
    archivo = Archivo.find(archivoId)
    migracion = Migracion.where(["nombre_resultado = '#{archivo.migracion.to_s}'"]).first
    migracioncampos = migracion.camposselect
    cantcampos = migracion.migracionescampos.count.to_i
    cr = 0
    cadena = []
    cadena2 = []
    a = 0
    sql2 = ""
    encabezado = " insert into #{migracion.nombre_resultado.to_s} (created_at,updated_at,user_id,archivo_id,portafolio_id,#{migracioncampos}) values "
    spreadsheet = Roo::Spreadsheet.open(path)
    (spreadsheet.first_row+1..spreadsheet.last_row).each do |i|
      a = 0
      cadena2 = []
      while a < cantcampos
        # Aqiui falta validar el formato del campo...
        cadena2.push "'"+spreadsheet.row(i)[a].to_s+"'"
        a = a + 1
      end
      sql2 = ""
      sql2 << cadena2.join(",")
      cadena.push " (now(),now(),#{archivo.user_id},'#{archivo.id}','#{archivo.portafolio_id}',#{sql2} )"
      cr = cr + 1
      if cr == 50
        self.save_data(encabezado,cadena)
        cadena = []
        cadena2 = []
        cr = 0
      end
    end

    if not cadena.empty?
      self.save_data(encabezado,cadena)
      cadena.clear
      cadena2.clear
    end
  end

  # MARK unico de cargue MYSQL
  def self.save_data(encabezado, registros)
    sql = ""
    sql = encabezado + ' ' + registros.join(",")
    res = ActiveRecord::Base.connection.execute(sql)
  end
=end

end
