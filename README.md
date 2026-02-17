# 29 NOV 2023 - REQUERIMIENTOS

- Implementacion de formatos en proceso juridicos
- En Monday Ejecuciones, se debe de cambiar el modelo, para que aparezcan todos los usuarios, pero al dar clic, se vean
  las actividades con jquery.
- Crear dos graficas en Monday Ejecuciones

#### 1. PENDIENTES - EN PROCESO - FINALIZADAS

#### 2. GRAFICA DOS: DE CARA A LAS PERSONAS Y DEBE DE SER EN BARRAS, QUE MUESTRE POR CADA USUARIO EL NUMERO DE ACTIVIDADES REALIZADAS.

# PROCESO DE FIRMA DIGITAL DESDE EL PROCESO

- Cuando se cree el proceso se debe de habilitar un boton para firmar las personas y los testigos, y solo se deben de
  ver el proceso d firma para las personas.
- En el campo de fecha para citacion se pierde la fecha y hora al momento de editar
- En la citacion se debe de firmar por codigo otp, y se debe de abrir una venta que muestre las opciones para colocar el
  codigo otp y es de cara al user_id, que registro la transaccion.
- Agregar un campo en el modulo de citaciones, articulo infraccionado y capitulo reglamento interno
- Cuando sea la opcion no atendido en citaciones , crear un campo datos no comparecencia.
- Cuando se marco como no atendida se debe de generar un nuevo documento CONSTANCIA DE NO COMPARECENCIA.
- en el pdf de la citacion quitar los ultimos datos de quien recibe. en citaciones,
- en el registro de las citaciones, se debe de habilitar los dos formatos pdf y dos proceso d firma otp
- En el proceso de descargos, tambien se debe de firmar por otp, y en el documento debe de aparecer el abagado que le de
  clic en el boton de firma.
- Crear tabla de registros otp como una bitacora (codigo, usuario, proceso, codigo recibodo, fecha firma, key, id del
  registro, tabla del proceso)
- El proceso de sancion igual. - OK
    - Agregar campos en sancion, desvinculacion (si/no), fecha desvinculacion date. - OK


- CUANDO SE FIRME EL PROCESO SE DEBE DE COLOCAR LOS DATOS DE LA FIRMA, QUE ESTAN FALTANDO
- ESTE BOTON DE FIRMA DE CARA AL USUARIO DESDE LA PESTAÑA PRINCIPAL
- MOSTRAR EN LOS REGISTROS QUIEN FUE EL USUARIO QUE LO FIRMO, PORQUE ACTUALMENTE ESTA ES A LA FECHA. -- ok
- AL MOMENTO DE EDITAR EL PROCESO DE CITACIONES, NO SE PUEDE MODIFICAR LA CITA NI LA FECHA SOLO EL ESTADO. -- ok
- QUE SE PUEDA VER EL DOCUMENTO DIGITAL DESDE CADA REGISTO, Y TAMBIEN EN LA PARTE DE DODUCMENTOS DIGITALES.
- DARLE FORMATO A LAS FECHAS Y QUE SOLO APAREZC HH MINUTOA Y SEGUNDOS
    - EN EL PROCESO DE DESCARGOS HABILITAR UN BOTON MAS PARA QUE FIRME EL TESTIGO CON OTP, Y APAREZCA EN EL FORMATO, Y
      SOLO SE GENERA EL PDF CUANDO ESTEN LAS DOS FIRMAS.
    - ORGANIZAR ORDEN, SANCION, REGLAMENTO, DESVINCULACION Y FECHA, EN SACONES
    - CUANDO SE CREE EL DOCUMNTO SE DEBE DE CREAR CON LA SIGUIENTE ESTRUCTURA citacion_idproceso_fechayhora
    - QUITAR EL BOTON DE FIRMA DIGITAL Y DOCUMENTO EN NOTAS.
    - COLOCAR PERMISO AL BOTON DE HISTORICO QUE SE LLAME procesosauditorias

## 06/12/2023

