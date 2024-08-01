-- Atividade 1)

---------------------------------------------------------------------------------------------------------------------------------------------
-- a) Insira >‘943775543’, ‘Roberto’, ‘F’, ‘Silva’, ‘M’, ‘Rua X, 22 – Araucária – PR’, ‘1952-06-21’, ‘888665555’, ‘1’, 58000< em EMPREGADO.
---------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO empregado 
VALUES ('943775543', 'Roberto', 'F', 'Silva', 'M', 'Rua X, 22 – Araucária – PR', '1952-06-21',
'888665555', '1', '58000.00');

-- sem erros 


---------------------------------------------------------------------------------------------------------------------------------------------
-- b) Insira >‘4’, ProdutoA’, ‘Araucaria’, ‘2’< em PROJETO.
---------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO projeto
VALUES ('4', 'ProdutoA', 'Araucaria', '2');

-- ERROR:  insert or update on table \"projeto\" violates foreign key constraint \"fk_projeto_departamento\"\nDETAIL: 
-- Key (dnum)=(2) is not present in table \"departamento\".\n
 
-- O departamento 2 não existe na tabela departamento. Isso viola a chave estrangeira.


---------------------------------------------------------------------------------------------------------------------------------------------
-- c) Insira >‘4’, ‘Produção’, ‘943775543’, ‘1998-10-01’< em DEPARTAMENTO.
---------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO departament
VALUES ('4', 'Produção', '943775543', '1998-10-01');

-- ERROR:  duplicate key value violates unique constraint \"departamento_pkey\"\nDETAIL:  
-- Key (dnumero)=(4) already exists.\n

-- A chave primaria de valor 4 já existe. Não podemos duplicar chaves primárias


---------------------------------------------------------------------------------------------------------------------------------------------
-- d) Insira >‘677678989’, null, 40,0< em TRABALHA.
---------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO trabalha
VALUES ('677678989', null, 40.0);

-- ERROR:  null value in column \"pno\" violates not-null constraint\nDETAIL:  Failing row contains (677678989, null, 40).\n

-- A coluna pno não pode conter nulos.


---------------------------------------------------------------------------------------------------------------------------------------------
-- e) Insira >‘453453453’, ‘Joao’, ‘M’, ‘1970-12-12’, ‘CONJUGE’< em DEPENDENTE.
---------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO dependente
VALUES ('453453453', 'Joao', 'M', '1970-12-12', 'CONJUGE');

-- sem erros.


---------------------------------------------------------------------------------------------------------------------------------------------
-- f) Remova as tuplas de TRABALHA com ESSN = ‘333445555’.
---------------------------------------------------------------------------------------------------------------------------------------------

DELETE FROM trabalha
WHERE essn = '333445555';

-- sem erros.


---------------------------------------------------------------------------------------------------------------------------------------------
-- g) Remova a tupla de EMPREGADO com SSN = ‘987654321’.
---------------------------------------------------------------------------------------------------------------------------------------------

DELETE FROM empregado
WHERE ssn = '987654321';

-- ERROR:  update or delete on table \"empregado\" violates foreign key constraint \"fk_empregado_empregado\" 
-- on table \"empregado\"\nDETAIL:  Key (ssn)=(987654321) is still referenced from table \"empregado\".\n

-- Não podemos excluir essa chave primária pois ela ainda é referenciada, como chave estrangeira na tabela dependente.


---------------------------------------------------------------------------------------------------------------------------------------------
-- h) Remova a tupla de PROJETO com PJNOME = ‘ProdutoX’
---------------------------------------------------------------------------------------------------------------------------------------------

DELETE FROM projeto
WHERE pjnome = 'ProdutoX';

-- ERROR:  update or delete on table \"projeto\" violates foreign key constraint \"fk_trabalha_projeto\" on table 
-- \"trabalha\"\nDETAIL:  Key (pnumero)=(1 ) is still referenced from table \"trabalha\".\n

-- Não podemos remover esse projeto pois ainda temos muitos empregados trabalhando nela, na tabela trabalha 
-- (ela é uma chave estrangeira).


---------------------------------------------------------------------------------------------------------------------------------------------
-- i) Modifique o GERSSN e GERDATAINICIO da tupla de DEPARTAMENTO com DNUMERO = 5 para ‘123456789’ e ‘1999-01-10’, respectivamente
---------------------------------------------------------------------------------------------------------------------------------------------

UPDATE departamento
SET gerssn = '123456789', gerdatainicio= '1999-01-10'
WHERE dnumero = '5';

-- sem erros.


---------------------------------------------------------------------------------------------------------------------------------------------
-- j) j) Modifique o atributo SUPERSSN da tupla EMPREGADO com SSN = ‘999887777’ para ‘943775543’.
---------------------------------------------------------------------------------------------------------------------------------------------

UPDATE empregado
SET superssn = '943775543'
WHERE ssn = '999887777';

-- sem erros.


---------------------------------------------------------------------------------------------------------------------------------------------
-- l) Modifique o atributo HORAS da tupla de TRABALHA com ESSN = ‘999887777’ e PNO = ‘10’ para 5,0.
---------------------------------------------------------------------------------------------------------------------------------------------

UPDATE trabalha
SET horas = 5.0
WHERE essn = '999887777' AND pno = '10';

-- sem erros.
