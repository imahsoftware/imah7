
Objeto.find_by_sql("SELECT f.id contratosperfecha_id, u.id user_id, i.id contratosperimagen_id,i.created_at
                    FROM   contratosperfechas f, users u, contratosperimagenes i, contratospersonas p
                    WHERE  p.id = f.contratospersona_id
                    and    f.id in (89607,89606,89605,89604,89603,89602,89601,89600,89599,89598,89597,89596,89594,89593,89592,89591,89590,89589,89588,89587,89586,89585,89584,89583,89582,89581,89580,89579,89578,89577,89576,89575,89574,89573,89572,89571,89570,89569,89568,89567,89566,89565,89564,89563,89562,89561,89560,89559,89558,89557,89556,89555,89554,89553,89552,89551,89550,89549,89548,89547,89546,89545,89544,89543,89542,89541,89540,89539,89538,89537,89536,89535,89534,89533,89532,89531,89530,89529,89528,89527,89526,89525,89524,89523,89522,89510,89509,89508,89507,89506,89505,89504,89503,89502,89501,89500,89499,89498,89497,89496,89495,89494,89493,89492,89491,89490,89489,89488,89487,89486,89485,89484,89483,89482,89481)
                    AND    f.codigo_firma IS NOT NULL
                    AND    f.id = i.contratosperfecha_id
                    AND    i.descripcion LIKE 'CONTRATO FIRMADO DIGITALMENTE%'
                    AND    f.contratospersona_id = u.contratospersona_id").each do |a|
  a = Contratosperimagen.find(a.contratosperimagen_id)
  a.destroy
  ContratosperfechasController.firmacontrato(a.contratosperfecha_id, a.user_id)
  puts "Firmado... contrato de #{a.contratospersona_id.to_s}"
end
=begin
Objeto.find_by_sql("SELECT f.id contratosperfecha_id, u.id user_id, i.id contratosperimagen_id,i.created_at
                    FROM   contratosperfechas f, users u, contratosperimagenes i, contratospersonas p
                    WHERE  p.id = f.contratospersona_id
                    and    f.id in (79210,79211,79212,79213,79214,79215,79216,79217,79218,79219,79220,79221,79222,79223,79224,79225,79226,79227,79228,79229,79230,79231,79232,79233,79234,79235,79236,79237,79238,79239,79240,79241,79242,79243,79244,79245,79246,79247,79248,79249,79250,79251,79252,79253,79254,79255,79256,79257,79258,79259,79260,79261,79262,79263,79264,79265,79266,79267,79268,79269,79270,79271,79272,79273,79274,79275,79276,79277,79278,79279)
                    AND    f.codigo_firma IS NOT NULL
                    AND    f.id = i.contratosperfecha_id
                    AND    i.descripcion LIKE 'CONTRATO FIRMADO DIGITALMENTE%'
                    AND    f.contratospersona_id = u.contratospersona_id").each do |a|
  a = Contratosperimagen.find(a.contratosperimagen_id)
  a.destroy
  ActiveRecord::Base.connection.execute("update contratosperfechas set dotacion ='SI' where id = #{a.contratosperfecha_id}")
  ContratosperfechasController.firmacontrato(a.contratosperfecha_id, a.user_id)
  ActiveRecord::Base.connection.execute("update contratosperfechas set dotacion ='NO' where id = #{a.contratosperfecha_id}")
  puts "Firmado... contrato de #{a.contratospersona_id.to_s}"
end
=end
=begin
contador = 0
Objeto.find_by_sql("SELECT * FROM refirmaprocesos").each do |a|
  contador = contador + 1
  ContratosperprosancionesController.refirmarterminacion(a.contratosperprosancion_id,a.namefile.to_s)
  system("cp -f /home/deploy/coquetin/public/archivos/pdf/#{a.namefile.to_s}.pdf #{a.ruta1}") rescue nil
  system("cp -f /home/deploy/coquetin/public/archivos/pdf/#{a.namefile.to_s}.pdf #{a.ruta2}") rescue nil
  puts "Firmado...#{contador} contratosperprosancion_id: #{a.contratosperprosancion_id.to_s}"
end
=end
=begin
contador = 0
Objeto.find_by_sql("SELECT f.id contratosperfecha_id, u.id user_id, f.contratospersona_id
                    FROM   contratosperfechas f, users u
                    WHERE  f.contrato_id = 827 AND f.fecha_inicio >= '2025-01-01' AND f.dotacion = 'SI'
                    AND    f.contratospersona_id = u.contratospersona_id").each do |a|
  contador = contador + 1
  Modulo.find_by_sql("select id contratosperimagen_id from contratosperimagenes where contratosperfecha_id = #{a.contratosperfecha_id}
                      AND descripcion = 'CONTRATO FIRMADO DIGITALMENTE'").each do |b|
    b = Contratosperimagen.find(b.contratosperimagen_id)
    b.destroy
  end
  ActiveRecord::Base.connection.execute("update contratosperfechas set dotacion ='NO' where id = #{a.contratosperfecha_id}")
  ContratosperfechasController.firmacontrato(a.contratosperfecha_id, a.user_id)
  puts "Firmado...#{contador} contrato de #{a.contratospersona_id.to_s}"
end
=end

=begin
Objeto.find_by_sql("SELECT f.id contratosperfecha_id, u.id user_id, i.id contratosperimagen_id,i.created_at
                    FROM   contratosperfechas f, users u, contratosperimagenes i, contratospersonas p
                    WHERE  p.id = f.contratospersona_id
                    and    f.id in (75859,75860,75861,75862,75863,75864,75865,75866,75867,75868,75869,75870,75871,75872,75873,75874,75875,75876,75877,75878,75879,75880,75881,75882,75883,75884,75885,75886,75887,75888,75889,75890,75891,75892,75893,75894,75895,75896,75897,75898,76035,76046,76051,76052,76056,76057,76058,76066,76069,76095,76096,76097,76098,76101,76102,76104,76113,76124,76129,76132,76133,76134,76135,76136,76137,76138,76139,76141,76211,76212,76213,76215,76216,76217,76218,76219,76286,76289,76290,76481,76681,76850)
                    AND    f.codigo_firma IS NOT NULL
                    AND    f.id = i.contratosperfecha_id
                    AND    i.descripcion LIKE 'CONTRATO FIRMADO DIGITALMENTE%'
                    AND    f.contratospersona_id = u.contratospersona_id").each do |a|
  a = Contratosperimagen.find(a.contratosperimagen_id)
  a.destroy
  ActiveRecord::Base.connection.execute("update contratosperfechas set set user_id = #{u.id} where id = #{p.id} and portafolio_id= 10100")
  ContratosperfechasController.firmacontrato(a.contratosperfecha_id, a.user_id)
  puts "Firmado... contrato de #{a.contratospersona_id.to_s}"
end
=end

=begin
Objeto.find_by_sql("SELECT m.id contratosperimagen_id
                    FROM   contratospersonas p, contratosperfechas f, contratosperimagenes m
                    WHERE p.identificacion IN ('1027887112','1000656709','1022035015','1033337739','43875502','21438722','43711252','43710573','43708147','43686990','1033336898','43708514','1033336900','1033336979','1033341614','1033336053','1193069652','43711363','1018346947','1018351858','43911581','32092356','1020332137','1027892325','1027889078','1028040115','1027887112','1027884839','1027880321','1032096831','1001020466','1027883065','1027890869','3377711','15534375','43281196','43284707','1027886391','1027885683','1036660314','1027883396','21480225','21487815','1035128962','1035129611','1035127333','1000908662','70927342','1007631171','1036607987','1023749037','1033369724','70529402','1033371110','1007331590','1007340475','1019117345','1033376682','1003404771','25773307','42656270','1148944500','1017176643','43382176','71421957','1038816942','1001243632','39214027','70136219','39209158','39211767','21715296','1013536156','1010065356','1018373339','1048019520','43718485','1018372020','1042767406','1001161916','21588151','21590221','1032249443','1032259907','1001159444','1001159739','98673219','1038125537','1032260988','1045433968','1032248054','1032250369','1032257929','1045423929','98672628','1066516054','1023831669','21595803','98570602','1026152712','21533349','1000921448','1026160576','1000311055','1026132387','1026140836','1033340836','1000919586','1038335339','43153613','1040732954','71395972','3507793','1046953999','43782113','1037635050','43884054','1038626006','1022361730','1001560610','70416372','1040350085','71251842','39305249','39425432','43147876','39421322','43998581','71253160','1001672611','1040379514','71253674','32294763','71272141','43145795','86084783','1112789326','39414922','71115335','1036402584','1036402975','1193520543','1036927815','1036404124','43300423','92532696','39286950','1038117968','39281488','39275055','98650838','70662867','1007332351','1038094370','1045142755','39286578','39283869','39279713','1038103150','50886307','1001534842','1038098395','50917193','1038116386','1038435376','32294717','1040372203','1038814217','1040362758','1038814991','1038823049','1192748909','43144773','1038808873','8337420','32288385','1038796600','1038816295','1040367645','1192715819','1038805081','1038821439','32293862','1007874630','1038806586','1128400795','1007432967','1193585699','70415748','70419701','43488772','32393875','43838457','21675762','1038770147','43844485','1035418940','43907791','42684225','32210869','42683736','32297789','15508031','1000111020','43417959','8418175','71260376','1039290980','1039288168','1039288417','1152439974','1035800134','1025640849','1152716580','1003060359','43444075','1038232065','43847993','15261842','1040516838','1007338883','1040502042','1040498790','1022034123','8363603','98475576','43896360','1005417212','1040500881','1040507188','43898293','1001741628','1040512844','1038139865','1040495281','1040514153','1040496222','43895511','1038803035','1040490356','1035833830','1035832399','43752407','1041150079','32160809','8462958','1041148765','43413948','1041151324','21739364','1041148164','1041148407','32275845','1038336998','71022378','21426177','21495604','1038334497','71021812','1017262666','1038334150','1041176906','70324480','39355652','42159310','1003697600','98526596','43694718','71660034','42702159','43210568','43210502','1035915175','43913634','1035912734','43211455','21788492','21788465','1036448582','1128457675','1000874190','1022142355','1037269000','1037266926','1001509492','1037776029','70811334','1037324963','39285753','39191663','39191943','39188685','1040030972','1040033914','1038386145','43473097','43861943','1017138868','1128432826','1018231274','1036779793','1001471234','98501627','1039622620','1038418371','43795947','43796239','70904359','1038799186','98552263','1039048161','30079191','43776006','1045111495','1036839316','1038436193','1038479329','1038480241','1038437708','8050891','8374104','1038481320','1039089250','1007674151','1010060932','1039102608','1001595484','1039080451','39314120','1039083529','71989946','1000136540','32201918','1039102001','1039097774','1039078534','50641536','1039083254','43150364','3805937','1037485897','1007636979','1039082342','1039625704','42841074','42841016','1041233677','21912649','1046933008','1039420094','1039422080','1039421406','43652033','43483912','43651414','1039695759','43652655','1007447688','43653447','21940446','1007335148','1001445792','1000189638','1036224727','1001443588','1036225522','1038546831','1038541919','42940974','1040182488','1040182517','1036780563','21970649','1038770233','1039759053','1000900608','8156204','21992325','1007433645','70164934','43701291','1037946371','1037946036','70162726','1037071171','1037975140','43904434','43703552','43704335','1037484037','1001504528','43823456','1037480568','1039678802','1001504023','1037473035','1037480726','43823881','22167486','1037472439','1037468783','1001504086','1037977046','98503352','43987740','1040320733','43366246','1040323425','43364668','43366383','43365999','32254888','1041265982','1041267609','1032176185','1017133382','1041264678','1018460094','98600389','1041258613','1041256694','8328793','98598409','1041265874','1041258204','8328722','1001401717','1041269995','1001747135','8323112','1041256213','32272435','43701509','1037074012','1001477960','1037504499','43805333','1037501317','1035389032','43855643','1152683834','43855555','1041329221','43856696','1041325699','1001749355','71140994','32228328','43907499','1044503346','41956426','32104421','1036685866','21501288','1022094282','1022094736','15405659','21500896','1017245005','1044100138','1039884336','43796565','1045023185','1193056971','70386089','39172342','1045326425','1126705367','1007494604','1047964336','43459835','43459649','1193123437','1037976886','22117950','1042709292','1152454651','43412327','39429144','32117680','32119944','8039769','1045423228','8039033','1002085931','21591550','21591930','1045417677','1002085586','1046933310','1046932194','1039022928','1047996504','43323231','43323082','1002148002','15490458','1048017563','1048017637','15490587','15484537','1037628316','1048014283','15487515','1048019008','43718185','71492616','1045076818','98764815','1045078199','1017133860','1022389913','43152707','1038540981','11565230','1077456426','1077453801','35775193','1042732846','1001846077','1042732289','1148143210','98648390','22217714','43147166','32562904','32555496','32557922','1042765516','1005681244','1044509749','1042775361','15328786','1017164850','98529477','43110523','1000088940','1045106870','1045111176','1096203406','1042212861','1001684319','22247274','22243974','78701203','1193594330','1040506668','44120481','1007448632','1045143983','1007494693','43896797')
                    AND   p.id = f.contratospersona_id
                    AND   f.contrato_id = 827
                    AND   f.estado = 'ACTIVO'
                    AND   f.id = m.contratosperfecha_id
                    AND   m.descripcion = 'CONTRATO FIRMADO DIGITALMENTE'").each do |a|
  begin
    d = Contratosperimagen.find(a.contratosperimagen_id)
    d.destroy
  rescue Exception => ex
    puts "Errror...." + a.contratosperimagen_id.to_s + ex.message[0..1000].to_s
  end
end

=end

# Asearmail::SendmailServices.new.sendEmailCodigo('imahsoftware@gmail.com', "Codigo para la firma de la capacitacion", "asear_mailer/envio_codigo.html.erb", nil, nil, 10002,12345)
# AND   p.identificacion IN ('88205295','1005416626','1018342128','1045436611','43482420','1020418955','43671225','98491173','32207812','1020417777','43440716','32191017','1039689049','1128415727','43621949','1041230193','43904194','52905887','43519639','1128393555','43851891','43611827','71691287','1020452098','43628172','43812923','43472732','1040044336','21939627','43651449','42901943','24651673','21431564','1037072946','43701557','1036942694','39456231','43856638','43477778','43476010','1040030696','39328381','1036634000','1045420308','21587602','39274493','42656000','39272252','39276053','43483523','42701813','43535490','21481608','39329327','21487940','1042211109','43610588','1040502276','1035520161','1035126191','1048044439','39213583','43382237','43537321','43632066','43880211','42843393','43679029','43433195','15404928','43667418','39455380','39285814','1037044519','71777848','21487964','1017256546','1036666606','43165288','92642074','1100396677','43710337','25171555','1000754846','43522312','43263170','71275137','1040323476','43787608','1096201494','32278315','3483102','21588553','8027334','43119077','1037268026','43454613','1020444182','1020479631','70979050','43670812','32107912','1152718331','43552659','43270511','43458177','1000747241','21587284','1030420208','1102364062','98389115','1037595182','1001140164','22009395','43813666','1152687711','1017127367','43634713','1152711349','1007380629','11166192','1007111644','32294650','1007459994','52928822','43105001','43684875','43583587','39448261','1010050468','43612763','22148348','21992015','15286557','1038063259','32564909','43484007','22012246','32229418','1007649234','43279190','44002974','1193364751','50906514','71377525','1038477997','1000442655','43588568','1007239214','22034971','5001059285','43599349','1038333841','1040326283','1035390822','1007494374','1007625579','5004868246','32562296','1041257292','1041256497','43695396','1037576530','32182235','43158712','63456808','1017142109','21431564','39450279','43322820','1041256497','43454613','43482420','1020418955','1017192171','1152470950','1037584311','1018225017','42688835','21469392','22009467','43258759','98465189','32259761','1037265633','43254347','43928546','43111190','1118815310','88205295','43591472','39200760','1005416626','1018342128','43280179')

#ContratospernominasController.downloadtirilla
=begin
Objeto.find_by_sql("SELECT distinct i.id contratosperimagen_id
                    FROM  contratosperdotaciones d, contratospersonas p, contratosperimagenes i
                    WHERE d.contrato_id IN (755,756,757)
                    AND   d.contratospersona_id = p.id
                    AND   d.estado != 'PENDIENTE'
                    AND   d.contratospersona_id = i.contratospersona_id
                    AND   d.contratosperfecha_id = i.contratosperfecha_id
                    AND   i.descripcion = 'CERTIFICADO ENTREGA DOTACION'
                    AND   d.codigo_firma IS NOT NULL").each do |a|
  begin
    d = Contratosperimagen.find(a.contratosperimagen_id)
    d.destroy
  rescue Exception => ex
    puts "Errror...." + a.contratosperimagen_id.to_s + ex.message[0..1000].to_s
  end
end

Objeto.find_by_sql("SELECT p.identificacion, d.id
                    FROM  contratosperdotaciones d, contratospersonas p
                    WHERE d.contrato_id IN (755,756,757)
                    AND   d.contratospersona_id = p.id
                    AND   d.estado != 'PENDIENTE'
                    AND   d.codigo_firma IS NOT NULL").each do |a|
  ContratosperdotacionesController.firmardocumento(a.id)
end
=end
=begin
Contratosperlabora.where("anno = '2024' and codigo_firma = '-1'").each do |a|
  a.codigo_firma = SecureRandom.hex
  a.save(validate: false)
end


if !Contratosperlabora.where("anno = '#{anno}' and mes = '#{mes}' and user_asigna = #{isadmin} and contratosperfecha_id = #{@contratosperfecha.id}").present?
  contratosperlabora = Contratosperlabora.new
  contratosperlabora.anno = anno
  contratosperlabora.mes = mes
  contratosperlabora.user_asigna = isadmin
  contratosperlabora.contratospersona_id = @contratosperfecha.contratospersona_id
  contratosperlabora.contratosperfecha_id = @contratosperfecha.id
  contratosperlabora.labora =  params[:contratosperlabora][:labora]
  contratosperlabora.codigo_firma = SecureRandom.hex
  contratosperlabora.save(validate: false)
else
  contratosperlabora = Contratosperlabora.where("anno = '#{anno}' and mes = '#{mes}' and user_asigna = #{isadmin} and contratosperfecha_id = #{@contratosperfecha.id}").first
  contratosperlabora.update(labora: params[:contratosperlabora][:labora], codigo_firma: SecureRandom.hex)
end
=end


#ContratosperprocesosController.generalpdf(72)
#WsController.smscolombiared('3164637945','PRUEBA ASEAR ESP....')
=begin
gastos = Objeto.find_by_sql(["SELECT p.`identificacion`, s.`contratosperfecha_id`, l.id
                              FROM   solicitudesretiros s, contratosperliquidaciones l, contratospersonas p
                              WHERE  s.consecutivo in ('586')
                              AND    s.`contratosperliquidacion_id` = l.`id`
                              AND    s.`contratospersona_id` = p.`id`"])
gastos.each do |g|
  begin
    file = File.open("/samba/gestion/#{g.identificacion.to_s}.pdf", 'rb')
    if file.present?
      contratosperlimagen = Contratosperlimagen.new
      contratosperlimagen.contratosperfecha_id = g.contratosperfecha_id
      contratosperlimagen.user_id = 1
      contratosperlimagen.liquidacionesimagen = file
      contratosperlimagen.save
      file.close
      if contratosperlimagen.id.to_i > 0
        File.delete(file)
      end
    else
      file.close
    end
  rescue Exception => ex
    puts "Errror...." + g.identificacion.to_s + ex.message[0..1000].to_s
  end
end

=end
=begin
Objeto.find_by_sql("SELECT id contratosperimagen_id FROM contratosperimagenes WHERE descripcion = 'ENCUESTA OFIMATICA'").each do |a|
  a = Contratosperimagen.find(a.contratosperimagen_id)
  a.destroy
end
=end
#DatasController.predownload(693)
=begin
1037603082 HECTOR FABIAN ATEHORTUA LOPEZ
1035918708 WENDY VANESSA ISAZA MEJIA

Objeto.find_by_sql("SELECT f.id contratosperfecha_id, u.id user_id, i.id contratosperimagen_id
                    FROM   contratosperfechas f, users u, contratosperimagenes i, contratospersonas p
                    WHERE  p.identificacion IN ('1152690298')
                    AND    p.id = f.contratospersona_id
                    AND    f.codigo_firma IS NOT NULL
                    AND    f.id = i.contratosperfecha_id
                    AND    i.descripcion LIKE 'CONTRATO FIRMADO DIGITALMENTE%'
                    AND    f.contratospersona_id = u.contratospersona_id").each do |a|
  a = Contratosperimagen.find(a.contratosperimagen_id)
  a.destroy
  ContratosperfechasController.firmacontrato(a.contratosperfecha_id,a.user_id)
end

Objeto.find_by_sql("SELECT f.id contratosperfecha_id, u.id user_id, i.id contratosperimagen_id, cf.id idcontrolfirma
                    FROM   contratosperfechas f, users u, contratosperimagenes i, contratospersonas p, contratos c, empresas e, controlfirmas cf
                    WHERE  p.id = f.contratospersona_id
                    AND    f.id = cf.id_registro
                    AND    f.id = i.contratosperfecha_id
                    AND    f.contratospersona_id = u.contratospersona_id
                    AND    f.contrato_id = c.id
                    AND    c.empresa_id = e.id
                    AND    e.logo != 'logo_inicio_asear.png'").each do |a|
  a = Contratosperimagen.find(a.contratosperimagen_id)
  a.destroy
  ControlfirmasController.firmadocumento(a.idcontrolfirma)
end

Contratosperimagen.where("id in (25538)").each do |a|
  a.destroy
  puts "Eliminado..." + a.id.to_s
end

=end


User.where(["id in (31170,31169,31168,31167,31166,31165,31164,31163,31162,31161,31160,31159,31158,31157,31156,31155,31154,31153,31152,31151,31150,31149,31148,31147,31146,31145,31144,31143,31142,31141,31140,31139,31138,31137,31136,31135,31134,31133,31132,31131,31130,31129,31128,31127,31126,31125,31124,31123,31122,31121,31120,31119,31118,31117)"]).each do |p|
  u = User.find(p.id)
  u.password = '890900842'
  u.save(validate: false)
end

=begin

# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
# #
# # Examples:
# #

User.where(["id in (6386,6385,6384,6383,6382,6381,6380,6379,6378,6377,6376,6375,6374,6373,6372,6371,6370,
      6369,6368,6367,6366,6365,6364,6363,6362,6361,6360,6359,6358,6357,6356,6355,6354,6353,
      6352,6351,6350,6349,6348,6347,6346,6345,6344,6343,6342)"]).each do |a|

end

Persona.where(["user_id is null and trunc(created_at) = trunc(sysdate) and portafolio_id = 10100"]).each do |p|
  u = User.create(identificacion:p.identificacion,
              email:p.email,
              portafolio_id:10100,
              username:p.email, 
              password: '12345678', 
              activo: 'S',
              observaciones: 'MIGRACION 12-10-2018',
              tipoconsulta: 'ESTUDIANTE',
              etapa: 'A',
              nombre:p.nombre_completo,
              persona_id:p.id)
  if u.id.to_s != ""
   ActiveRecord::Base.connection.execute("update personas set user_id = #{u.id} where id = #{p.id} and portafolio_id= 10100")
  end
end
=end
=begin
Portafolio.create(nombre:'Dominiisoft',estado: 'ACTIVO')
Modulo.create(descripcion: 'Usuarios', imagen: 'fa fa-users', mensaje: 'Usuarios', controlador: '/admin/users', nivel: '4')
Usersmodulo.create(user_id: 1, modulo_id: 1)
Modulo.create(descripcion:sdsadsads 'Modulos', imagen: 'fa fa-square', mensaje: 'Modulos', controlador: '/modulos', nivel: '4')
#User.create(identificacion:'0000000',email:'admin@admin.com',portafolio_id:1,username:'admin', password: '12345678', activo: 'S',observaciones: 'CREADO', etapa: 'A',nombre:'ADMINISTRADOR')

User.where(["id in (6386,6385,6384,6383,6382,6381,6380,6379,6378,6377,6376,6375,6374,6373,6372,6371,6370,
      6369,6368,6367,6366,6365,6364,6363,6362,6361,6360,6359,6358,6357,6356,6355,6354,6353,
      6352,6351,6350,6349,6348,6347,6346,6345,6344,6343,6342)"]).each do |p|
  u = User.find(p.id)
  u.password = '123456789'
  u.save(validate: false)
end
=end
=begin
User.where("id = 1").each do |p|
  puts "Actualizado ..-. " + p.identificacion.to_s
  p.password = 'Jero0410'
  p.save(validate: false)
end

User.all.each do |p|
    p.failed_attempts = 0
    p.unlock_token = nil
    p.locked_at = nil
    p.save(validate: false)
end

=end
