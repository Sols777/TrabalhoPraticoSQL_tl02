# Criar base de dados

```sql
CREATE DATABASE ta02_pegaevai
```

# Criar tabelas
As tabelas foram criadas de acordo com o schema disponibilizado.
Foi retirada a informação (v/f) do campo ''refrigerado'' da tabela ''produto'', uma vez que tal informação seria apenas para a criação da tabela. Quem a utiliza e faz manutenção consegue verificar essa informação facilmente.
Na tabela 'local' o campo nome deveria ser substituído por campos de localização mais exatos (distrito, concelho, freguesia), uma vez que pode ter influencia depois nos preços vs preço base. Se for o local como nome do local, deveria existir uma outra tabela de referência geográfica para ligar com esta.


1. criar tabela **Local**
    ```sql
    CREATE TABLE Local(
    id INT,
    nome VARCHAR(50),
    CONSTRAINT PK_Local PRIMARY KEY (id)
    );
    ```
2. criar tabela **Maquina**
    ```sql
    CREATE TABLE Maquina(
    codigo INT,
    idLocal INT,
    dataUltimaManut DATETIME,
    CONSTRAINT PK_Maquina PRIMARY KEY (codigo),
    CONSTRAINT FK_Maquina_local FOREIGN KEY(idLocal)
    REFERENCES local(id)
    );
    ````
    
3. criar tabela **TipoProduto**
    ```sql
    CREATE TABLE TipoProduto(
    id INT,
    nome VARCHAR(50),
    CONSTRAINT PK_tipoProduto PRIMARY KEY (id)
    );
    ```
    
4. criar tabela **Produto**
    ```sql
    CREATE TABLE Produto(
    id INT,
    nome VARCHAR(50),
    idTipo INT,
    refrigerado bit,
    valorPredefinido DECIMAL(9,2),
    CONSTRAINT PK_Produto PRIMARY KEY (id),
    CONSTRAINT FK_Produto_TipoProduto FOREIGN KEY(idTipo)
    REFERENCES tipoProduto(id)
    );
    ```
    
5. criar tabela **Maquina_Produto**
    ```sql
    CREATE TABLE Maquina_Produto(
    codMaquina INT,
    idProduto INT,
    valorUnidade DECIMAL(9,2),
    stock INT,
    CONSTRAINT PK_Maquina_Produto PRIMARY KEY (codMaquina ,idProduto),
    CONSTRAINT FK_Maquina_Produto_Maquina FOREIGN KEY(codMaquina)
    REFERENCES maquina(codigo),
    CONSTRAINT FK_Maquina_Produto_Produto FOREIGN KEY(idProduto)
    REFERENCES produto(id)
    );
    ```
    
6. criar tabela **MetodoDePagamento**
    ```sql
    CREATE TABLE MetodoDePagamento(
    id INT,
    nome VARCHAR(50),
    CONSTRAINT PK_MetodoDePagamento PRIMARY KEY (id)
    );
    ```
    
7. criar tabela **Venda**
    ```sql
    CREATE TABLE Venda(
    codMaquina INT,
    idProduto INT,
    valor DECIMAL(11,2),
    dataHora DATETIME,
    idMetodoPagamento INT,
    CONSTRAINT PK_Venda PRIMARY KEY (codMaquina ,idProduto,dataHora),
    CONSTRAINT FK_Venda_Maquina FOREIGN KEY(codMaquina)
    REFERENCES maquina(codigo),
    CONSTRAINT FK_Venda_Produto FOREIGN KEY(idProduto)
    REFERENCES produto(id),
    CONSTRAINT FK_Venda_MetodoDePagamento FOREIGN KEY(idMetodoPagamento)
    REFERENCES metododepagamento(id)
    );
    ```
    
<!--     scheama
    
    ![Alt text](/schema.png) -->
    

# Inserir dados de teste

#### PS: nesta fase tinha-mos os ID's com auto increment para teste , retirado apos ver-mos que os dados ja vinham com ID's
1. Insert na tabela local
    
    ```sql
    INSERT INTO local (nome) VALUES
    ('Porto'),
    ('Braga'),
    ('Coimbra');
    ```
    
2. Insert na tabela maquina
    
    ```sql
    INSERT INTO maquina (idLocal,dataUltimaManut) VALUES
    (1 ,'2024-07-24 15:45:00'),
    (2 ,'2023-12-31 23:59:59'),
    (3 ,'2023-03-01 03:02:22');
    ```
    
3. Insert na tabela tipoProduto
    
    ```sql
    INSERT INTO tipoproduto (nome) VALUES
    ('Bebida'),
    ('Comida'),
    ('Utensilios');
    ```
    
4. Insert na tabela produto
    
    ```sql
    INSERT INTO produto (nome,idTipo,refrigerado) VALUES
    ('Sumo de laranja' ,1,1,2.5),
    ('Baba de camelo' ,2,1,3.6),
    ('Colher de plastico' ,3,0,0.75);
    ```
    
5. Insert na tabela maquina_produto
    
    ```sql
    INSERT INTO maquina_produto (codMaquina,idProduto,valorUnidade,stock)
    VALUES
    (1, 1, 1.70,4),
    (2, 2, 2.50,3),
    (3, 3, 0.20,9)
    ```
    
6. Insert na tabela MetodoDePagamento

    ```sql
    INSERT INTO metododepagamento(nome) VALUES
    ('MBWAY'),
    ('Dinheiro'),
    ('VISA/MASTERCARD');
    ```
    
7. Insert na tabela vendas
    
    ```sql
    INSERT INTO venda (codMaquina,idProduto,valor,dataHora,idMetodoPagamento)
    VALUES
    (1, 1, 18.50,'2024-07-23 18:02:47',1),
    (2, 2, 19.3,'2024-07-25 12:12:05',2),
    (3, 3, 6.20,'2024-07-24 17:40:30',3);
    ```   

# Apagar os registos de testes
```sql
DELETE FROM venda;
DELETE FROM metododepagamento;
DELETE FROM maquina_produto;
DELETE FROM maquina;
DELETE FROM produto;
DELETE FROM tipoproduto;
DELETE FROM local;
```

# Upload dos ficheiros

1. Foi realizada uma limpeza do file txt removendo a primeira linha, parênteses, aspas e ponto e vírgulas. Os files ficaram do tipo: info,info,info,etc
 
2. Importação do file através do código abaixo (generalizado):
```sql
LOAD DATA INFILE 'diretório_do_file/nome_do_file.txt'
INTO TABLE nome_tabela
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
```

# Selecionar dados
1. Listar todos os locais ordenado os nomes por ordem alfabética.
    ```sql
    SELECT nome as "Nome do local"
    FROM Local
    ORDER BY nome;
    ```

2. Listar os 5 locais com mais máquinas.
    ```sql
    SELECT l.nome AS "Nome do local", COUNT(m.codigo) AS "Quantidade de máquinas"
    FROM Local l
    JOIN Maquina m ON l.id = m.idLocal
    GROUP BY l.nome
    ORDER BY COUNT(m.codigo) DESC
    LIMIT 5;
    ```

3. Saber os locais que não tem máquinas.
    ```sql
    SELECT l.nome as "Locais sem máquinas"
    FROM Local l
    LEFT JOIN Maquina m ON l.id = m.idLocal
    WHERE m.codigo IS NULL;
    ```

4. Mostrar todas as máquinas e o nome do local.

   - Info ordernada primeiro por nome do local e não por código máquina uma vez que o local pode ter máquinas mais antigas e mais recentes

    ```sql
    SELECT m.codigo AS "Código da máquina", l.nome AS "Nome do local"
    FROM Maquina m
    JOIN Local l ON m.idLocal = l.id
    ORDER BY l.nome, m.codigo;
    ```

5. Mostrar todas as máquinas e nome do local, onde a manutenção foi feita à mais de 2 meses.

    -  Ordenamos por data manutenção para ser mais fácil de verificar quais as que não têm manutenção há mais tempo.

    ```sql
    SELECT m.codigo AS "Código da máquina", l.nome AS "Nome do local", dataUltimaManut as "Última Manutenção"
    FROM Maquina m
    JOIN Local l ON m.idLocal = l.id
    WHERE m.dataUltimaManut < DATE_SUB(CURDATE(), INTERVAL 2 MONTH)
    ORDER BY dataUltimaManut;
    ```

6. Listar todos os produtos registrados, o tipo de produto por extenso e em quantas máquinas ele está a venda. (não deves mostrar os id/códigos)
    ```sql
    SELECT p.nome AS "Nome do Produto", tp.nome AS "Tipo do produto", COUNT(mp.codMaquina) AS "Quantidade de máquinas"
    FROM Produto p
    JOIN TipoProduto tp ON p.idTipo = tp.id
    LEFT JOIN Maquina_Produto mp ON p.id = mp.idProduto
    GROUP BY p.nome, tp.nome
    Order BY p.nome;
    ```

7. Saber a informação dos produtos que estão com um stock abaixo de 3. Mostra a informação da máquina também. 

    - Ordenamos por local e código de máquina para ser mais fácil verificar o que é preciso para cada, para facilitar a ação de reposição.

    ```sql
    SELECT p.nome AS "Nome do Produto", tp.nome AS "Tipo do produto", mp.stock, m.codigo AS "Código da máquina", l.nome AS "Nome do local"
    FROM Produto p
    JOIN TipoProduto tp ON p.idTipo = tp.id
    JOIN Maquina_Produto mp ON p.id = mp.idProduto
    JOIN Maquina m ON mp.codMaquina = m.codigo
    JOIN Local l ON m.idLocal = l.id
    WHERE mp.stock < 3
    ORDER BY l.nome, m.codigo;
    ```

8. Cria uma view que mostra as vendas mais recentes.

    - Se quisermos, por exemplo, as 20 mais recentes, seria adicionar LIMIT 20;

    ```sql
    create view VendasMaisRecentes as
    SELECT 
    v.dataHora AS "Data e hora",
    p.nome AS "Nome do produto",
    v.idProduto AS "Id do produto",
    v.valor,
    v.codMaquina AS "Código da máquina",
    v.idProduto AS "Vendas",
    mdp.nome AS "Metodo de Pagamento"
    FROM Venda v
    JOIN Produto p ON v.idProduto = p.id
    JOIN MetodoDePagamento mdp ON v.idMetodoPagamento = mdp.id
    ORDER BY 
    v.dataHora DESC
    ```


9. Cria uma view que apresenta a percentagem de vendas através do método de pagamento por QR Code.
    ```sql
    CREATE VIEW PercentagemVendasQRCode AS
    SELECT 
        mp.nome AS "Método Pagamento", 
        COUNT(*) AS "Total Vendas", 
        ROUND((COUNT(*) / (SELECT COUNT(*) FROM Venda)) * 100, 2) AS "Percentagem Vendas" 
    FROM Venda v 
    JOIN MetodoDePagamento mp ON v.idMetodoPagamento = mp.id 
    WHERE mp.nome LIKE '%QR%' 
    GROUP BY mp.nome
    ORDER BY "Percentagem Vendas" DESC;
    ```

10. Desafío: mostrar, na mesma view, as percentagem para cada método de pagamento.

Opção 1: validando quais são QR Code
```sql
CREATE OR REPLACE VIEW PercentagemVendasQRCode AS
SELECT
    mp.nome AS "Método Pagamento",
    COUNT(v.idMetodoPagamento) AS "Total Vendas",
    ROUND((COUNT(v.idMetodoPagamento) * 100.0 / (SELECT COUNT(*) FROM Venda)), 2) AS "Percentagem Vendas",
    CASE 
        WHEN mp.nome LIKE '%QR%' THEN 'Sim'
        ELSE 'Não'
    END AS "É QR Code"
