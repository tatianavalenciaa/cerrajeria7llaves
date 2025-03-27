-- --------------------------
-- Creacion de base de datos
-- --------------------------

drop database if exists cerrajeria;
create database cerrajeria;

use cerrajeria;

-- --------------------------
-- Creacion de tablas
-- --------------------------

--
-- Tabla: usuario 
--
-- Existirán 2 tipos de usuarios: Administrador y Vendedor

create table usuario (
    id_usuario int primary key auto_increment,
    nombre varchar(100),
    usuario varchar(50) ,
    contrasena varchar(255),
    rol varchar(20) not null check (rol in ('Administrador', 'Vendedor')),
    fecha_creacion datetime, 
    fecha_actualizacion datetime
);

--
-- Tabla: categoria_producto
-- 
-- El usuario podrá crear las categorias que desee
-- Ejemplos: llaves_chinas, llaves_yale, llaves_electronicas, etc

create table categoria_producto (
	id_categoria_producto int primary key auto_increment, 
    nombre varchar(100),
    fecha_creacion datetime, 
    fecha_actualizacion datetime
);

--
-- Tabla: producto 
--

create table producto (
    id_producto int primary key auto_increment,
    nombre varchar(100),
    id_categoria_producto int,
    precio decimal(10,2),
    stock int not null check (stock >= 0),
    stock_minimo int not null default 5,
    estado varchar(20) not null check (estado in ('Disponible', 'Bajo', 'Agotado')),
    fecha_creacion datetime, 
    fecha_actualizacion datetime,
    constraint fk_pro_cat foreign key (id_categoria_producto) references categoria_producto(id_categoria_producto)
);

--
-- Tabla: movimiento_stock
--
-- Sirve para llevar el inventario de productos

create table movimiento_stock (
    id_movimiento_stock int primary key auto_increment,
    id_producto int not null,
    tipo varchar(10) not null check (tipo in ('Entrada', 'Salida')),
    cantidad int not null,
    motivo varchar(255),
    fecha_creacion datetime, 
    fecha_actualizacion datetime,
    constraint fk_mst_pro foreign key (id_producto) references producto(id_producto)
);

--
-- Tabla: venta
--
-- El total de la venta se calculará en el sistema.
-- No es necesario agregar una columna de total.

create table venta (
    id_venta int primary key auto_increment,
    id_usuario int not null,
    fecha_creacion datetime, 
    fecha_actualizacion datetime,
	constraint fk_ven_usu foreign key (id_usuario) references usuario(id_usuario)
);

--
-- tabla: detalle_venta
--
-- El subtotal del detalle de venta se calculará en el sistema
-- No es necesario agregar una columna de subtotal.

create table detalle_venta (
    id_detalle_venta int primary key auto_increment,
    id_venta int not null,
    id_producto int not null,
    cantidad int not null,
    fecha_creacion datetime, 
    fecha_actualizacion datetime,
    constraint fk_dve_ven foreign key (id_venta) references venta(id_venta),
    constraint fk_dve_pro foreign key (id_producto) references producto(id_producto)
);


--
-- Tabla: comision_categoria_producto
--
-- Este será un catalogo donde estaran las distintas comisiones por cada categoria de producto
-- Ejemplos:
-- Si venden un producto de la categoria: llaves_chinas, la comision es del 2%
-- Si venden un producto de la categoria: llaves_yale, la comision es del 4%
-- Si venden un producto de la categoria: llaves_electronicas, la comision es del 6%

create table comision_categoria_producto (
	id_com_cat_pro int primary key auto_increment, 
    id_categoria_producto int, 
    porcentaje_comision int,
    fecha_creacion datetime, 
    fecha_actualizacion datetime,
    constraint fk_ccp_cpr foreign key (id_categoria_producto) references categoria_producto(id_categoria_producto)
);

--
-- Tabla: comision
--
-- Aqui se lleva el historial de comisiones de cada usuario

create table comision_usuario (
    id_comision_usuario int primary key auto_increment,
    id_usuario int not null,
    id_venta int not null,
    monto_comision decimal(10,2),
    estado varchar(10) not null check (estado in ('Pendiente', 'Pagado')),
    foreign key (id_usuario) references usuario(id_usuario),
    foreign key (id_venta) references venta(id_venta)
);

--
-- Tabla: servicio
--
-- Un ejemplo de servicio: ir a domicilio a abrir una puerta porque perdieron las llaves

create table servicio (
    id_servicio int primary key auto_increment,
    descripcion varchar(255),
    precio decimal(10,2),
    fecha_creacion datetime, 
    fecha_actualizacion datetime
);

--
-- Tabla: control_financiero 
-- 
-- Sirve para llevar el control de Ingresos y Egresos
-- Esta tabla puede ser llenada cada dia al final del corte
-- No es necesario que una persona lo haga. Lo puede hacer el sistema

CREATE TABLE control_financiero (
    id_control_financiero int primary key auto_increment,
    tipo varchar(10) not null check (tipo in ('Ingreso', 'Egreso')),
    descripcion varchar(255),
    monto decimal(10,2),
    fecha_creacion datetime, 
    fecha_actualizacion datetime
);




