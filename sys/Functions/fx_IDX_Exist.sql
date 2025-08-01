CREATE DEFINER=`root`@`localhost` FUNCTION `fx_IDX_Exist`(
    v_Database VARCHAR(50),
    v_Table    VARCHAR(50),
    v_idx_Name VARCHAR(50)
) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
    DECLARE v_existe BOOLEAN;

    SELECT count(*) INTO v_existe
	FROM INFORMATION_SCHEMA.STATISTICS
	WHERE
        TABLE_SCHEMA = v_Database AND
        TABLE_NAME   = v_Table    AND
        INDEX_NAME   = v_idx_Name;
    RETURN v_existe;
END