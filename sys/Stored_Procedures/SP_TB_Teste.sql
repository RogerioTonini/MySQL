CREATE DEFINER=`root`@`localhost` PROCEDURE `sys`.`SP_TB_Teste`()
BEGIN
    DROP TEMPORARY TABLE IF EXISTS LST_TABELAS;
    DROP TEMPORARY TABLE IF EXISTS LST_SK_KEY;
    DROP TEMPORARY TABLE IF EXISTS LST_CAMPOS;

	-- Lista das Tabelas / Chave Primária    
    CREATE TEMPORARY TABLE LST_TABELAS (
        ID_Tabela   INT PRIMARY KEY,
        Nome_Tabela VARCHAR(50),
        Nome_PK     VARCHAR(30)
    );
    INSERT INTO LST_TABELAS VALUES
        ( 1, 't_alteracoes_log', 'ID_REG' ),
		( 2, 't_calendario',     'ID_REG' ),
        ( 3, 't_feriados',       'ID_REG' );

	-- Lista dos Índices Secundários
    CREATE TEMPORARY TABLE LST_SK_KEY (
        ID_Table_SK  INT,
        TableName_SK TEXT,           
        FieldName_SK TEXT            
    );
    INSERT INTO LST_SK_KEY VALUES
		( 1, 't_alteracoes_log', 'DATA_HORA' ),
        ( 2, 't_calendario',     'DataReferencia' ),
		( 3, 't_feriados',       'Ano, Mes, Dia' ),
		( 3, 't_feriados',       'TipoFeriado' );

	-- Listas das Colunas das Tabelas
    CREATE TEMPORARY TABLE LST_CAMPOS (
        ID_TabelaCampo INT PRIMARY KEY,
        Nome_DefCampo  TEXT,           
        Nome_FN_Key    TEXT            
    );
    INSERT INTO LST_CAMPOS VALUES
		( 1,
		  '`ID_REG`      SMALLINT PRIMARY KEY AUTO_INCREMENT NOT NULL,
 		  `DATA_HORA`    DATETIME(3) NOT NULL,
		  `NOME_TABELA`  VARCHAR(50),
		  `NOME_COLUNA`  VARCHAR(50),
		  `TP_TAM_ATUAL` VARCHAR(30),
		  `TP_TAM_NOVO`  VARCHAR(30),
		  `MENSAGEM`     VARCHAR(255)',
		  '' ),

	  	( 2,
	  	  '`ID_REG`             SMALLINT PRIMARY KEY AUTO_INCREMENT NOT NULL,
      	  `DataReferencia`         DATE        NOT NULL',
          '' ),

		( 3,
		  '`ID_REG`  SMALLINT PRIMARY KEY AUTO_INCREMENT NOT NULL,
		  `Ano`         SMALLINT     NOT NULL,
		  `Mes`         TINYINT      NOT NULL,
		  `Dia`         TINYINT      NOT NULL,
		  `NomeFeriado` VARCHAR(150) NOT NULL,
		  `UF`          CHAR(2),
		  `TipoFeriado` ENUM(''1'', ''2'', ''3'', ''4'', ''5'') NOT NULL',
		  '' );
END