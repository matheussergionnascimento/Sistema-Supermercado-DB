-- ============================================================
-- BANCO DE DADOS - SUPERMERCADO
-- ============================================================

DROP DATABASE IF EXISTS bd_supermercado;

CREATE DATABASE bd_supermercado
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE bd_supermercado;


-- ============================================================
-- 1. TABELA CLIENTE
-- ============================================================

CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    email VARCHAR(100),
    telefone VARCHAR(20),
    data_nascimento DATE,
    ativo BOOLEAN DEFAULT TRUE
);


-- ============================================================
-- 2. TABELA ENDERECO
-- ============================================================

CREATE TABLE endereco (
    id_endereco INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    logradouro VARCHAR(150) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    complemento VARCHAR(100),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    estado CHAR(2),
    cep VARCHAR(9),

    CONSTRAINT fk_endereco_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


-- ============================================================
-- 3. TABELA COLABORADOR
-- ============================================================

CREATE TABLE colaborador (
    id_colaborador INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    cargo VARCHAR(80) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100),
    salario DECIMAL(10,2),
    data_admissao DATE,
    ativo BOOLEAN DEFAULT TRUE
);


-- ============================================================
-- 4. TABELA FORNECEDOR
-- ============================================================

CREATE TABLE fornecedor (
    id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    razao_social VARCHAR(150) NOT NULL,
    nome_fantasia VARCHAR(150),
    cnpj VARCHAR(18) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(100),
    logradouro VARCHAR(150),
    numero VARCHAR(10),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    estado CHAR(2),
    cep VARCHAR(9),
    ativo BOOLEAN DEFAULT TRUE
);


-- ============================================================
-- 5. TABELA PRODUTO
-- ============================================================

