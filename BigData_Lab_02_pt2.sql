-----------------
-- Atividade 2 --
-----------------

---------------------------------------------------------------------------------------------------------------------------------------------
-- Atividade 3) Funções agregadas e nativas
---------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------
-- a) Recupere a média salarial de todos os empregados do sexo feminino.
---------------------------------------------------------------------------------------------------------------------------------------------

select avg(e.salario)
from empregado as e 
where e.sexo = 'F';


---------------------------------------------------------------------------------------------------------------------------------------------
-- b) Mostre o número de empregados por supervisor
---------------------------------------------------------------------------------------------------------------------------------------------

select e.superssn, count(e.ssn)
from empregado as e 
group by e.superssn
having e.superssn notnull;


---------------------------------------------------------------------------------------------------------------------------------------------
-- c) Mostre o maior número de horas envolvido em projetos
---------------------------------------------------------------------------------------------------------------------------------------------

select max(t.horas)
from trabalha as t;


---------------------------------------------------------------------------------------------------------------------------------------------
-- d) Para cada projeto, liste o nome do projeto e o total de horas por semana (de todos os empregados) gastas no projeto.
---------------------------------------------------------------------------------------------------------------------------------------------

select 
    p.pjnome,
    sum(t.horas) as Total_Horas
from 
    projeto p
join 
    trabalha t on p.pnumero = t.pno
group by 
    p.pjnome;

   
---------------------------------------------------------------------------------------------------------------------------------------------
-- e) Para cada departamento, recupere o nome do departamento e a média salarial de todos os empregados que trabalham nesse departamento.
---------------------------------------------------------------------------------------------------------------------------------------------
   
select 
    d.dnome as nome_departamento,
    avg(e.salario) as media_salarial
from 
    departamento d
join 
    empregado e on d.dnumero = e.dno
group by 
    d.dnome;

   
---------------------------------------------------------------------------------------------------------------------------------------------
-- f) Liste os nomes de todos os empregados com dois ou mais dependentes
---------------------------------------------------------------------------------------------------------------------------------------------
  
select 
    e.pnome as primeiro_nome,
    e.unome as ultimo_nome
from 
    empregado e
join 
    dependente d on e.ssn = d.essn
group by 
    e.pnome, e.unome
having 
    count(d.nomedep) >= 2;


---------------------------------------------------------------------------------------------------------------------------------------------
-- g) Nome do departamento com o menor número de projetos associados
---------------------------------------------------------------------------------------------------------------------------------------------  
   
select 
    d.dnome as nome_departamento
from 
    departamento d
join 
    projeto p on d.dnumero = p.dnum
group by 
    d.dnome
order by 
    count(p.pnumero) asc
limit 1;


---------------------------------------------------------------------------------------------------------------------------------------------
-- h) Consulta que retorne do 10º ao 22º caractere do endereço do empregado
---------------------------------------------------------------------------------------------------------------------------------------------

select 
    substring(endereco from 10 for 13) as endereco_parcial
from 
    empregado;

   
---------------------------------------------------------------------------------------------------------------------------------------------
-- i) Consulta que retorne apenas o mês de nascimento de cada funcionário
---------------------------------------------------------------------------------------------------------------------------------------------  
   
select 
    extract(month from datanasc) as mes_nascimento
from 
    empregado;


---------------------------------------------------------------------------------------------------------------------------------------------
-- j) Idade do empregado quando o dependente de parentesco filho ou filha nasceu
---------------------------------------------------------------------------------------------------------------------------------------------  

 select 
    e.pnome as primeiro_nome,
    e.unome as ultimo_nome,
    extract(year from (d.datanascdep - e.datanasc)) as idade_quando_filho_nasceu
from 
    empregado e
join 
    dependente d on e.ssn = d.essn
where 
    d.parentesco in ('FILHO', 'FILHA');


---------------------------------------------------------------------------------------------------------------------------------------------
-- k) Consulta que conte o número de dependentes por ano de nascimento
---------------------------------------------------------------------------------------------------------------------------------------------  

select 
    extract(year from datanascdep) as ano_nascimento,
    count(*) as numero_dependentes
from 
    dependente
group by 
    extract(year from datanascdep)
order by 
    ano_nascimento;


---------------------------------------------------------------------------------------------------------------------------------------------
-- l) Nome de supervisores que tenham 2 ou mais supervisionados	
---------------------------------------------------------------------------------------------------------------------------------------------

select 
    e.pnome as primeiro_nome,
    e.unome as ultimo_nome
