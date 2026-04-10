Rails.application.routes.draw do

  mount ActionCable.server => '/cable'

  # config/routes.rb — agregar dentro de Rails.application.routes.draw do

  resources :interventorias do
    collection do
      get  :buscar
      get  :validar
      delete :borrar
      get  :etapar
      get  :visualizar
      get  :visualizarfinal
      get  :visualizaracum
      get  :informe_indicadores
      post :envio
      get :verificacion
      get :revisioninter
      post :aprobar
      post :rechazar
      post :actualizacionact
      resources :interactividades
    end

    member do
      get  :revisioninter
      get  :revisionfinal
      get  :verificacionfinal
      get  :verificacion
      get  :firmar_digital
      get  :aprobargh_modal
      get  :rechazargh_modal
      get  :rechazarghfinal_modal
      get  :aprobarghfinal_modal
      get  :aprobarcont_modal
      get  :aprobar_supervisor_gh_modal
      get  :rechazar_supervisor_gh_modal
      post :envio
      post :enviofinalgh
      post :enviofinalint
      post :aprobarint
      post :rechazarint
      post :aprobar
      post :rechazar
      post :enviogh
      post :aprobargh
      post :rechazargh
      post :aprobarghfinal
      post :rechazarghfinal
      post :aprobarcont
      post :rechazarcont
      post :firmar_informes
      post :validaresp
      post :recalcular_retencion
      post :obs_calculofinal
      post :recargar_actividades
      post :generar_otp_supervisor_gh
      post :aprobar_supervisor_gh
      post :rechazar_supervisor_gh
      post :generar_otp_contabilidad
    end
  end

  resources :interactividades do
    resources :interactimagenes
    member do
      get  :cargue_documentos
      get  :cargue_observaciones
      post :update_observation
    end
    collection do
      post :update_observation
      get  :cargue_documentos
      get  :cargue_observaciones
    end
  end

  resources :interactimagenes
  resources :interactobservaciones do
    collection do
      get :verificar
      get :verificacion
    end
  end
  resources :interbitacoras



  resources :notificacionesplataformas, only: [:index] do
    member do
      patch :marcar_como_leida
    end
    collection do
      patch :marcar_todas_como_leidas
      get :contador  # ← AGREGAR ESTA LÍNEA
    end
  end


  resources :iparametrosformatos
  resources :formatos do
    collection do
      get :etapar
      get :preliminar
      get 'clonar'
    end
    resources :formatosvariables
  end

  resources :variables
  resources :migracionessedes
  resources :migracionestallas
  resources :veriserviciosasoportes
  resources :veriserviciosinotas do
    collection do
      post :create2
    end
  end

  resources :veriserviciosiimagenes do
    collection do
      get :captura
      get :captura_trasera
      post :create2
    end
  end

  resources :veriserviciosicompromisos do
    collection do
      post :create2
    end
  end

  resources :veriserviciositems do
    resources :veriserviciosinotas
    resources :veriserviciosicompromisos
    resources :veriserviciosiimagenes
    patch 'update_items', on: :member
    collection do
      post :captura_imagen
      get :nota
      get :item
      get :show_detalle
      get :compromiso
      get :documento
    end
  end

  resources :veriserviciosusers do
    collection do
      get :otp
      post :captura_otp
    end
  end

  resources :veriserviciosagendas do
    resources :veriserviciosasoportes
    resources :veriserviciosusers
    collection do
      get :prueba_pdf_hichart
      get :show_detalle
      get :usuarios
      get :conclusion
    end
  end

  resources :veriservicios do
    resources :veriserviciositems
    resources :veriserviciosagendas
    resources :veriserviciosusers
      collection do
      get :get_contratossede_id
      get :formatoPdf
      get :show_detalle
      get :dash
      get :verificacion
    end
  end

  resources :contratossoleppscontroles
  resources :visitashallazgos do
    collection do
      get :captura
      post :captura_imagen
    end
  end

  resources :compromisos do
    collection do
      get :finalizar
      get :cargar
      get :ver_documentos
      get :estado
    end
  end

  get 'combine_pdfs', to: 'pdf#combine_pdfs'
  get 'descargar_informe_combinado', to: 'pdf#descargar_informe_combinado'

  resources :contratosperinvactas
  resources :usersparametros
  resources :contratosenteppsfirmas
  resources :contratossoleppsatenciones do
    collection do
      get :otp
      post :captura_otp
    end
  end

  resources :contratossoleppsdocs
  resources :contratosperdetallesdocs
  resources :contratosperinvatenciones do
    collection do
      get :otp
      post :captura_otp
    end
  end

  resources :contratosperinvdetalles do
    resources :contratosperdetallesdocs
    collection do
      post :update2
      get :marcar
      get :show_detalle
      get :fotoweb
      post 'captura_web'
    end
  end

  resources :contratosperinventarios do
    resources :contratosperinvdetalles
    resources :contratosperinvatenciones
    resources :contratosperinvnotas
    collection do
      get :acta
      get :cerrar_acta
      post 'captura_web'
      get :otp
      post :captura_otp
      get :otp3
      post :captura_otp3
      get :visualizar
      get :complemento
      get :devolucion
    end
  end

  resources :contratosperdotaciones do
    resources :contratosperdotadicionales
    collection do
      get :entregar_todo
      get :carta_dotacion
      get :carta_dotacione
      get :carta_dotacion_todos
      get 'marcar'
      get :entrega_anticipada
      get :searchdotacion_todo
      get :otp
      post :captura_otp
      get :firmar_entrega
      get :otros
    end
  end

  resources :contratosentepps do
    resources :contratosenteppsdetalles
    collection do
      get :firmados
      get :show_contrato
      get :informegeneral_contrato
      get :control_empresa
      get :periodos_contrato
      get :informepdf
      get :rotulo
      get :otp
      post :captura_otp
      get :etapar
      get :ver
      get :estado
      get :formato
      get :gestion
      get :complementar
      get :show_detalle_epps
      get :show_detalle_usuario
      get :dash_epps
    end
  end

  resources :contratossoleppsdetalles do
    patch 'update2', on: :member
  end

  resources :contratossolepps do
    resources :contratossoleppsdocs
    resources :contratossoleppsdetalles
    resources :contratossoleppsbitacoras
    resources :contratossoleppsatenciones
    collection do
      get :periodos_contrato
      get :procesos
      get :etapar
      get :rotulo
      get :otp
      post :captura_otp
      get :etapar
      get :ver
      get :estado
      get :formato
      get :gestion
      get :complementar
    end
  end

  resources :usersvisitas do
    collection do
      get :searchUsuarios
    end
  end

  resources :evaluacionesejecucionesdocs do
    collection do
      get :eliminar
    end
  end

  resources :evaluacionesejecuciones do
    resources :evaluacionesejecucionesdocs
    collection do
      get :agregar_a_contrato
      get :actividades_pdf
      get :actividades_pdf_completo
      post :update_resultado
      get :finalizar
      get :finalizar_prueba
      get :cargar
      get :proceso
    end
  end

  resources :evaluaciones do
    resources :evaluacionesdetalles
    resources :evaluacionescontratos
    collection do
      get :informepdf
      get :ver_grafica_clases
      get :ver_grafica_usuarios
      get :search
      get :ver_grafica_general
      get :mostrar_evaluacion
      get :abrir_evaluacion
      get :abrir_evaluacion2
      get :gestion
      get :gestion_prueba
      get :detec
      get 'contrato'
      get :clonar
      get :incluirtodos
      get :agregar_usuario
      get :mostrar_evaluacion_prueba
    end
  end

  resources :evaluacionescontratos do
    collection do
      get :cancelar
      get :show_detalle_resultado
      get :cerrar_capacitacion
      post :captura_otp
      get :otppp
      post :captura_otppp
      get :evaluacion_pdf
      get :estado_juridico
    end
  end

  resources :evaluacionesdetalles do
    collection do
      get :cancelar
    end
  end

  resources :visitassedes
  resources :soportesnotasimagenes

  resources :soportesnotas do
    resources :soportesnotasimagenes
    collection do
      get :documento
    end
  end

  resources :soportes do
    collection do
      get :finalizar
    end
    resources :soportesnotas
  end

  resources :visitasdocs do
    collection do
      post :create2
      get :captura
      get :captura_trasera
      post :captura_imagen
    end
  end

  resources :bitacoraprocesos
  resources :contratosperprocitaciones do
    collection do
      get :notificarcitacion
      get :otp
      get :otp2
      post :captura_otp
      post :captura_otp2
    end
  end

  resources :contratosperprodescargos do
    collection do
      get :otp
      post :captura_otp
      get :otp2
      post :captura_otp2
    end
  end

  resources :contratosperprosanciones do
    collection do
      get :otp
      post :captura_otp
      get :otp2
      post :captura_otp2
    end
  end

  resources :contratosperpronotas do
    collection do
      get :otp
      post :captura_otp
    end
  end

  resources :contratosperprocesos do
    resources :contratosperprosanciones
    resources :contratosperprodescargos
    resources :contratosperprocitaciones
    resources :contratosperprodocs
    resources :contratosperpronotas
    collection do
      get 'showinfo'
      get :se_niega
      get :show_firma
      post :ws_otp
      get :codigo_otp
      get :ver_bitacora
      get :get_contratosperprocitaciones_estado
      get :regresar
      get :firmar_usuario
      get :firma
      get :firma_individual
      put :update_firma
      put :update_firma_usuario
      put :update_firma_testigo1
      put :update_firma_testigo2
      get :general
      get :procesos_pdf
      get :new2
      get :editproceso
      get :proceso
      get 'etapars'
      get 'cambio'
      get 'general_pdf'
    end
  end

  resources :migracionesactividades
  resources :tareasdocs do
    collection do
      get :cancelar
    end
  end

  resources :contratoscapacitaciones do
    resources :contratoscaparesultados
    resources :contratoscapapersonas
    collection do
      get :capacitacion_pdf
    end
  end

  resources :contratoscapapersonas do
    collection do
      get :cargar_capacitacion_pdf
      get :devolver
      get :devolver_todo
      get :capacitacion_pdf
      get :capacitacion_pdf_full
      get :capacitacion_pdf_contrato
    end
  end

  resources :tareasactdocs do
    collection do
      get :eliminar
    end
  end

  resources :tareasactividades do
    resources :tareasactdocs
    collection do
      get :search
      get :finalizar
      get :cancelar
      post :update_observation
    end
  end

  resources :tareas do
    collection do
      get :clonar
      get :gestion
      get :cargar
      get :mostrar_monday
      get :ver_grafica_general
      get :ver_grafica_usuarios
      get :detec
    end
    resources :tareasdocs
    resources :tareasactividades
  end

  resources :contratoscaparesultados do
    member do
      patch 'update_respuesta'
    end
  end

  resources :contratoscapapersonas
  resources :capacitaciondocs do
    collection do
      get :estado
      get 'video'
      get 'link'
      get :cancelar
    end
  end
  resources :capacitacionevaopciones

  resources :capacitaciones do
    collection do
      post :ws_otp
      get 'show_detalle'
      get 'envia_capacitacion'
      get 'incluirtodos'
      get 'clonar'
    end
    resources :contratoscaparesultados
    resources :contratoscapacitaciones
    resources :capacitacionevaluaciones
    resources :capacitaciondocs
  end

  resources :capacitacionevaluaciones do
    resources :capacitacionevaopciones
    collection do
      get :show_detalle
      get :estado
      get :cancelar
    end
  end

  resources :visitasatenciones do
    collection do
      get :otp
      post :captura_otp
    end
  end

  resources :visitascompromisos do
    collection do
      get :compromisos
      get :show_detalle
      get :documento
    end
  end

  resources :visitas do
    resources :visitasasistentes
    resources :visitashallazgos
    resources :visitascompromisos
    resources :visitasnotas
    resources :visitasdocs
    resources :visitassedes
    resources :visitasatenciones
    collection do
      get :primer_registro
      get :show_contrato
      get :informe_general
      get :periodos
      get :periodos_contrato
      get :periodos_anno
      get :informegeneral
      get :informegeneral_contrato
      get :excepcion
      get :formato
      post :captura
      post :captura_despues
      get :antes
      get :antes_trasera
      get :despues
      get :consolidado
      get :vistaexcel
      get :complementar
      get 'etapars'
    end
    member do
      post :cerrar
      post :captura_gps
    end
  end

  resources :migracionestelefonos
  resources :migracionesterminaciones

  resources :controlformatos
  resources :migracionescuentas
  resources :controlfirmas do
    collection do
      post 'generar_otp'
      post 'generar_otp1'
      post 'ws_otp'
      post 'ws_otp2'
      get 'envio_notificacion'
      get 'firmadocumento'
      get 'formatos_pdf'
      get 'levantar_firma'
      get 'levantarfirma'
      get 'bloqueofirma'
      get 'pdfdocumento'
    end
  end

  resources :iparametrosusers
  resources :contratosperlaboras do
    collection do
      post 'update_labora'
    end
  end

  resources :contratosperactobs do
    collection do
      get 'marcar'
      put 'update_individual'
    end
  end

  resources :contratoscargosacts
  resources :contratosperfechasdocs
  resources :personasforencuestas do
    collection do
      get 'examen_reporte_pdf'
      put 'update_individual'
    end
  end

  resources :encuestapreguntas do
    resources :encuestapreopciones
  end

  resources :encuestas do
    resources :encuestapreguntas
  end

  resources :encuestapreguntas do
    collection do
      get :cancelar
    end
  end

  resources :personasforexadocs do
    collection do
      get 'abrir_documento'
    end
  end
  resources :migracionesestados

  resources :personasformulariosdocs do
    collection do
      get 'abrir_documento'
      get 'cambioestado'
    end
  end

  resources :migracionesexamenes
  resources :personasformulariosexamenes do
    resources :personasforexadocs
    collection do
      get :notificacion_examen
      get :notificacion
      get :cancelar
    end
  end

  resources :personasformulariosmensajes
  resources :personasformulariosdocs do
    collection do
      get :cancelar
    end
  end

  resources :personasformularios do
    collection do
      get 'abrir_compromiso'
      get 'abrir_registros'
      get 'examenes_registros'
      get 'registro'
      post 'update2'
      get 'envio_formulario'
      get 'desbloqueo'
      get 'reenviar_correo'
      get 'reenviar_sms'
      get 'reenviar_sms2'
      get 'notificacion_correo'
      get 'notificacion_sms'
      get :get_personasformulario_genero
    end
    resources :personasformulariosdocs
    resources :personasformulariosexamenes
    resources :personasformulariosmensajes
  end

  resources :migracionespersonas

  resources :parcargos do
    collection do
      get :replicar
    end
    resources :parcargosdocs
  end

  resources :parcargosdocs do
    collection do
      get :cancelar
    end
  end

  resources :contratosperfacts do
    collection do
      get 'evaluar'
      get 'carta'
      get 'showinfo'
      get 'get_contratosperfact_contrato_id'
    end
  end

  resources :tiposnaportes
  resources :contratosinsimagenes do
    collection do
      get 'masivo'
    end
  end

  resources :documentosfirmas do
    collection do
      post 'firma'
      get 'abrirfirma'
    end
  end
  resources :contratosproyectos do
    resources :contratosprosedes
    collection do
      get 'abrirsedes'
      get 'recalcular'
    end
  end

  resources :contratosactnovedades do
    collection do
      get 'cambioestado'
      get 'indexadmin'
      get 'etapar'
      get 'etapar2'
      # Graficas
      get 'dash_seguimientos'
      get 'dash_seguimientosacumulado'
      get 'dash_seguimientosnodos'
      get 'solicitud'
    end
    resources :contratosactnovusers
    resources :contratosactnovnotas
    resources :contratosactnovdocs
  end

  resources :ejecuciones
  resources :portafoliosconfiguraciones
  resources :contratosperfcontroles
  resources :migracionesprorrogas
  resources :migracionescontratos
  resources :migracionessupervisores
  resources :migracionesnovedades
  resources :migracionesrodamientos

  resources :contratoscargos do
    collection do
      get 'cargosnota'
      get 'actividades'
      get 'cargospersona'
      get 'cargosdetalle'
    end
    resources :contratoscargospersonas
    resources :contratoscargosnotas
    resources :contratoscargosacts
    resources :contratoscargosdetalles
  end

  resources :contratoscargospersonas do
    collection do
      get 'cambioestado'
    end
  end

  resources :eproveedorescompretenciones

  resources :conceptos do
    resources :conceptosretenciones
  end

  resources :eproveedores do
    collection do
      get 'egreso'
      get 'egresoe'
      get 'egresod'
      get 'show_detalle'
    end
    resources :eproveedorestempcompras
    resources :eproveedorescompras
    resources :egresos
    resources :eproveedoresimagenes
    resources :eproveedorescreditos
    resources :eproveedoresrecibos
    resources :eproveedorestemegresos
  end

  resources :eproveedorescreditos do
    collection do
      get 'ver'
    end
  end

  resources :eproveedorescimagenes

  resources :eproveedorescompras do
    collection do
      get 'vercausacion'
      get 'equivalente'
      get 'show_detalle'
      get 'adicionar'
    end
  end

  resources :egresosimagenes
  resources :egresos do
    collection do
      get 'veregreso'
      get 'cambio'
    end
    resources :egresosdetalles
  end

  resources :centroscostos
  resources :cuentas

  resources :contratospervacaciones do
    collection do
      get 'marcar_firma'
      get 'masiva'
      get 'aprobar'
      get 'evaluar'
      get 'novedad'
      get 'vacacion'
      get 'archivoplano'
      get 'vacacion_masive'
      get 'vacacionmasive'
      get 'carta'
    end
  end

  resources :contratosprefdebitos do
    collection do
      get 'visualizar'
    end
  end

  resources :contratosprefcreditos do
    collection do
      get 'visualizar'
    end
  end

  resources :contratospermasivas do
    collection do
      get 'masiva'
      get 'masivaesp'
      get 'aprobar'
      get 'get_contratospermasiva_contrato_id'
      get 'masivaproceso'
      get 'aprobarproceso'
      get 'incluirnomina'
      get 'reversarnomina'
      get 'generarplanos'
      get 'archivoplanoproceso'
    end
    resources :contratospermasdetalles
  end

  resources :contratospermasdetalles do
    collection do
      get 'proceso'
    end
  end

  resources :contratospernovimagenes
  resources :contratosperlimagenes
  resources :contratoscargos do
    collection do
      get 'actividad'
    end
    resources :contratoscaractividades
  end

  resources :contratosperliquidaciones do
    collection do
      get 'novedad'
      get 'liquidacion'
      get 'archivoplano'
      get 'liquidacion_masive'
      get 'liquidacionmasive'
      get 'recalculo'
      get 'reliquidacion'
      get 'cargarimagenes'
    end
    resources :contratosperliqnovedades
  end

  resources :solicitudesretiros do
    collection do
      get 'evaluar'
      post 'search'
    end
  end

  resources :contratosprenimagenes
  resources :tiposentidades
  resources :contratosnodos
  resources :tipospretenciones

  resources :contratosactmcodigosinfos
  resources :contratosactcodigosinfos
  resources :contratosactmcodigos do
    collection do
      get 'evaluar'
      get 'edit_individual'
      put 'update_individual'
    end
  end

  resources :tiposmevaluaciones
  resources :tiposevaluaciones
  resources :contratostiposnovedades do
    collection do
      get 'cargar'
    end
  end

  resources :contratospernominas do
    collection do
      get 'show_detalle'
      get 'show_detallepro'
      get 'enviar_novedad_consecutivo'
      get 'nomina'
      get 'nominaindividual'
      get 'nominaesp'
      get 'datos'
      get 'cambioestado'
      get 'tirilla'
      get 'tirilla_masive'
      get 'edit_individual'
      put 'update_individual'
      get 'archivoplano'
      get 'archivosplanoliq'
      get 'etapar'
      get 'etapars'
      get 'get_contratospernomina_contrato_id'
      get 'archivosplano'
      get 'nominaelectronica'
      get 'vernominaelectronica'
      get 'nominaelectronicamas'
      get 'ejecutarake'
      get 'cancelar_ejecutarake'
      get 'ejecutarakeaportes'
      get 'cancelar_ejecutarakeaportes'
      get 'enviar_novedad_periodo'
      get 'enviar_novedad_annomes'
    end
  end

  resources :periodosliquidaciones do
    collection do
      get 'showinfo'
    end
  end

  resources :contratospernovedades
  resources :tiposnovedades
  get 'contratosactejecuciones/index'

  resources :contratosactcodigos do
    collection do
      get 'evaluar'
      get 'edit_individual'
      put 'update_individual'
    end
  end

  resources :contratosactejecuciones do
    collection do
      get 'new2'
      post 'create2'
    end
  end

  resources :contratosactividades do
    collection do
      get 'informe'
      get 'ver'
      get 'edit2'
      post 'update2'
      get 'seleccionar'
    end
    resources :contratosactejecuciones
    resources :contratosactnotas
  end

  resources :contratosprefacturas do
    collection do
      get 'generar_factura'
      get 'informe'
      get 'cambioestado'
      get 'firma'
      get 'visualizar'
      get 'visualizare'
      get 'mostrare'
      get 'replicar'
      put 'update_firma'
      get 'insumosinforme'
      get 'generar_facturalocal'
    end
    resources :contratosprefdetalles
    resources :contratosprefretenciones
    resources :contratosprefimagenes
  end

  get '/ws_token', to: "ws#tokensiigo"
  get '/wstoken', to: "ws#pedir_token"
  get '/wsreguser', to: "ws#registro_persona"

  get '/consulta', to: "menus#consultaexterna" # Para la consulta de si es validao o no un codigo de seguridad de los contratos
  get '/consultas', to: "menus#consultaliq" # Consulta general de todos los trabajadores
  get '/cartapresentacion', to: "menus#cartapresentacion"

  resources :ws_aportes do
    collection do
      get :creacion_cotizante
      get :certificado_aportes
    end
  end

  resources :ws_alegra do
    collection do
      get :enviar_nomina
      get :crear_empresa
      get :habilitar_empresa
    end
  end

  resources :ws do
    collection do
      get :enviar_nomina
      get :pedir_token
      get :tokensiigo
      get :registro_persona
      post :confirmacion
      get :confirmaciontest
      get :tokensiigo
      get :smscolombiared
    end
  end

  resources :contratosinsumos do
    collection do
      get 'edit_individual'
      put 'update_individual'
      get 'search'
      get 'fichatecnica'
    end
  end

  resources :personastemporales do
    collection do
      get 'finalizado'
      get 'new2'
      post 'create2'
    end
  end

  get 'contratospersonas/index'

  resources :contratosperagendas
  resources :contratospersonas do
    collection do
      get :get_contratospersona_genero
      get :inventario_items
      get :inventario_items_ind
      get :inventario_items_contrato
      get :visitas
      get :inventario
      get :abrir_datos
      post 'update2'
      get 'searchevaluacion'
      get 'evaluacion_pdf'
      get 'evaluacion_reporte_pdf'
      get 'hojavida'
      get 'crear_cotizante'
      get 'informe'
      get 'cambioestado'
      get 'novedad'
      get 'procesos'
      get 'evaluacion'
      get 'evaluacion_masiva'
      get 'evaluacion_documento'
      get 'proceso'
      get 'buscar'
      get 'get_contratospersona_contrato_id'
      get 'controluser'
      get 'verdocumentos'
      get 'hojavida_att'
    end
    resources :contratosperinventarios
    resources :contratosperbitacoras
    resources :contratospergrupos
    resources :contratosperestados
    resources :contratosperexamenes
    resources :contratospernovedades
    resources :contratosperprocesos
    resources :contratosperalertas
    resources :contratosperfechas do
      resources :contratosperfechasdocs
      collection do
        get "get_contratosseccion_contratoid"
      end
    end
    resources :contratosperusers
    resources :contratosperdescuentos
    resources :contratosperrodamientos
    resources :contratosperprestamos
    resources :contratosperembargos
    resources :contratosperimagenes
    resources :contratospersugerencias
    resources :contratosperquejas
    resources :contratosperchequeos
    resources :contratospernotas
  end

  resources :contratosperimagenes do
    collection do
      post 'update_observacion'
      get 'decision'
      post :create2
    end
  end

  resources :contratosperusers do
    collection do
      get 'abrircargue'
    end
  end

  resources :contratosperfechas do
    resources :contratosperfechasdocs
    resources :contratosperalertas
    resources :contratospernotas
    collection do
      get 'firmar_conjunto'
      post 'firmar_conjunto_otp'
      get 'search_persona'
      post 'update_fecha_real'
      get 'carta_dotacion'
      get 'prueba'
      get 'eliminar_contratos'
      get 'entregar_dotacion'
      get 'entregar_carne'
      get 'marcar_eps'
      get 'marcar_afp'
      get 'marcar_arl'
      get 'marcar_ccaf'
      get 'get_contratosperfecha_contrato_id'
      get "get_contratosseccion_contratoid"
      get 'contrato'
      get 'carta'
      get 'cartam'
      get 'prorrogas'
      get 'crear_aporte'
      get 'retirar_aporte'
      get 'marcar_firma'
      post 'ws_otp'
      post 'ws_otp2'
      post 'generar_otp'
      post 'generar_otp1'
      get 'firmacontrato'
      get 'levantar_firma'
      get 'levantarinactivos_firma'
      get 'cartapre'
      get 'habilitafirma'
      get 'refirmar'
      get 'dotacion'
      get 'inducciongeneral'
    end
  end

  resources :contratosperexamenes do
    collection do
      get 'informe'
      get 'cambioestado'
    end
  end

  resources :iparametros do
    resources :iparametrosformatos
    collection do
      get 'agregar_usuario'
      get 'agregar_formato'
    end
  end

  resources :barrios
  resources :entradas do
    collection do
      get 'buscador'
    end
  end

  resources :contratossoldetalles do
    collection do
      get 'edit_individual'
      put 'update_individual'
      get 'fichatecnica'
    end
  end

  resources :proveedores do
    collection do
      get 'informe'
    end
    resources :proveedoresimagenes
    resources :proveedorescontactos
  end

  resources :userstemporales do
    collection do
      get 'finalizado'
      get 'new2'
      post 'create2'
    end
  end

  resources :contratossolicitudes do
    collection do
      get 'informe'
      get 'cambioestado'
      get 'firma'
      get 'visualizar'
      get 'visualizare'
      get 'mostrare'
      get 'replicar'
      put 'update_firma'
      get 'insumosinforme'
    end
    resources :contratossolbitacoras
    resources :contratossoldetalles
    resources :contratossolotros
    resources :contratossolnotas
    resources :contratossolimagenes
  end

  resources :tiposcargos
  resources :migracionesinsumos
  resources :tiposareas

  resources :insumos do
    resources :insumosfichas
    collection do
      get 'search'
      get 'fichas'
    end
  end

  resources :empresas do
    collection do
      get 'informe'
    end
    resources :empresassedes
    resources :contratos
  end

  resources :contratossecciones do
    collection do
      get 'secuser'
      get 'procesos'
      post 'search'
    end
    resources :contratossecusers
  end

  resources :contratos do
    collection do
      get 'descargarepp'
      get 'capacitacionesusuario'
      get 'iniciar_capacitacion'
      get 'informe'
      get 'show_detalle'
      get 'marcar_capacitacion'
      get 'marcar_noaplica'
      get 'marcar_capacitacion2'
      get 'marcar_todo'
      get 'capacitacion'
      get 'abrircargue'
      get 'validacion'
      post 'cargar'
      get 'search'
      get 'searchall'
      get 'searchm'
      get 'depurarinsumos'
      get 'descargacontrato'
      get 'descargacontratoesp'
      get 'cargardocumentos'
      get 'download'
      get 'depurarsedes'
    end
    resources :contratosservicios
    resources :contratoscapacitaciones
    resources :contratossecciones
    resources :contratospersonas
    resources :contratospagos
    resources :contratosobservaciones
    resources :contratosmodificaciones
    resources :contratosusers
    resources :contratosimagenes
    resources :contratosinsumos
    resources :contratoscargos
    resources :contratossedes
    resources :contratosmaquinarias
    resources :contratosotros
    resources :contratossolicitudes
    resources :contratosprefacturas
    resources :contratosprefdebitos
    resources :contratosprefcreditos
    resources :contratosactividades
    resources :contratostiposnovedades
    resources :contratosretenciones
    resources :contratosautoinsumos
    resources :contratosperdescuentos
    resources :contratosperrodamientos
    resources :contratosperprestamos
    resources :contratosperembargos
    resources :contratosgrupos
    resources :contratosproyectos
  end

  resources :contratosgrupos do
    collection do
      get 'contratosmasive'
    end
  end

  resources :contratospagos do
    collection do
      get 'visualizar'
    end
  end

  resources :contratosusers do
    collection do
      get 'sede'
    end
  end

  resources :municipios
  resources :tiposcontratos
  resources :tiposcuentas
  resources :tiposimagenes
  resources :tiposdocumentos
  resources :fechas

  resources :datas do
    collection do
      get 'informe_pdf_inventarios'
      get 'informe_pdf'
      get 'informe_pdf_examenes'
      get 'informe'
      get 'informedat'
      get 'informe_rowspan'
      get 'headxls'
      get 'cambioestado'
      get 'codigos'
      get 'generar_lote'
      get 'generar_lote_estado'
      get 'descargardocbyperfecha'
      get 'descargardocbyperfechasalud'
      get 'descargardocbycontrato'
      get 'notificacionvacante'
      get 'download'
      get 'descargarfile'
      get 'descargardocbyproceso'
    end
  end

  get 'personas/index'

  resources :reportes

  resources :centros
  get '/asear', to: "antecedentes#index"
  get '/microcinco', to: "antecedentes#index2"
  get '/construmater', to: "antecedentes#index3"

  resources :personasevaluaciones do
    collection do
      get 'calificar'
    end
  end

  resources :personas do
    collection do
      get 'seguimiento'
      get 'seguimientoa'
      get 'seguimientoa2'
      get 'activarinactivar'
    end
    resources :personasobservaciones
    resources :personasimagenes
  end
  resources :antecedentes do
    collection do
      get 'finalizado'
    end
  end

  resources :archivos do
    collection do
      get 'get_tipoproceso'
      get 'errores'
      get 'download_ctl'
    end
  end

  resources :migraciones do
    collection do
      get 'etapar'
      get 'etaparformulario'
      get 'index_convocatorias'
      get 'buscador'
    end
    resources :migracionescampos
  end

  resources :migracionesreportes
  resources :migracionescrmes
  resources :usersregistrados do
    get :createpersona, on: :collection
    get :consolidado, on: :collection
    get :finalizado, on: :collection
    get :perido20182, on: :collection
    get :buscador, on: :collection
    get :actualiza, on: :collection
    get :confirmacion, on: :collection
  end

  get 'errors/internal_server_error'

  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  scope "/admin" do
    resources :audits do
      collection do
        get 'busqueda'
      end
    end
    resources :registros
    resources :usersactivos do
      collection do
        get 'cerrarsesion'
      end
    end
  end

  resources :grupos
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users_controller', passwords: 'users/passwords' }

  devise_scope :user do
    scope :users, as: :users do
      get 'pre_otp', to: 'users/sessions#pre_otp'
    end

    post "/users/sessions/verify_otp" => "users/sessions#verify_otp"

    authenticated :user do
      root 'menus#index'
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end

    put 'users' => 'devise/registrations#update', as: 'user_registration'
    get 'users/edit' => 'devise/registrations#edit', as: 'edit_user_registration'
    delete 'users' => 'devise/registrations#destroy', as: 'registration'
    get 'logout' => 'devise/sessions#destroy'
  end

  resources :portafolios do
    resources :portafoliospersonas
  end

  resources :parametros

  # chain_selects

  resources :modulos
  resources :objetos

  scope "/admin" do
    resources :users do
      get :autocomplete_identificacion_nombre, on: :collection
      get :autocomplete_cambio_user2, on: :collection
      get :autocomplete_user_nombre, on: :collection
      collection do
        get 'tabhome'
        get 'resetpass'
        get 'reestablecesusuario'
        get 'cambiousuario'
        get 'cargar'
        get 'cargar2'
        get 'inconsistencias'
        get 'fincargue'
        get 'actemail'
        post 'updateemailedu'
        get 'modogestion'
        get 'modograficoedu'
        get 'desbloquearusuario'
        get 'desbloquearusuariop'
        get 'desbloquearusuariof'
        get 'activaruser'
        get 'inactivaruser'
        get 'cambioportafolio'
        get 'cambiotipoconsulta'
        get 'cambiosucursal'
        get 'cambiarperfil'
        get 'masivo'
        get 'updatepass'
        post 'etapar'
        get 'etapa'
        get 'act'
        get 'edupol_desbloquearusuario'
        get 'carguemasivo'
        post 'importar'
        post 'importar2'
        get 'permisosymodulos'
        get 'searchall'
        get 'copyusers'
        get 'restableceyenvia'
      end
      resources :usersvehiculos
      resources :usersmodulos
      resources :userspermisos
      resources :usersparametros
      resources :usersreportes
      resources :userssucursales
      resources :usersportafolios
      resources :usersvisitas
      resources :usersfechas
      resources :usersimagenes
      resources :migracionesusers

    end
  end

  resources :usersmodulos do
    get :menu, on: :collection
    get :datos, on: :collection
    get :aprobarterminos, on: :collection
  end

  resources :menus do
    collection do
      get :show_detalle_contrato_entrega
      get :codigo_qr
      get :abrir_datos
      get :show_detalle_contratos
      get 'searchdocfirma'
      get 'searchdocfirma_todo'
      get 'show_detalle_docfirma'
      get 'searchdocumento_todo'
      get 'searchevalua_documento'
      get 'marcar_visto'
      get 'control_firma_digital'
      get 'pasar_afiliado'
      get 'pasari_afiliado'
      get 'hab_doc'
      get 'observacion_salud'
      get 'searchdotacion_todo'
      get 'searchcarnet_todo'
      get 'searchsalud_todo'
      get 'show_detalle_carnet'
      get 'show_detalle_dotacion_entrega'
      get 'show_detalle_compromiso'
      get 'show_detalle_salud_contratos'
      get 'show_detalle_salud_observacion'
      get 'show_detalle_dotacion'
      get 'abrir_documentos'
      get 'abrir_documentos_contrato'
      get 'abrir_formatos'
      get 'show_detalle_salud'
      get 'searchsalud'
      get 'searchcarnet'
      get 'searchdotacion'
      post 'search_contrato'
      post 'search_contratopre'
      post 'search_contratoliq'
      get 'aceptartratamiento'
      get 'tratamientodatos'
      get 'runjob'
      get 'menu'
      post :index
      post 'cargarprueba'
      get 'semaforoalertas'
      get 'abrirmapa'
      get 'modogestion'
      get 'call'
      get 'disconect'
      get 'produccion'
      get 'parametros'
      get 'libranzas'
      get 'actividades'
      get 'firmadigital'
      post 'filtroedu'
      post 'filtrocredito2'
      get 'recaudo_detalle_dia'
      post 'filtrosistem'
      get 'etapar'
      get 'etapac'
      get 'show_detalle'
      get 'show_detallef'
      get 'show_detalles'
      get 'show_detalles_epp'
    end
  end

  resources :datas do
    collection do
      get 'informe_pdf'
      get 'procesardatacredito'
      get 'datacredito'
      get 'cifin'
      get 'datacollector'
      get 'datacisa'
    end
  end
end
