/*
Script: Remocao_Duplicidades_NFCE.sql
===
Autor: Matheus Paula
===
Descrição:
    Este script identifica e remove registros duplicados 
    utilizando a função ROW_NUMBER() para definir qual registro deve ser mantido.
    Foi desenvolvido para uso em ambiente SQL Server.
    No exemplo abaxio, foi testado para correção de vendas duplicadas.
===
Lógica geral:
    1️. Coleta cupons duplicados no período definido.
    2️. Identifica os códigos únicos (CODNFCE) correspondentes aos duplicados.
    3️. Utiliza ROW_NUMBER() para numerar as duplicidades e marcar quais devem ser excluídas (RN > 1).
    4️. Exibe os registros que seriam excluídos (podendo substituir o SELECT por DELETE em ambiente de produção).
*/
  
/*
  Declaração de variáveis de controle (período e loja)

  Parâmetros:
    @DATAINI  → Data inicial do intervalo de análise
    @DATAEND  → Data final do intervalo de análise
    @CODLOJA  → Código da loja a ser verificada
*/
DECLARE
    @DATAINI DATE,
    @DATAEND DATE,
    @CODLOJA INT

-- Definição dos parâmetros de entrada
SET @DATAINI = '2025-10-01'
SET @DATAEND = '2025-10-31'
SET @CODLOJA = 1

-- LIMPEZA INICIAL: Remove tabelas temporárias anteriores, caso existam
DROP TABLE IF EXISTS ##DUPLICADOS
DROP TABLE IF EXISTS ##CODNFCE_DUPLIC
DROP TABLE IF EXISTS ##CODNFCE_DUPLIC_RN
/*
  ETAPA 1: Identificação de cupons duplicados no sistema
  Aqui buscamos combinações de dados (NF, caixa, data, loja, etc.) que aparecem mais de uma vez.
*/
SELECT
    NUMNFCE,
    CODCAIXA,
    SEQUENCIAL,
    DATA,
    CODLOJA,
    COUNT(*) AS TOTAL
INTO ##DUPLICADOS
FROM INFO_CUPOM
WHERE DATA BETWEEN @DATAINI AND @DATAEND
  AND CODLOJA = @CODLOJA
GROUP BY DATA, NUMNFCE, CODCAIXA, CHAVEACESSO, NUMLOTE, SEQUENCIAL, PROTOCOLO, HRENVIO, CODLOJA
-- Retorna apenas registros duplicados
HAVING COUNT(*) > 1

/*
  ETAPA 2: Associa os duplicados da tabela  ##DUPLICADOS com a principal
  Utiliza "LEFT JOIN" com CAPA_CUPOM para validar se o sequencial está coerente para fazer a segunda trativa antes de excluir.

  Observação: O SEQDIF ser ve para filtrar o SEQUENCAIL caso tenha alguma divergência, porém se for 
  totalmente duplicado, até mesmo o sequencial, não é necessário filtrar essa coluna no "WHERE"
*/
SELECT
    P.CODNFCE,
    P.NUMNFCE,
    P.CODCAIXA,
    P.SEQUENCIAL,
    P.DATA,
    P.CODLOJA,
    -- Divergência de sequência
    CASE WHEN ISNULL(C.SEQUENCIAL, 1) <> P.SEQUENCIAL THEN '1'  
    ELSE '0'END AS SEQDIF
INTO ##CODNFCE_DUPLIC
FROM INFO_CUPOM AS P
INNER JOIN ##DUPLICADOS AS D ON D.CODCAIXA = P.CODCAIXA
   AND D.NUMNFCE = P.NUMNFCE
   AND D.SEQUENCIAL = P.SEQUENCIAL
   AND D.DATA = P.DATA
   AND D.CODLOJA = P.CODLOJA
LEFT JOIN CAPA_CUPOM AS C ON D.CODCAIXA = C.CODCAIXA
   AND D.NUMNFCE = C.COO
   AND D.SEQUENCIAL = C.SEQUENCIAL
   AND D.DATA = C.DATA
   AND D.CODLOJA = C.CODLOJA

/*
  ETAPA 3: Geração da temporária final de duplicidades
  Usa ROW_NUMBER() para atribuir uma ordem dentro de cada grupo (NUMNFCE),
  considerando divergências de sequência e código.
*/
SELECT
    D.CODNFCE,
    D.NUMNFCE,
    D.CODCAIXA,
    D.SEQUENCIAL,
    D.DATA,
    D.CODLOJA,
    ROW_NUMBER() OVER (
        PARTITION BY D.NUMNFCE
        ORDER BY D.SEQDIF DESC, D.CODNFCE DESC
    ) AS RN
INTO ##CODNFCE_DUPLIC_RN
FROM ##CODNFCE_DUPLIC AS D

/*
  ETAPA 4: O "SELECT" permite validar os registros antes da exclusão efetiva.
  IMPORTANTE: No ambiente real, substitua o SELECT por DELETE para efetivar a limpeza.
  Após verificação, substitua o SELECT por DELETE para corrigir as duplicidades.

  RN > 1 É definido de forma a deixar apenas os registros que são iguais a 1, e aqueles
  que são maiores que 1, serão excluidos. Esse método foi desenvolvido para correção em tabelas 
  que não tem ID único.
*/
-- Visualiza duplicidades na tabela principal (INFO_CUPOM)
SELECT *
-- DELETE P
FROM INFO_CUPOM AS P
INNER JOIN ##CODNFCE_DUPLIC_RN AS R
    ON P.CODNFCE = R.CODNFCE
   AND P.NUMNFCE = R.NUMNFCE
   AND P.CODCAIXA = R.CODCAIXA
   AND P.DATA = R.DATA
   AND P.SEQUENCIAL = R.SEQUENCIAL
   AND P.CODLOJA = R.CODLOJA
WHERE R.RN > 1

-- Visualiza duplicidades na tabela XML associada (XML_CUPOM)
SELECT *
-- DELETE X
FROM XML_CUPOM AS X
INNER JOIN ##CODNFCE_DUPLIC_RN AS R
    ON X.CODNFCE = R.CODNFCE
   AND X.NUMNFCE = R.NUMNFCE
   AND X.CODCAIXA = R.CODCAIXA
   AND X.DATA = R.DATA
   AND X.CODLOJA = R.CODLOJA
WHERE R.RN > 1