CREATE TABLE produto (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,

    codigo_barras VARCHAR(50) NOT NULL UNIQUE,

    nome VARCHAR(150) NOT NULL,

    descricao VARCHAR(255),

    categoria VARCHAR(100),

    unidade_medida VARCHAR(20) NOT NULL,

    preco_custo DECIMAL(10,2) NOT NULL,

    preco_venda DECIMAL(10,2) NOT NULL,

    estoque DECIMAL(10,3) DEFAULT 0,

    estoque_minimo DECIMAL(10,3) DEFAULT 0,

    id_fornecedor INT NOT NULL,

    ativo BOOLEAN DEFAULT TRUE,

    CONSTRAINT fk_produto_fornecedor
        FOREIGN KEY (id_fornecedor)
        REFERENCES fornecedor(id_fornecedor)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


-- ============================================================
-- 6. TABELA VENDA
-- ============================================================

CREATE TABLE venda (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,

    data_venda DATETIME DEFAULT CURRENT_TIMESTAMP,

    id_cliente INT,

    id_colaborador INT NOT NULL,

    tipo_compra ENUM(
        'PRESENCIAL',
        'ONLINE',
        'DELIVERY',
        'RETIRADA'
    ) NOT NULL DEFAULT 'PRESENCIAL',

    forma_pagamento ENUM(
        'DINHEIRO',
        'CARTAO',
        'PIX',
        'VALE_REFEICAO',
        'VALE_ALIMENTACAO'
    ) NOT NULL,

    valor_desconto DECIMAL(10,2) DEFAULT 0,

    valor_total DECIMAL(10,2) NOT NULL DEFAULT 0,

    status ENUM(
        'PENDENTE',
        'FINALIZADA',
        'CANCELADA'
    ) NOT NULL DEFAULT 'PENDENTE',

    CONSTRAINT fk_venda_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_venda_colaborador
        FOREIGN KEY (id_colaborador)
        REFERENCES colaborador(id_colaborador)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


-- ============================================================
-- 7. TABELA ITEM_VENDA
-- ============================================================

CREATE TABLE item_venda (
    id_item_venda INT AUTO_INCREMENT PRIMARY KEY,

    id_venda INT NOT NULL,

    id_produto INT NOT NULL,

    quantidade DECIMAL(10,3) NOT NULL,

    valor_unitario DECIMAL(10,2) NOT NULL,

    desconto DECIMAL(10,2) DEFAULT 0,

    valor_total DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_item_venda
        FOREIGN KEY (id_venda)
        REFERENCES venda(id_venda)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_item_produto
        FOREIGN KEY (id_produto)
        REFERENCES produto(id_produto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


-- ============================================================
-- DADOS DE EXEMPLO
-- ============================================================


-- ============================================================
-- CLIENTES
-- ============================================================

INSERT INTO cliente
(nome, cpf, email, telefone, data_nascimento)
VALUES
(
    'Joao da Silva',
    '123.456.789-00',
    'joao@email.com',
    '(48) 99999-1111',
    '1990-05-20'
),
(
    'Maria Oliveira',
    '234.567.890-11',
    'maria@email.com',
    '(48) 99999-2222',
    '1985-10-15'
),
(
    'Carlos Santos',
    '345.678.901-22',
    'carlos@email.com',
    '(48) 99999-3333',
    '1995-03-10'
);


-- ============================================================
-- ENDERECOS
-- ============================================================

INSERT INTO endereco
(
    id_cliente,
    logradouro,
    numero,
    complemento,
    bairro,
    cidade,
    estado,
    cep
)
VALUES
(
    1,
    'Rua das Flores',
    '100',
    NULL,
    'Centro',
    'Palhoca',
    'SC',
    '88130-000'
),
(
    2,
    'Rua Brasil',
    '250',
    'Apartamento 202',
    'Centro',
    'Sao Jose',
    'SC',
    '88100-000'
),
(
    3,
    'Avenida Central',
    '500',
    NULL,
    'Kobrasol',
    'Sao Jose',
    'SC',
    '88101-000'
);


-- ============================================================
-- COLABORADORES
-- ============================================================

INSERT INTO colaborador
(
    nome,
    cpf,
    cargo,
    telefone,
    email,
    salario,
    data_admissao
)
VALUES
(
    'Carlos Souza',
    '456.789.012-33',
    'Operador de Caixa',
    '(48) 98888-1111',
    'carlos@supermercado.com',
    2200.00,
    '2024-01-15'
),
(
    'Ana Pereira',
    '567.890.123-44',
    'Gerente',
    '(48) 98888-2222',
    'ana@supermercado.com',
    4500.00,
    '2022-03-10'
),
(
    'Lucas Martins',
    '678.901.234-55',
    'Repositor',
    '(48) 98888-3333',
    'lucas@supermercado.com',
    2100.00,
    '2025-02-01'
);


-- ============================================================
-- FORNECEDORES
-- ============================================================

INSERT INTO fornecedor
(
    razao_social,
    nome_fantasia,
    cnpj,
    telefone,
    email,
    logradouro,
    numero,
    bairro,
    cidade,
    estado,
    cep
)
VALUES
(
    'Distribuidora Brasil LTDA',
    'Distribuidora Brasil',
    '12.345.678/0001-90',
    '(48) 3333-1111',
    'contato@distribuidorabrasil.com',
    'Rua Industrial',
    '100',
    'Centro',
    'Palhoca',
    'SC',
    '88130-100'
),
(
    'Alimentos Sul LTDA',
    'Alimentos Sul',
    '23.456.789/0001-01',
    '(48) 3333-2222',
    'contato@alimentossul.com',
    'Avenida das Industrias',
    '500',
    'Distrito Industrial',
    'Sao Jose',
    'SC',
    '88100-100'
);


-- ============================================================
-- PRODUTOS
-- ============================================================

INSERT INTO produto
(
    codigo_barras,
    nome,
    descricao,
    categoria,
    unidade_medida,
    preco_custo,
    preco_venda,
    estoque,
    estoque_minimo,
    id_fornecedor
)
VALUES
(
    '789100000001',
    'Arroz 5kg',
    'Arroz branco tipo 1',
    'Alimentos',
    'UN',
    20.00,
    28.90,
    50,
    10,
    1
),
(
    '789100000002',
    'Feijao 1kg',
    'Feijao carioca',
    'Alimentos',
    'UN',
    6.00,
    8.90,
    100,
    20,
    1
),
(
    '789100000003',
    'Leite 1L',
    'Leite integral',
    'Laticinios',
    'UN',
    3.80,
    5.49,
    80,
    15,
    2
),
(
    '789100000004',
    'Cafe 500g',
    'Cafe torrado e moido',
    'Bebidas',
    'UN',
    13.00,
    18.90,
    35,
    10,
    2
),
(
    '789100000005',
    'Acucar 1kg',
    'Acucar refinado',
    'Alimentos',
    'UN',
    3.50,
    5.20,
    70,
    15,
    1
),
(
    '789100000006',
    'Oleo de Soja 900ml',
    'Oleo de soja',
    'Alimentos',
    'UN',
    5.00,
    7.50,
    60,
    15,
    1
);


-- ============================================================
-- VENDA DE EXEMPLO 1
-- ============================================================

INSERT INTO venda
(
    id_cliente,
    id_colaborador,
    tipo_compra,
    forma_pagamento,
    valor_desconto,
    valor_total,
    status
)
VALUES
(
    1,
    1,
    'PRESENCIAL',
    'PIX',
    0.00,
    82.07,
    'FINALIZADA'
);


-- ============================================================
-- ITENS DA VENDA 1
-- ============================================================

INSERT INTO item_venda
(
    id_venda,
    id_produto,
    quantidade,
    valor_unitario,
    desconto,
    valor_total
)
VALUES
(
    1,
    1,
    1,
    28.90,
    0.00,
    28.90
),
(
    1,
    2,
    2,
    8.90,
    0.00,
    17.80
),
(
    1,
    3,
    3,
    5.49,
    0.00,
    16.47
),
(
    1,
    4,
    1,
    18.90,
    0.00,
    18.90
);


-- ============================================================
-- VENDA DE EXEMPLO 2
-- ============================================================

INSERT INTO venda
(
    id_cliente,
    id_colaborador,
    tipo_compra,
    forma_pagamento,
    valor_desconto,
    valor_total,
    status
)
VALUES
(
    2,
    1,
    'PRESENCIAL',
    'CARTAO',
    5.00,
    52.50,
    'FINALIZADA'
);


-- ============================================================
-- ITENS DA VENDA 2
-- ============================================================

INSERT INTO item_venda
(
    id_venda,
    id_produto,
    quantidade,
    valor_unitario,
    desconto,
    valor_total
)
VALUES
(
    2,
    1,
    1,
    28.90,
    0.00,
    28.90
),
(
    2,
    5,
    2,
    5.20,
    0.00,
    10.40
),
(
    2,
    6,
    2,
    7.50,
    0.00,
    15.00
);


-- ============================================================
-- ATUALIZAR ESTOQUE
-- ============================================================

UPDATE produto
SET estoque = estoque - 1
WHERE id_produto = 1;

UPDATE produto
SET estoque = estoque - 2
WHERE id_produto = 2;

UPDATE produto
SET estoque = estoque - 3
WHERE id_produto = 3;

UPDATE produto
SET estoque = estoque - 1
WHERE id_produto = 4;


-- ============================================================
-- CONSULTAS / LISTAGENS
-- ============================================================


-- ------------------------------------------------------------
-- LISTAR CLIENTES
-- ------------------------------------------------------------

SELECT *
FROM cliente
WHERE ativo = TRUE;


-- ------------------------------------------------------------
-- LISTAR ENDERECOS DOS CLIENTES
-- ------------------------------------------------------------

SELECT
    c.id_cliente,
    c.nome,
    c.cpf,
    c.telefone,
    c.email,
    e.logradouro,
    e.numero,
    e.bairro,
    e.cidade,
    e.estado,
    e.cep
FROM cliente c
LEFT JOIN endereco e
    ON c.id_cliente = e.id_cliente;


-- ------------------------------------------------------------
-- LISTAR COLABORADORES
-- ------------------------------------------------------------

SELECT *
FROM colaborador
WHERE ativo = TRUE;


-- ------------------------------------------------------------
-- LISTAR FORNECEDORES
-- ------------------------------------------------------------

SELECT *
FROM fornecedor
WHERE ativo = TRUE;


-- ------------------------------------------------------------
-- LISTAR PRODUTOS
-- ------------------------------------------------------------

SELECT
    p.id_produto,
    p.codigo_barras,
    p.nome,
    p.categoria,
    p.unidade_medida,
    p.preco_custo,
    p.preco_venda,
    p.estoque,
    p.estoque_minimo,
    f.nome_fantasia AS fornecedor
FROM produto p
INNER JOIN fornecedor f
    ON p.id_fornecedor = f.id_fornecedor
WHERE p.ativo = TRUE;


-- ------------------------------------------------------------
-- PESQUISAR PRODUTO PELO CODIGO DE BARRAS
-- ------------------------------------------------------------

SELECT *
FROM produto
WHERE codigo_barras = '789100000001';


-- ------------------------------------------------------------
-- LISTAR VENDAS
-- ------------------------------------------------------------

SELECT
    v.id_venda,
    v.data_venda,
    c.nome AS cliente,
    co.nome AS colaborador,
    v.tipo_compra,
    v.forma_pagamento,
    v.valor_desconto,
    v.valor_total,
    v.status
FROM venda v
LEFT JOIN cliente c
    ON v.id_cliente = c.id_cliente
INNER JOIN colaborador co
    ON v.id_colaborador = co.id_colaborador
ORDER BY v.id_venda;


-- ------------------------------------------------------------
-- DETALHAMENTO DE UMA VENDA
-- ------------------------------------------------------------

SELECT
    v.id_venda,
    v.data_venda,
    c.nome AS cliente,
    co.nome AS colaborador,
    p.codigo_barras,
    p.nome AS produto,
    iv.quantidade,
    iv.valor_unitario,
    iv.desconto,
    iv.valor_total
FROM venda v
LEFT JOIN cliente c
    ON v.id_cliente = c.id_cliente
INNER JOIN colaborador co
    ON v.id_colaborador = co.id_colaborador
INNER JOIN item_venda iv
    ON v.id_venda = iv.id_venda
INNER JOIN produto p
    ON iv.id_produto = p.id_produto
WHERE v.id_venda = 1;


-- ============================================================
-- ALTERAÇÕES
-- ============================================================


-- ------------------------------------------------------------
-- ALTERAR TELEFONE DO CLIENTE
-- ------------------------------------------------------------

UPDATE cliente
SET telefone = '(48) 98888-9999'
WHERE id_cliente = 1;


-- ------------------------------------------------------------
-- ALTERAR PRECO DO PRODUTO
-- ------------------------------------------------------------

UPDATE produto
SET preco_venda = 29.90
WHERE id_produto = 1;


-- ------------------------------------------------------------
-- ALTERAR ESTOQUE
-- ------------------------------------------------------------

UPDATE produto
SET estoque = estoque + 20
WHERE id_produto = 1;


-- ============================================================
-- DESATIVAR CADASTROS
-- ============================================================


-- ------------------------------------------------------------
-- DESATIVAR CLIENTE
-- ------------------------------------------------------------

UPDATE cliente
SET ativo = FALSE
WHERE id_cliente = 3;


-- ------------------------------------------------------------
-- DESATIVAR PRODUTO
-- ------------------------------------------------------------

UPDATE produto
SET ativo = FALSE
WHERE id_produto = 6;


-- ------------------------------------------------------------
-- DESATIVAR COLABORADOR
-- ------------------------------------------------------------

UPDATE colaborador
SET ativo = FALSE
WHERE id_colaborador = 3;


-- ============================================================
-- CANCELAMENTO DE VENDA
-- ============================================================

UPDATE venda
SET status = 'CANCELADA'
WHERE id_venda = 2;


-- ============================================================
-- CONSULTAR VENDAS CANCELADAS
-- ============================================================

SELECT
    id_venda,
    data_venda,
    forma_pagamento,
    valor_total,
    status
FROM venda
WHERE status = 'CANCELADA';


-- ============================================================
-- RELATORIOS
-- ============================================================


-- ------------------------------------------------------------
-- VALOR TOTAL DE VENDAS FINALIZADAS
-- ------------------------------------------------------------

SELECT
    SUM(valor_total) AS total_vendido
FROM venda
WHERE status = 'FINALIZADA';


-- ------------------------------------------------------------
-- QUANTIDADE DE VENDAS
-- ------------------------------------------------------------

SELECT
    COUNT(*) AS quantidade_vendas
FROM venda
WHERE status = 'FINALIZADA';


-- ------------------------------------------------------------
-- VENDAS POR FORMA DE PAGAMENTO
-- ------------------------------------------------------------

SELECT
    forma_pagamento,
    COUNT(*) AS quantidade_vendas,
    SUM(valor_total) AS total_vendido
FROM venda
WHERE status = 'FINALIZADA'
GROUP BY forma_pagamento
ORDER BY total_vendido DESC;


-- ------------------------------------------------------------
-- VENDAS POR TIPO DE COMPRA
-- ------------------------------------------------------------

SELECT
    tipo_compra,
    COUNT(*) AS quantidade_vendas,
    SUM(valor_total) AS total_vendido
FROM venda
WHERE status = 'FINALIZADA'
GROUP BY tipo_compra;


-- ------------------------------------------------------------
-- PRODUTOS COM ESTOQUE BAIXO
-- ------------------------------------------------------------

SELECT
    id_produto,
    codigo_barras,
    nome,
    estoque,
    estoque_minimo
FROM produto
WHERE estoque <= estoque_minimo
AND ativo = TRUE;


-- ------------------------------------------------------------
-- PRODUTOS MAIS VENDIDOS
-- ------------------------------------------------------------

SELECT
    p.nome,
    SUM(iv.quantidade) AS quantidade_vendida,
    SUM(iv.valor_total) AS faturamento
FROM item_venda iv
INNER JOIN produto p
    ON iv.id_produto = p.id_produto
INNER JOIN venda v
    ON iv.id_venda = v.id_venda
WHERE v.status = 'FINALIZADA'
GROUP BY p.id_produto, p.nome
ORDER BY quantidade_vendida DESC;


-- ------------------------------------------------------------
-- TOTAL DE VENDAS POR COLABORADOR
-- ------------------------------------------------------------

SELECT
    co.nome AS colaborador,
    COUNT(v.id_venda) AS quantidade_vendas,
    SUM(v.valor_total) AS total_vendido
FROM venda v
INNER JOIN colaborador co
    ON v.id_colaborador = co.id_colaborador
WHERE v.status = 'FINALIZADA'
GROUP BY co.id_colaborador, co.nome
ORDER BY total_vendido DESC;


-- ------------------------------------------------------------
-- TOTAL DE VENDAS POR CLIENTE
-- ------------------------------------------------------------

SELECT
    c.nome AS cliente,
    COUNT(v.id_venda) AS quantidade_compras,
    SUM(v.valor_total) AS total_gasto
FROM venda v
INNER JOIN cliente c
    ON v.id_cliente = c.id_cliente
WHERE v.status = 'FINALIZADA'
GROUP BY c.id_cliente, c.nome
ORDER BY total_gasto DESC;


-- ============================================================
-- FIM DO BANCO DE DADOS
-- ============================================================

-- ============================================================
-- AUTOMATIZAÇÃO - TRIGGER (GATILHO) DE ESTOQUE
-- ============================================================

DELIMITER $$

CREATE TRIGGER tg_baixa_estoque_venda
AFTER INSERT ON item_venda
FOR EACH ROW
BEGIN
    -- Atualiza o estoque do produto diminuindo a quantidade vendida
    UPDATE produto 
    SET estoque = estoque - NEW.quantidade
    WHERE id_produto = NEW.id_produto;
END$$

DELIMITER ;
