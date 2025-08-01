-- Author: Rogerio Tonini
-- Data: 25/07/2025
-- Versão: 1.0
-- URL: HTTP://www.github.com/RogerioTonini
-- Objetivo: Criar um banco de dados se não existir
-- Schema: sys
-- Utilização - Parâmetros:
-- v_Database: Nome do banco de dados onde a tabela está localizada.
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Create_DB`(
	IN v_Database         VARCHAR(50),
    IN v_SP_Create_TBs VARCHAR(50)
)
BEGIN
	DECLARE v_status_msg VARCHAR(255);
    
-- 	IF NOT sys.fx_DB_Exist( v_Database) THEN
-- 		CALL sys.SP_SQL_Exec( CONCAT( 'CREATE DATABASE `', v_Database, '`' ), @ok );
-- 		IF @ok THEN
-- 			SET v_status_msg = CONCAT('Banco de dados ', v_Database, ' criado com sucesso!');
-- 		ELSE
-- 			SET v_status_msg = CONCAT('Erro ao criar o banco de dados ', v_Database);
-- 			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_status_msg;
-- 		END IF;
-- 	ELSE
-- 		SELECT CONCAT('Banco de dados ', v_Database, ' já existe.') AS status_msg;
-- 	END IF;
    
	-- Cria as tabelas do banco
-- 	CALL SP_Create_DB_Tables( v_Database, v_SP_Create_TBs );
-- 	IF v_SP_Create_Tables IS NOT NULL AND v_SP_Create_Tables <> '' THEN
-- 		SET @comando := CONCAT('CALL ', v_Database, '.', v_SP_Create_Tables, '()');
-- 		CALL sys.SP_SQL_Exec(@comando, @ok, @err_code, @err_msg );

-- 		IF NOT @ok THEN
-- 			SET v_status_msg = CONCAT('Erro ao executar ', v_SP_Create_Tables, ' no banco ', v_Database);
-- 			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_status_msg;
-- 		END IF;
-- 	END IF;

    -- Altera a tabela t_calendario para reconfigurar a coluna NUM_INDEX e criar o índice
	SET @comando := CONCAT(
		'ALTER TABLE `', v_Database, '`.`t_calendario` ',
		'MODIFY `NUM_INDEX` SMALLINT AUTO_INCREMENT NOT NULL ',
		'ADD CONSTRAINT idx_Num_Index UNIQUE ( NUM_INDEX )'
	);
    CALL sys.SP_SQL_Exec( @comando, @ok, @err_code, @err_msg );  
-- 	IF @ok THEN
-- 		SET v_status_msg = concat( 'Coluna: [', v_Database, '.t_calendario.NUM_INDEX] alterada com sucesso' );
-- 		CALL sys.SP_Record_LOG( v_Database, 't_calendario', 'NUM_INDEX', 'CHAR(1)', 'SMALLINT AUTO_INCREMENT', v_status_msg );
-- 	ELSE
-- 		SET v_status_msg = concat( 'Falha ao alterar Coluna: [', v_Database, '.t_calendario.NUM_INDEX]. Verificar!!!' );
-- 		CALL sys.SP_Record_LOG( v_Database, 't_calendario', 'NUM_INDEX', 'CHAR(1)', 'SMALLINT AUTO_INCREMENT', v_status_msg );
-- 		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_status_msg;
-- 	END IF;
    -- Altera a tabela t_calendario (se existir) para configurar os índices: PK_DataReferencia, SK_NumIndex

	-- Altera tabela Feriados
-- 	SET @sql := concat(
-- 		'ALTER TABLE ', v_Database, '.', 't_feriados 
--      MODIFY NUM_INDEX SMALLINT NOT NULL AUTO_INCREMENT 
-- 		ADD CONSTRAINT pk_AnoMesDiaMes PRIMARY KEY ( Ano, Mes, DiaMes ), 
-- 		ADD CONSTRAINT idx_NumIndex    UNIQUE ( NUM_INDEX );'
-- 	);
END