CREATE PROCEDURE sys.SP_Create_Tables(
	IN v_Database VARCHAR(50),
	IN v_TableName VARCHAR(50),
	IN v_Def_Coluna TEXT,
	OUT v_result    BOOLEAN
)
	DETERMINISTIC
BEGIN
	DECLARE v_data_table VARCHAR(100);
	DECLARE v_status_msg VARCHAR(255);

	IF NOT sys.fx_TB_Exist( v_Database, v_TableName ) THEN	
		SET v_result   = TRUE;
		SET v_data_table = concat( '`', v_Database, '`.`', v_TableName, '`' );
		SET v_status_msg = concat(
			'Tabela + Índice Primário ', v_data_table, ' criada com sucesso.'
		);
	    SET @cmd_key     := concat( 'CREATE TABLE ', v_data_table, ' (', v_Def_Coluna, ')' );
		
		CALL sys.SP_SQL_Exec( @cmd_key, @ok, @err_code, @err_msg );
		IF NOT @ok THEN
			SET v_result     = FALSE;
			SET v_status_msg = concat(
				'Erro ao criar a Tabela + Índice Primário: ', v_data_table, @err_code, @err_msg
			);
		END IF;
		CALL sys.SP_Record_LOG( v_Database, v_TableName, '', '', '', v_status_msg );
	END IF;
END