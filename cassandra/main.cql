-- Criando o keyspace
CREATE KEYSPACE filmes_e_bandas_keyspace WITH replication = {'class': 'SimpleStrategy', 'replication_factor' : 1};

-- Usando o keyspace criado
USE filmes_e_bandas_keyspace;

-- Criando a tabela 'filmes'
CREATE TABLE filmes (
    id UUID PRIMARY KEY,
    titulo TEXT,
    ano INT,
    genero SET<TEXT>,
    elenco LIST<TEXT>,
    avaliacao MAP<TEXT, DECIMAL>,
    info_complementar TUPLE<TEXT, TEXT>
);

-- Criando a tabela 'bandas'
CREATE TABLE bandas (
    id UUID PRIMARY KEY,
    nome TEXT,
    pais_origem TEXT,
    membros LIST<TEXT>,
    estilos SET<TEXT>,
    albuns MAP<TEXT, INT>,
    dados_complementares TUPLE<TEXT, INT>
);

-- UUIDs gerados aleatoriamente
-- UUID para 'Inception'
INSERT INTO filmes (id, titulo, ano, genero, elenco, avaliacao, info_complementar)
VALUES (uuid(), 'Inception', 2010, {'Ação', 'Ficção Científica'}, ['Leonardo DiCaprio', 'Joseph Gordon-Levitt'], {'IMDb': 8.8, 'Rotten Tomatoes': 87.5}, ('Christopher Nolan', 'Warner Bros'));

-- UUID para 'Pulp Fiction'
INSERT INTO filmes (id, titulo, ano, genero, elenco, avaliacao, info_complementar)
VALUES (uuid(), 'Pulp Fiction', 1994, {'Crime', 'Drama'}, ['John Travolta', 'Samuel L. Jackson'], {'IMDb': 8.9, 'Rotten Tomatoes': 92.0}, ('Quentin Tarantino', 'Miramax'));

-- UUID para 'AC/DC'
INSERT INTO bandas (id, nome, pais_origem, membros, estilos, albuns, dados_complementares)
VALUES (uuid(), 'AC/DC', 'Austrália', ['Angus Young', 'Malcolm Young', 'Phil Rudd', 'Cliff Williams'], {'Rock', 'Hard Rock'}, {'High Voltage': 1975, 'Back in Black': 1980}, ('Columbia Records', 4));

-- Inserindo outras linhas na tabela 'filmes'
INSERT INTO filmes (id, titulo, ano, genero, elenco, avaliacao, info_complementar)
VALUES (uuid(), 'The Matrix', 1999, {'Ação', 'Ficção Científica'}, ['Keanu Reeves', 'Laurence Fishburne'], {'IMDb': 8.7, 'Rotten Tomatoes': 88.0}, ('Lana Wachowski', 'Warner Bros'));

INSERT INTO filmes (id, titulo, ano, genero, elenco, avaliacao, info_complementar)
VALUES (uuid(), 'The Godfather', 1972, {'Crime', 'Drama'}, ['Marlon Brando', 'Al Pacino'], {'IMDb': 9.2, 'Rotten Tomatoes': 98.0}, ('Francis Ford Coppola', 'Paramount Pictures'));

INSERT INTO filmes (id, titulo, ano, genero, elenco, avaliacao, info_complementar)
VALUES (uuid(), 'Fight Club', 1999, {'Drama', 'Suspense'}, ['Brad Pitt', 'Edward Norton'], {'IMDb': 8.8, 'Rotten Tomatoes': 79.0}, ('David Fincher', '20th Century Fox'));

-- Inserindo outras linhas na tabela 'bandas'
INSERT INTO bandas (id, nome, pais_origem, membros, estilos, albuns, dados_complementares)
VALUES (uuid(), 'The Beatles', 'Reino Unido', ['John Lennon', 'Paul McCartney', 'George Harrison', 'Ringo Starr'], {'Rock', 'Pop'}, {'Abbey Road': 1969, 'Let It Be': 1970}, ('EMI', 4));

INSERT INTO bandas (id, nome, pais_origem, membros, estilos, albuns, dados_complementares)
VALUES (uuid(), 'Led Zeppelin', 'Reino Unido', ['Robert Plant', 'Jimmy Page', 'John Paul Jones', 'John Bonham'], {'Rock', 'Hard Rock'}, {'Led Zeppelin IV': 1971, 'Physical Graffiti': 1975}, ('Atlantic Records', 4));

INSERT INTO bandas (id, nome, pais_origem, membros, estilos, albuns, dados_complementares)
VALUES (uuid(), 'Pink Floyd', 'Reino Unido', ['Roger Waters', 'David Gilmour', 'Nick Mason', 'Richard Wright'], {'Rock', 'Progressive Rock'}, {'The Dark Side of the Moon': 1973, 'The Wall': 1979}, ('Harvest Records', 4));

INSERT INTO bandas (id, nome, pais_origem, membros, estilos, albuns, dados_complementares)
VALUES (uuid(), 'Nirvana', 'EUA', ['Kurt Cobain', 'Krist Novoselic', 'Dave Grohl'], {'Grunge', 'Rock'}, {'Nevermind': 1991, 'In Utero': 1993}, ('DGC Records', 3));

-- Declarações de atualização
UPDATE filmes SET elenco = elenco + ['Tom Hardy'] WHERE id = 7b69cbea-ef8b-4e0a-9620-1bbfd7553845;
UPDATE bandas SET membros = membros + ['Brian Johnson'] WHERE id = 342d0db4-fd4e-451a-9d5e-2e8db4e99f47;
UPDATE filmes SET genero = genero - {'Drama'} WHERE id = fa2b8f29-dce1-4872-9852-2442ec34f48d;

-- Operações primitivas em colunas de coleções
-- Adicionar e remover em listas, conjuntos e mapas

-- Lista (elenco)
UPDATE filmes SET elenco = elenco + ['Elliot Page'] WHERE id = 7b69cbea-ef8b-4e0a-9620-1bbfd7553845;
UPDATE filmes SET elenco = elenco - ['Elliot Page'] WHERE id = 7b69cbea-ef8b-4e0a-9620-1bbfd7553845;

-- Conjunto (genero)
UPDATE filmes SET genero = genero + {'Suspense'} WHERE id = 7b69cbea-ef8b-4e0a-9620-1bbfd7553845;
UPDATE filmes SET genero = genero - {'Ação'} WHERE id = 7b69cbea-ef8b-4e0a-9620-1bbfd7553845;

-- Mapa (avaliacao)
UPDATE filmes SET avaliacao['Metacritic'] = 75.0 WHERE id = 7b69cbea-ef8b-4e0a-9620-1bbfd7553845;
UPDATE filmes SET avaliacao = avaliacao + {'Audience Score': 90.0} WHERE id = 7b69cbea-ef8b-4e0a-9620-1bbfd7553845;
DELETE avaliacao['Audience Score'] FROM filmes WHERE id = 7b69cbea-ef8b-4e0a-9620-1bbfd7553845;

-- Instruções SELECT
-- SELECT com WHERE e ORDER BY
SELECT titulo, ano FROM filmes WHERE ano > 1990 ORDER BY ano DESC;

-- SELECT com ALLOW FILTERING
SELECT * FROM bandas WHERE estilos CONTAINS 'Rock' ALLOW FILTERING;

-- Criar um índice secundário
CREATE INDEX ON filmes(genero);