from 
    empregado e
join 
    empregado sup on e.ssn = sup.superssn
group by 
    e.pnome, e.unome
having 
    count(sup.ssn) >= 2;


---------------------------------------------------------------------------------------------------------------------------------------------
-- m) Valor mensal a ser pago por projeto
---------------------------------------------------------------------------------------------------------------------------------------------  

select 
    p.pjnome as nome_projeto,
    sum(e.salario * t.horas / 160) as valor_mensal_pago
from 
    projeto p
join 
    trabalha t on p.pnumero = t.pno
join 
    empregado e on t.essn = e.ssn
group by 
    p.pjnome;



---------------------------------------------------------------------------------------------------------------------------------------------
-- Atividade 4) – Subconsultas
---------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- a) Recupere nome (pnome e unome) de cada um dos empregados que tenham um dependente cujo primeiro nome e sexo sejam o mesmo do empregado em questão.
-------------------------------------------------------------------------------------------------------------------------------------------------------

select 
    e.pnome, e.unome
from 
    empregado e
where 
    exists (
        select 
            1
        from 
            dependente d
        where 
            d.essn = e.ssn
            and d.nomedep = e.pnome
            and d.sexodep = e.sexo
    );


-------------------------------------------------------------------------------------------------------------------------------------------------------
-- b) Recupere os nomes dos empregados (pnome e unome) cujos salários são maiores que a média dos salários dos empregados do departamento 5.
-------------------------------------------------------------------------------------------------------------------------------------------------------

select 
    e.pnome, e.unome
from 
    empregado e
where 
    e.salario > (
        select 
            avg(e2.salario)
        from 
            empregado e2
        where 
            e2.dno = '5'
    );
   
   

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- c) Retorne o número do seguro social (SSN) de todos os empregados que trabalham com a mesma combinação (projeto, horas) em algum dos projetos em que o empregado ‘Fabio Will’ (SSN= 333445555) trabalhe.
-------------------------------------------------------------------------------------------------------------------------------------------------------
   
select 
    t2.essn
from 
    trabalha t2
where 
    exists (
        select 
            1
        from 
            trabalha t1
        where 
            t1.essn = '333445555'
            and t1.pno = t2.pno
            and t1.horas = t2.horas
            and t2.essn <> '333445555'
    );
   


-------------------------------------------------------------------------------------------------------------------------------------------------------
-- d) Recupere os nomes de todos os empregados que não trabalham em nenhum projeto.
-------------------------------------------------------------------------------------------------------------------------------------------------------
   
select 
    e.pnome, e.unome
from 
    empregado e
where 
    not exists (
        select 
            1
        from 
            trabalha t
        where 
            t.essn = e.ssn
    );
   


-------------------------------------------------------------------------------------------------------------------------------------------------------
-- e) Recupere o nome de empregados que não tenham dependentes.
-------------------------------------------------------------------------------------------------------------------------------------------------------
   
select 
    e.pnome, e.unome
from 
    empregado e
where 
    not exists (
        select 
            1
        from 
            dependente d
        where 
            d.essn = e.ssn
    );
   


-------------------------------------------------------------------------------------------------------------------------------------------------------
-- f) Liste o último nome de todos os gerentes de departamento que não tenham dependentes.
-------------------------------------------------------------------------------------------------------------------------------------------------------
   
select 
    e.unome
from 
    empregado e
where 
    exists (
        select 
            1
        from 
            departamento d
        where 
            d.gerssn = e.ssn
    )
    and not exists (
        select 
            1
        from 
            dependente dep
        where 
            dep.essn = e.ssn
    );
   


-------------------------------------------------------------------------------------------------------------------------------------------------------
-- g) Liste os nomes dos gerentes que tenham, pelo menos, um dependente.
-------------------------------------------------------------------------------------------------------------------------------------------------------
   
select 
    e.pnome, e.unome
from 
    empregado e
where 
    exists (
        select 
            1
        from 
            departamento d
        where 
            d.gerssn = e.ssn
    )
    and exists (
        select 
            1
        from 
            dependente dep
        where 
            dep.essn = e.ssn
    );
   

---------------------------------------------------------------------------------------------------------------------------------------------
-- Atividade 5) – Íncices
---------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------
-- a) Crie a tabela tempEmpregado contendo dos dados dos atributos ssn, pnome, sexo, endereco e datanasc da tabela empregado. Realizar a cópia dos dados durante o processo de criação da nova tabela.
---------------------------------------------------------------------------------------------------------------------------------------------

