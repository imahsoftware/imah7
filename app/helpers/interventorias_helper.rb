# app/helpers/interventorias_helper.rb
module InterventoriasHelper

  # Retorna un badge HTML con el ícono del estado del informe
  def icono_estado_interventoria(interventoria)
    return content_tag(:span, '', class: 'label label-default',
                       title: 'No generado', style: 'font-size:10px;') if interventoria.nil?

    estado = interventoria.estado.to_s
    config = {
      'PENDIENTE'         => ['label-default', 'fa-hourglass-start', 'Pendiente de envío'],
      'REVISION'          => ['label-warning',  'fa-eye',             'En revisión del supervisor'],
      'REVISIONFINALINT'  => ['label-warning',  'fa-eye',             'Revisión final interventor'],
      'REVISIONFINALGH'   => ['label-warning',  'fa-users',           'Revisión Gestión Humana'],
      'APROBADO'          => ['label-success',  'fa-check',           'Aprobado por supervisor'],
      'APROBADOGH'        => ['label-primary',  'fa-check-circle',    'Aprobado Gestión Humana'],
      'APROBADOCONT'      => ['label-success',  'fa-check-circle-o',  'Aprobado Contabilidad'],
      'APROBADOFINAL'     => ['label-success',  'fa-trophy',          'Aprobado Final'],
      'RECHAZADO'         => ['label-danger',   'fa-times',           'Rechazado'],
      'RECHAZADOGH'       => ['label-danger',   'fa-times-circle',    'Rechazado Gestión Humana'],
      'RECHAZADOCONT'     => ['label-danger',   'fa-times-circle-o',  'Rechazado Contabilidad'],
      'RECHAZADOFINALINT' => ['label-danger',   'fa-times',           'Rechazado por interventor'],
      'RECHAZADOFINALGH'  => ['label-danger',   'fa-times-circle',    'Rechazado final GH'],
      'TESORERIA'         => ['label-info',     'fa-bank',            'En tesorería'],
    }

    css_class, icon, titulo = config[estado] || ['label-default', 'fa-question', estado]
    content_tag(:span, '', class: "label #{css_class}",
                title: titulo, style: 'font-size: 10px;') do
      content_tag(:i, '', class: "fa #{icon}")
    end
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
