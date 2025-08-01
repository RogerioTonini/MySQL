CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Create_DB`(
	IN v_Database         VARCHAR(50),
    IN v_SP_Create_Tables VARCHAR(50)
)
BEGIN
	DECLARE v_status_msg VARCHAR(255);
    
	IF NOT sys.fx_DB_Exist( v_Database) THEN
		CALL sys.SP_SQL_Exec( CONCAT( 'CREATE DATABASE `', v_Database, '`' ), @ok );
        IF @ok THEN
			SET v_status_msg = CONCAT('Banco de dados ', v_Database, ' criado com sucesso!');
		ELSE
			SET v_status_msg = CONCAT('Erro ao criar o banco de dados ', v_Database);
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_status_msg;
		END IF;
    ELSE
        SELECT CONCAT('Banco de dados ', v_Database, ' já existe.') AS status_msg;
    END IF;
    -- CALL SP_Create_DB_Tables( v_Database, v_SP_Create_Tables );		-- Cria as tabelas do banco

	-- Altera tabela Calendario
	IF v_SP_Create_Tables IS NOT NULL AND v_SP_Create_Tables <> '' THEN
        SET @comando := CONCAT('CALL ', v_Database, '.', v_SP_Create_Tables, '()');
        CALL sys.SP_SQL_Exec(@comando, @ok);

        IF NOT @ok THEN
            SET v_status_msg = CONCAT('Erro ao executar ', v_SP_Create_Tables, ' no banco ', v_Database);
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_status_msg;
        END IF;
    END IF;

    -- Altera a tabela t_calendario para reconfigurar a coluna NUM_INDEX e criar o índice
	SET @comando := CONCAT(
		'ALTER TABLE `', v_Database, '`.`t_calendario` ',
		'MODIFY `NUM_INDEX` SMALLINT AUTO_INCREMENT NOT NULL ',
		'ADD CONSTRAINT idx_Num_Index UNIQUE ( NUM_INDEX )'
	);
    select @comando;
    CALL sys.SP_SQL_Exec( @comando, @ok );
    IF @ok THEN
		SET v_status_msg = concat( 'Coluna: [', v_Database, '.t_calendario.NUM_INDEX] alterada com sucesso' );
 		CALL sys.SP_Record_LOG( v_Database, 't_calendario', 'NUM_INDEX', 'CHAR(1)', 'SMALLINT AUTO_INCREMENT', v_status_msg );
    ELSE
        SET v_status_msg = concat( 'Falha ao alterar Coluna: [', v_Database, '.t_calendario.NUM_INDEX]. Verificar!!!' );
 		CALL sys.SP_Record_LOG( v_Database, 't_calendario', 'NUM_INDEX', 'CHAR(1)', 'SMALLINT AUTO_INCREMENT', v_status_msg );
 		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_status_msg;
    END IF;
    -- Altera a tabela t_calendario (se existir) para configurar os índices: PK_DataReferencia, SK_NumIndex

-- 		'ADD CONSTRAINT pk_DataReferencia PRIMARY KEY ( DataReferencia ), '
-- 		'ADD CONSTRAINT idx_NumIndex      UNIQUE ( NUM_INDEX );'
-- 	);

	-- Altera tabela Feriados
-- 	SET @sql := concat(
-- 		'ALTER TABLE ', v_Database, '.', 't_feriados 
--      MODIFY NUM_INDEX SMALLINT NOT NULL AUTO_INCREMENT 
-- 		ADD CONSTRAINT pk_AnoMesDiaMes PRIMARY KEY ( Ano, Mes, DiaMes ), 
-- 		ADD CONSTRAINT idx_NumIndex    UNIQUE ( NUM_INDEX );'
-- 	);
END