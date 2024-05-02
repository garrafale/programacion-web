/* 1. Se desea mostrar en pantalla a los pasajeros la información sobre los próximos vuelos, ordenados
por el más próximo a partir. No se deben mostrar vuelos que partieron hace más de 30 minutos ni que van a
partir en más de 12hs respecto del momento en que se ejecuta la query.
La información requerida es:
Código de vuelo
Ciudad de destino
Hora de partida (en formato 24hs)
Hora de llegada*/
select v.cod_vuelo, a.ciudad, to_char(v.partida_t,'HH24:MI:SS') as h_partida,
to_char(v.llegada_t,'HH24:MI:SS') as h_llegada
from vuelos v join aeropuertos a
on v.id_destino = a.id
where v.partida_t
between current_timestamp - interval '30 minutes'
and current_timestamp + interval '12 hours';

/* 2. Para el sistema de check-in se requiere obtener la información de los pasajeros:
Apellido, Nombre (con ese formato)
e-mail
Documento
Nacionalidad (nombre del país)*/
select concat(pj.apellido, ', ', pj.nombre), pj.email, pj.documento, ps.nombre
from pasajeros pj
join paises ps on pj.id_pais = ps.id;

/* 3. Para el sistema de check-in, también se requiere modificar el estado del campo "checked_in"
del pasajero una vez que lo haya realizado. Realizar query que actualice dicho valor,
especificando el documento del usuario. */
update tickets set checked_in = current_timestamp where doc_pasajero >= 400;
current_timestamp - INTERVAL concat(doc_pasajero, ' days') where doc_pasajero <= 250;

/* 4. Obtener todos los aviones disponibles, ordenados por consumo, apareciendo el que menos
consume primero y el que más consume, al final. */
select * from aviones order by consumo asc;

/* 5. Mostrar la cantidad de pasajeros de cada nacionalidad que hay cargados en el sistema.
Ordenar de mayor cantidad a menor cantidad.*/
select pi.nombre, count(*) as cantidad from pasajeros ps join paises pi on ps.id_pais = pi.id
group BY pi.nombre order by cantidad desc;

/* 6. Mostrar cuántos vuelos realizó cada avión, ordenados de mayor cantidad a menor cantidad.
Mostrar patente, modelo y cantidad de vuelos. */
select a.patente, a.modelo, count(*) as cantidad_vuelos from aviones a join vuelos v
on a.patente = v.id_avion group by a.patente order by cantidad_vuelos desc;

/* 7. Mostrar los vuelos ordenados por consumo de combustible. Mostrar código de vuelo, y qué
consumo de combustible tiene en función del avión asignado. */
select v.cod_vuelo, a.consumo from vuelos v join aviones a on v.id_avion = a.patente
order by a.consumo;

/* 8. Ordenar los vuelos por duración (en tiempo), ordenados de mayor a menor. */
select * from vuelos order by (llegada_t - partida_t) desc;

/* 9. A partir de la duración de cada vuelo, obtener cuántos litros de combustible se utiliza para
cada uno. Mostrar código de vuelo, ciudad de origen, ciudad de destino y litros de combustible totales.
Esta última columna debe aparecer con el nombre "litros_consumidos" */
select v.cod_vuelo, ae.ciudad, af.ciudad,
av.consumo/(extract( year FROM (v.llegada_t)) - extract( year FROM (v.partida_t)))
as litros_consumidos
from vuelos v join aeropuertos ae
on v.id_origen = ae.id
join aeropuertos af
on v.id_destino = af.id
join aviones av on v.id_avion = av.patente
order by (v.llegada_t - v.partida_t) desc;
--Aclaración: los LITROS CONSUMIDOS son POR AÑO