-- Creacion del modelo de datos library-

drop database library; -- Reset base de datos
create database library;
use library; -- Seleccion de base de datos

-- Objetos creados en esta base de datos

-- Creando tablas
CREATE TABLE school (
    id_school INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_school)
);

CREATE TABLE career (
    id_career INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    school INT NOT NULL,
    PRIMARY KEY (id_career),
    FOREIGN KEY (school)
        REFERENCES school (id_school)
);

CREATE TABLE student (
    id_student INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    identity INT NOT NULL UNIQUE,
    career INT NOT NULL,
    PRIMARY KEY (id_student),
    FOREIGN KEY (career)
        REFERENCES career (id_career)
);

CREATE TABLE university_staff (
    id_universitystaff INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    identity INT NOT NULL UNIQUE,
    staff VARCHAR(100) NOT NULL,
    primary key (id_universitystaff)
);

CREATE TABLE librarian (
    id_librarian INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    identity INT NOT NULL UNIQUE,
    PRIMARY KEY (id_librarian)
);

CREATE TABLE books (
    id_books INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(200) NOT NULL,
    author VARCHAR(200) NOT NULL,
    career INT NOT NULL,
    PRIMARY KEY (id_books),
    FOREIGN KEY (career)
        REFERENCES career (id_career)
);

CREATE TABLE inventory_control (
    id_inventorycontrol INT NOT NULL AUTO_INCREMENT,
    book INT NOT NULL,
    `status` VARCHAR(200) NOT NULL,
    PRIMARY KEY (id_inventorycontrol),
    FOREIGN KEY (book)
        REFERENCES books (id_books)
);

CREATE TABLE to_buy (
    id_tobuy INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(200) NOT NULL,
    career INT NOT NULL,
    `status` VARCHAR(200) NOT NULL,
    author varchar(200) NOT NULL,
    PRIMARY KEY (id_tobuy),
    FOREIGN KEY (career)
        REFERENCES career (id_career)
);

CREATE TABLE prices (
    id_prices INT NOT NULL AUTO_INCREMENT,
    days INT NOT NULL,
    price INT NOT NULL,
    PRIMARY KEY (id_prices)
);

CREATE TABLE rented (
    id_rented INT NOT NULL AUTO_INCREMENT,
    student INT,
    staff INT,
    `date` DATE NOT NULL,
    devolution DATE,
    book INT NOT NULL,
    librarian INT NOT NULL,
    price INT NOT NULL,
    PRIMARY KEY (id_rented),
    FOREIGN KEY (student)
        REFERENCES student (id_student),
    FOREIGN KEY (staff)
        REFERENCES university_staff (id_universitystaff),
    FOREIGN KEY (book)
        REFERENCES books (id_books),
    FOREIGN KEY (librarian)
        REFERENCES librarian (id_librarian),
    FOREIGN KEY (price)
        REFERENCES prices (id_prices)
);
CREATE TABLE prices_modification (
    id_prices INT NOT NULL,
    days INT NOT NULL,
    price INT NOT NULL,
    date_modification DATETIME
);

-- fin del creado de tablas

-- insercion de registros

insert into school (`name`)
values ('Ciencias exactas'), 
('Ciencias humanas'), 
('Ingenieria'), 
('Ciencias economicas'), 
('Agronomia y veterinaria');

-- SELECT * FROM school;

insert into career (`name`, school)
values('Geologia', 1),
('Ciencias biologicas', 1),
('Profesorado Matematica', 1),
('Microbiologia', 1),
('Quimica', 1),
('Analista en computacion', 1),
('Fisica', 1),
('Tecnico en laboratorio', 1),
('Contador publico', 4),
('Administracion', 4),
('Economia', 4),
('Gestion empresarial', 4),
('Ingenieria agronomica', 5),
('Medicina veterinaria', 5),
('Gestión agropecuaria y agroalimentaria', 5),
('Ingenieria electricista', 3),
('Ingenieria en telecomunicaciones', 3),
('Ingenieria mecanica', 3),
('Ingenieria quimica', 3),
('Ingenieria en energias renovables', 3),
('Abogacia', 2),
('Produccion audiovisual', 2),
('Periodismo', 2),
('Ciencias Politicas', 2),
('Educacion especial', 2),
('Educacion fisica', 2),
('Educacion inicial', 2),
('Enfermeria', 2),
('Filosofia', 2),
('Geografia', 2),
('Historia', 2),
('Inglés', 2),
('Lengua y literatura', 2),
('Psicopedagogia', 2),
('Trabajo social', 2),
('Ciencias juridicas, politicas y sociales', 2);

-- select * from career;

-- Las inserciones de las tablas student, university staff, librarian, books, inventory_control,
-- to buy, prices, se realizaron a través de import Wizard

-- select * from student;
-- select * from university_staff;
-- select * from librarian;
-- select * from books;
-- select * from inventory_control;
-- select * from to_buy;
-- select * from prices;
-- select * from rented;

-- fin de la insercion de datos 

-- creacion de vistas

-- vista de facultades, sus carreras y sus libros
CREATE VIEW v_books_career AS
    SELECT 
        s.name AS `school`,
        c.name AS `career`,
        b.name AS `books`,
        b.author
    FROM
        school AS s
            INNER JOIN
        career AS c ON (c.school = s.id_school)
            INNER JOIN
        books AS b ON (b.career = c.id_career);
        