FROM MetodoDePagamento mp
LEFT JOIN Venda v ON mp.id = v.idMetodoPagamento
GROUP BY mp.id, mp.nome
ORDER BY "Percentagem Vendas" DESC;
```

Opção 2: validando quais são QR Code
```sql
ALTER VIEW PercentagemVendasQRCode AS
SELECT 
    mp.nome AS "Método Pagamento", 
    COUNT(v.idMetodoPagamento) AS "Total Vendas",
    ROUND((COUNT(v.idMetodoPagamento) * 100.0) / (SELECT COUNT(*) FROM Venda), 2) AS "Percentagem Vendas",
    CASE 
        WHEN mp.nome LIKE '%QR%' THEN 'Sim'
        ELSE 'Não'
    END AS "É QR Code"
FROM MetodoDePagamento mp
LEFT JOIN Venda v ON mp.id = v.idMetodoPagamento
GROUP BY mp.id, mp.nome
ORDER BY "Percentagem Vendas" DESC;
```

# Procedimentos
1. Procedimento regista uma nova venda com os dados recebidos (código da máquina, o ID do produto e o ID do método de pagamento), bem como a data atual e o preço atual.

Código:
```sql
DROP PROCEDURE IF EXISTS fazerMovimento;
DELIMITER //
CREATE PROCEDURE fazerMovimento (
    IN codigo_maquina INT,
    IN id_produto INT,
    IN id_MetodoPagamento INT)
