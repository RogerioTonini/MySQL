CREATE DEFINER=`root`@`localhost` PROCEDURE `sys`.`SP_Create_DB_Tables`(
	IN v_Database VARCHAR(50),		 -- Nome do banco de dados onde serão criadas as tabelas
    IN v_SP_Tables   VARCHAR(50)		 -- Nome da procedure que define as tabelas temporárias
)
BEGIN
    -- Variáveis Tabela LST_TABELAS
    DECLARE v_ID_Table    INT;				-- Índice da Tabela
    DECLARE v_TableName   VARCHAR(50);		-- Nome da Tabela
    DECLARE v_PrimKeyName VARCHAR(50);		-- Nome da chave Primária

    -- Variáveis Tabela LST_COLUNAS   
    DECLARE v_Def_Coluna TEXT;
    DECLARE v_Def_FN_Key TEXT;

	-- Variáveis para análise de colunas
    DECLARE v_colunas        TEXT;
    DECLARE v_Col_Nome       VARCHAR(255);
    DECLARE v_Col_Tipo       VARCHAR(50);
    DECLARE v_Col_Tamanho    INT;
    DECLARE v_Tb_Col_Tipo    VARCHAR(50);
    DECLARE v_Tb_Col_Tamanho INT;
    DECLARE v_is_primary_key INT DEFAULT 0;

	-- Variáveis GERAIS
    DECLARE done         INT DEFAULT 0;         -- Handler para fim do cursor
	DECLARE v_data_table VARCHAR(100);	        -- Nome do Database +  Nome da Tabela
	DECLARE v_status_msg VARCHAR(255) default '';		-- Mensagem de erro. Saída: CONSOLE / Gravação LOG

    -- Cursor para TABELAS
    DECLARE cur_Tables CURSOR FOR
        SELECT ID_Tabela, Nome_Tabela, Nome_PK
        FROM LST_TABELAS
        ORDER BY ID_Tabela;
    
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;    -- Handler para fim do cursor
    
    SET @sql = CONCAT( 'CALL ', v_SP_Tables, '()' );
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    OPEN cur_Tables;
	    loop_Table: LOOP
		    FETCH cur_Tables INTO v_ID_Table, v_TableName, v_PrimKeyName;
	        IF done THEN
	            LEAVE loop_Table;
	        END IF;
	
	        /* ---- Busca definição de colunas e chave estrangeira ---- */
	        SELECT Nome_DefCampo, Nome_FN_Key INTO v_Def_Coluna, v_Def_FN_Key
	        FROM LST_CAMPOS
	        WHERE ID_TabelaCampo = v_ID_Table;

	        /* ---- Verifica se a tabela EXISTE ou NÃO no DB ---- */
			SET v_data_table := concat( '`', v_Database, '`.`', v_TableName, '`' );
	        IF NOT EXISTS (
	            SELECT 1 
	            FROM INFORMATION_SCHEMA.TABLES
	            WHERE TABLE_SCHEMA = v_Database AND TABLE_NAME = v_TableName ) THEN            
	
				/* ---- Cria a Tabela e o Índice Primário ---- */
				CALL sys.SP_Create_Tables( v_Database, v_TableName, v_Def_Coluna, @ok_tbl );
				IF @ok_tbl THEN
					/* ---- Cria o(s) demais Índice(s) ---- */
					CALL SP_Create_Sec_Key( v_data_table, v_ID_Table, @ok_sk );
					IF @ok_pk THEN
						SET v_status_msg = concat( 
							'Tabela: ', 'Índice ', v_data_table, ' criados com sucesso.' 
						);
						CALL SP_Record_LOG( v_Database, v_TableName, '', '', '', v_status_msg );
					END IF;
				END IF;
			END IF;
		END LOOP loop_Table;
    CLOSE cur_Tables;

	DROP TEMPORARY TABLE IF EXISTS LST_TABELAS;
	DROP TEMPORARY TABLE IF EXISTS LST_SK_KEY;
	DROP TEMPORARY TABLE IF EXISTS LST_CAMPOS;
END