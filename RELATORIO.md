# Relatório de Análise: Avengers (Five Thirty Eight)

Análise exploratória em SQL sobre o dataset de membros dos Vingadores mantido pela [Five Thirty Eight](https://github.com/fivethirtyeight/data/tree/master/avengers). As consultas completas estão em [`analise.sql`](analise.sql) e podem ser reproduzidas contra `avengers.db` (gerado por `gerar_banco.py`).

## Nota metodológica

A coluna `Name/Alias` **não é uma chave única confiável**: 10 linhas têm o valor nulo e há colisões de nome entre personagens diferentes (ex.: "Vance Astrovik" identifica duas entidades distintas, com URLs e anos de introdução diferentes — 1978 e 1998). Usar `COUNT(DISTINCT "Name/Alias")` faz essas linhas desaparecerem ou se fundirem incorretamente nas contagens. Como não há duplicidade de `URL` na base, todas as contagens de heróis abaixo usam `COUNT(*)`, tratando cada linha como um registro válido.

## 1. Quantidade total de heróis

**173 heróis** no dataset.

## 2. Distribuição de gênero

| Gênero | Qtd. heróis |
|---|---|
| MALE | 115 |
| FEMALE | 58 |

Personagens masculinos são quase o dobro dos femininos (~66% vs ~34%).

## 3. Média de aparições

- Geral: **414,05** aparições por personagem.
- Por gênero:

| Gênero | Média de aparições |
|---|---|
| MALE | 490,07 |
| FEMALE | 263,33 |

Além de serem minoria, as personagens femininas aparecem em média **quase metade** das vezes que os personagens masculinos.

## 4. Qualidade dos dados: coluna `Year`

O intervalo bruto de `Year` vai de **1900 a 2015** — inconsistente, já que a Marvel foi fundada em **1939**. Há **14 linhas** com `Year < 1939`, tratadas como erro de cadastro e excluídas das análises temporais a seguir.

## 5. Adesão acumulada ao grupo (a partir de 1939)

Após o filtro, a base ativa passa a ter **159 heróis** com ano válido. A entrada de novos membros não é constante: há picos concentrados em anos específicos — **2013 (+24)**, **2005 e 2010 (+16 cada)** — coincidindo com períodos de expansão do universo Marvel (filmes/eventos editoriais), contra um ritmo de 1 a 5 admissões/ano na maior parte do histórico.

## 6. Distribuição de gênero por década

| Década | % Feminino | % Masculino |
|---|---|---|
| 1960 | 13,33% | 86,67% |
| 1970 | 35,29% | 64,71% |
| 1980 | 40,74% | 59,26% |
| 1990 | 47,06% | 52,94% |
| 2000+ | 28,92% | 71,08% |

A participação feminina cresce de forma consistente entre 1960 e 1990 (de 13% para quase 47%, quase atingindo paridade), mas **recua para ~29% na década de 2000+**, revertendo parte do avanço anterior.

## 7. Personagens honorários por gênero

| Status | % dentro do gênero Feminino | % dentro do gênero Masculino |
|---|---|---|
| Full | 74,14% | 82,61% |
| Academy | 15,52% | 6,96% |
| Honorary | 10,34% | 8,70% |
| Probationary | — | 1,74% |

Mulheres têm proporcionalmente **menos participação "Full"** (74% vs 83%) e mais que o **dobro de participação via "Academy"** (15,5% vs 7%) que os homens — indício de que personagens femininas entram mais por programas de formação/treinamento do que como membros plenos diretos.

## 8. Mortes e retornos por gênero

| Gênero | Mortes | % do gênero que já morreu | Retornaram | % de retorno entre os que morreram |
|---|---|---|---|---|
| FEMALE | 21 | 36,21% | 16 | 76,19% |
| MALE | 48 | 41,74% | 30 | 62,50% |

Personagens masculinos morrem proporcionalmente mais (41,7% vs 36,2%), mas as personagens femininas que morrem **voltam à vida com mais frequência** (76% vs 62,5%) — a "morte" é ainda menos permanente para elas.

## 9. Aparições vs. gênero e morte

| Gênero | Já morreu | Média de aparições |
|---|---|---|
| MALE | YES | 701,52 |
| MALE | NO | 338,58 |
| FEMALE | YES | 334,24 |
| FEMALE | NO | 223,08 |

Em ambos os gêneros, quem já morreu tem uma média de aparições bem maior — coerente com a ideia de que personagens mais relevantes/populares (mais aparições) acumulam mais arcos de morte-e-retorno ao longo do tempo. O padrão se mantém entre gêneros: até os homens "mortos" mais aparecem, os femininos mortos aparecem menos que os homens vivos.

## Principais conclusões

1. Personagens masculinos dominam numericamente (2:1) e em aparições (quase 2x a média).
2. A representatividade feminina cresceu de forma constante até 1990, mas regrediu na década de 2000 em diante.
3. Mulheres entram no grupo mais via programas honorários/acadêmicos do que como membros plenos.
4. A "morte" nos quadrinhos é pouco permanente para todos, mas especialmente para personagens femininas.
