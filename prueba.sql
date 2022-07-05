CREATE DATABASE biblioteca;

\c biblioteca


CREATE TABLE socio(
rut_socio CHAR(10) PRIMARY KEY,
nombre_socio VARCHAR(100),
apellido_socio VARCHAR(100),
direccion_socio VARCHAR(255),
telefono_socio VARCHAR(10)
);


CREATE TABLE autor(
codigo_autor INT PRIMARY KEY,
nombre_autor VARCHAR(100),
apellido_autor VARCHAR(100),
fnac_autor DATE,
fdef_autor DATE
);


CREATE TABLE libro(
isbn_libro CHAR(15) PRIMARY KEY,
titulo_libro VARCHAR(255),
paginas_libro INT
);


CREATE TABLE autoria(
isbn_libro CHAR(15),
codigo_autor INT,
tipo_autor VARCHAR(20),
FOREIGN KEY (isbn_libro) REFERENCES libro (isbn_libro),
FOREIGN KEY (codigo_autor) REFERENCES autor (codigo_autor)
);


CREATE TABLE prestamo(
id_prestamo SERIAL PRIMARY KEY,
fecha_prestamo DATE,
fecha_devolucion DATE,
rut_socio CHAR(10),
isbn_libro CHAR(15),
FOREIGN KEY (rut_socio) REFERENCES socio (rut_socio),
FOREIGN KEY (isbn_libro) REFERENCES libro (isbn_libro)
);

-- INSERTAR VALORES A TABLA AUTORES

INSERT INTO autor(CODIGO_AUTOR, NOMBRE_AUTOR, APELLIDO_AUTOR, FNAC_AUTOR, FDEF_AUTOR)
VALUES
(3, 'JOSE', 'SALGADO', '1968-01-01', '01-01-2020'),
(4, 'ANA', 'SALGADO', '1972-01-01',NULL),
(1, 'ANDRES', 'ULLOA', '1982-01-01',NULL),
(2, 'SERGIO', 'MARDONES', '1950-01-01','2012-01-01'),
(5, 'MARTIN', 'PORTA', '1976-01-01',NULL)
;

-- INSERTAR VALORES A TABLA LIBROS
INSERT INTO LIBRO(ISBN_LIBRO, TITULO_LIBRO, PAGINAS_LIBRO)
VALUES
('111-1111111-111', 'CUENTOS DE TERROR', 344),
('222-2222222-222', 'POESIAS CONTEMPORANEAS', 167),
('333-3333333-333', 'HISTORIA DE ASIA', 511),
('444-4444444-444', 'MANUAL DE MECANICA', 298);

-- INSERTAR VALORES A TABLA AUTORIA
INSERT INTO AUTORIA(ISBN_LIBRO, CODIGO_AUTOR, TIPO_AUTOR)
VALUES
('111-1111111-111', 3, 'PRINCIPAL'),
('111-1111111-111', 4, 'COAUTOR'),
('222-2222222-222', 1, 'PRINCIPAL'),
('333-3333333-333', 2, 'PRINCIPAL'),
('444-4444444-444', 5, 'PRINCIPAL');

-- INSERTAR VALORES A TABLA SOCIO
INSERT INTO SOCIO(RUT_SOCIO, NOMBRE_SOCIO, APELLIDO_SOCIO, DIRECCION_SOCIO, TELEFONO_SOCIO)
VALUES
('1111111-1', 'JUAN', 'SOTO', 'AVENIDA 1, SANTIAGO', '911111111'),
('2222222-2', 'ANA', 'PEREZ', 'PASAJE 2, SANTIAGO', '922222222'),
('3333333-3', 'SANDRA', 'AGUILAR', 'AVENIDA 2, SANTIAGO', '933333333'),
('4444444-4', 'ESTEBAN', 'JEREZ', 'AVENIDA 3, SANTIAGO', '944444444'),
('5555555-5', 'SILVANA', 'MUNOZ', 'PASAJE 3, SANTIAGO', '955555555');

-- INSERTAR VALORES A TABLA PRESTAMO
INSERT INTO PRESTAMO(FECHA_PRESTAMO, FECHA_DEVOLUCION, RUT_SOCIO, ISBN_LIBRO)
VALUES
('2020-01-20', '2020-01-27', '1111111-1', '111-1111111-111'),
('2020-01-20', '2020-01-30', '5555555-5', '222-2222222-222'),
('2020-01-22', '2020-01-30', '3333333-3', '333-3333333-333'),
('2020-01-23', '2020-01-30', '4444444-4', '444-4444444-444'),
('2020-01-27', '2020-02-04', '2222222-2', '111-1111111-111'),
('2020-01-31', '2020-02-12', '1111111-1', '444-4444444-444'),
('2020-01-31', '2020-02-12', '3333333-3', '222-2222222-222');



--1. Mostrar todos los libros que posean menos de 300 páginas:

SELECT titulo_libro, paginas_libro FROM libro WHERE paginas_libro < 300 ORDER BY paginas_libro DESC;


--2. Mostrar todos los autores que hayan nacido después del 01-01-1970

SELECT nombre_autor, apellido_autor FROM autor
WHERE fnac_autor>'1970-01-01';


--3. ¿Cuál es el libro más solicitado?

SELECT titulo_libro, COUNT(*) as numero_prestamos FROM libro
INNER JOIN prestamo
ON libro.isbn_libro = prestamo.isbn_libro
GROUP BY libro.titulo_libro ORDER BY numero_prestamos DESC;


--4. Si se cobrara una multa de $100 por cada día de atraso, mostrar cuánto debería pagar cada usuario que entregue el préstamo después de 7 días:

  --opcion1, muestra resultados de consulta de multa por prestamo

SELECT prestamo.id_prestamo, socio.rut_socio,((fecha_devolucion - fecha_prestamo) - 7)*100 AS "monto_adeudado" FROM prestamo
INNER JOIN socio
ON prestamo.rut_socio=socio.rut_socio
WHERE ((fecha_devolucion - fecha_prestamo) - 7) > 0
ORDER BY prestamo.id_prestamo;


--opcion2, muestra resultados de consulta de multa por socio (sumando la deuda de varios prestamos)

SELECT nombre_socio, apellido_socio, socio.rut_socio,
SUM(fecha_devolucion - fecha_prestamo - 7)*100 AS "monto_adeudado" FROM prestamo
INNER JOIN socio
ON prestamo.rut_socio=socio.rut_socio
WHERE ((fecha_devolucion - fecha_prestamo) - 7) > 0
GROUP BY socio.rut_socio;