- ORGANIZAR LAS OPCIONES DEL MONDAY EN EL MENU -- ok
- VALIDAR LA GRAFICA AL ABRIRLA LA SEGUNDA VEZ. -- ok
- VALIDAR ERROR DE RECARGA AL CREAR EL PROCESO.
- COLOCAR EL USUARIO DE QUIEN CREO LA CITACION - ok
- HABILITAR EL BOTON DE EDITAR AL MOMENTO DE CREAR LA CITACION. -- ok
- EN LA PESTAÑA DE DESCARGOS AGREGAR LA FIRMA PAA EL EMPLEADO.
- EN EL DESCARGO MOSTRAR EL USUARIO QUE FIRMO. -- ok
- MOSTRAR EL DOCUMENTO EN SANCIONES QUE YA ESTA FIRMADO -- ok

## 14/12/2023

- en empleados cuando se crea el proceso, habilitar un boton para que se pueda firmar, con codigo como quedo como
  capacitaciones, sobre escribiniendo la tabla, y despues de que los firme quitarle los botones de ediutar y eliminar ,
  en el modulo de nelcy , quien lo crea es que lo firma digitalmnete.
- cuando se cree el proceso, que le notifique por mensaje de texto que tiene pendiente por firma, y la usuaria debe de
  ingresae y ver todos los procesos que tine para firmar en manuscrito, y que le notifique a los testigos un mensaje de
  texto a los testigos. para firmar en manuscrito.
- Cambiar el bootn de firma de servicios, que muestre las firmas que van.
- EN EL FORMATO DEL PROCESO COLOCAR LOS TESTIGOS, Y COLOCAR LOS NOMBRES EN LAS FIRMAS.

## 18/12/2023

- COLOCAR UN BOTON DESDE LA CREACION DE LA CITACION, DONDE SE ENVIE UN MENSAJE DE TEXTO AL USUARIO INFORMANDOLE SOBRE LA
  CITACIONES REALIZADA (LUGAR Y FECHA) - ok
- CREAR BOTON DESDE EL PROCESO PARA CUANDO EL USUARIO SE NIEGA A FIRMAR, Y GUARSAR ESE REGISATRO Y MOSTRARLO EN
  FORMATO. -- ok
- CREAR UN CAMPO DE APERTURA DE PROCESO STRING -- ok
- CUANDO SE CREE UN SOPORTE QUE SE LE ENVIE UN MENSAJE DICIENDO OOEOOEE FABI UN SOPORTE TENCI -- ok
- EN EL BOTON DE NUEVO COLOCAR CREAR NUEVO SOPORTE. -- ok
- CUANDO SE FINALICE SE DEBE DE ENVIAR UN MENSAJE DE TEXTO INFORMANDO SOBRE SU FNALIZACION. -- ok

## 30/12/2023

- cuandno nazca la el detalle o la ejecucion debe de aparecer vacio, y cumple es igual a 1, y no cumple es igual a 0
- filtrar por la evaluacion.

## 02/01/2024

- En la evaluacion colocar la persona que marco - cumple y no cumple y su fecha , lo mismo para el excel - El
  usuario. -- OK
- el excel complementarlo mas con la fecha , usuario, nombre de la evaluacion, el objetivo, fecha limite de la
  evaluacion. -- ok
- En monday ejecuciones colocar un buscador que le pemita buscar por actividad y que solo muestre quien la tiene y la
  actividad. sin botones, dentro del mismo tablero --ok
-
- que se pueda agregar usuarios a las capacitaciones, y son todo los usuarios activos en le
  sistema, https://appasearesp.com/capacitaciones/3/edit?subetapa=3 y tiene que ingresar en estado pendiente.,
  y se deben de cargar en la tabla, Contratoscapapersonas con un estado difrente para que cuando se marque se pueda
  pasar a estado ACTIVO. -- ok
- Cuando se le de clic al sst, que no se oculte los indicadores. -- ok
- Colcoar Total Evaluaciones por total actividades -- ok
- Unificar el texto del siderbar (capacitacion programacion y Capacitacion ejecucion) y pasarlo para procesos, y pasar
  monday y evaluaciones.. -- ok
- Habiltar una pestaña los que estan pendientes para iniciar capacitacion. -- ok
- En la pestaña de https://appasearesp.com/contratos/capacitacion, deben de aparecer para que pueda agregar otros
  usuarios de otros contratos. --ok
- El iniciar capacitacion solo se habilita cuando tenga al menos uno marcado o pendiente de iniciar. -- ok
- el marcar todo que quede en la pestaña de pendientes y cuanod se marquen para capacitacion , que se pasen para la
  nueva pestaña y el boton de iniciar capacitacion debe de estar en la pestaña de pendientes de iniciar. -- ok
