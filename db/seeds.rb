Justificacion.destroy_all
ActiveRecord::Base.connection.execute("TRUNCATE justificaciones")
p "Justificaciones resetado"

Partida.destroy_all
ActiveRecord::Base.connection.execute("TRUNCATE partidas")
p "Paridas resetado"

Tipos.destroy_all
ActiveRecord::Base.connection.execute("TRUNCATE tipos")
p "Tipos resetado"

Moneda.destroy_all
ActiveRecord::Base.connection.execute("TRUNCATE monedas")
p "Monedas resetado"

Moneda.create!(
    [
        {
            "id": 1,
            "code": "MXN",
            "nombre": "Pesos Mexicanos",
            "simbolo": "$"
        },
        {
            "id": 2,
            "code": "USD",
            "nombre": "Dolares Americanos",
            "simbolo": "$"
        },
        {
            "id": 3,
            "code": "EUR",
            "nombre": "Euros",
            "simbolo": ""
        },
        {
            "id": 4,
            "code": "CHF",
            "nombre": "Francos Suizos",
            "simbolo": ""
        },
        {
            "id": 5,
            "code": "GBP",
            "nombre": "Libra Esterlina",
            "simbolo": "£"
        }
    ]
)

p "Created #{Moneda.count} Monedas"

Tipo.create!(
    [
        {
            "id": 1,
            "code": "Accesorios y Material de Laboratorio",
            "fraccion": 17,
            "created_at": "2017-11-28 22:23:07",
            "updated_at": "2017-11-28 22:23:07"
        },
        {
            "id": 2,
            "code": "Subcontratacion por Honorarios",
            "fraccion": 14,
            "created_at": "2017-11-28 22:24:09",
            "updated_at": "2017-11-28 22:24:09"
        },
        {
            "id": 3,
            "code": "Mantenimiento a equipos",
            "fraccion": 15,
            "created_at": "2017-11-28 22:24:45",
            "updated_at": "2017-11-28 22:24:45"
        },
        {
            "id": 4,
            "code": "Equipo especializado",
            "fraccion": 17,
            "created_at": "2017-11-28 22:25:06",
            "updated_at": "2017-11-28 22:25:06"
        },
        {
            "id": 5,
            "code": "Otro",
            "fraccion": 1,
            "created_at": "2017-11-28 22:25:19",
            "updated_at": "2017-11-28 22:25:19"
        },
        {
            "id": 6,
            "code": "Capacitación",
            "fraccion": 7,
            "created_at": "2018-01-31 15:27:00",
            "updated_at": "2018-01-31 15:27:09"
        },
        {
            "id": 7,
            "code": "Herramientas y refacciones",
            "fraccion": 7,
            "created_at": "2018-01-31 15:27:32",
            "updated_at": "2018-01-31 15:27:35"
        },
        {
            "id": 8,
            "code": "Alimentos",
            "fraccion": 7,
            "created_at": "2018-01-31 15:27:47",
            "updated_at": "2018-01-31 15:27:50"
        },
        {
            "id": 9,
            "code": "Congresos",
            "fraccion": 1,
            "created_at": "2018-01-31 15:29:03",
            "updated_at": "2018-01-31 15:29:05"
        },
        {
            "id": 10,
            "code": "Servicios integrales",
            "fraccion": 7,
            "created_at": "2018-07-05 09:57:06",
            "updated_at": "2018-07-05 09:57:10"
        }
    ]
)

p "Created #{Tipo.count} Tipos"

Partida.create!(   [
                       {
                           "id": 10000,
                           "nombre": "No aplica"
                       },
                       {
                           "id": 21101,
                           "nombre": "Materiales y útiles de oficina"
                       },
                       {
                           "id": 22104,
                           "nombre": "Productos alimenticios para el personal en las instalaciones de las dependencias y entidades"
                       },
                       {
                           "id": 24201,
                           "nombre": "Cemento y productos de concreto"
                       },
                       {
                           "id": 24301,
                           "nombre": "Cal, yeso y productos de yeso"
                       },
                       {
                           "id": 24401,
                           "nombre": "Madera y productos de madera"
                       },
                       {
                           "id": 24501,
                           "nombre": "Vidrio y productos de vidrio"
                       },
                       {
                           "id": 24601,
                           "nombre": "Material eléctrico y electrónico"
                       },
                       {
                           "id": 24701,
                           "nombre": "Artículos metálicos para la construcción"
                       },
                       {
                           "id": 24801,
                           "nombre": "Materiales complementarios"
                       },
                       {
                           "id": 24901,
                           "nombre": "Otros materiales y artículos de construcción y reparación"
                       },
                       {
                           "id": 25101,
                           "nombre": "PRODUCTOS QUIMICOS BASICOS"
                       },
                       {
                           "id": 25501,
                           "nombre": "MATERIALES,ACCESOSRIOS Y SUMINISTROS DE LABORATORIO"
                       },
                       {
                           "id": 26104,
                           "nombre": "Combustibles, lubricantes y aditivos para vehículos terrestres, aéreos, marítimos, lacustres y fluviales asignados a servidores públicos"
                       },
                       {
                           "id": 27101,
                           "nombre": "VESTUARIO Y UNIFORMES"
                       },
                       {
                           "id": 27201,
                           "nombre": "PRENDAS DE PROTECCION PERSONAL"
                       },
                       {
                           "id": 29101,
                           "nombre": "Herramientas menores"
                       },
                       {
                           "id": 29201,
                           "nombre": "Reracciones y accesorios menores de edificios"
                       },
                       {
                           "id": 29301,
                           "nombre": "Refacciones y accesorios menores de mobiliario y equipo de administración, educacional y recreativo"
                       },
                       {
                           "id": 29401,
                           "nombre": "Refacciones y accesorios para equipo de cómputo y telecomunicaciones"
                       },
                       {
                           "id": 29501,
                           "nombre": "Refacciones y accesorios menores de equipo e instrumental médico y de laboratorio"
                       },
                       {
                           "id": 29601,
                           "nombre": "Refacciones y accesorios menores de equipo de transporte"
                       },
                       {
                           "id": 29801,
                           "nombre": "Refacciones y accesorios menores de maquinaria y otros equipos"
                       },
                       {
                           "id": 29901,
                           "nombre": "Refacciones y accesorios menores de otros bienes mueble"
                       },
                       {
                           "id": 33401,
                           "nombre": "Capacitación"
                       },
                       {
                           "id": 33901,
                           "nombre": "Subcontratación de servicos con terceros"
                       },
                       {
                           "id": 33903,
                           "nombre": "Servicio de transporte"
                       },
                       {
                           "id": 35501,
                           "nombre": "Mantenimiento y conservación de Vehículos terrestres, aéreos, marítimos, lacustres y fluviales"
                       },
                       {
                           "id": 35701,
                           "nombre": "MANTENIMIENTO Y CONSERVACION DE MAQUINARIA Y EQUIPO"
                       }
               ])

p "Created #{Partida.count} Partidas"