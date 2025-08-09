CREATE DEFINER=`root`@`localhost` PROCEDURE `sys`.`SP_Create_DB`(
	IN v_Database  VARCHAR(50),
    IN v_SP_Tables VARCHAR(50)
)
BEGIN
	DECLARE v_status_msg VARCHAR(150);

	IF sys.Valid_Parameter(v_Database, 'O nome do banco de dados deve ser informado!!!') AND
		sys.Valid_Parameter(v_SP_Tables, 'Nome da STORED PROCEDURE NÃO foi informado, favor verificar!!!') THEN
		
		-- Criação do DB
		IF NOT sys.fx_DB_Exist( v_Database) THEN
			CALL sys.SP_SQL_Exec( concat( 'CREATE DATABASE `', v_Database, '`' ), @ok, @err_code, @err_msg );
			IF @ok THEN
				SET v_status_msg = concat( 'Banco de dados ', v_Database, ' criado com sucesso!' );
			ELSE
				SET v_status_msg = concat( 'Erro ao criar o banco de dados ', v_Database );
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_status_msg;
			END IF;
		ELSE
			SELECT concat( 'Banco de dados ', v_Database, ' já existe.' ) AS status_msg;
		END IF;
	    
		-- Criação das tabelas do banco
		CALL SP_Create_DB_Tables( v_Database, v_SP_Tables );
		IF v_SP_Tables IS NOT NULL AND v_SP_Tables <> '' THEN
			SET @comando := concat( 'CALL ', v_Database, '.', v_SP_Tables, '()' );
			CALL sys.SP_SQL_Exec( @comando, @ok, @err_code, @err_msg );
	
			IF NOT @ok THEN
				SET v_status_msg = concat( 'Erro ao executar ', v_SP_Create_Tables, ' no banco ', v_Database );
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_status_msg;
			END IF;
		END IF;
	END IF;
	SELECT "Processo finalizado!";
END	

		
--	-- Validação do nome do banco
--     IF v_Database IS NULL OR trim(v_Database) = '' THEN
-- 		SET v_status_msg = 'O nome do banco de dados deve ser informado!!!';
-- 		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_status_msg;
--     END IF;
-- 
--    -- Validação do nome da SP de tabelas
-- 	IF v_SP_Tables IS NULL OR trim(v_SP_Tables) = '' THEN
-- 		SET v_status_msg = 'Nome da STORED PROCEDURE NÃO foi informado, favor verificar!!!';
-- 		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_status_msg;
-- 	END IF;
-- 	
-- 	-- Criação do DB
-- 	IF NOT sys.fx_DB_Exist( v_Database) THEN
-- 		CALL sys.SP_SQL_Exec( concat( 'CREATE DATABASE `', v_Database, '`' ), @ok, @err_code, @err_msg );
-- 		IF @ok THEN
-- 			SET v_status_msg = concat( 'Banco de dados ', v_Database, ' criado com sucesso!' );
-- 		ELSE
-- 			SET v_status_msg = concat( 'Erro ao criar o banco de dados ', v_Database );
-- 			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_status_msg;
-- 		END IF;
-- 	ELSE
-- 		SELECT concat( 'Banco de dados ', v_Database, ' já existe.' ) AS status_msg;
-- 	END IF;
--     
-- 	-- Criação das tabelas do banco
-- 	CALL SP_Create_DB_Tables( v_Database, v_SP_Tables );
-- 	IF v_SP_Tables IS NOT NULL AND v_SP_Tables <> '' THEN
-- 		SET @comando := concat( 'CALL ', v_Database, '.', v_SP_Tables, '()' );
-- 		CALL sys.SP_SQL_Exec( @comando, @ok, @err_code, @err_msg );
-- 
-- 		IF NOT @ok THEN
-- 			SET v_status_msg = concat( 'Erro ao executar ', v_SP_Create_Tables, ' no banco ', v_Database );
-- 			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_status_msg;
-- 		END IF;
-- 	END IF;
-- 	SELECT "Processo finalizado!";
-- END