CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Create_TB_Calendario`()
BEGIN
    DROP TEMPORARY TABLE IF EXISTS LST_TABELAS;
    DROP TEMPORARY TABLE IF EXISTS LST_CAMPOS;

    CREATE TEMPORARY TABLE LST_TABELAS(
        ID_Tabela INT PRIMARY KEY,
        Nome_Tabela VARCHAR(255),
        Nome_PK VARCHAR(255)
    );

    INSERT INTO 
		LST_TABELAS 
    VALUES
        ( 1, 'T_Calendario', 'NUM_INDEX' );

    CREATE TEMPORARY TABLE LST_CAMPOS (
        ID_TabelaCampo INT PRIMARY KEY,
        Nome_DefCampo  TEXT,           
        Nome_FN_Key    TEXT            
    );

    INSERT INTO LST_CAMPOS VALUES
	( 1,
		concat(
			'`NUM_INDEX`',            'SMALLINT ', 'NOT NULL, ',
			'`DataReferencia`',       'DATE ',     'NOT NULL, ',
			'`DataRef_Nome`',         'CHAR(10) ', 'NOT NULL, ',
			'`Data_OffSet`',          'SMALLINT ', 'NOT NULL, ',
			'`Data_Futura`',          'BOOLEAN ',  'NOT NULL, ',
			-- Colunas DIA 
            -- Observação: Não é necessário a coluna [Dia_INDEX], pois a coluna [NUM_INDEX] é similar
			'`Dia_Offset`',           'SMALLINT ',    'NOT NULL, ',
			'`DiaMesRef_Nome`',       'CHAR(2) ',     'NOT NULL, ', -- Número do Dia do Mês em formato caractere de 2 dígitos
			'`DiaMes_Num`',           'TINYINT ',     'NOT NULL, ',
			'`DiaAno_Num`',           'SMALLINT ',    'NOT NULL, ', -- Número do dia no Ano
			'`DiaSemanaAno_Num`',     'SMALLINT ',    'NOT NULL, ',
			'`DiaSemana_Num`',        'TINYINT  ',    'NOT NULL, ', -- Padrão: Segunda = 1 a Domingo = 7
			'`DiaSemana_Abrev`',      'CHAR(3)  ',    'NOT NULL, ', -- Nome do dia abreviado
			'`DiaSemana_Nome`',       'VARCHAR(13) ', 'NOT NULL, ', -- Nome do dia por extenso
			'`DiaSemana_Sigla`',      'CHAR(1) ',     'NOT NULL, ',
			'`DiaUtil_Num`',          'BOOLEAN ',     'NOT NULL, ', -- É dia útil
			'`DiaUtilMes_Acm`',       'TINYINT ',     'NOT NULL, ', -- Acumulado de dias úteis no Mês 
			'`DiaUtilAno_Acm`',       'TINYINT ',     'NOT NULL, ', -- Acumulado de dias úteis no Ano
			'`FeriadoNome`',          'VARCHAR(50) ', 'DEFAULT NULL, ',            
            --
			-- Colunas MES
			'`Mes_INDEX`',            'SMALLINT ',   'NOT NULL, ',
			'`Mes_Offset`',           'SMALLINT ',   'NOT NULL, ',
			'`Mes_Num`',              'TINYINT',     'NOT NULL, ',
			'`MesRef_Nome`',          'CHAR(2) ',    'NOT NULL, ', -- Número do mês em formato caractere de 2 dígito
			'`Mes_Qtd`',              'SMALLINT',    'NOT NULL, ', -- Quantidade de meses na tabela Calendario
			'`Mes_Abrev`',            'CHAR(3)',     'NOT NULL, ', -- Nome abreviado
			'`Mes_Nome`',             'VARCHAR(8) ', 'NOT NULL, ', -- Nome por extenso
			'`Mes_Sigla`',            'CHAR(1)',     'NOT NULL, ', -- Primeira letra
			'`MesDoAno_Num`',         'MEDIUMINT',   'NOT NULL, ', -- [AnoRef_Nome] & [MesRef_Nome], padrão dados: [YYYY][mm]
			'`MesDoAno_Abrev`',       'CHAR(6)',     'NOT NULL, ', -- [Mes_Abrev] & [AnoRef_Nome],   padrão: mmm/YYYY
			'`MesDoAno_Nome`',        'CHAR(13)',    'NOT NULL, ', -- [Mes_Nome] & [Ano_Num],        padrão: mmmm/YYYY
			'`MesDoDia_Num`',         'SMALLINT',    'NOT NULL, ', -- [MesRef_Nome] & [DiaRef_Nome], padrão: [mm][dd]
			'`MesDoDia_Abrev`',       'CHAR(6)',     'NOT NULL, ', -- [Mes_Abrev] & [DiaRef_Nome],   padrão: [mmm]/[dd]
            --
			-- Colunas ANO
			'`Ano_INDEX`',            'TINYINT ',  'NOT NULL, ',
			'`Ano_OffSet`',           'TINYINT ',  'NOT NULL, ',
			'`Ano_Num`',              'TINYINT ',  'NOT NULL, ',
			'`AnoRef_Nome`',          'CHAR(4) ',  'NOT NULL, ', -- Número do ano em formato caractere de 2 dígitos
			'`DataAnoInicio`',        'DATE ',     'NOT NULL, ',
			'`DataAnoFim`',           'DATE ',     'NOT NULL, ',
			'`AnoFiscal`',            'SMALLINT ', 'NOT NULL, ',
            --
			-- Colunas SEMANA
			'`Semana_INDEX` ',        'SMALLINT ', 'NOT NULL, ',
			'`Semana_Offset` ',       'SMALLINT ', 'NOT NULL, ',
			'`SemanaRefMes_Nome` ',   'CHAR(2) ',  'NOT NULL, ', -- Número da Semana no Mês em formato caractere de 2 dígito
			'`SemanaDoMes_Num` ',     'TINYINT ',  'NOT NULL, ',
			'`SemanaDoMes_Abrev` ',   'CHAR(15) ', 'NOT NULL, ', -- [SemanaRefDoMes_Nome] & [Mes_Abrev], padrão dados: Sem-[nn]-mmm
			'`SemanaDoAno_Num` ',     'TINYINT ',  'NOT NULL, ',
			'`SemanaRefDoAno_Nome` ', 'CHAR(2) ',  'NOT NULL, ', -- Número da Semana no Ano em formato caractere de 2 dígitos
			'`SemanaDoAno_Abrev` ',   'CHAR(15) ', 'NOT NULL, ', -- [SemanaRefDoMes_Nome] & [AnoRef_Nome], padrão dados: Sem-[nn]-YYYY
			'`SemanaDoAno_Num` ',     'SMALLINT ', 'NOT NULL, ', -- [Ano_Num] & [SemanaDoAno_Num],         padrão dados: [YYYY][dd]
			'`SemanaDataInicio` ',    'DATE ',     'NOT NULL, ',
			'`SemanaDataFim` ',       'DATE ',     'NOT NULL, ',
			'`SemanaPeriodo` ',       'CHAR(23) ', 'NOT NULL, ', -- padrão dados: dd/mm/YYYY a dd/mm/YYYY
            --
			-- Colunas QUINZENA
			'`Quinzena_INDEX` ',      'SMALLINT ',    'NOT NULL, ',
			'`Quinzena_Offset` ',     'SMALLINT ',    'NOT NULL, ',
			'`QuinzenaRefMes_Nome` ', 'CHAR(1) ',     'NOT NULL, ', -- Número da Semana no Mês em formato caractere de 1 dígito
			'`QuinzenaDoMes_Num` ',   'TINYINT ',     'NOT NULL, ',
			'`QuinzenaDoMes_Abrev` ', 'CHAR(9) ',     'NOT NULL, ', -- [QuinzenaRefMes_Nome] & [Mes_Abrev], padrão dados: Qui [n]-mmm
			'`QuinzenaDoMes_Nome` ',  'VARCHAR(14) ', 'NOT NULL, ', -- [QuinzenaRefMes_Nome] & [Mes_Nome], padrão dados: Qui [n]-mmmm
			'`QuinzenaDataInicio` ',  'DATE ',        'NOT NULL, ',
			'`QuinzenaDataFim` ',     'DATE ',        'NOT NULL, ',
            --
			-- Colunas BIMESTRE
            -- [Ano_Num] & [SemanaDoAno_Num] & [QuinzenaDoMes_Num],padrão dados: [YYYY][mm][dd]
			'`Bimestre_INDEX` ',      'SMALLINT ', 'NOT NULL, ',
			'`Bimestre_Offset` ',     'SMALLINT ', 'NOT NULL, ',
			'`BimestreRefAno_Nome` ', 'CHAR(1) ',  'NOT NULL, ', -- Número do Bimestre no Ano em formato caractere de 1 dígito
			'`BimestreDoAno_Num` ',   'TINYINT ',  'NOT NULL, ', 
			'`BimestreDoAno_Nome`',   'CHAR(8) ',  'NOT NULL, ', -- [BimestreRefAno_Nome] & [Ano_Nome], padrão dados: B [n]-YYYY
			'`BimestreDataInicio` ',  'DATE ',     'NOT NULL, ',
			'`BimestreDataFim` ',     'DATE ',     'NOT NULL, ',
			'`BimestrePeriodo` ',     'CHAR(23) ', 'NOT NULL, ', -- padrão dados: dd/mm/YYYY a dd/mm/YYYY            
            --
			-- Colunas TRIMESTRE
			'`Trimestre_INDEX` ',      'SMALLINT ', 'NOT NULL, ',
			'`Trimestre_Offset` ',     'SMALLINT ', 'NOT NULL, ',
			'`TrimestreRefAno_Nome` ', 'CHAR(1) ',  'NOT NULL, ', -- Número do Trimestre no Ano em formato caractere de 1 dígito
			'`TrimestreDoAno_Num` ',   'TINYINT ',  'NOT NULL, ', 
			'`TrimestreDoAno_Nome`',   'CHAR(8) ',  'NOT NULL, ', -- [TrimestreRefAno_Nome] & [Ano_Nome], padrão dados: T [n]-YYYY
			'`TrimestreDataInicio` ',  'DATE ',     'NOT NULL, ',
			'`TrimestreDataFim` ',     'DATE ',     'NOT NULL, ',
			'`TrimestrePeriodo` ',     'CHAR(23) ', 'NOT NULL, ', -- padrão dados: dd/mm/YYYY a dd/mm/YYYY            
            --
			-- Colunas SEMESTRE
			'`Semestre_INDEX` ',      'SMALLINT ', 'NOT NULL, ',
			'`Semestre_Offset` ',     'SMALLINT ', 'NOT NULL, ',
			'`SemestreRefAno_Nome` ', 'CHAR(1) ',  'NOT NULL, ', -- Número do Semestre no Ano em formato caractere de 1 dígito
			'`SemestreDoAno_Num` ',   'TINYINT ',  'NOT NULL, ', 
			'`SemestreDoAno_Nome`',   'CHAR(8) ',  'NOT NULL, ', -- [SemestreRefAno_Nome] & [Ano_Nome], padrão dados: T [n]-YYYY
			'`SemestreDataInicio` ',  'DATE ',     'NOT NULL, ',
			'`SemestreDataFim` ',     'DATE ',     'NOT NULL, ',
			'`SemestrePeriodo` ',     'CHAR(23) ', 'NOT NULL, ', -- padrão dados: dd/mm/YYYY a dd/mm/YYYY            
			--
            -- Colunas FECHAMENTO
			'`MesFechamento_INDEX` ',    'SMALLINT ',   'NOT NULL, ',
			'`MesFechamento_Offset` ',   'SMALLINT ',   'NOT NULL, ',
			'`MesFechamentoRef_Nome` ',  'CHAR(2) ',    'NOT NULL, ', -- Número do Mês de Fechamento em formato caractere de 2 dígitos
			'`MesFechamento_Num` ',      'TINYINT ',    'NOT NULL, ',
			'`MesFechamento_Abrev` ',    'CHAR(3) ',    'NOT NULL, ',
			'`MesFechamento_Nome` ',     'VARCHAR(8) ', 'NOT NULL, ',
			'`AnoFechamentoRef_Nome` ',  'CHAR(4) ',    'NOT NULL, ',
			'`AnoFechamento_Num` ',      'SMALLINT ',   'NOT NULL, ',
			'`MesAnoFechamento_Num` ',   'MEDIUMINT ',  'NOT NULL, ', -- [AnoFechamento_Num] & [MesFechamentoRef_Nome], padrão dados: YYYYmm
			'`MesAnoFechamento_Abrev` ', 'CHAR(6) ',    'NOT NULL, ', -- [MesFechamento_Abrev] & [AnoFechamentoRef_Nome], padrão dados: mmm/YYYY
			--
            -- Colunas DIVERSAS
			'`EstacaoAnoNum`            TINYINT NOT NULL, ',
			'`EstacaoAnoNome`           CHAR(9) NOT NULL, '
		),
	'');
END

-- `NUM_INDEX`     INT AUTO_INCREMENT NOT NULL, 
-- `DataReferencia` DATE     NOT NULL, 
-- `DataRef_Nome`   CHAR(10) NOT NULL,
-- `Data_OffSet`    SMALLINT NOT NULL,
-- `Data_Futura`    BOOLEAN  NOT NULL,
-- -- Colunas DIA 
-- -- Observação: Não é necessário a coluna [Dia_INDEX], pois a coluna [NUM_INDEX] é similar
-- `Dia_Offset`       SMALLINT    NOT NULL,
-- `DiaMesRef_Nome`   CHAR(2)     NOT NULL, -- Número do Dia do Mês em formato caractere de 2 dígitos
-- `DiaMes_Num`       TINYINT     NOT NULL,
-- `DiaAno_Num`       SMALLINT    NOT NULL, -- Número do dia no Ano
-- `DiaSemanaAno_Num` SMALLINT    NOT NULL, 
-- `DiaSemana_Num`    TINYINT     NOT NULL,  -- Padrão: Segunda = 1 a Domingo = 7
-- `DiaSemana_Abrev`  CHAR(3)     NOT NULL,  -- Nome do dia abreviado
-- `DiaSemana_Nome`   VARCHAR(13) NOT NULL,  -- Nome do dia por extenso
-- `DiaSemana_Sigla`  CHAR(1)     NOT NULL, 
-- `DiaUtil_Num`      BOOLEAN     NOT NULL,  -- É dia útil
-- `DiaUtilMes_Acm`   TINYINT     NOT NULL,  -- Acumulado de dias úteis no Mês 
-- `DiaUtilAno_Acm`   TINYINT     NOT NULL,  -- Acumulado de dias úteis no Ano
-- `FeriadoNome`      VARCHAR(50) DEFAULT NULL,             
-- --
-- -- Colunas MES
-- `Mes_INDEX`      SMALLINT   NOT NULL, 
-- `Mes_Offset`     SMALLINT   NOT NULL, 
-- `Mes_Num`        TINYINT    NOT NULL, 
-- `MesRef_Nome`    CHAR(2)    NOT NULL,  -- Número do mês em formato caractere de 2 dígito
-- `Mes_Abrev`      CHAR(3)    NOT NULL,  -- Nome abreviado
-- `Mes_Nome`       VARCHAR(8) NOT NULL,  -- Nome por extenso
-- `Mes_Sigla`      CHAR(1)    NOT NULL,  -- Primeira letra
-- `MesDoAno_Num`   MEDIUMINT  NOT NULL,  -- [AnoRef_Nome] & [MesRef_Nome], padrão dados: [YYYY][mm]
-- `MesDoAno_Abrev` CHAR(6)    NOT NULL,  -- [Mes_Abrev] & [AnoRef_Nome],   padrão: mmm/YYYY
-- `MesDoAno_Nome`  CHAR(13)   NOT NULL,  -- [Mes_Nome] & [Ano_Num],        padrão: mmmm/YYYY
-- `MesDoDia_Num`   SMALLINT   NOT NULL,  -- [MesRef_Nome] & [DiaRef_Nome], padrão: [mm][dd]
-- `MesDoDia_Abrev` CHAR(6)    NOT NULL,  -- [Mes_Abrev] & [DiaRef_Nome],   padrão: [mmm]/[dd]
-- --
-- -- Colunas ANO
-- `Ano_INDEX`     TINYINT  NOT NULL, 
-- `Ano_OffSet`    TINYINT  NOT NULL, 
-- `Ano_Num`       TINYINT  NOT NULL, 
-- `AnoRef_Nome`   CHAR(4)  NOT NULL,  -- Número do ano em formato caractere de 2 dígitos
-- `DataAnoInicio` DATE     NOT NULL, 
-- `DataAnoFim`    DATE     NOT NULL, 
-- `AnoFiscal`     SMALLINT NOT NULL, 
-- --
-- -- Colunas SEMANA
-- `Semana_INDEX`        SMALLINT NOT NULL, 
-- `Semana_Offset`       SMALLINT NOT NULL, 
-- `SemanaRefMes_Nome`   CHAR(2)  NOT NULL,  -- Número da Semana no Mês em formato caractere de 2 dígito
-- `SemanaDoMes_Num`     TINYINT  NOT NULL, 
-- `SemanaDoMes_Abrev`   CHAR(15) NOT NULL,  -- [SemanaRefDoMes_Nome] & [Mes_Abrev], padrão dados: Sem-[nn]-mmm
-- `SemanaDoAno_Num`     TINYINT  NOT NULL, 
-- `SemanaRefDoAno_Nome` CHAR(2)  NOT NULL,  -- Número da Semana no Ano em formato caractere de 2 dígitos
-- `SemanaDoAno_Abrev`   CHAR(15) NOT NULL,  -- [SemanaRefDoMes_Nome] & [AnoRef_Nome], padrão dados: Sem-[nn]-YYYY
-- `SemanaDoAno_Num`     SMALLINT NOT NULL,  -- [Ano_Num] & [SemanaDoAno_Num],         padrão dados: [YYYY][dd]
-- `SemanaDataInicio`    DATE     NOT NULL, 
-- `SemanaDataFim`       DATE     NOT NULL, 
-- `SemanaPeriodo`       CHAR(23) NOT NULL,  -- padrão dados: dd/mm/YYYY a dd/mm/YYYY
-- --
-- -- Colunas QUINZENA
-- `Quinzena_INDEX`      SMALLINT    NOT NULL, 
-- `Quinzena_Offset`     SMALLINT    NOT NULL, 
-- `QuinzenaRefMes_Nome` CHAR(1)     NOT NULL,  -- Número da Semana no Mês em formato caractere de 1 dígito
-- `QuinzenaDoMes_Num`   TINYINT     NOT NULL, 
-- `QuinzenaDoMes_Abrev` CHAR(9)     NOT NULL,  -- [QuinzenaRefMes_Nome] & [Mes_Abrev], padrão dados: Qui [n]-mmm
-- `QuinzenaDoMes_Nome`  VARCHAR(14) NOT NULL,  -- [QuinzenaRefMes_Nome] & [Mes_Nome], padrão dados: Qui [n]-mmmm
-- `QuinzenaDataInicio`  DATE        NOT NULL, 
-- `QuinzenaDataFim`     DATE        NOT NULL, 
-- --
-- -- Colunas BIMESTRE
-- `Bimestre_INDEX`      SMALLINT NOT NULL, 
-- `Bimestre_Offset`     SMALLINT NOT NULL, 
-- `BimestreRefAno_Nome` CHAR(1)  NOT NULL,  -- Número do Bimestre no Ano em formato caractere de 1 dígito
-- `BimestreDoAno_Num`   TINYINT  NOT NULL,  
-- `BimestreDoAno_Nome`  CHAR(8)  NOT NULL,  -- [BimestreRefAno_Nome] & [Ano_Nome], padrão dados: B [n]-YYYY
-- `BimestreDataInicio`  DATE     NOT NULL, 
-- `BimestreDataFim`     DATE     NOT NULL, 
-- `BimestrePeriodo`     CHAR(23) NOT NULL,  -- padrão dados: dd/mm/YYYY a dd/mm/YYYY            
-- --
-- -- Colunas TRIMESTRE
-- `Trimestre_INDEX`      SMALLINT NOT NULL, 
-- `Trimestre_Offset`     SMALLINT NOT NULL, 
-- `TrimestreRefAno_Nome` CHAR(1)  NOT NULL,  -- Número do Trimestre no Ano em formato caractere de 1 dígito
-- `TrimestreDoAno_Num`   TINYINT  NOT NULL,  
-- `TrimestreDoAno_Nome`  CHAR(8)  NOT NULL,  -- [TrimestreRefAno_Nome] & [Ano_Nome], padrão dados: T [n]-YYYY
-- `TrimestreDataInicio`  DATE     NOT NULL, 
-- `TrimestreDataFim`     DATE     NOT NULL, 
-- `TrimestrePeriodo`     CHAR(23) NOT NULL,  -- padrão dados: dd/mm/YYYY a dd/mm/YYYY            
-- --
-- -- Colunas SEMESTRE
-- `Semestre_INDEX`      SMALLINT NOT NULL, 
-- `Semestre_Offset`     SMALLINT NOT NULL, 
-- `SemestreRefAno_Nome` CHAR(1)  NOT NULL,  -- Número do Semestre no Ano em formato caractere de 1 dígito
-- `SemestreDoAno_Num`   TINYINT  NOT NULL,  
-- `SemestreDoAno_Nome`  CHAR(8)  NOT NULL,  -- [SemestreRefAno_Nome] & [Ano_Nome], padrão dados: T [n]-YYYY
-- `SemestreDataInicio`  DATE     NOT NULL, 
-- `SemestreDataFim`     DATE     NOT NULL, 
-- `SemestrePeriodo`     CHAR(23) NOT NULL,  -- padrão dados: dd/mm/YYYY a dd/mm/YYYY            
-- --
-- -- Colunas FECHAMENTO
-- `MesFechamento_INDEX`    SMALLINT   NOT NULL, 
-- `MesFechamento_Offset`   SMALLINT   NOT NULL, 
-- `MesFechamentoRef_Nome`  CHAR(2)    NOT NULL,  -- Número do Mês de Fechamento em formato caractere de 2 dígitos
-- `MesFechamento_Num`      TINYINT    NOT NULL, 
-- `MesFechamento_Abrev`    CHAR(3)    NOT NULL, 
-- `MesFechamento_Nome`     VARCHAR(8) NOT NULL, 
-- `AnoFechamentoRef_Nome`  CHAR(4)    NOT NULL, 
-- `AnoFechamento_Num`      SMALLINT   NOT NULL, 
-- `MesAnoFechamento_Num`   MEDIUMINT  NOT NULL,  -- [AnoFechamento_Num] & [MesFechamentoRef_Nome], padrão dados: YYYYmm
-- `MesAnoFechamento_Abrev` CHAR(6)    NOT NULL,  -- [MesFechamento_Abrev] & [AnoFechamentoRef_Nome], padrão dados: mmm/YYYY
-- --
-- -- Colunas DIVERSAS
-- `EstacaoAnoNum`  TINYINT NOT NULL, 
-- `EstacaoAnoNome` CHAR(9) NOT NULL '