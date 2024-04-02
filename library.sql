-- Creacion del modelo de datos library-

drop database library; -- Reset base de datos
create database library;
use library; -- Seleccion de base de datos

-- Objetos creados en esta base de datos

-- Creando tablas
CREATE TABLE school (
    id_school INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL,
    PRIMARY KEY (id_school)
);

CREATE TABLE career (
    id_career INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL,
    school INT NOT NULL,
    PRIMARY KEY (id_career),
    FOREIGN KEY (school)
        REFERENCES school (id_school)
);

CREATE TABLE student (
    id_student INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    identity INT NOT NULL UNIQUE,
    career INT NOT NULL,
    PRIMARY KEY (id_student),
    FOREIGN KEY (career)
        REFERENCES career (id_career)
);

CREATE TABLE university_staff (
    id_universitystaff INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    identity INT NOT NULL UNIQUE,
    staff VARCHAR(45) NOT NULL,
    primary key (id_universitystaff)
);

CREATE TABLE librarian (
    id_librarian INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    identity INT NOT NULL UNIQUE,
    PRIMARY KEY (id_librarian)
);

CREATE TABLE books (
    id_books INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL,
    author VARCHAR(45) NOT NULL,
    career INT NOT NULL,
    PRIMARY KEY (id_books),
    FOREIGN KEY (career)
        REFERENCES career (id_career)
);

CREATE TABLE inventory_control (
    id_inventorycontrol INT NOT NULL AUTO_INCREMENT,
    book INT NOT NULL,
    `status` VARCHAR(45) NOT NULL,
    PRIMARY KEY (id_inventorycontrol),
    FOREIGN KEY (book)
        REFERENCES books (id_books)
);

CREATE TABLE to_buy (
    id_tobuy INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL,
    career INT NOT NULL,
    `status` VARCHAR(45) NOT NULL,
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

-- fin del creado de tablas
