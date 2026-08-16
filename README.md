# Projeto 1: Avengers

**Fonte:** Five Thirty Eight
**Link do dataset:** https://github.com/fivethirtyeight/data/tree/master/avengers

## Sobre
Dados sobre membros dos Vingadores da Marvel, incluindo nome/alias, número de aparições, gênero, data de entrada na equipe, status atual e informações sobre mortes e retornos dos personagens.

## Como obter os dados
Baixe os CSVs diretamente do repositorio do Five Thirty Eight no GitHub:

https://github.com/fivethirtyeight/data/tree/master/avengers

(os arquivos .csv desta pasta ja foram baixados via raw.githubusercontent.com pelo script `baixar_dados.py`, quando disponivel)

## Como gerar o banco SQLite

Depois de ter o(s) CSV(s) nesta pasta, rode:

```bash
python gerar_banco.py
```

Isso cria o arquivo `avengers.db`, com uma tabela para cada CSV encontrado na pasta.

## Perguntas de negocio

Veja `perguntas.pdf` nesta pasta para a lista de perguntas de negocio a responder com SQL.