create table tempempregado as
select 
    ssn, pnome, sexo, endereco, datanasc
from 
    empregado;



---------------------------------------------------------------------------------------------------------------------------------------------
-- b) Utilize o comando EXPLAIN ANALYSE e anote o tempo de execução da consulta SELECT * FROM TEMPEMPREGADO.
---------------------------------------------------------------------------------------------------------------------------------------------

explain analyse
select * from tempempregado;



---------------------------------------------------------------------------------------------------------------------------------------------
-- c) Crie um índice com o campo ssn que não permite dados duplicados para a tabela tempEmpregado, utilizando o algoritmo de ordenação BTREE.
---------------------------------------------------------------------------------------------------------------------------------------------

create unique index idx_ssn_tempempregado on tempempregado using btree (ssn);


---------------------------------------------------------------------------------------------------------------------------------------------
-- d) Crie um índice com o campo pnome para a tabela tempEmpregado, em ordem decrescente e que utilize o algoritmo de ordenação HASH.
---------------------------------------------------------------------------------------------------------------------------------------------

create index idx_pnome_tempempregado on tempempregado using hash (pnome);


---------------------------------------------------------------------------------------------------------------------------------------------
-- e) Utilize o comando EXPLAIN ANALYSE, anote e compare com o tempo de execução da consulta SELECT * FROM TEMPEMPREGADO. O que achou do resultado?
---------------------------------------------------------------------------------------------------------------------------------------------

explain analyse
select * from tempempregado;


-- O tempo de planning é maior com os índices, mas o tempo de execução é menor. Nesse caso, como são poucos dados, o impacto não é tão significativo.

---------------------------------------------------------------------------------------------------------------------------------------------
-- f) Remova os índices criados nos itens c e d.
---------------------------------------------------------------------------------------------------------------------------------------------

drop index if exists idx_ssn_tempempregado;
drop index if exists idx_pnome_tempempregado;


---------------------------------------------------------------------------------------------------------------------------------------------
-- g) Remova a tabela temporária criada no item a.
---------------------------------------------------------------------------------------------------------------------------------------------

drop table if exists tempempregado;


---------------------------------------------------------------------------------------------------------------------------------------------
-- Atividade 6) Visões
---------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------
-- a) Crie a visão chamada TRABALHA_EM que deverá conter os campos pnome e unome da tabela empregado, o campo pjnome da tabela projeto e o campo horas da tabela trabalha.
---------------------------------------------------------------------------------------------------------------------------------------------

create view trabalha_em as
select 
    e.pnome, e.unome, p.pjnome, t.horas
from 
    empregado e
join 
    trabalha t on e.ssn = t.essn
join 
    projeto p on t.pno = p.pnumero;


---------------------------------------------------------------------------------------------------------------------------------------------
-- b) Crie uma consulta SQL na visão implementada no item a que retorne o último e o primeiro nome de todos os empregados que trabalham no ‘ProdutoX’.
---------------------------------------------------------------------------------------------------------------------------------------------

select 
    unome, pnome
from 
    trabalha_em
where 
    pjnome = 'ProdutoX';


---------------------------------------------------------------------------------------------------------------------------------------------
-- c) Exclua a visão criada no item a.
---------------------------------------------------------------------------------------------------------------------------------------------

drop view if exists trabalha_em;


---------------------------------------------------------------------------------------------------------------------------------------------
-- d) Crie uma visão chamada DEPTO_INFO que deverá conter os campos dnome da tabela departamento, e o total de empregados e somatório dos salários dos empregados da tabela empregado por departamento.
---------------------------------------------------------------------------------------------------------------------------------------------

create view depto_info as
select 
    d.dnome,
    count(e.ssn) as total_empregados,
    sum(e.salario) as soma_salarios
from 
    departamento d
join 
    empregado e on d.dnumero = e.dno
group by 
    d.dnome;


---------------------------------------------------------------------------------------------------------------------------------------------
-- e) Crie uma consulta SQL na visão implementada no item d que retorne a lista de informações por departamentos ordenados pelo somatório dos salários.
---------------------------------------------------------------------------------------------------------------------------------------------

select 
    dnome, total_empregados, soma_salarios
from 
    depto_info
order by 
    soma_salarios desc;


---------------------------------------------------------------------------------------------------------------------------------------------
-- f) Exclua as visões criadas nos itens a.
---------------------------------------------------------------------------------------------------------------------------------------------

drop view if exists depto_info;