BEGIN
    DECLARE vPreco DECIMAL(11,2);
    DECLARE stockExistente INT;
    DECLARE contagem INT;
    START TRANSACTION;
    -- Verificar se existe exatamente um registro correspondente (uma vez que o erro que estava a dar era de vários registos)
    SELECT COUNT(*) INTO contagem
    FROM maquina_produto
    WHERE codMaquina = codigo_maquina AND idProduto = id_produto;
    IF contagem = 1 THEN
        -- Verificar stock existente e preço
        SELECT stock, valorUnidade INTO stockExistente, vPreco
        FROM maquina_produto
        WHERE codMaquina = codigo_maquina AND idProduto = id_produto;
        -- Validar se existe stock
        IF stockExistente > 0 THEN
            -- Validar que o preço existe
            IF vPreco IS NOT NULL THEN
                -- Inserir o movimento
                INSERT INTO venda (codMaquina, idProduto, valor, dataHora, idMetodoPagamento)
                VALUES (codigo_maquina, id_produto, vPreco, NOW(), id_MetodoPagamento);
                -- Atualizar o stock da máquina
                UPDATE maquina_produto
                SET stock = stock - 1
                WHERE codMaquina = codigo_maquina AND idProduto = id_produto;
                COMMIT;
                SELECT 'Tudo ok' AS mensagem; -- se tudo ok -> sem registos múltiplos, stock >0 e preço existente
            ELSE
                ROLLBACK;
                SELECT 'Preço não definido' AS mensagem; -- sem registos múltiplos, stock >0 mas preço não existente
            END IF;
        ELSE
            ROLLBACK;
            SELECT 'Sem stock' AS mensagem; -- sem registos múltiplos, mas stock <0 
        END IF;
    ELSE
        ROLLBACK;
        SELECT 'Erro: Produto/máquina not found ou múltiplos registos' AS mensagem; -- com registos múltiplos
    END IF;
