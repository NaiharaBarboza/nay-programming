CREATE bd_ConsorcioVeiculo_NS2
GO
USE bd_ConsorcioVeiculo_NS2
GO

CREATE TABLE tb_veiculo (
id_veiculo VARCHAR(8) NOT NULL,
categoria_veiculo INT,
chassi_veiculo VARCHAR(25),
modelo_veiculo VARCHAR(40),
marca_veiculo VARCHAR(30),
cor_veiculo VARCHAR (10),
tamanho_veiculo VARCHAR (6),
peso_veiculo VARCHAR (6),
ano_veiculo VARCHAR (4),
PRIMARY KEY (id_veiculo)
);
GO

CREATE TABLE tb_cliente(
nome_cliente VARCHAR (40),
cpf_cliente VARCHAR (11) NOT NULL,
rg_cliente VARCHAR (9),
dataNasc_cliente VARCHAR(8),
endereço_cliente VARCHAR(100),
PRIMARY KEY (cpf_cliente)
);
GO

CREATE TABLE tb_categoriaVeiculo (
id_categoria INT NOT NULL,
nome_categoria VARCHAR(50)
);
GO
CREATE TABLE tb_funcionario (
cod_funcionario VARCHAR (11),
nome_funcionario VARCHAR(40),
num_telefoneFunc VARCHAR(10)
);
GO

CREATE TABLE tb_venda (
id_venda VARCHAR(10),
forma_pagamento VARCHAR(11),
estado_veiculo VARCHAR(5),
valor_parcelaVARCHAR (4) NOT NULL,
qtd_parcela INT CHECK(qtd_parcela<=60),
data_venda VARCHAR(8),
valor_total VARCHAR (7) NOT NULL,
FOREIGN KEY (cpf_cliente) REFERENCES tb_cliente(cpf_cliente),
FOREIGN KEY (id_veiculo) REFERENCES tb_veiculo (id_veiculo)
);
GO

CREATE TABLE tb_compraUsado (
estado_usado VARCHAR(5),
chassi_usado VARCHAR(25) NOT NULL,
ano_carro INT(4) NOT NULL,
forma_pagamento VARCHAR(10),
data_compra VARCHAR (8),
valor_normal VARCHAR (8),
valor_cacrescimo VARCHAR (8)
);

SELECT * FROM tb_veículo v
INNER JOIN tb_categoriaVeiculo c
ON v.categoria_veiculo = c.id_categoria;
SELECT i.cpf_cliente, s.cpf_cliente
FROM tb_cliente i
LEFT JOIN tb_venda s ON i.cpf_cliente = s.cpf_cliente;
SELECT a.id_veiculo, n.id_veiculo
FROM tb_veiculo a
RIGHT JOIN tb_venda n ON a.id_veiculo = n.id_veiculo;
SELECT * FROM tb_funcionario f
FULL OUTER JOIN tb_venda p
ON f.cod_funcionario = p.id_venda;
SELECT a.forma_pagamento, b.forma_pagamento
FROM tb_venda a , tb_compraUsado b
WHERE a.forma_pagamento = b.forma_pagamento;
SELECT a.forma_pagamento, b.forma_pagamento
FROM tb_venda a
LEFT JOIN tb_compraUsado b ON a.forma_pagamento = b.forma_pagamento
WHERE a.forma_pagamento IS NULL

CREATE PROCEDURE add_Juros
@forma_pagamento VARCHAR (11),
AS
BEGIN
UPDATE tb_venda
SET valor_total = valor_total *1.1;
WHERE forma_pagamento=@forma_pagamento;
END;
exec add_Juros (Crédito)
--adiciona 10% de juros para pagamentos no crédito—

CREATE FUNCTION calc_valor
RETURNS VARCHAR
AS
BEGIN
DECLARE @valor_total VARCHAR(11)
SELECT @qtd_parcela = qtd_parcela, @valor_parcela= valor_parcela
FROM tb_venda
SELECT @valor_total = @qtd_parcela*@valor_parcela
FROM tb_vendas
WHERE valor_total = @valor_total
RETURN @valor_total
END;
--calcula valor total do carro de acordo com a quantidade e valor das parcelas--

CREATE TRIGGER tr_acrescimo AFTER
INSERT OF estado_usado
ON tb_compraUsado
FOR EACH ROW
BEGIN
 IF(estado_usado = ‘Ótimo’)
THEN
SET NEW. valor_cacrescimo
SET NEW.valor_cacrescimo = (NEW. valor_cacrescimo * 1.05);
END IF;

END;
--caso o carro usado for de ótimo estado, a concessionária compra o carro e bonifica o dono com um
acréscimo de 5% além do valor do carro --
