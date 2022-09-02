--Obter clientes com seus dependentes

SELECT
    c.id AS 'ID CLIENTE',
    c.nome 'NOME',
    cc.id_conta AS 'ID CONTA',
    cc.dependente AS 'DEPENDENTE'
FROM cliente c
    JOIN cliente_conta cc ON c.id = cc.id_cliente
    JOIN conta co ON cc.id_conta = co.id
WHERE cc.id_conta IN (
        SELECT id_conta
        FROM cliente_conta
        WHERE dependente = 1
    )
ORDER BY id_conta, dependente;

--5 contas que mais fizeram transações

SELECT
    c.id AS 'ID CLIENTE',
    c.nome AS 'NOME',
    cc.id_conta AS 'ID CONTA',
    co.numero AS 'Nro CONTA',
    COUNT(t.id) AS 'NRO DE TRANSAÇOES'
FROM transacao t
    JOIN cliente c ON c.id = cc.id_cliente
    JOIN cliente_conta cc ON cc.id = t.id_cliente_conta
    JOIN conta co ON co.id = cc.id_conta
GROUP BY co.id
ORDER BY COUNT(t.id) DESC
LIMIT 5;

-- 5 contas que menos fizeram transações

SELECT
    c.id AS 'ID CLIENTE',
    c.nome AS 'NOME',
    cc.id_conta AS 'ID CONTA',
    co.numero AS 'Nro CONTA',
    COUNT(t.id) AS 'NRO DE TRANSAÇOES'
FROM transacao t
    JOIN cliente c ON c.id = cc.id_cliente
    JOIN cliente_conta cc ON cc.id = t.id_cliente_conta
    JOIN conta co ON co.id = cc.id_conta
GROUP BY co.id
ORDER BY COUNT(t.id) ASC
LIMIT 5;

--Saber o saldo de cada conta no banco

SELECT
    c.nome AS 'CLIENTE',
    co.numero AS 'NRO CONTA',
    depositos.total AS 'DEPOSITOS',
    saques.total AS 'SAQUES',
    contas_pagas.total AS ' CONTAS PAGAS',
    transferencias.total AS 'TRANSFERENCIAS',
    (depositos.total - saques.total - contas_pagas.total + transferencias.total) AS 'SALDO TOTAL'
FROM conta co
    JOIN cliente_conta cc ON cc.id_conta = co.id
    JOIN cliente c ON c.id = cc.id_cliente
    JOIN (
        SELECT
            cc.id_conta AS 'id',
            SUM(t.valor) AS 'total'
        FROM transacao t
            JOIN cliente_conta cc ON cc.id = t.id_cliente_conta
        WHERE t.id_tipo_transacao = 1
        GROUP BY
            cc.id_conta
    ) AS 'depositos' ON depositos.id = co.id
    JOIN (
        SELECT
            cc.id_conta AS 'id',
            SUM(t.valor) AS 'total'
        FROM transacao t
            JOIN cliente_conta cc ON cc.id = t.id_cliente_conta
        WHERE t.id_tipo_transacao = 2
        GROUP BY
            cc.id_conta
    ) AS 'saques' ON saques.id = co.id
    JOIN (
        SELECT
            cc.id_conta AS 'id',
            SUM(t.valor) AS 'total'
        FROM transacao t
            JOIN cliente_conta cc ON cc.id = t.id_cliente_conta
        WHERE t.id_tipo_transacao = 3
        GROUP BY
            cc.id_conta
    ) AS 'contas_pagas' ON contas_pagas.id = co.id
    JOIN (
        SELECT
            cc.id_conta AS 'id',
            SUM(t.valor) AS 'total'
        FROM transacao t
            JOIN cliente_conta cc ON cc.id = t.id_cliente_conta
        WHERE t.id_tipo_transacao = 4
        GROUP BY
            cc.id_conta
    ) AS 'transferencias' ON transferencias.id = co.id
GROUP BY co.id;
