-- Qual foi a categoria de produtos mais vendido?
SELECT
    c.Categoria,
    count(pp.ID_Pedido) as orders
FROM
	categorias c
JOIN
	produtos p ON c.ID_Categoria = p.ID_Categoria
JOIN
	pedidos pp ON p.ID_Produto = pp.ID_Produto
GROUP BY
	c.Categoria
ORDER BY
	orders desc;

-- Qual são o produto campeão de vendas de cada loja?

SELECT
	l.loja,
    pp.Nome_Produto,
    SUM(p.Qtd_Vendida) as quantidade_vendida
FROM
	pedidos p
JOIN
	produtos pp ON p.ID_Produto = pp.ID_Produto
JOIN
	lojas l ON l.id_loja = p.ID_Loja
GROUP BY
	l.loja,
    pp.Nome_Produto
ORDER BY
	l.loja,
    quantidade_vendida desc;
    
   WITH ProdutosMaisVendidos AS (
    SELECT
        l.loja,
        pp.Nome_Produto,
        SUM(p.Qtd_Vendida) as quantidade_vendida,
        RANK() OVER(PARTITION BY l.loja ORDER BY SUM(p.Qtd_Vendida) DESC) as ranking
    FROM
        pedidos p
    JOIN
        produtos pp ON p.ID_Produto = pp.ID_Produto
    JOIN
        lojas l ON l.id_loja = p.ID_Loja
    GROUP BY
        l.loja,
        pp.Nome_Produto
)
SELECT
    loja,
    Nome_Produto,
    quantidade_vendida
FROM
    ProdutosMaisVendidos
WHERE
    ranking = 1
ORDER BY
	quantidade_vendida desc;

-- Qual o valor médio gasto por cliente?

SELECT
	ID_Cliente,
    ROUND(AVG(Preco_Unit), 2) as media_gasto
FROM
	pedidos p
GROUP BY
	ID_Cliente;
    
select ROUND(avg(Preco_Unit),2) from pedidos;

-- Quais são os top 3 clientes que mais compram?

WITH top_clientes AS (
SELECT
	p.ID_Cliente,
    CONCAT(c.Nome, ' ', c.Sobrenome) as Customer,
    count(*) as Orders,
	DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS ranking
FROM
	clientes c
JOIN
	pedidos p ON c.ID_Cliente = p.ID_Cliente
GROUP BY
	p.ID_Cliente,
    Customer
ORDER BY
	Orders desc
)
SELECT
    ID_Cliente,
    Customer,
    Orders,
    ranking
FROM
	top_clientes
WHERE
	ranking <= 3;

-- Qual o produto que mais vendeu em quantidade?

SELECT
	pp.Nome_Produto,
    count(*) as quantidade
FROM
	pedidos p
JOIN
	produtos pp ON p.ID_Produto = pp.ID_Produto
GROUP BY
	pp.Nome_Produto
ORDER BY
	quantidade desc;

-- Qual a média de venda por cada loja?

SELECT
	l.loja,
    ROUND(AVG(p.Preco_Unit), 2 ) as ticket_medio
FROM
	pedidos p
JOIN
	lojas l ON p.ID_Loja = l.ID_Loja
GROUP BY
	l.loja
ORDER BY
	ticket_medio desc;
    
-- Receita total de cada loja

SELECT 
	p.ID_Loja,
    l.loja,
    sum(p.Receita_Venda) as Receita_Por_Loja
FROM
	pedidos p
JOIN
	lojas l ON p.ID_Loja = l.ID_Loja
GROUP BY
	p.ID_Loja,
    l.loja
ORDER BY
	 Receita_Por_Loja DESC;
    
-- Qual são os estados e cidades que mais vendem?

SELECT
	ll.Loja,
    l.Estado,
    sum(p.Qtd_Vendida) AS qtd_vendida,
    sum(p.Receita_Venda) - sum(p.Custo_Venda) as lucro
FROM
	locais l
JOIN
	lojas ll ON l.Loja = ll.Loja
JOIN
	pedidos p ON ll.ID_Loja = p.ID_Loja
GROUP BY
	ll.Loja,
    l.Estado
ORDER BY
    lucro desc;
    
-- Qual a média salarial dos nossos clientes?

SELECT
	AVG(Renda_Anual) as renda_anual
FROM
	clientes;

-- Baseado nos resultados do ano de 2019, quais são os meses do ano que mais vendem e quais performam abaixo e que podemos explorar com campanhas para melhorar a performance?

SELECT
	extract(month from Data_Venda) as Mes,
    DATE_FORMAT(Data_Venda, '%M') as Nome_Mes,
    sum(Receita_Venda) as Total_Vendas
FROM
	pedidos
GROUP BY
	extract(month from Data_Venda),
	DATE_FORMAT(Data_Venda, '%M')
ORDER BY
	Total_Vendas desc;
    
    
    
-- Qual o foi o lucro real que cada cliente deu ao longo do tempo?

select
	ID_Cliente,
    sum(Receita_Venda) - sum(Custo_Venda) as lucro
 from
	pedidos
 group by
	ID_Cliente
 order by
	lucro desc;
    
-- Qual a quantidade de itens que cada cliente comprou e qual o foi o lucro real que cada um deles deixou com a gentew

select
	c.ID_Cliente,
    c.Nome,
    count(Qtd_Vendida) AS QTD,
    sum(p.Receita_Venda) - sum(p.Custo_Venda) as lucro
from
	clientes c
JOIN
	pedidos p ON c.ID_Cliente = p.ID_Cliente
GROUP BY
		c.ID_Cliente,
    c.Nome
ORDER BY
	QTD desc;
    
-- Analisando duplicidade de pedidos
    
SELECT
    ID_Pedido,
    count(ID_Pedido) AS Pedidos_Duplicados
FROM
	pedidos
GROUP BY
	ID_Pedido
HAVING
	count(ID_Pedido) > 1;

--
select * from pedidos;
    
-- Receita média por mês

SELECT
	extract(month from data_venda),
    date_format(data_venda, '%M'),
    avg(receita_venda)
FROM
	pedidos
GROUP BY
	extract(month from data_venda),
    date_format(data_venda, '%M');
    
select * from produtos;