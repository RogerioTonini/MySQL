CREATE DEFINER=`root`@`localhost` FUNCTION `fx_SQL_Valid`(
	v_command TEXT
) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
    RETURN v_command IS NOT NULL AND LENGTH(TRIM(v_command)) > 0;
END