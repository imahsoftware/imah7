every :day, at: '10:00pm' do
  rake 'coquetin:enviodianprogramado'
end
every :day, at: '02:00am' do
  rake 'coquetin:enviodianprogramado'
end
every :day, at: '9:00pm' do
  rake 'coquetin:envioaportesprogramado'
end

every :day, at: ['6:15 am','6:30 am','6:45 am','7:15 am','7:30 am','7:45 am','8:00 am','8:15 am','8:30 am','8:45 am','9:00 am','9:15 am','9:30 am','9:45 am','10:00 am','10:15 am','10:30 am','10:45 am','11:00 am','11:15 am','11:30 am','11:45 am','12:00 pm','12:15 pm','12:30 pm','12:45 pm','01:00 pm','01:15 pm','01:30 pm','01:45 pm','02:00 pm','02:15 pm','02:30 pm','02:45 pm','03:00 pm','03:15 pm','03:30 pm','03:45 pm','04:00 pm','04:15 pm','04:30 pm','04:45 pm','05:00 pm','05:15 pm','05:30 pm','05:45 pm','06:00 pm','06:15 pm','06:30 pm','06:45 pm','07:00 pm','07:15 pm','07:30 pm','07:45 pm','08:00 pm','08:30 pm','09:00 pm','10:30 pm'] do
  rake 'coquetin:mantenimientoespecial'
  rake 'coquetin:envioaporte'
end

every 2.minute do
  rake 'coquetin:enviocorreo'
end

every 3.minute do
  rake 'coquetin:activanuevoemp'
end

every :day, at: ['3:00 am','6:00 am','7:10 am','8:10 am','9:10 am','10:10 am','11:10 am','12:10 pm','1:10 pm','2:10 pm','3:10 pm','4:10 pm','5:10 pm','6:10 pm','7:10 pm','8:10 pm','9:10 pm','10:10 pm'] do
  rake 'coquetin:checkusers'
end

every :day, at: ['6:40 am','7:40 am','9:40 am','10:40 am','1:00 pm','2:30 pm','4:00 pm','6:00 pm','9:00 pm'] do
  rake 'coquetin:mantenimiento'
end

every :day, at: ['8:00 am','4:00 pm'] do
  rake 'coquetin:notificacionvisita'
  rake 'coquetin:notificacionvisitanocerrada3'
  rake 'coquetin:alegra'
end

every :day, at: '7:30 am' do
  rake 'coquetin:notificacioncontrato'
end

every :day, at: ['7:40 am','11:10 am','4:00 pm'] do
  rake 'coquetin:notificacionmonday'
  rake 'coquetin:contratosnofirmados'
end

every :day, at: ['5:40 pm'] do
  rake 'coquetin:notificacionvisitanocerrada'
end

every :day, at: ['8:30 pm'] do
  rake 'coquetin:notificacionvisitanocerrada2'
end

every :day, at: ['8:03 am'] do
  rake 'coquetin:visitasininiciar'
end

every :day, at: ['11:10 pm'] do
  rake 'coquetin:visitascierre'
end

every :day, at: ['8:15 am'] do
  rake 'coquetin:personascontrato'
  rake 'coquetin:notificacionterminacion'
  rake 'coquetin:notificaciondotacion'
end

=begin
every :day, at: ['01:25 pm'] do
  rake 'coquetin:generacionliquidaciones'
end


every :day, at: ['10:50 am'] do
  rake 'coquetin:generaciondotacion'
end

every :day, at: ['10:50 am'] do
  rake 'coquetin:generaciondotacion'
end


every :day, at: ['11:50 am'] do
  rake 'coquetin:generaciontirillas2'
end

every :day, at: ['11:25 am'] do
  rake 'coquetin:predownloadactivos'
end
=end
# whenever --update-crontab



