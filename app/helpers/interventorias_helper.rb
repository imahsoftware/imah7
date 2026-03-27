# app/helpers/interventorias_helper.rb
module InterventoriasHelper

  # Retorna un círculo icono igual a la línea de tiempo de _leyenda_estados
  def icono_estado_interventoria(interventoria)
    # Configuración: [color_fondo, icono_fa, tooltip]
    config = {
      nil              => ['#95a5a6', 'fa-file-o',      'No generado'],
      'PENDIENTE'      => ['#bdc3c7', 'fa-clock-o',     'Listo, pendiente envío'],
      'REVISION'       => ['#f39c12', 'fa-paper-plane', 'Enviado a revisor'],
      'REVISIONFINALINT'  => ['#f39c12', 'fa-paper-plane', 'Enviado a revisor'],
      'REVISIONFINALGH'   => ['#f39c12', 'fa-paper-plane', 'Enviado a revisor'],
      'RECHAZADO'         => ['#e74c3c', 'fa-times-circle', 'Rechazado'],
      'RECHAZADOGH'       => ['#e74c3c', 'fa-times-circle', 'Rechazado'],
      'RECHAZADOCONT'     => ['#e74c3c', 'fa-times-circle', 'Rechazado'],
      'RECHAZADOFINALINT' => ['#e74c3c', 'fa-times-circle', 'Rechazado'],
      'RECHAZADOFINALGH'  => ['#e74c3c', 'fa-times-circle', 'Rechazado'],
      'APROBADO'          => ['#27ae60', 'fa-check-circle', 'Aprobado Int. → SGSST'],
      'APROBADOGH'        => ['#3c8dbc', 'fa-shield',       'Aprobado SGSST'],
      'APROBADOCONT'      => ['#00a65a', 'fa-money',        'Contabilizado'],
      'APROBADOFINAL'     => ['#00a65a', 'fa-money',        'Contabilizado'],
      'TESORERIA'         => ['#00a65a', 'fa-money',        'Contabilizado'],
    }

    estado = interventoria&.estado.to_s.presence
    color, icon, titulo = config[estado] || ['#95a5a6', 'fa-file-o', 'No generado']

    content_tag(:div,
      content_tag(:i, '', class: "fa #{icon}"),
      title: titulo,
      data: { toggle: 'tooltip' },
      style: "width:28px; height:28px; border-radius:50%; background:#{color}; color:#fff;
              display:inline-flex; align-items:center; justify-content:center;
              font-size:13px; margin:auto;"
    )
  end

  # CSS class para el badge de estado en tablas
  def label_estado_interventoria(estado)
    case estado.to_s
    when 'PENDIENTE'                              then 'label-default'
    when 'REVISION', 'REVISIONFINALINT',
      'REVISIONFINALGH'                        then 'label-warning'
    when 'APROBADO'                               then 'label-success'
    when 'APROBADOGH', 'APROBADOCONT',
      'APROBADOFINAL'                          then 'label-primary'
    when /^RECHAZADO/                             then 'label-danger'
    when 'TESORERIA'                              then 'label-info'
    else                                               'label-default'
    end
  end

  # Nombre del mes en español
  def descmesmin(mes)
    Interventoria::MESES[mes.to_i] || '------'
  end

  def select_sino_credito
    [
      ["SI", 3185900],
      ["NO", 0]
    ]
  end

  def select_sino_prepagada
    [
      ["SI", 509744],
      ["NO", 0]
    ]
  end

  def select_sino_dependiente
    [
      ["SI", 1019488],
      ["NO", 0]
    ]
  end

  def estado_label_class(estado)
    label_estado_interventoria(estado)
  end
end