- Mostrar en finalizar la fecha de finaliz acion y codigo de la firma. -- ok
- Organizar el que marco con jquery. -- ok
- Colocar un buscador por persona. -- ok
- Colocar la grafica del sst como esta por usuario (Se crearon dos grafias, 1 por clase y otra por usuarios) -- ok
- Crear un pdf de la capacitacion en la hoja de vida. -- ok


- En la pestala de finalizado, colocar la fecha de firma con fecha y hora. -- ok
- Pendientes, otros pendientes, pendiente sinciar capacitacion , en proceso y fianlizado -- ok
- Organizar grafica de Pendientes, otros pendientes, pendiente sinciar capacitacion , en proceso y fianlizado -- ok
- https://appasearesp.com/contratos/capacitacion , que quede en una vista -- ok
- el boton de iniciar capacitacion que solo se vea en iniciar capacitacion. -- ok
- nombre capacitacion, nombre contrato, , quitar fecha limite, y agregar las dema spestañas como pendientes de inciar
  capacitacion., -- ok
- Capacitaciones Asignadas, organizar todos los contadores. y en la visualiuzacioon, debe de tener la tabla , -- ok
- Indicadores en evaluaciones en curso con otros colores -- ok
- El titulo del pdf generar , es capacitaciones. (Nombre capacitacion, tema, objetivo, fecha limite, estado, creada
  por). y en evaluacion cambiar descripcion por pregunta. en la tabla de usuarios de finalizados, colocar la fecha , la
  firma y el codigo de la firma., 890980153- INSTITUCIÓN UNIVERSITARIA PASCUAL BRAVO , debe de aparecer en la parte
  despues de estado informacion pricipal. -- ok
- Organizar el pdf , para que muestre los pendietes , en proceso y finalizados de la capacitacion. -- ok
- ORDEN (PENDIENTE, CUMPLE, NO CUMPLE, NO APLICA, PARCIALMENTE). (NO APLICA - 1.0, PARCIALMENTE - 0.5). -- ok
- Crear un excel con la misma informacion (en el estado hacia abajo, mostrar el estado y mostrar por capacitacion el
  excel), en el exel separar la informacion de identificacion y nombre.
- no aplica, en la selecion del estado, y otra que se llame parcialmente , si va a marcar no aplica, parcialmente o no
  cumple debe de registrar una observacion. -- ok
- Dentro del buscador de evaluaciones, cuando busque por un usuario que se permita evaluar desde el mismo buscador -- ok
- SI NO HAY DOCUMENTOS DOIGITALES NO SACER LA INFORMACION , DOCUMENTOS DIGITALES DE LA CAPACITACIÓN, Ttambien en el pdf,
  agregar le nombre ydentificacion y cargo. -- ok
- tambien agregar quien hizo la capacitacion , Contratos Asociados (esta enc contatos ) -- ok
- Dentro de la evaluacion, al lado del nombre colocar un pdf, de la evaluacion generar de la persona, que muetsre todas
  las actividades, asi este en otros procesos. -- ok
- https://appasearesp.com/visitas?utf8=✓&user_id=&fchinicial=2024-01-11&fchfinal=2024-01-11&ubicacion%5Btipo%5D=VISTA&button=,
  SE DEME DE MOSTRAR TODOS LOS COMPRIMIDOS QUE ESTAN EN ESTADO PENDINTE., de cara al usuario. y debe de mostarr , Fecha
  Inicio Visita, Empresa - Contrato, y el detalle del compriomiso.
- colocar un boton donde permita registrar la observacion de la atencion, que abra una modar y coloque la observacion
  del compromiso. y que se pueda cargar un soporte del compromiso y que se pueda agregar a visitasdocumentos. -- ok
- CLONAR LA EVALUCION, asi como se clona el monday,
- Calificacion de evaluaciones - se evalua contra el nro de correctas de la evaluciones -- OK
- En la programacion en el tab de finalizado cambiar estado por calificacion y quita estado en proceso , en todas sobra
  el estado -- OK
- En el pdf quitar estado, fecha programacion y colocar estado de la evauaciones -- OK
- Crear un excel por estado, y que salgan contrato , descrip los datos basicos de la capacitacion, y nombre , estado y
  calificacion si apli -- ok
