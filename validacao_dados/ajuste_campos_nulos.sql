/*
Script: Ajuste_Campos_Nulos.sql
===
Autor: Matheus Paula
===
Descrição:
    Este script identifica e corrige registros de cupons fiscais (ITENS_CUPONS)
    que estão com o campo CST_PISCOFINS nulo, utilizando como referência
    os códigos fiscais cadastrados e registrados em outra tabela.
    Desenvolvido para ambiente SQL Server.
===
Lógica geral:
    1️. Localiza produtos vendidos sem código de CST_PISCOFINS.
    2️. Relaciona os produtos com sua base fiscal (IMPOSTOS_FEDERAIS_PRODUTOS).
    3️. Atualiza os registros ausentes com o código de saída correspondente.
    4️. Permite validar o impacto da atualização antes da execução definitiva.
===
Observação:
    > Este processo garante a consistência fiscal de cupons e relatórios,
      evitando divergências no SPED e em auditorias fiscais.
*/

/*
  ETAPA 1: Validação
  Nesta etapa, listamos os itens de cupons fiscais (ITENS_CUPONS)
  que estão sem CST_PISCOFINS e comparamos com o valor de referência
  da tabela de impostos federais.
*/
SELECT 
    P.CODPROD,                               
    I.CST_PISCOFINSSAIDA AS CST_REFERENCIA,  
    P.COO,                                   
    P.DATA,                                  
    P.CST_PISCOFINS AS CST_ATUAL,            
    P.CODLOJA                                
FROM ITENS_CUPONS AS P
INNER JOIN IMPOSTOS_FEDERAIS_PRODUTOS AS I 
    ON P.CODPROD = I.CODPROD
WHERE P.DATA >= '2025-10-01'
  
  -- Filtro de registros sem código fiscal
  AND P.CST_PISCOFINS IS NULL
/*
  ETAPA 2: Correção
  A atualização preenche o campo CST_PISCOFINS com o valor 
  correspondente de CST_PISCOFINSSAIDA da tabela de referência.
  Recomenda-se testar primeiro com o SELECT acima antes de aplicar o UPDATE.
*/
-- BEGIN TRANSACTION  -- Use para testes seguros

UPDATE P
SET P.CST_PISCOFINS = I.CST_PISCOFINSSAIDA
FROM ITENS_CUPONS AS P
INNER JOIN IMPOSTOS_FEDERAIS_PRODUTOS AS I 
    ON P.CODPROD = I.CODPROD
WHERE P.DATA >= '2025-10-01'
  AND P.CST_PISCOFINS IS NULL

-- COMMIT   -- Confirma a atualização
-- ROLLBACK  -- Cancela caso algo esteja incorreto

