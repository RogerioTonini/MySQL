CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Create_DB_Tables`(
	IN v_data   VARCHAR(100),		 -- Nome do banco de dados onde serão criadas as tabelas
    IN v_tables VARCHAR(100)		 -- Nome da procedure que define as tabelas temporárias
)
BEGIN
    -- Variáveis para controle de loop e dados
    DECLARE v_ID_Tabela   INT;
    DECLARE v_NomeTabela  VARCHAR(255);
    DECLARE v_NomePrimKey VARCHAR(255);
    DECLARE v_Def_Coluna  TEXT;
    DECLARE v_Def_FN_Key  TEXT;
    DECLARE done          INT DEFAULT 0;
    
    -- Variáveis para análise de colunas
    DECLARE v_colunas        TEXT;
    DECLARE v_Col_Nome       VARCHAR(255);
    DECLARE v_Col_Tipo       VARCHAR(50);
    DECLARE v_Col_Tamanho    INT;
    DECLARE v_Tb_Col_Tipo    VARCHAR(50);
    DECLARE v_Tb_Col_Tamanho INT;
    DECLARE v_is_primary_key INT DEFAULT 0;

    -- Cursor para tabelas
    DECLARE cur_tabelas CURSOR FOR
        SELECT ID_Tabela, Nome_Tabela, Nome_PK
        FROM LST_TABELAS
        ORDER BY ID_Tabela;
    
    -- Handler para fim do cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    SET @sql = CONCAT( 'CALL ', v_tables, '()' );
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

	-- LOOP para teste da existência da(s) tabela(s) no DB
    OPEN cur_tabelas;
    tabela_loop: LOOP
        FETCH cur_tabelas INTO v_ID_Tabela, v_NomeTabela, v_NomePrimKey;
        IF done THEN
            LEAVE tabela_loop;
        END IF;

        -- Busca definição de colunas e chave estrangeira        
        SELECT Nome_DefCampo, Nome_FN_Key INTO v_Def_Coluna, v_Def_FN_Key
        FROM LST_CAMPOS
        WHERE ID_TabelaCampo = v_ID_Tabela;
       
        -- Verifica se a tabela NÃO existe no DB
        IF NOT EXISTS (
            SELECT 1 
            FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_SCHEMA = v_data AND TABLE_NAME = v_NomeTabela ) THEN            

			SET @sql := CONCAT( 'CREATE TABLE `', v_data, '`.`', v_NomeTabela, '` (', v_Def_Coluna );

			-- Adiciona chave primária se informada
			IF v_NomePrimKey IS NOT NULL AND v_NomePrimKey <> '' THEN
				SET @sql := CONCAT(
                    @sql, ', CONSTRAINT PK_', v_NomePrimKey, ' PRIMARY KEY (`', v_NomePrimKey, '`)' 
				);
			END IF;

			-- Adiciona chave estrangeira se houver
			IF v_Def_FN_Key IS NOT NULL AND v_Def_FN_Key <> '' THEN
				SET @sql := CONCAT( @sql, ', ', v_Def_FN_Key );
			END IF;
            SET @sql = CONCAT( @sql, ')' );

            PREPARE stmt FROM @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            
            -- Salva o LOG na tabela T_alteracoes_LOG
            SET @mensagem = CONCAT( 'Tabela "', v_data, '`.`', v_NomeTabela, '" criada com sucesso.' );
            SELECT @mensagem AS status_msg;
			CALL SP_Record_LOG( v_data, v_NomeTabela, '', '', '', @mensagem );
		ELSE
			-- Se a tabela existir verifica sua estrutura e compara com a estrutura definida no script
            SET v_colunas = v_Def_Coluna;

			-- Extrai a próxima definição de coluna
            coluna_loop: WHILE LENGTH( TRIM( v_colunas ) ) > 0 DO
                SET @pos = LOCATE( ',', v_colunas );
                IF @pos > 0 THEN
                    SET @linha = TRIM( SUBSTRING( v_colunas, 1, @pos - 1 ) );
                    SET v_colunas = TRIM( SUBSTRING( v_colunas, @pos + 1 ) );
                ELSE
                    SET @linha = TRIM( v_colunas );
                    SET v_colunas = '';
                END IF;
                SET v_Col_Nome = SUBSTRING_INDEX( SUBSTRING_INDEX( @linha, '`', 2 ), '`', -1 );                
                SET @resto     = TRIM( SUBSTRING( @linha, LENGTH( v_Col_Nome ) + 3 ) );
                SET v_Col_Tipo = UPPER( SUBSTRING_INDEX( @resto, '(', 1 ) );
                
                IF LOCATE( '(', @resto ) > 0 THEN
                    SET v_Col_Tamanho = CAST( SUBSTRING_INDEX( SUBSTRING_INDEX( @resto, ')', 1 ), '(', -1 ) AS UNSIGNED );
                ELSE
                    SET v_Col_Tamanho = NULL;
                END IF;

                -- Verifica se a coluna existe na tabela do banco informado
				IF NOT EXISTS (
						SELECT 1 
						FROM INFORMATION_SCHEMA.COLUMNS
						WHERE TABLE_SCHEMA = v_data AND TABLE_NAME = v_NomeTabela AND COLUMN_NAME = v_Col_Nome ) THEN

					-- Altera a tabela, criando a coluna
					SET @sql = CONCAT('ALTER TABLE `', v_data, '`.`', v_NomeTabela, '` ADD COLUMN ', @linha);
                    PREPARE stmt FROM @sql;
                    EXECUTE stmt;
                    DEALLOCATE PREPARE stmt;

					SET @mensagem = CONCAT( 'Coluna "', v_Col_Nome, '" adicionada à tabela ', v_NomeTabela );
                    SELECT @mensagem AS status_msg;
                    CALL SP_Record_LOG(
						v_data, v_NomeTabela, v_Col_Nome, 
                        CONCAT( v_Tb_Col_Tipo, '(', v_Tb_Col_Tamanho, ')' ),
						CONCAT( v_Col_Tipo, '(', v_Col_Tamanho, ')' ), 
                        @mensagem );
				ELSE
                    -- Verifica se a coluna é chave primária
					SELECT COUNT(*) INTO v_is_primary_key
                    FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
                    WHERE TABLE_SCHEMA = v_data AND TABLE_NAME = v_NomeTabela AND COLUMN_NAME = v_Col_Nome AND CONSTRAINT_NAME = 'PRIMARY';

					-- Se a coluna for Chave Primária, NÃO faz nada e pula para a próxima coluna
                    IF v_is_primary_key > 0 THEN
                        ITERATE coluna_loop;
                    END IF;

                    -- Busca tipo e tamanho atuais da coluna
                    SELECT DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
					INTO v_Tb_Col_Tipo, v_Tb_Col_Tamanho
                    FROM INFORMATION_SCHEMA.COLUMNS
                    WHERE TABLE_SCHEMA = v_data AND TABLE_NAME = v_NomeTabela AND COLUMN_NAME  = v_Col_Nome;

                    IF UPPER( v_Tb_Col_Tipo ) = UPPER( v_Col_Tipo ) THEN
                        IF v_Col_Tamanho IS NOT NULL AND v_Tb_Col_Tamanho IS NOT NULL THEN
                            IF v_Col_Tamanho > v_Tb_Col_Tamanho THEN
                                SET @sql = CONCAT( 'ALTER TABLE `', v_data, '`.`', v_NomeTabela, '` MODIFY COLUMN ', @linha );
                                PREPARE stmt FROM @sql;
                                EXECUTE stmt;
                                DEALLOCATE PREPARE stmt;
                                
                                SET @mensagem = CONCAT( 'Coluna "', v_Col_Nome, '" alterada para tamanho ', v_Col_Tamanho );
                                SELECT @mensagem AS status_msg;
								CALL SP_Record_LOG(
									v_data, v_NomeTabela, v_Col_Nome, 
                                    CONCAT( v_Tb_Col_Tipo, '(', v_Tb_Col_Tamanho, ')' ),
									CONCAT( v_Col_Tipo, '(', v_Col_Tamanho, ')' ), 
                                    @mensagem );
                                    
                            ELSEIF v_Col_Tamanho < v_Tb_Col_Tamanho THEN
								SET @mensagem = CONCAT( 'Coluna "', v_Col_Nome, '" não alterada: tamanho menor que o atual.' );
                                SELECT @mensagem AS status_msg;
								CALL SP_Record_LOG(
									v_data, v_NomeTabela, v_Col_Nome, 
                                    CONCAT( v_Tb_Col_Tipo, '(', v_Tb_Col_Tamanho, ')' ),
									CONCAT( v_Col_Tipo, '(', v_Col_Tamanho, ')' ), 
                                    @mensagem );
                            END IF;
                        END IF;
                    END IF;
                END IF;
            END WHILE coluna_loop;
        END IF;
    END LOOP tabela_loop;

    CLOSE cur_tabelas;
    DROP TEMPORARY TABLE IF EXISTS LST_TABELAS;
    DROP TEMPORARY TABLE IF EXISTS LST_CAMPOS;
END