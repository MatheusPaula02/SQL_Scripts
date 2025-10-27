/*
  Script: Analise_Forma_Pagamento.sql  
  ===
  Autor: Matheus de Paula
  ===
  Data: 2025-10-27
  ===
  Descrição:
    Este script apresenta os valores e sua formas de pagamento de forma separada. 
    Supondo que foi tido um forma de pagamento com 5 cartões diferentes, a mesma foi desenvolvida para
    mostrar os valores e o nome de cada pagamento separado. Criado para controle de vendas.
  ===
  Observação: 
  > Script criado levando em consideração sistemas de criação personalizada de relatórios
  > Este script foi originalmente desenvolvido e testado em um sistema interno de criação de relatórios personalizados.
    Por esse motivo, utiliza o formato de "Identificador Delimitado" ([nome_coluna]) do SQL Server,
    permitindo melhor exibição e compatibilidade dos nomes de colunas na ferramenta utilizada.
*/
/*
  =======================================
   BLOCO 1: CTE PAGAMENTOS
  ======================================= 
*/
/*
  Subconsulta conta quantas ocorrências iguais (mesmo cupom, valor, tipo etc.)
  existem até o registro atual (PGTO.ID). Isso gera um contador incremental
  que será usado para identificar pagamentos duplicados do mesmo tipo. Essa implementação foi necessária
  devido a pagamentos com mais de 5 cartões que impactavam ao apresentar o NOMECARTAO de outra tabela. 
  No resultado anterior a implementação não era mostrado o nome de cada cartão separadamente.
*/
WITH PAGAMENTOS AS (
    SELECT 
        PGTO.*,
        (
            SELECT COUNT(*) 
            FROM TIPOS_PAGAMENTOS_GERAL P2
            WHERE P2.DATA = PGTO.DATA
              AND P2.CODLOJA = PGTO.CODLOJA
              AND P2.CODCAIXA = PGTO.CODCAIXA
              AND P2.SEQUENCIAL = PGTO.SEQUENCIAL
              AND P2.COO = PGTO.COO
              AND P2.VALORBRUTO = PGTO.VALORBRUTO
              AND P2.TEFTIPO = PGTO.TEFTIPO
              AND P2.ID <= PGTO.ID
        ) AS RN_PGTO
    FROM TIPOS_PAGAMENTOS_GERAL PGTO
),
/* 
  =======================================
   BLOCO 2: CTE NOMECARTAO
  ======================================= 
*/
NOMECARTAO AS (
    SELECT 
        TRN.NOMECARTAO,
        TRN.DATA,
        TRN.CODLOJA,
        TRN.CODCAIXA,
        TRN.SEQUENCIAL,
        TRN.COO,
        TRN.VALOR,
        TRN.DC,
        /*
          Gera uma numeração por conjunto de dados idênticos (DATA, LOJA, VALOR, etc.). Isso servirá para vincular com
          a CTE PAGAMENTOS e apresentar o nome de cada Cartão de forma correta, com cada valor separado. Sem isso
          iria ser mostrado valores diferentes com o mesmo nome de cartão.
        */
        ROW_NUMBER() OVER (
            PARTITION BY TRN.DATA, TRN.CODLOJA, TRN.CODCAIXA, TRN.SEQUENCIAL, TRN.COO, TRN.VALOR, TRN.DC
            ORDER BY TRN.ID
        ) AS RN
    -- Tabela NOME_CARTOES contém o nome dos cartões (Alelo, Mastercard, Visa, etc.)
    FROM NOME_CARTOES TRN
    WHERE YEAR(GETDATE()) - 1 <= YEAR(TRN.DATA)
)
/*
  =======================================
  BLOCO 3: SELECT PRINCIPAL
  ======================================= 
*/
SELECT PGTO.CODLOJA AS CODLOJA
      ,CAPA.HORAFINAL
      ,CAST(PGTO.DATA AS DATE) DATA
  
      /* Concatena o código e nome da loja em uma única coluna descritiva */
      ,CAST(PGTO.CODLOJA AS VARCHAR(10)) + ' - ' + L.DESCRICAO AS DESCRICAO_LOJA
      ,PGTO.CODCAIXA AS CODCAIXA
      ,PGTO.CODUSUARIO
      ,U.NOME NOME_USUARIO
      ,PGTO.CODFORMAPG AS CODFORMAPG
      ,PGTO.SEQUENCIAL AS SEQUENCIAL
      ,PGTO.COO AS COO
      ,PGTO.CODCLIE AS CODCLIE
      ,C.RAZAO AS RAZAO
      /*
        Cria descrição amigável da forma de pagamento, com base no tipo de cupom. Isso só foi possivel
        graças as CTEs anteriores com os contadores. Sem eles, teria inconsistência nos dados.
      */
      ,CASE 
        WHEN CAPA.TIPOCUPOM = '7' THEN PG.DESCRICAO + ' - Recarga Celular'
        WHEN CAPA.TIPOCUPOM = '6' THEN PG.DESCRICAO + ' - Receb. Títulos'
        WHEN CAPA.TIPOCUPOM = '8' THEN PG.DESCRICAO + ' - Correspondente Bancario'
        WHEN PGTO.CODFORMAPG IN (3, 9) THEN PG.DESCRICAO + ' - ' + ISNULL(TRN1.NOMECARTAO, 'Cartão não Identificado')
       ELSE PG.DESCRICAO END AS DESCRICAO
  
      /* Calcula troco apenas quando a forma de pagamento é dinheiro (CODFORMAPG = 1) */
	    ,CASE WHEN PGTO.CODFORMAPG = 1 THEN (ISNULL(PCT.VALOR, 0.00)) ELSE 0 END AS TROCO
  
      /* Se for cartão e houver valor válido em TRN, usa ele. Caso contrário, usa o valor bruto */
      ,CASE WHEN PGTO.CODFORMAPG IN (3,9) AND TRN.VALOR IS NOT NULL THEN TRN.VALOR ELSE ISNULL(PGTO.VALORBRUTO, 0.00) END AS VALOR 
      ,CAPA.DESCONTOGLOBAL [Desc.Total.Cupom]
  
  /*
  =======================================
  BLOCO 4: JUNÇÕES (JOINS)
  ======================================= 
*/
FROM PAGAMENTOS PGTO
INNER JOIN LOJAS L ON L.CODLOJA = PGTO.CODLOJA
INNER JOIN FORMAS_PAGAMENTO PG ON PGTO.CODFORMAPG = PG.CODFORMAPG
LEFT JOIN VALOR_TROCO PCT ON PCT.DATA = PGTO.DATA
	AND PGTO.CODLOJA = PCT.CODLOJA
	AND PGTO.CODCAIXA = PCT.CODCAIXA
	AND PGTO.SEQUENCIAL = PCT.SEQUENCIAL
	AND PGTO.COO = PCT.COO
