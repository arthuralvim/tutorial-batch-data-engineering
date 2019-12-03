# tutorial-batch-data-engineering

[![Python Version](https://img.shields.io/badge/python-3.7.0-green.svg)](https://img.shields.io/badge/python-3.7.0-green.svg)
[![Coverage Status](https://coveralls.io/repos/github/arthuralvim/tutorial-batch-data-engineering/badge.svg?branch=master)](https://coveralls.io/github/arthuralvim/tutorial-batch-data-engineering?branch=master)


## DESENVOLVIMENTO

```bash
$ pre-commit install
```

```bash
$ pipenv install --dev
```


## BASE DE DADOS

CRIAR BALDE NO S3

https://brasil.io/dataset/gastos-deputados/cota_parlamentar

## AWS ECR

## AWS BATCH

## AWS ATHENA

https://docs.aws.amazon.com/athena/latest/ug/select.html
https://docs.aws.amazon.com/athena/latest/ug/data-types.html

```sql
CREATE EXTERNAL TABLE IF NOT EXISTS dados_brasil.deputados_cota_parlamentar (
  `codlegislatura` int,
  `datemissao` timestamp,
  `idedocumento` int,
  `idecadastro` int,
  `indtipodocumento` int,
  `nucarteiraparlamentar` int,
  `nudeputadoid` int,
  `nulegislatura` int,
  `numano` int,
  `numespecificacaosubcota` int,
  `numlote` int,
  `nummes` int,
  `numparcela` int,
  `numressarcimento` int,
  `numsubcota` int,
  `sgpartido` string,
  `sguf` string,
  `txnomeparlamentar` string,
  `txtcnpjcpf` string,
  `txtdescricao` string,
  `txtdescricaoespecificacao` string,
  `txtfornecedor` string,
  `txtnumero` string,
  `txtpassageiro` string,
  `txttrecho` string,
  `vlrdocumento` float,
  `vlrglosa` float,
  `vlrliquido` float,
  `vlrrestituicao` float
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES (
  'serialization.format' = ',',
  'field.delim' = ','
) LOCATION 's3://tutorial-batch-data-engineering/cota-parlamentar/'
TBLPROPERTIES ('has_encrypted_data'='false');
```

https://aws.amazon.com/blogs/big-data/top-10-performance-tuning-tips-for-amazon-athena/

```sql
SELECT * FROM "dados_brasil"."deputados_cota_parlamentar" limit 10;
```

```sql
SELECT COUNT(*) FROM "dados_brasil"."deputados_cota_parlamentar";
```

```sql
SELECT txnomeparlamentar, COUNT(*) count FROM "dados_brasil"."deputados_cota_parlamentar" GROUP BY txnomeparlamentar ORDER BY count DESC limit 10;
```

```sql
SELECT txnomeparlamentar, sgpartido, sguf, SUM(vlrliquido) vlrtotal FROM "dados_brasil"."deputados_cota_parlamentar" GROUP BY txnomeparlamentar, sgpartido, sguf ORDER BY txnomeparlamentar DESC limit 10;
```


1 (Run time: 2.36 seconds, Data scanned: 713.04 MB)
3.697.967

2 (Run time: 2.21 seconds, Data scanned: 99.33 MB)
3.697.983


16 linhas de diferença. 8 arquivos.
