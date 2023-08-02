-- SQL SERVER

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
CREATE TABLE stg_prontuario.paciente AS
    SELECT *
    FROM stg_hospital_a.paciente
    UNION ALL
    SELECT *
    FROM stg_hospital_b.paciente
    UNION ALL
    SELECT *
    FROM stg_hospital_c.paciente;
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

-- Saída: Paciente B1	01-JAN-90	12345678901	Mãe B1

----------------------------------------------------------

-- PROBLEMA 4

SELECT nome, dt_nascimento, cpf, nome_mae, MAX(dt_atualizacao)
FROM stg_prontuario.paciente
GROUP BY nome, dt_nascimento, cpf, nome_mae
HAVING COUNT(*) > 1;

-- Saída: Paciente B1	01-JAN-90	12345678901	Mãe B1	02-JAN-90

----------------------------------------------------------

-- PROBLEMA 5 e 6: Arquivo Python

----------------------------------------------------------

-- PROBLEMA 7 -- consultar diagrama

-- como diagnostico, tipo e data dependem somente do n_protocolo, causa uma
-- dependência parcial, ferindo a 2FN, assim, é necessário criar uma nova tabela "protocolo"

CREATE TABLE stg_prontuario.atendimento_medico (
    id_paciente INT NOT NULL, -- herda pois entidade fraca
    n_protocolo INT NOT NULL, -- discriminadora
    codigo_procedimento VARCHAR(100),  -- chave estrangeira pelo relacionamento "realiza"
    PRIMARY KEY (id_paciente, n_protocolo),
    FOREIGN KEY (id_paciente) REFERENCES stg_prontuario.paciente(id),
    FOREIGN KEY (codigo_procedimento) REFERENCES stg_prontuario.procedimento_medico(codigo_procedimento)
);

CREATE TABLE stg_prontuario.protocolo (
    id_paciente INT NOT NULL,
    n_protocolo INT NOT NULL,
    tipo CHAR(1),
    data_atendimento DATE,
    PRIMARY KEY (id_paciente, n_protocolo),
    FOREIGN KEY (id_paciente, n_protocolo) REFERENCES stg_prontuario.atendimento_medico(id_paciente, n_protocolo),
);

-- atributo multivalorado de protocolo
CREATE TABLE stg_prontuario.diagnostico (
    id_paciente INT NOT NULL,
    n_protocolo INT NOT NULL,
    diagnostico VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_paciente, n_protocolo, diagnostico), 
    FOREIGN KEY (id_paciente, n_protocolo) REFERENCES stg_prontuario.protocolo(id_paciente, n_protocolo)
);

----------------------------------------------------------

-- PROBLEMA 8

ALTER TABLE stg_prontuario.protocolo
ADD CONSTRAINT CK_tipo_atendimento
CHECK (tipo IN ('I', 'U', 'A'));

-- POVOAMENTO ATENDIMENTO simulação
-- INSERT INTO stg_prontuario.atendimento_medico
--     (id_paciente, n_protocolo, codigo_procedimento)
-- VALUES
--     (1, 1, '1010101');
-- INSERT INTO stg_prontuario.atendimento_medico
--     (id_paciente, n_protocolo, codigo_procedimento)
-- VALUES
--     (2, 2, '2020202');
-- INSERT INTO stg_prontuario.atendimento_medico
--     (id_paciente, n_protocolo, codigo_procedimento)
-- VALUES
--     (3, 3, '3030303 ');
-- INSERT INTO stg_prontuario.atendimento_medico
--     (id_paciente, n_protocolo, codigo_procedimento)
-- VALUES
--     (4, 4, '2020202');
-- INSERT INTO stg_prontuario.atendimento_medico
--     (id_paciente, n_protocolo, codigo_procedimento)
-- VALUES
--     (5, 5, '1010101');

-- POVOAMENTO PROTOCOLO simulação
-- INSERT INTO stg_prontuario.protocolo
--     (id_paciente, n_protocolo, tipo, data_atendimento)
-- VALUES
--     (1, 1, 'U', '2023-07-31');
-- INSERT INTO stg_prontuario.protocolo
--     (id_paciente, n_protocolo, tipo, data_atendimento)
-- VALUES
--     (2, 2, 'U', '2023-08-01');
-- INSERT INTO stg_prontuario.protocolo
--     (id_paciente, n_protocolo, tipo, data_atendimento)
-- VALUES
--     (3, 3, 'U', '2023-08-02');
-- INSERT INTO stg_prontuario.protocolo
--     (id_paciente, n_protocolo, tipo, data_atendimento)
-- VALUES
--     (4, 4, 'I', '2023-08-02');
-- INSERT INTO stg_prontuario.protocolo
--     (id_paciente, n_protocolo, tipo, data_atendimento)
-- VALUES
--     (5, 5, 'A', '2023-08-03');

-- POVOAMENTO DIAGNOSTICO simulação
-- INSERT INTO stg_prontuario.diagnostico (id_paciente, n_protocolo, diagnostico)
-- VALUES
--     (1, 1, 'Gripe');
-- INSERT INTO stg_prontuario.diagnostico (id_paciente, n_protocolo, diagnostico)
-- VALUES
--     (1, 1, 'Febre');
-- INSERT INTO stg_prontuario.diagnostico (id_paciente, n_protocolo, diagnostico)
-- VALUES
--     (2, 2, 'Dor de Cabeça');
-- INSERT INTO stg_prontuario.diagnostico (id_paciente, n_protocolo, diagnostico)
-- VALUES
--     (3, 3, 'Alergia');
-- INSERT INTO stg_prontuario.diagnostico (id_paciente, n_protocolo, diagnostico)
-- VALUES
--     (3, 3, 'Rinite');
-- INSERT INTO stg_prontuario.diagnostico (id_paciente, n_protocolo, diagnostico)
-- VALUES
--     (3, 3, 'Espirros');

SELECT AVG(qtd_diagnosticos) AS media_diagnosticos_tipo_U
FROM (
    SELECT COUNT(*) AS qtd_diagnosticos
    FROM stg_prontuario.diagnostico d
    INNER JOIN stg_prontuario.protocolo p ON p.n_protocolo = d.n_protocolo AND p.id_paciente = d.id_paciente
    INNER JOIN stg_prontuario.atendimento_medico a ON p.n_protocolo = a.n_protocolo AND p.id_paciente = a.id_paciente
    WHERE p.tipo = 'U'
	GROUP BY p.id_paciente, p.n_protocolo
);

-- Saída: 2

----------------------------------------------------------

-- PROBLEMA 9 e 10: Arquivo Python