LEFT JOIN CAPA_CUPOM CAPA ON CAPA.DATA = PGTO.DATA
	AND CAPA.CODLOJA = PGTO.CODLOJA
	AND CAPA.CODCAIXA = PGTO.CODCAIXA
	AND CAPA.SEQUENCIAL = PGTO.SEQUENCIAL
	AND CAPA.COO = PGTO.COO
LEFT JOIN NOME_CARTOES TRN ON TRN.DATA = PGTO.DATA
	AND TRN.CODLOJA = PGTO.CODLOJA
	AND TRN.CODCAIXA = PGTO.CODCAIXA
	AND TRN.SEQUENCIAL = PGTO.SEQUENCIAL
	AND TRN.COO = PGTO.COO
	AND TRN.VALOR = PGTO.VALORBRUTO
	AND TRN.DC = PGTO.TEFTIPO
	AND TRN.REDEDESTINO = PGTO.TEFCODADMCARTAO 
LEFT JOIN CLIENTES C ON C.CODCLIE = PGTO.CODCLIE
LEFT JOIN USUARIOS U ON U.CODUSUARIO = PGTO.CODUSUARIO
	AND U.CODLOJA = PGTO.CODLOJA
  
  /* Junta a CTE NOMECARTAO com o mesmo número de sequência (RN_PGTO = RN) com a CTE PAGAMENTOS */
LEFT JOIN NOMECARTAO TRN1 
  ON TRN1.DATA = PGTO.DATA
  AND TRN1.CODLOJA = PGTO.CODLOJA
  AND TRN1.CODCAIXA = PGTO.CODCAIXA
  AND TRN1.SEQUENCIAL = PGTO.SEQUENCIAL
  AND TRN1.COO = PGTO.COO
  AND TRN1.VALOR = PGTO.VALORBRUTO
  AND TRN1.DC = PGTO.TEFTIPO
  AND TRN1.RN = PGTO.RN_PGTO

/*
  =======================================
  BLOCO 5: FILTROS FINAISL E AGRUPAMENTOS
  ======================================= 
*/
WHERE YEAR(GETDATE()) - 1 <= YEAR(PGTO.DATA)
	AND CAPA.TIPOCUPOM IN (1,6,7,8) 
	AND CAPA.CANCELADO = 0 
GROUP BY PGTO.CODLOJA,PGTO.DATA,L.DESCRICAO,PGTO.CODCAIXA,CAPA.TIPOCUPOM,PGTO.CODFORMAPG,PG.DESCRICAO,PGTO.SEQUENCIAL,PGTO.CODCLIE,C.RAZAO,PGTO.CODUSUARIO,PGTO.COO,
	CAPA.CANCELADO,PCT.VALOR,TRN.VALOR,U.NOME,CAPA.DESCONTOGLOBAL,PGTO.VALORBRUTO,CAPA.HORAFINAL,
	PGTO.ID,PGTO.TEFTIPO, TRN1.NOMECARTAO 

