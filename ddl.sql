-- tabla clientes
create table clientes (
    cliente_id serial primary key,
    nombre varchar(100) not null,
    apellido varchar(100) not null,
    email varchar(255) unique not null,
    telefono varchar(20) not null,
    direccion text not null,
    fecha_registro timestamp default current_timestamp,
    activo boolean default true
);

-- tabla empleados
create table empleados (
    empleado_id serial primary key,
    nombre varchar(100) not null,
    apellido varchar(100) not null,
    email varchar(255) unique not null,
    telefono varchar(20) not null,
    puesto varchar(50) not null,
    fecha_contratacion date not null,
    activo boolean default true
);

-- tabla sucursales
create table sucursales (
    sucursal_id serial primary key,
    nombre varchar(100) not null,
    direccion text not null,
    ciudad varchar(100) not null,
    pais varchar(100) not null,
    codigo_postal varchar(20) not null,
    telefono varchar(20) not null,
    email varchar(255) unique not null,
    responsable_id integer references empleados(empleado_id)
);

-- tabla paquetes
create table paquetes (
    paquete_id serial primary key,
    cliente_id integer not null references clientes(cliente_id),
    sucursal_origen_id integer not null references sucursales(sucursal_id),
    sucursal_destino_id integer not null references sucursales(sucursal_id),
    empleado_registro_id integer not null references empleados(empleado_id),
    codigo_seguimiento varchar(50) unique not null,
    peso decimal(10,2) not null check (peso > 0),
    alto decimal(10,2) not null check (alto > 0),
    ancho decimal(10,2) not null check (ancho > 0),
    largo decimal(10,2) not null check (largo > 0),
    contenido text not null,
    valor_declarado decimal(10,2) not null check (valor_declarado >= 0),
    fecha_registro timestamp default current_timestamp,
    fecha_entrega_estimada date,
    estado_actual varchar(50) not null,
    instrucciones_especiales text
);

-- tabla estados_paquete
create table estados_paquete (
    estado_id serial primary key,
    nombre varchar(50) unique not null,
    descripcion text
);

-- tabla historial_estados
create table historial_estados (
    historial_id serial primary key,
    paquete_id integer not null references paquetes(paquete_id),
    estado_id integer not null references estados_paquete(estado_id),
    sucursal_id integer references sucursales(sucursal_id),
    empleado_id integer references empleados(empleado_id),
    fecha_hora timestamp default current_timestamp,
    observaciones text
);

-- tabla servicios
create table servicios (
    servicio_id serial primary key,
    nombre varchar(100) unique not null,
    descripcion text,
    precio_base decimal(10,2) not null check (precio_base >= 0),
    tiempo_estimado_dias integer not null check (tiempo_estimado_dias > 0)
);

-- tabla paquete_servicios
create table paquete_servicios (
    paquete_id integer not null references paquetes(paquete_id),
    servicio_id integer not null references servicios(servicio_id),
    precio_aplicado decimal(10,2) not null check (precio_aplicado >= 0),
    primary key (paquete_id, servicio_id)
);

-- tabla tarifas
create table tarifas (
    tarifa_id serial primary key,
    servicio_id integer not null references servicios(servicio_id),
    peso_minimo decimal(10,2) not null check (peso_minimo >= 0),
    peso_maximo decimal(10,2) not null check (peso_maximo > peso_minimo),
    precio decimal(10,2) not null check (precio >= 0),
    activa boolean default true
);

-- tabla transportes
create table transportes (
    transporte_id serial primary key,
    tipo varchar(50) not null,
    matricula varchar(50) unique not null,
    capacidad decimal(10,2) not null check (capacidad > 0),
    modelo varchar(100) not null,
    año integer check (año > 1900),
    activo boolean default true
);

-- tabla rutas
create table rutas (
    ruta_id serial primary key,
    sucursal_origen_id integer not null references sucursales(sucursal_id),
    sucursal_destino_id integer not null references sucursales(sucursal_id),
    distancia_km decimal(10,2) not null check (distancia_km > 0),
    tiempo_estimado_horas decimal(10,2) not null check (tiempo_estimado_horas > 0),
    activa boolean default true,
    check (sucursal_origen_id != sucursal_destino_id)
);

-- tabla envios
create table envios (
    envio_id serial primary key,
    ruta_id integer not null references rutas(ruta_id),
    transporte_id integer not null references transportes(transporte_id),
    empleado_responsable_id integer not null references empleados(empleado_id),
    fecha_salida timestamp not null,
    fecha_llegada_estimada timestamp not null,
    fecha_llegada_real timestamp,
    estado varchar(50) not null,
    check (fecha_llegada_estimada > fecha_salida),
    check (fecha_llegada_real is null or fecha_llegada_real >= fecha_salida)
);

-- tabla paquete_envios
create table paquete_envios (
    paquete_id integer not null references paquetes(paquete_id),
    envio_id integer not null references envios(envio_id),
    fecha_embarque timestamp default current_timestamp,
    fecha_desembarque timestamp,
    primary key (paquete_id, envio_id),
    check (fecha_desembarque is null or fecha_desembarque >= fecha_embarque)
);

-- tabla pagos
create table pagos (
    pago_id serial primary key,
    paquete_id integer not null references paquetes(paquete_id),
    monto_total decimal(10,2) not null check (monto_total > 0),
    metodo_pago varchar(50) not null,
    fecha_pago timestamp default current_timestamp,
    estado varchar(50) not null,
    transaccion_id varchar(100) unique
);