- En visitas. crear una pestaña al lado de las fechas que se llame compromisos , y dentro de esta colocar los
  compromisos que esten pendientes.

## 20/01/2024

- En las evaluaciones colocar un pdf donde genere toda la informacion de las evaluaciones que ha realizado por usuario (
  Todo), incluso si esta en otros procesos. solo dentro de la evaluacion donde esta parado.
    - Organizar User Marca -- ok
- Organizar el buscador. -- ok , en le buscador colcoar el pdf y el email y telefono. -- ok
- En visitas , en el edit, colocar este mensaje (Te falta registrar una nota, te falta registrar un compromiso, te falta
  persona que realiza la atención)  y si el contrato tiene sede se debe solicitar que agregue la sede, el comprimiso y
  la nota tiene que ir siempre, para poder habilitar el cerrado de la visita.
    - Complementar para que sea con una sola condicion. -- ok

## 20/01/2024

- El boton debe de quedar abajo cuando se termine la capacotacion -- ok
- Adecuar responsive para que se vea bien desde mobil. -- ok,,,,
- En la visita verificar si hace cro la foto cuando se toma la foto -- ok
- en visitas en tipo crear un tipo mas en el selector que sea pdf, y es el resulatdo dela isyaluixcion
- en el buscador de visitas agregarle el vcontrato de visitas

## 27/01/2024

- Agregar la variable de contratos en el buscador de visita (empresa y contrato junto).
- Mandar un mensaje que el va a utorizar que se va a firmar en
  conjunto. , https://appasearesp.com/contratospersonas/1357/edit?etapa=F y el boton se debe de llamar firmar en
  conjunto y solo sale cuando no este firmado y el contrato este activo.
- Cuando le le clic , se envia un mensaje que debe de ccir (Codigo para Autorizacion de firma de contrato en conjunto -
  Codigo: 988883).
- Agregar dos csampos mas para guardar ese codigo. (codigo_conjunto, codigo_conjunto_resp), y despues se habilita la
  pantalla del codigo principal para el contrato.

## 29/01/2024

- Donde se envien los codigos sms otp , adjuntar para que se envie por email -- ok
- En la visita que muestre el pdf y que muestre el html del consolidado, y mirar en contratos hay un separado que se
  llama salto de linea. -- ok
- https://appasearesp.com/contratoscapacitaciones/capacitacion_pdf.pdf?contrato_id=755&id=4002 en usuarios finalizados
  una cosluman del resultado.
  Cuando ingrese el usuario por primera vez a realizar la visita debe de mostrar el siguiente mensaje "Solicitamos
  respetuosamente que todas las visitas y gestiones con clientes se realicen dentro de la jornada máxima de 47
  horas semanales, y en caso de requerir tiempo adicional (horas extras) para el cumplimiento de sus objetivos se
  requiere
  autorización de la subgerencia de la compañía o a quien está delegue, en caso de laborar tiempo complementario sin la
  autorización requerida dicho tiempo no será remunerado y/o compensado. Tambien le recordamos que dentro de dicha
  jornada
  debe destinar una hora diaria para almorzar en el tiempo que mejor se
  acople a la ejecucion de sus labores" -- ok

- Informe mensual (colocar el boton en cualquiera de las fechas de visitas, que se llame informe mensual y solo lo
  podemos ver fabian y yo), y el informe en pdf solo debe traer todas las
  visitas(no debe de traer los compropromisos), compromisos (en una hoja aparte), evaluaciones, retiros (solicitudes
  retiros), ingresos (contratosperusers). el boton de pdf colcoarlo en la pestaña de consolidado y es por supervisor.

- La primera hoja es visitas, evaluaciones, capacitaciones, retiros, ingresos -- ok
- Al lado del supervisor - crear un permisos que se llama excepcioncierrevisita,
  esa activa o inactiva el permiso - Si no lo tiene debe de aparecer en rojo, y si tiene el permiso en verde.,
  si lo tiene no tiene que perdir que le manden el codigo (no necesita llenar la atencion para cerrar la visita). -- ok

## 06/02/2024

- Actualizacion de los campos con un boton en el navbar. -- ok
- estas dos cedulas, 1033336148, 1039625404, verificar que no los deja ver la ejecucion de las evaluaciones. porque no
  los deja ver. -- ok
