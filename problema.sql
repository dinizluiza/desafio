-- SQL SERVER

-- Quando há versão 1 e versão 2, são formas diferentes de resolver
-- aquele problema/trecho de código específico. Não é para interpretar todos
-- os "versão 1" como um documento completo e "versão 2" como outro.

-- PROBLEMA 1 e 2

CREATE DATABASE hospital_staging;

USE hospital_staging;

CREATE SCHEMA stg_hospital_a;
CREATE SCHEMA stg_hospital_b;
CREATE SCHEMA stg_hospital_c;

-- Simulando valores para stg_hospital_{a, b, c}
CREATE TABLE stg_hospital_a.paciente (
    id INT PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(100),
    dt_nascimento DATE,
    cpf INT,
    nome_mae VARCHAR(100),
    dt_atualizacao TIMESTAMP
);

CREATE TABLE stg_hospital_b.paciente (
    id INT PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(100),
    dt_nascimento DATE,
    cpf INT,
    nome_mae VARCHAR(100),
    dt_atualizacao TIMESTAMP
);

CREATE TABLE stg_hospital_c.paciente (
    id INT PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(100),
    dt_nascimento DATE,
    cpf INT,
    nome_mae VARCHAR(100),
    dt_atualizacao TIMESTAMP
);

INSERT INTO
    stg_hospital_a.paciente (nome, dt_nascimento, cpf, nome_mae, dt_atualizacao)
VALUES
    ('Paciente A1', '1990-01-01', 12345678901, 'Mãe A1', CURRENT_TIMESTAMP);
INSERT INTO
    stg_hospital_a.paciente (nome, dt_nascimento, cpf, nome_mae, dt_atualizacao)
VALUES
    ('Paciente A2', '1985-03-15', 98765432109, 'Mãe A2', CURRENT_TIMESTAMP);
INSERT INTO
    stg_hospital_a.paciente (nome, dt_nascimento, cpf, nome_mae, dt_atualizacao)
VALUES
    ('Paciente A3', '2000-12-30', 54321678901, 'Mãe A3', CURRENT_TIMESTAMP);

INSERT INTO
    stg_hospital_b.paciente (nome, dt_nascimento, cpf, nome_mae, dt_atualizacao)
VALUES
    ('Paciente B1', '1988-05-20', 45678901234, 'Mãe B1', CURRENT_TIMESTAMP);
INSERT INTO
    stg_hospital_b.paciente (nome, dt_nascimento, cpf, nome_mae, dt_atualizacao)
VALUES
    ('Paciente B2', '1995-07-10', 56789012345, 'Mãe B2', CURRENT_TIMESTAMP);
INSERT INTO
    stg_hospital_b.paciente (nome, dt_nascimento, cpf, nome_mae, dt_atualizacao)
VALUES
    ('Paciente B3', '1979-11-25', 67890123456, 'Mãe B3', CURRENT_TIMESTAMP);

INSERT INTO
    stg_hospital_c.paciente (nome, dt_nascimento, cpf, nome_mae, dt_atualizacao)
VALUES
    ('Paciente A1', '1990-01-01', 12345678901, 'Mãe A1', CURRENT_TIMESTAMP);
INSERT INTO
    stg_hospital_c.paciente (nome, dt_nascimento, cpf, nome_mae, dt_atualizacao)
VALUES
    ('Paciente C2', '1980-04-05', 90123456789, 'Mãe C2', CURRENT_TIMESTAMP);
INSERT INTO
    stg_hospital_c.paciente (nome, dt_nascimento, cpf, nome_mae, dt_atualizacao)
VALUES
    ('Paciente C3', '2005-02-14', 43210987654, 'Mãe C3', CURRENT_TIMESTAMP);

CREATE SCHEMA hospital_staging.stg_prontuario;

-- VERSÃO 1
-- CREATE TABLE stg_prontuario.paciente AS
--     SELECT *
--     FROM stg_hospital_a.paciente
--     UNION ALL
--     SELECT *
--     FROM stg_hospital_b.paciente
--     UNION ALL
--     SELECT *
--     FROM stg_hospital_c.paciente;
-- /VERSÃO 1

-- VERSÃO 2
CREATE TABLE stg_prontuario.paciente (
    id INT PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(100),
    dt_nascimento DATE,
    cpf INT,
    nome_mae VARCHAR(100),
    dt_atualizacao TIMESTAMP
);

INSERT INTO stg_prontuario.paciente (nome, dt_nascimento, cpf, nome_mae, dt_atualizacao)
SELECT nome, dt_nascimento, cpf, nome_mae, dt_atualizacao
FROM stg_hospital_a.paciente
UNION ALL
SELECT nome, dt_nascimento, cpf, nome_mae, dt_atualizacao
FROM stg_hospital_b.paciente
UNION ALL
SELECT nome, dt_nascimento, cpf, nome_mae, dt_atualizacao
FROM stg_hospital_c.paciente;
-- /VERSÃO 2

-- SELECT * FROM stg_prontuario.paciente;

----------------------------------------------------------

-- PROBLEMA 3

SELECT nome, dt_nascimento, cpf, nome_mae
FROM stg_prontuario.paciente
GROUP BY nome, dt_nascimento, cpf, nome_mae
HAVING COUNT(*) > 1;

----------------------------------------------------------

-- PROBLEMA 4

SELECT nome, dt_nascimento, cpf, nome_mae, MAX(dt_atualizacao)
FROM stg_prontuario.paciente
GROUP BY nome, dt_nascimento, cpf, nome_mae
HAVING COUNT(*) > 1;

----------------------------------------------------------

-- PROBLEMA 5 e 6: Arquivo Python

----------------------------------------------------------

-- PROBLEMA 7
-- atributo multivalorado de procedimento / atendimento médico
CREATE TABLE diagnostico (
    codigo_processamento VARCHAR(100) PRIMARY KEY,
    diagnostico VARCHAR(100) PRIMARY KEY,
    FOREIGN KEY (codigo_processamento) REFERENCES processamento_medico(codigo_processamento)
);
