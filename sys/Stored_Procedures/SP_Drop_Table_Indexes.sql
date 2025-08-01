CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Drop_Table_Indexes`(
	IN v_Database VARCHAR(70),
	IN v_Table    VARCHAR(70)
)
BEGIN
	DECLARE v_sql       TEXT;
    DECLARE v_existe    BOOL DEFAULT FALSE;
	DECLARE v_resultado BOOL DEFAULT FALSE;

	IF sys.fx_TB_Exist( v_Database, v_Table ) THEN
		-- Tenta remover os índices diferentes de PRIMARY
		CALL sys.SP_Drop_Indexes(v_Database, v_Table, @resultado);

	IF @resultado THEN 
		SET @sql := concat('DROP TABLE `', v_Database, '`.`', v_Table, '`' );
		PREPARE stmt FROM @sql;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
		SELECT concat( 'Tabela: [ ', v_Table, ' ] apagada com sucesso!' ) AS Mensagem;
	END IF;
	ELSE
		SELECT concat( 'Tabela: ', v_Table, ' NÃO existe!' ) AS Mensagem;
	END IF; 
END