- en evaluacions que permita ver https://appasearesp.com/evaluaciones/18/edit?etapa=B, la evaluacion es en pdf por esa
  persona en la pestaña de usuarios. -- ok
- Enla evaluacion cuando se realiza la evaluacion , que se permita cambiar a no cumple. o reversar el poroceso. -- ok
- en esta parte de sedes, https://appasearesp.com/visitas/complementar?etapa=D&id=2003, que se llame viaticos y gregar
  la georeferenciacion -- ok

- en capacitaciones, https://appasearesp.com/capacitaciones/5/edit?subetapa=1, colocar una fecha limite y cuando se
  cumpla la fecha limite no se puede dejar ver la capacitacion.

## 07/02/2024

- Direccion - Telefono - Email y tallas para la actualizacion -- ok
- si tiene sede en visitas, se guarda normal. pero si no tiene sede agregar un campo de descripcion donde coloque la
  direccion y es obligatorio. -- ok
- colocar la feha limite al inicio y mostrar la fecha limite en todos los pdf de la capacitacion -- ok
- Cambiat el orden de la capacitacion en los campos (nombre, feecha limite, valor aprobacion - estado). -- ok
- La fecha milite aplica en esta vista , https://appasearesp.com/contratos/capacitacion y que esten estado activo. -- ok

## 08/02/2024

- crear una tabla que se llame contratosservicios, (contrato_id, user_id, servicio "es una lista de iparametros y el 
  campo es contratosservios"") y es un hijo e ocntratos, https://appasearesp.com/contratos/802/edit?etapa=A, y va al
  finalarde la vista en el lado izq. -- ok
- En el informe 81 - Informe Empresa y Contratos, agregar una columna mas que se llame servivios y debe de traer todos los servicios concatenamos. ... corregir le nombre de estato por estado -------- -- OK
- Organizar el informe por estadp , pero que se separe por hoja. -- ok
- AGREGAR DOS COLUMNAS MAS, SUPERVIDOR Y COORDINADOR, Y SE DEBE DE TRAER LA INFORMACION CONCATENADA, https://appasearesp.com/contratos/802/edit?etapa=D SEGUN EL TIPO. -- ok
- LA COLUMNA DEL MUNUCIPIO DIVIDIRLA , DEPARTAMENTO Y MUNICIPIO APARTE. -- ok
- En procesos, del empleado crear un campo mas que se llame observacion_empleado y del mismo tamaño de Detalle de los Hechos y es opcional, cuando se ingrese al proceso se muestre en todas partes.
- Crear un excel en  https://appasearesp.com/evaluaciones/18/edit?etapa=A, con esta estructura 


## 12/02/2024
- Organizar error de visitas. -- ok
- La pestaña de serviicos moverla a parametrizacion. -- ok
- En le modulo de visitas se necesita crear una nueva opcion que se llama numero de tikect(numero) y otra teletrabajo (Si/no y por fedault no) (Son campos al momento de crear la vsita) -- ok
- Diseña el proceso de visitas para que se pueda ver lo asignado -- ok
- usersvisitas (user_id, user_asignado) y al modulo de usuarios se le asigna las personas de que quiere ver las visitas

## 23/02/2024
- contratossoleppsdetalle cuando se creen un registro , se debe de agrupar por la clasificion de iparametros -- ok.
- El estado al crearse ingresa en estado pendiente por default, y quito el campo de estado de la solicitud. -- ok
- Del tr del detalle quitar fecha y colocarla en boton, quitar Cnt Aprobada y cuando se cree o se actualice cantidad es iguala a Cnt Aprobada. -- ok
- Cuando el sistema detecte que almenos se tenga un detalle , el sistema debe de habiliar un boton de enviar y se cambia el estado a enviado en contratossolepps. -- ok
- El titulo se va a llaamr solicitudes epp -- ok
- Cada usuario solo puede ver lo que ha creado en el index,  y debe de habilitarse le boton de eliminar simpre y cuando este en estaod pendiente. -- OK
- En el detalle colocar la observacion dle aprobador. -- OK 
- Los estados son (pendiente - enviado - aprobado , rechazado y despachado)
- Crear un acta similar a esta - https://appasearesp.com/contratossolicitudes/2391