END //
DELIMITER ;
```

Exemplo call da procedure:
```sql
CALL fazerMovimento(7001, 7010, 7001);
```

2. Procedimento que retorna o valor total de vendas por máquina entre o período indicado por parâmetros.

Código:
```sql
DROP PROCEDURE IF EXISTS vendasEntreDatas;
 
DELIMITER //
 
CREATE PROCEDURE vendasEntreDatas (
    IN dataInicio DATETIME,
    IN dataFim DATETIME
)
BEGIN
 
    START TRANSACTION;
    SELECT SUM(valor)
    FROM venda
    WHERE dataHora BETWEEN dataInicio AND dataFim
    GROUP BY codMaquina;
 
    COMMIT;
    SELECT valorTotalVendas;
END //
 
DELIMITER ;
```

Exemplo call da procedure:
```sql
CALL vendasEntreDatas('2023-01-01 00:00:00', '2025-01-31 23:59:59')
```

# Otimização
1. Verifica, e documenta o processo, se:
    1. É possível otimizar a entrega dos dados da alínea 1. de Procedimento. 
    ```sql
    CREATE UNIQUE INDEX idx_MaquinaProduto ON maquina_produto (codMaquina, idProduto);
    CREATE INDEX idx_VendaMaquinaProduto ON venda (codMaquina, idProduto);
    CREATE INDEX idx_VendadataHora ON venda (dataHora);
    ```
    - Com a chama da procedure, o tempo de resposta foi de 0.0138, 0.0135 e 0.0007 segundos, nas 3 vezes que foi chamada, estalibizando depois nos 0.012 segundos. Com os indexs criados, o tempo de resposta foi de 0.0144, 0.0132 e 0.0007 para os primeiros 3 testes, estabilizando depois nos 0.0005 segundos. Podemos considerar que os indexs otimizaram a rapidez de registo de uma nova venda e tudo o que isso implica como a atualização de stock. 


    2. É possível otimizar a entrega dos dados na alínea 2. de Procedimentos.
    - Embora o index para este pudesse ser já o acima, testamos com um novo, em separado.
    ```sql
    CREATE INDEX idx_VendadataHora ON venda(dataHora);
    ```
    - Com a chama da procedure, o tempo de resposta foi de 0.0102, 0.0044 e 0.0033 segundos, nas 3 vezes que foi chamada, estalibizando depois nos 0.044 segundos. Com o index criado, o tempo de resposta foi de 0.0039, 0.0027 e 0.0019 para os primeiros 3 testes, estabilizando depois nos 0.0034 segundos. Podemos considerar que o index otimizou a rapidez de pesquisa do total de vendas num dado período. 

# Finalização

1. Podes sugerir mais código SQL de análises dos dados que te pareçam relevantes.

- De forma a delinear a estratégia comercial, seria importante analisar:
    -  Quais os locais que vendem mais produtos:
    ```sql
    SELECT l.nome AS local, COUNT(v.codMaquina) AS TotalVendas
    FROM local l
    LEFT JOIN maquina m ON l.id = m.idLocal
    LEFT JOIN venda v ON m.codigo = v.codMaquina
    GROUP BY l.id, l.nome
    ORDER BY TotalVendas DESC;
    ```

    - Quais as máquinas que vendem mais produtos:
    ```sql
    SELECT m.codigo AS CodigoMaquina, l.nome AS Local, COUNT(v.codMaquina) AS TotalVendas
    FROM maquina m
    LEFT JOIN local l ON m.idLocal = l.id
    LEFT JOIN venda v ON m.codigo = v.codMaquina
    GROUP BY m.codigo, l.nome
    ORDER BY TotalVendas DESC;
    ```

    - Verificar o peso de cada máquina nas vendas totais do local, para saber a rentabilidade de cada uma (em quantidade e valor):
    ```sql
    CREATE VIEW RentabilidadeMaquinaLocal AS
    WITH vendas_local AS (
        SELECT l.id AS local_id, l.nome AS Local, 
            COUNT(v.codMaquina) AS VendasLocal,
            SUM(v.valor) AS ValorTotalLocal
        FROM local l
        LEFT JOIN maquina m ON l.id = m.idLocal
        LEFT JOIN venda v ON m.codigo = v.codMaquina
        GROUP BY l.id, l.nome),
    vendas_maquina AS (
        SELECT m.idLocal, m.codigo AS Maquina, 
            COUNT(v.codMaquina) AS VendasMaquina,
            SUM(v.valor) AS ValorTotalMaquina
        FROM maquina m
        LEFT JOIN venda v ON m.codigo = v.codMaquina
        GROUP BY m.idLocal, m.codigo)
    SELECT vl.Local, 
        vl.VendasLocal,
        vl.ValorTotalLocal,
        vm.Maquina, 
        vm.VendasMaquina,
        vm.ValorTotalMaquina,
        CASE 
            WHEN vl.VendasLocal > 0 
            THEN ROUND(vm.VendasMaquina * 100.0 / vl.VendasLocal, 2)
            ELSE 0
        END AS PercentagemQuantidadeVendas,
        CASE 
            WHEN vl.ValorTotalLocal > 0 
            THEN ROUND(vm.ValorTotalMaquina * 100.0 / vl.ValorTotalLocal, 2)
            ELSE 0
        END AS PercentagemValorVendas
    FROM vendas_local vl
    LEFT JOIN vendas_maquina vm ON vl.local_id = vm.idLocal
    ORDER BY vl.ValorTotalLocal DESC, vm.ValorTotalMaquina DESC;
    ```


2. Podes sugerir alteração e implementação que consideres interessantes para versões futuras deste projeto.
- Reposição de stocks: deverão ser respostos os stocks a 0 ou abaixo de 3 com urgência. A empresa também consegue avaliar através das vendas a rotatividade do stock para cada produto e máquina, de forma a antecipar possíveis falhas de stock;

- Rentabilidade das máquinas: existem discrepâncias de rentabilidade das máquinas (peso nas vendas totais do local) para todas as máquinas. Contudo, podemos analisá-las de várias formas. Em alguns casos, como no El Corte Inglês, a diferença entre máquina mais e menos rentável é de 10 pontos percentuais (17.38 vs 7.19), a verdade é que este local tem muitas máquinas e a que tem mais vendas não chega a 20% das vendas. Contudo, uma vez que é o local com mais vendas no total, parece ser uma boa aposta comercial. Tal carece de confirmação tendo em conta os custos aossciados (talvez menos 1 ou 2 máquinas exponenciariam o lucro líquido através da alocaçao eficiente de máquinas no local). No Parque Nascente, por exemplo, existem 3 máquinas e uma dela tem mais de 50% das vendas em valor e 40% em quantidade. Seria importante avaliar se uma melhor localização para as outras poderia aumentar os lucros como um todo. O Glicínias Plaza consegue 3x mais de vendas do que o GaiaShopping tendo ambos apenas uma máquina. Seria também importante avaliar o motivo (localização, tipo de produtos, etc.). Outras análises do género poderiam ser feitos sobre todos os locais e máquinas, mas uma tabela com os custos seriam importante para tirar ilações sobre os valores líquidos em vez de apenas sobre os brutos.

- Expandir para outras localizações/quantidade máquinas: De acordo com a análise acima, o Glicínias Plaza é dos que tem melhor desempenho de máquina. Uma vez que o local tem apenas 1 máquina, poderia ser interessante avaliar a colocação de uma segunda. Estando a empresa tão presente na zona do Porto, poderia também avaliar e tentar o negócio de entrar no shopping Via Catarina, uma vez que é dos Shoppings com maior movimento, com muitos jovens e em que uma máquina de venda rápida pode ser mais apelativa que ir à restauração que costuma estar muito lotada.
