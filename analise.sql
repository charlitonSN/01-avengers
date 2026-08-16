-- ============================================================
-- Projeto 1: Avengers — Analise SQL
-- Fonte: Five Thirty Eight
-- Observacao: "Name/Alias" NAO e uma chave unica confiavel
-- (10 linhas com valor NULO e ao menos 1 nome duplicado
-- referente a personagens diferentes: "Vance Astrovik").
-- Por isso, contagens de herois usam COUNT(*) em vez de
-- COUNT(DISTINCT "Name/Alias"), evitando perda silenciosa de
-- linhas (NULL e ignorado por COUNT DISTINCT) e colisoes de nome.
-- ============================================================


-- Quantos herois temos no conjunto de dados?
SELECT
    COUNT(*) AS qtd_herois

FROM avengers;



-- Qual a distribuicao de genero dos personagens?
SELECT
    Gender AS genero,
    COUNT(*) AS qtd_herois

FROM avengers

GROUP BY Gender;



-- Qual e a media de aparicoes dos personagens?
SELECT
    ROUND(AVG(Appearances), 2) AS media_aparicoes

FROM avengers;



-- Qual e a media de aparicoes dos personagens por genero?
SELECT
    Gender AS genero,
    ROUND(AVG(Appearances), 2) AS media_aparicoes

FROM avengers

GROUP BY Gender;



-- Como a adesao dos herois ao grupo dos Avengers ao longo dos anos se modificou?
WITH herois_por_ano AS (
    SELECT
        "Year" AS anos,
        COUNT(*) AS qtd_herois
    FROM avengers
    GROUP BY "Year"
)

SELECT
    anos,
    qtd_herois,
    SUM(qtd_herois) OVER (
        ORDER BY anos
    ) AS qtd_herois_acumulada
FROM herois_por_ano
ORDER BY anos ASC;



-- Sabendo que a Marvel foi criada em 1939, ha alguma incoerencia nos dados (linhas com 'Year' incorreto)?
-- Verificar o intervalo de anos
SELECT
    MIN("Year") AS min,
    MAX("Year") AS max

FROM avengers;

-- Refazer contagem da adesao dos herois
WITH herois_por_ano AS (
    SELECT
        "Year" AS anos,
        COUNT(*) AS qtd_herois
    FROM avengers

    WHERE "Year" >= 1939
    GROUP BY "Year"
)

SELECT
    anos,
    qtd_herois,
    SUM(qtd_herois) OVER (
        ORDER BY anos
    ) AS qtd_herois_acumulada
FROM herois_por_ano

ORDER BY anos ASC;



-- Ha menos personagens do genero feminino; essa distribuicao mudou por decada ao longo dos anos?
WITH contagem AS (

    SELECT
        CASE
            WHEN "Year" >= 1939 AND "Year" < 1950 THEN 1940
            WHEN "Year" >= 1950 AND "Year" < 1960 THEN 1950
            WHEN "Year" >= 1960 AND "Year" < 1970 THEN 1960
            WHEN "Year" >= 1970 AND "Year" < 1980 THEN 1970
            WHEN "Year" >= 1980 AND "Year" < 1990 THEN 1980
            WHEN "Year" >= 1990 AND "Year" < 2000 THEN 1990
            ELSE 2000
        END AS decada,

        "Gender" AS genero,

        COUNT(*) AS qtd_personagens

    FROM avengers

    WHERE "Year" >= 1939

    GROUP BY decada, genero
)

SELECT
    decada,
    genero,
    qtd_personagens,

    -- acumulado de cada genero
    SUM(qtd_personagens) OVER (
        PARTITION BY genero
        ORDER BY decada
    ) AS qtd_acumulada,

    -- participacao do genero na decada
    ROUND(
        100.0 * qtd_personagens /
        SUM(qtd_personagens) OVER (
            PARTITION BY decada
        ), 2 ) AS percentual_decada

FROM contagem

ORDER BY decada, genero;



-- Existe alguma diferenca na proporcao de personagens honorarios (coluna Honorary)
-- para cada um dos generos (tabela de frequencia cruzada)?

WITH contagem AS (
    SELECT
        Honorary AS honorarios,
        Gender AS genero,
        COUNT(*) AS qtd_personagens
    FROM avengers
    GROUP BY Honorary, Gender
)

SELECT
    honorarios,
    genero,
    qtd_personagens,

    ROUND(
        100.0 * qtd_personagens /
        SUM(qtd_personagens) OVER (
            PARTITION BY genero
        ), 2) AS percentual_genero

FROM contagem

ORDER BY genero, honorarios;



-- Qual a diferenca no numero de mortes dos personagens para cada genero (absoluto e relativo)
-- e qual o percentual que retornou de cada genero?
WITH contagem_mortes AS (

    SELECT
        Gender AS genero,
        Death1 AS morreu,
        COUNT(*) AS qtd_mortes

    FROM avengers

    GROUP BY Gender, Death1
),

perc_mortes AS (

    SELECT
        genero,
        morreu,
        qtd_mortes,

        ROUND(
            100.0 * qtd_mortes /
            SUM(qtd_mortes) OVER (
                PARTITION BY genero
            ),
            2
        ) AS percentual_mortes

    FROM contagem_mortes
),

contagem_retorno AS (

    SELECT
        Gender AS genero,

        COUNT(CASE
            WHEN Return1 = 'YES'
            THEN 1
        END) AS qtd_retornaram,

        COUNT(CASE
            WHEN Return1 = 'NO'
            THEN 1
        END) AS qtd_nao_retornaram

    FROM avengers

    WHERE Death1 = 'YES'

    GROUP BY Gender
)

SELECT
    t1.genero,
    t1.qtd_mortes,
    t1.percentual_mortes,

    CASE
        WHEN t1.morreu = 'YES'
        THEN t2.qtd_retornaram
        ELSE NULL
    END AS qtd_retornaram,

    CASE
        WHEN t1.morreu = 'YES'
        THEN ROUND(
            100.0 * t2.qtd_retornaram /
            t1.qtd_mortes,
            2
        )
        ELSE NULL
    END AS percentual_retornaram

FROM perc_mortes AS t1

LEFT JOIN contagem_retorno AS t2
    ON t1.genero = t2.genero

WHERE t1.morreu = 'YES'
ORDER BY t1.genero, t1.morreu;



-- A media de aparicoes varia de acordo com genero e ocorrencia de morte?
SELECT
    Gender AS genero,
    Death1 AS morte,
    ROUND(AVG(Appearances), 2) AS media_aparicoes

FROM avengers

GROUP BY Gender, morte;
