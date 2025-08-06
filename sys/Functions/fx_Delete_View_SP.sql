CREATE DEFINER=`root`@`localhost` FUNCTION `fx_Delete_View_SP`(
	v_Database VARCHAR(50),
    v_SP_Name  VARCHAR(100),
    v_Apagar   CHAR(1) -- 'S' = Apagar, 'N' = Apenas verificar
) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
    DECLARE v_Existe     INT DEFAULT 0;
	DECLARE v_status_msg VARCHAR(255);

    SELECT COUNT(DISTINCT ROUTINE_TYPE) INTO v_Existe
    FROM INFORMATION_SCHEMA.ROUTINES
    WHERE 
        ROUTINE_SCHEMA = v_Database AND
        ROUTINE_NAME = v_SP_Name    AND
        ROUTINE_TYPE = 'PROCEDURE';

    -- Se existir e for para apagar
    IF v_Existe > 0 AND UPPER(v_Apagar) = 'S' THEN
		CALL sys.SP_SQL_Exec( CONCAT('DROP PROCEDURE IF EXISTS `', v_Database, '`.`', v_SP_Name, '`'), @ok, @err_code, @err_msg );
		IF @ok THEN
			SET v_status_msg = CONCAT( 'Procedure ', v_Database, '`.`', v_SP_Name, 'apagada com sucesso!!!' );
		ELSE
			SET v_status_msg = CONCAT( 'Erro ao apagar Procedure ', v_Database, '`.`', v_SP_Name, '` !!!' );
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_status_msg;
		END IF;
    END IF;

    -- Apenas retorna se existe ou não
    RETURN v_Existe > 0;
END