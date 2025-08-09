CREATE DEFINER=`root`@`localhost` PROCEDURE `sys`.`SP_Create_DB`(
	IN v_Database  VARCHAR(50),
    IN v_SP_Tables VARCHAR(50)
)
BEGIN
	DECLARE v_status_msg VARCHAR(150);

	IF sys.fx_Valid_Parameter( v_Database, 'O nome do banco de dados deve ser informado!!!' ) AND
		sys.fx_Valid_Parameter( v_SP_Tables, 'Nome da STORED PROCEDURE NÃO foi informado, favor verificar!!!' ) THEN
		
		-- Criação do DB
		IF NOT sys.fx_DB_Exist( v_Database ) THEN
			CALL sys.SP_SQL_Exec( concat( 'CREATE DATABASE `', v_Database, '`' ), @ok, @err_code, @err_msg );
			IF @ok THEN
				SET v_status_msg = concat( 'Banco de dados ', v_Database, ' criado com sucesso!' );
			ELSE
				SET v_status_msg = concat( 'Erro ao criar o banco de dados: ', v_Database );
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_status_msg;
			END IF;
		ELSE
			SELECT concat( 'Banco de dados ', v_Database, ' já existe.' ) AS status_msg;
		END IF;
	    
		-- Criação das tabelas do banco
		CALL SP_Create_DB_Tables( v_Database, v_SP_Tables );

		SET @comando := concat( 'CALL ', v_Database, '.', v_SP_Tables, '()' );
		CALL sys.SP_SQL_Exec( @comando, @ok, @err_code, @err_msg );

		IF NOT @ok THEN
			SET v_status_msg = concat( 'Erro ao executar ', v_SP_Create_Tables, ' no banco ', v_Database );
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_status_msg;
		END IF;
	END IF;
		
	SELECT "Processo finalizado!";
END