-- select * from v_books_career;

-- vista de carreras con sus libros a reparar

CREATE VIEW v_books_inventory AS
    SELECT 
        c.name AS career,
        b.name AS book,
        b.author,
        ic.status AS `status`
    FROM
        career AS c
            INNER JOIN
        books AS b ON (b.career = c.id_career)
            INNER JOIN
        inventory_control AS ic ON (ic.book = b.id_books)
    WHERE
        ic.status = 'A reparar';
-- select * from v_books_inventory;

-- vista de libros a comprar
CREATE VIEW v_books_to_buy AS
    SELECT 
        tb.name AS book, c.name AS career, tb.status
    FROM
        to_buy AS tb
            INNER JOIN
        career AS c ON (c.id_career = tb.career)
    WHERE
        tb.status = 'pendiente';
select * from v_books_to_buy;

-- vista de estudiantes
CREATE VIEW v_students AS
    SELECT 
        CONCAT(s.first_name, ' ', s.last_name) AS full_name,
        s.identity,
        c.name AS career
    FROM
        student AS s
            INNER JOIN
        career AS c ON (c.id_career = s.career);
-- select * from v_students;

-- vista de los libros rentados por estudiantes
CREATE VIEW v_rented_students AS
    SELECT 
        CONCAT(s.first_name, ' ', s.last_name) AS student,
        r.date,
        r.devolution,
        b.name AS book,
        c.name AS career,
        CONCAT(l.first_name, ' ', l.last_name) AS librarian,
        p.price
    FROM
        rented AS r
            INNER JOIN
        student AS s ON (s.id_student = r.student)
            INNER JOIN
        books AS b ON (b.id_books = r.book)
            INNER JOIN
        career AS c ON (c.id_career = b.career)
            INNER JOIN
        librarian AS l ON (l.id_librarian = r.librarian)
            INNER JOIN
        prices AS p ON (p.id_prices = r.price);
-- select * from v_rented_students;

-- fin de la creacion de vistas

-- funciones
-- traer nombre de estudiante por DNI
delimiter &%
create function f_name_student(par_identity int)
returns varchar(50) reads sql data
begin
    declare student_name varchar(50);
    select concat(s.first_name, ' ', s.last_name) into student_name from student as s
    where identity = par_identity;
    return student_name;
end
&%
-- select identity, f_name_student (identity) from student;

-- busqueda de un libro a comprar
delimiter &%
create function f_book_status(par_book varchar(100))
returns varchar(50) reads sql data
begin
    declare book_status varchar(50);
    select `status` into book_status from to_buy
    where `name` = par_book;
    return book_status;
end
&%
-- select `name` , f_book_status(`name`) from to_buy;
-- fin de funciones

-- stored procedures
-- depuracion de rentas antiguas
delimiter //
create procedure p_depure_rented()
begin
delete from rented as r
where r.date < '2001-01-01';
end
//
-- call p_depure_rented();
-- insert into rented(student, date, devolution, book, librarian, price)
-- values (29, '2000-11-04', '2000-11-06', 488, 5, 5);
-- select * from rented;

-- agregar de la tabla de to_buy a books los libros ya comprados
delimiter //
create procedure p_add_book(par_id_tobuy int)
begin
DECLARE book_status VARCHAR(20);
DECLARE book_name VARCHAR(100);
DECLARE book_author VARCHAR(100);
DECLARE book_career VARCHAR(100);
declare book_count int;
SELECT 
    name, author, career, status
INTO book_name , book_author , book_career , book_status FROM
    to_buy
WHERE
    id_tobuy = par_id_tobuy;
set book_count = (SELECT COUNT(*) 
    FROM books
    WHERE name = book_name);
if (book_status = 'comprado') then 
 if (book_count > 0) then 
	SELECT 'El libro ya sen encuentra en el stock de libros';
 else
	INSERT INTO books (`name`, author, career)
        VALUES (book_name, book_author, book_career);
	SELECT name, author, career
		FROM books
		WHERE name = book_name;
    end if;
elseif (book_status = 'pendiente') then 
 select name, author, career, status from to_buy 
 WHERE
    id_tobuy = par_id_tobuy;
end if;
end
//
-- call p_add_book('1');
-- fin de stored procedures

-- Inicio de los triggers
-- autoincrementar tabla to_buy
delimiter %%
create trigger tr_to_buy_autoincrement before insert on to_buy for each row
begin
	declare var_id_tobuy int;
    set var_id_tobuy = (select max(id_tobuy)+1 from to_buy);
    set new.id_tobuy = var_id_tobuy;
end
%%
-- select * from to_buy order by 1 desc;
-- insert into to_buy (name, career, status, author);
-- values('pruebla','7','pendiente','autor prueba');

-- loggeo de modificacion de precios
delimiter %%
create trigger tr_prices_modif after update on prices for each row
begin
	insert into prices_modification(id_prices, days, price, date_modification)
    values (old.id_prices, old.days, old.price, current_timestamp());
end
%%
-- select * from prices;
-- update prices
-- set price = '650'
-- where id_prices = '6';
select * from prices_modification;
