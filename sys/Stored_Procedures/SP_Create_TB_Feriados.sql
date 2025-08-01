CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Create_TB_Feriados`(
	IN db_Name      VARCHAR(50)
    -- , IN v_AnoInicial SMALLINT
)
BEGIN
    DECLARE v_Valida     INT DEFAULT 1;	    -- FLAG de validação para Banco de Dados e Tabelas
    DECLARE v_status_msg VARCHAR(255);	    -- Mensagem de erro
    DECLARE db_Table     VARCHAR(50);		-- Nome da Tabela a ser criada, atualizada, apagada.
    DECLARE v_G INT;						-- Variável utilizada para os cálculos da Páscoa
    DECLARE v_K INT;						-- Variável utilizada para os cálculos da Páscoa
    DECLARE v_I INT;						-- Variável utilizada para os cálculos da Páscoa
    DECLARE v_H INT;						-- Variável utilizada para os cálculos da Páscoa
    DECLARE v_J INT;						-- Variável utilizada para os cálculos da Páscoa
    DECLARE v_L INT;						-- Variável utilizada para os cálculos da Páscoa
    DECLARE v_M INT;						-- Variável utilizada para os cálculos da Páscoa
    DECLARE v_Seculo    INT;				-- Variável utilizada para os cálculos da Páscoa
    DECLARE v_diaPascoa INT;				-- Variável utilizada para os cálculos da Páscoa
    DECLARE v_mesPascoa INT;				-- Variável utilizada para os cálculos da Páscoa
    DECLARE v_anoPascoa INT;				-- Variável utilizada para os cálculos da Páscoa
    DECLARE v_dataPascoa DATE;				-- Variável utilizada para os cálculos da Páscoa

    -- Validação do nome do banco de dados e se ele existe
    IF db_Name = '' THEN
        SET v_status_msg = 'O nome do Banco de Dados deve ser informado!!!';
        SET v_Valida = 0;
    ELSEIF NOT sys.fx_DB_Exist(db_Name) THEN
        SET v_status_msg = concat('Banco de Dados: [', db_Name, '] NÃO existe!');
        SET v_Valida = 0;
    END IF;

    -- Se houver erro, emite mensagem e finaliza script
    IF v_Valida = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_status_msg;
    END IF;
    
	-- Verifica se a Tabela: t_feriados existe. Se existir, apaga os índices e a tabela
	SET db_Table = 't_feriados';
	CALL sys.SP_Drop_Table_Indexes( db_Name, db_Table );
    
	-- Cria a tabela com SQL dinâmico
	SET @sql := concat(
		'CREATE TABLE ', db_Name, '.', db_Table, ' (
			NUM_INDEX   INT           AUTO_INCREMENT,
			Ano         SMALLINT     NOT NULL,
			Mes         TINYINT      NOT NULL,
			DiaMes      TINYINT      NOT NULL,
			NomeFeriado VARCHAR(150) NOT NULL,
			UF          CHAR(2),
			TipoFeriado ENUM(''1'', ''2'', ''3'', ''4'', ''5'') NOT NULL,

			CONSTRAINT PK_AnoMesDiaMes PRIMARY KEY ( Ano, Mes, DiaMes ),
			CONSTRAINT SK_NumIndex    UNIQUE (NUM_INDEX)
		);'
	);
	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

    -- Verifica se a tabela foi criada
    IF NOT sys.fx_TB_Exist( db_Name, db_Table) then
		SET v_status_msg = concat('Erro ao criar a tabela: [ ', db_Table, ' ]');
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = V_status_msg;
	END IF;
    
    -- Verifica se a tabela foi criada
    IF NOT sys.fx_IDX_Exist( db_Name, db_Table, @idx_Name) then
		SET v_status_msg = concat('Erro ao criar o índice: [ ', @idx_Name, ' da tabela: [ ', db_Table, ' ]');
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = V_status_msg;
	END IF;

	-- Insere feriados em datas fixas
    -- A coluna: TipoFeriado (última coluna) aceita somente os valores:
    -- [ 1 ] - Feriados Mundiais
    -- [ 2 ] - Feriados Nacionais
    -- [ 3 ] - Feriados Estaduais 
    -- [ 4 ] - Municipais
    -- [ 5 ] - Pontos Facultativos
	SET @sql := concat(
		'INSERT INTO ', 
			db_Name, '.', db_Table, ' (Ano, Mes, DiaMes, NomeFeriado, UF, TipoFeriado) ', 
		'VALUES ',
        -- Feriados Mundiais
		'( 0,     1,  1, ''Confraternização Universal'',                                     '''', ''1'' ), ',
		'( 0,     5,  1, ''Dia do Trabalhador'',                                             '''', ''1'' ), ',
		'( 0,    12, 25, ''Natal'',                                                          '''', ''1'' ), ',
		-- Feriados Nacionais
		'( 0,     4, 21, ''Tiradentes / Data magna do estado MG'',                           '''', ''2'' ), ',
		'( 0,     9,  7, ''Independência do Brasil'',                                        '''', ''2'' ), ',
		'( 0,    10, 12, ''Nsa. Senhora Aparecida'',                                         '''', ''2'' ), ',
		'( 0,    10, 28, ''Dia do Servidor Público - ponto facultativo'',                    '''', ''5'' ), ',
        '( 0,    11,  2, ''Finados'',                                                        '''', ''2'' ), ',
		'( 0,    11, 15, ''Proclamação da República'',                                       '''', ''2'' ), ',
		'( 0,    11, 20, ''Consciência Negra / Morte de Zumbi dos Palmares'',                '''', ''2'' ), ',
		-- Feriados Estaduais / Municipais / Ponto Facultativo (principais)
        -- Acre
		'( 1882, 12, 28, ''Aniversário do município: RIO BRANCO'',                           ''AC'', ''4'' ), ',
		'( 1903, 11, 17, ''Assinatura do Tratado de Petrópolis'',                            ''AC'', ''3'' ), ',
		'( 1962,  6, 15, ''Aniversário do estado'',                                          ''AC'', ''3'' ), ',
		'( 1968,  9,  5, ''Dia da Amazônia'',                                                ''AC'', ''3'' ), ',
		'( 2009,  1, 23, ''Dia do evangélico'',                                              ''AC'', ''3'' ), ',
        -- Amapá
		'( 1901, 10, 22, ''Aniversário do munícipio: AMAPÁ'',                                ''AP'', ''4'' ), ',
		'( 1943,  9, 13, ''Criação do Território Federal (Data Magna do estado)'',           ''AP'', ''3'' ), ',
		'( 1977,  2,  4, ''Aniversário do município: MACAPÁ (1758)'',                        ''AP'', ''4'' ), ',
		-- Amazonas
		'( 1869, 10, 24, ''Aniversário do munícipio: MANAUS'',                               ''AM'', ''4'' ), ',
        '( 1977,  9,  5, ''Elevação do Amazonas à categoria de província (1850)'',           ''AM'', ''3'' ), ',
		-- Bahia
		'( 1549,  3, 29, ''Aniversário do munícipio: SALVADOR'',                             ''BA'', ''3'' ), ',
		'( 1823,  7,  2, ''Independência da Bahia (Data magna do estado)'',                  ''BA'', ''3'' ), ',       
		-- Ceará
		'( 0,     3, 25, ''Data magna do estado (data da abolição da escravidão no Ceará)'', ''CE'', ''3'' ), ',
		'( 1726,  4, 16, ''Aniversário do munícipio: MANAUS'',                               ''CE'', ''4'' ), ',
		-- Distrito Federal
		'( 1960,  4, 21, ''Fundação de Brasília'',                                           ''DF'', ''3'' ), ',
		'( 2006, 11, 30, ''Dia do evangélico'',                                              ''DF'', ''3'' ), ',
		-- Maranhão
		'( 0,     7, 28, ''Adesão do Maranhão à independência do Brasil'',                   ''MA'', ''3'' ), ',
		'( 1612,  9,  8, ''Aniversário do município: SÃO LUIZ'',                             ''MA'', ''4'' ), ',
		-- Minas Gerais
		'( 1897, 12, 12, ''Aniversário do munícipio: BELO HORIZONTE'',                       ''MG'', ''4'' ), ',
		-- Mato Grosso
		'( 1749,  4,  8, ''Aniversário do munícipio: CUIABÁ'',                               ''MT'', ''4'' ), ',
		'( 1977, 10, 11, ''Criação do estado - MATO GROSSO'',                                ''MT'', ''3'' ), ',
		-- Mato Grosso do Sul
		'( 1899,  8, 26, ''Aniversário do munícipio: CAMPO GRANDE'',                         ''MS'', ''4'' ), ',
		'( 1748,  9, 21, ''Aniversário do munícipio: CORUMBÁ'',                              ''MS'', ''4'' ), ',
		'( 1977, 10, 11, ''Criação do estado - MATO GROSSO DO SUL'',                         ''MS'', ''3'' ), ',
		-- Pará
		'( 1616,  1, 12, ''Aniversário do munícipio: CAMPO GRANDE'',                         ''PA'', ''4'' ), ',
		'( 1823,  8, 15, ''Adesão do Grão-Pará à independência do Brasil (data magna)'',     ''PA'', ''3'' ), ',
		-- Paraíba
		'( 1585,  8,  5, ''Fundação do Estado - PARAÍBA (1585)'',                            ''PB'', ''3'' ), ',
		'( 1817,  9, 16, ''Emancipação Política de Alagoas'',                                ''PB'', ''3'' ), ',
		'( 1930,  7, 26, ''Homenagem à memória do ex-presidente João Pessoa'',               ''PB'', ''3'' ), ',
		'( 2006, 11, 30, ''Dia do Evangélico'',                                              ''PB'', ''3'' ), ',
		-- Piauí
 		'( 0,    12,  8, ''Nossa Senhora da Conceição'',                                     ''PI'', ''4'' ), ',
        '( 1852,  8, 16, ''Aniversário do munícipio: TERESINA'',                             ''PI'', ''4'' ), ',
		'( 1822, 10, 19, ''Dia do Piauí'',                                                   ''PI'', ''3'' ), ',
		-- Paraná
		'( 1693,  3, 29, ''Aniversário do munícipio: CURITIBA'',                             ''PR'', ''3'' ), ',
		'( 1853, 12, 19, ''Emancipação Política do Paraná'',                                 ''PR'', ''3'' ), ',
		-- Rio de Janeiro
		'( 1565,  3,  1, ''Aniversário do munícipio: Rio de Janeiro'',                       ''RJ'', ''4'' ), ',
		'( 2008,  4, 23, ''Dia de São Jorge'',                                               ''RJ'', ''3'' ), ',
		'( 2010,  1, 20, ''Dia de São Cristovão - feriado mun.: RIO DE JANEIRO'',            ''RJ'', ''4'' ), ',
		-- Rio Grande do Norte
		'( 1599, 12, 25, ''Aniversário do munícipio: NATAL'',                                ''RN'', ''4'' ), ',
		'( 2000,  8,  7, ''Dia do Rio Grande do Norte'',                                     ''RN'', ''3'' ), ',
		'( 2006, 10,  3, ''Mártires de Cunhaú e Uruaçu'',                                    ''RN'', ''3'' ), ',
		-- Rondônia
		'( 1914, 10,  2, ''Aniversário do munícipio: PORTO VELHO'',                          ''RO'', ''4'' ), ',
		'( 1982,  1,  4, ''Criação do estado - RONDÔNIA'',                                   ''RO'', ''3'' ), ',
		'( 2001,  6, 18, ''Dia do evangélico'',                                              ''RO'', ''3'' ), ',
		-- Roraima
		'( 1926,  7,  9, ''Aniversário do munícipio: BOA VISTA  '',                          ''RR'', ''4'' ), ',
		'( 1988, 10,  5, ''Criação do estado - RORAIMA'',                                    ''RR'', ''3'' ), ',
		-- Rio Grande do Sul
		'( 1772,  3, 26, ''Aniversário do munícipio: PORTO ALEGRE'',                         ''RS'', ''4'' ), ',
		'( 1836,  9, 11, ''Proclamação da República Rio-Grandense'',                         ''RS'', ''3'' ), ',
		-- Santa Catarina
		'( 1673,  3, 23, ''Aniversário do munícipio: FLORIANÓPOLIS'',                        ''SC'', ''4'' ), ',
		'( 1808, 10,  5, ''Dia da Cavalaria - Pol. MILITAR SC'',                             ''SC'', ''3'' ), ',
		'( 2022,  8, 11, ''Data Magna do Estado de Santa Catarina'',                         ''SC'', ''3'' ), ',
		-- São Paulo
		'( 1969,  1, 25, ''Aniversário do município: SÃO PAULO (1554)'',                     ''SP'', ''3'' ), ',
		'( 1997,  7,  9, ''Rev. Constitucionalista 1932'',                                   ''SP'', ''3'' ), ',
		-- Sergipe
		'( 0,     6, 24, ''São João'',                                                       ''SE'', ''3'' ), ',
		'( 0,    12,  8, ''Nossa Senhora da Conceição'',                                     ''SE'', ''3'' ), ',
		'( 1855,  3, 17, ''Aniversário do município: ARACAJU'',                              ''SE'', ''3'' ), ',
		'( 2023,  7,  8, ''Independência de Sergipe, ocorrida em 1820'',                     ''SE'', ''3'' ), ',
		-- Tocantins
		'( 1989, 10,  5, ''Criação do estado'',                                              ''TO'', ''3'' ), ',
		'( 1993,  9,  8, ''Nossa Senhora da Natividade - Padroeira do Estado'',              ''TO'', ''3'' ), ',
		'( 1996,  5, 20, ''Aniversário do munícipio: PALMAS'',                               ''TO'', ''4'' ); '
	);
	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	-- Verifica se os inserts ocorreram
	SET @sql := concat(
		'SELECT COUNT(*) INTO @qtd_registros 
		 FROM ', db_Name, '.', db_Table, ';'
	);
	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	IF @qtd_registros = 0 THEN
		SET v_status_msg = concat('Erro: Nenhum registro foi inserido na tabela: [ ', db_Table, ' ]');
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_status_msg;
	END IF;

	-- Calcula os feriados móveis no período dos anos requeridos
    SET @anoInicial  := 1900;
    SET @anoFinal    := 2099;
    SET @dataInicial := str_to_date( concat( @anoInicial, '-01-01' ), '%Y-%m-%d' );
    SET @dataFinal   := str_to_date( concat( @anoFinal,   '-12-31' ), '%Y-%m-%d' );
	SET v_anoPascoa  = @anoInicial;

	loop_Feriados: WHILE v_anoPascoa <= @anoFinal DO

		SET v_Seculo = v_anoPascoa / 100;
		SET v_G = v_anoPascoa % 19;
		SET v_K = floor( ( v_Seculo - 17 ) / 25 );
		SET v_I = ( v_Seculo - floor( v_Seculo / 4 ) - floor( ( v_Seculo - v_K ) / 3 ) + ( 19 * v_G) + 15 ) % 30;
		SET v_H = v_I - floor( v_I / 28 ) * ( 1 - floor( v_I / 28 ) * floor( 29 / ( v_I + 1 ) ) * floor( ( 21 - v_G) / 11 ) );
		SET v_J = ( v_anoPascoa + floor( v_anoPascoa / 4 ) + v_H + 2 - v_Seculo + floor( v_Seculo / 4 ) ) % 7;
		SET v_L = v_H - v_J;
		
		SET v_mesPascoa = 3 + floor( ( v_L + 40 ) / 44 );
		SET v_diaPascoa = v_L + 28 - 31 * floor( v_mesPascoa / 4 );
		SET v_dataPascoa = str_to_date( concat( v_anoPascoa, '-', lpad( v_mesPascoa, 2, '0' ), '-', lpad( v_diaPascoa, 2, '0' ) ), '%Y-%m-%d' );

		SET @sql := concat(
			'INSERT INTO ', 
				db_Name, '.', db_Table, '( Ano, Mes, DiaMes, NomeFeriado, UF, TipoFeriado ) ',
			'VALUES ',
				'( ', YEAR(DATE_SUB(v_dataPascoa, INTERVAL 47 DAY)), ', ', MONTH(DATE_SUB(v_dataPascoa, INTERVAL 47 DAY)), 
					', ', DAY(DATE_SUB(v_dataPascoa, INTERVAL 47 DAY)), ', ''Carnaval (segunda-feira)'', '''', ''5'' ), ',

				'( ', YEAR(DATE_SUB(v_dataPascoa, INTERVAL 48 DAY)), ', ', MONTH(DATE_SUB(v_dataPascoa, INTERVAL 48 DAY)), 
					', ', DAY(DATE_SUB(v_dataPascoa, INTERVAL 48 DAY)), ', ''Carnaval (terça-feira)'', '''', ''5'' ), ',

				'( ', YEAR(DATE_SUB(v_dataPascoa, INTERVAL 2 DAY)), ', ', MONTH(DATE_SUB(v_dataPascoa, INTERVAL 2 DAY)), 
					', ', DAY(DATE_SUB(v_dataPascoa, INTERVAL 2 DAY)), ', ''Sexta-feira Santa'', '''', ''1'' ), ',

				'( ', YEAR(v_dataPascoa), ', ', MONTH(v_dataPascoa), ', ', DAY(v_dataPascoa), ', ''Páscoa'', '''', ''1'' ), ',

				'( ', YEAR(DATE_ADD(v_dataPascoa, INTERVAL 60 DAY)), ', ', MONTH(DATE_ADD(v_dataPascoa, INTERVAL 60 DAY)), 
					', ', DAY(DATE_ADD(v_dataPascoa, INTERVAL 60 DAY)), ', ''Corpus Christi'', '''', ''1'' );'
		);
		PREPARE stmt FROM @sql;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
        
		SET v_anoPascoa = v_anoPascoa + 1;
	END WHILE loop_Feriados;    
    SELECT "Processo finalizado!!" AS Mensagem;
END

-- Feriados não incluídos
-- '( 2006, 11, 30, ''Dia do evangélico - AL, DF, ,                                     '''', ''3'' ), ',
-- '( 0,    12,  8, ''Nossa Sra da Conceição – AP (MACAPÁ, OIAPOQUE), SE, PI'',         '''', ''3'' ), ',
-- '( 0,     1, 23, ''Aniversário do município: MAZAGÃO'',                              ''AP'', ''4'' ), ',
-- '( 0,     1, 25, ''Aniversário do município: CALÇOENE'',                             ''AP'', ''4'' ),' ,
-- '( 0,     3, 19, ''Dia de São José, santo padroeiro do Estado do Amapá'',            ''AP'', ''3'' ), ',
-- '( 0,     5, 15, ''Dia de Cabralzinho'',                                             ''AP'', ''3'' ),' ,
-- '( 0,     5, 23, ''Aniversário do município: OIAPOQUE'',                             ''AP'', ''4'' ), ',
-- '( 0,     6, 13, ''Santo Antônio - feriado mun.: LARANJAL DO JARI'',                 ''AP'', ''4'' ), ',
-- '( 0,     6, 29, ''São Pedro - feriado mun.: CALÇOENE, VITÓRIA DO JARI, PEDRA BRANCA DO AMAPARI'', ''AP'', ''4'' ), ',
-- '( 0,     7, 21, ''Promulgação da Lei Orgânica - feriado mun.: VITÓRIA DO JARI''     ''AP'', ''4'' ), ',
-- '( 0,     7, 25, ''Dia de São Tiago'',                                               ''AP'', ''3'' ), ',
-- '( 0,     7, 26, ''Dia de Santa Ana – feriado mun.: SERRA DO NAVIO, SANTANA'',       ''AP'', ''4'' ), ',
-- '( 0,     6, 29, ''Promulgação da Lei Orgânica - feriado mun.: CALÇOENE, VITÓRIA DO JARI'', ''AP'', ''4'' ), ',
-- '( 0,     8, 15, ''Nossa Sra das Graças - feriado mun.: MANGAZÃO, OIAPOQUE'',        ''AP'', ''4'' ), ',
-- '( 0,     8, 31, ''São Raimundo Nonato - feriado mun.: MANGAZÃO'',                   ''AP'', ''4'' ), ',
-- '( 0,     9,  8, ''Aniversário do município: VITÓRIA DO JARI'',                      ''AP'', ''4'' ), ',
-- '( 0,    10, 17, ''Nossa Senhora Perpétuo Socorro – feriado mun.: TARTARUGALZINHO'', ''AP'', ''4'' ), ',
-- '( 0,    12, 17, ''Aniversário do munícipio: FERREIRA GOMES, TARTARUGALZINHO, SANTANA, LARANAJAL DO JARI'', ''AP'', ''4'' ), ',
-- '( 0,     4, 21, ''Data magna do estado'',                                           ''MG'', ''3'' ), ',