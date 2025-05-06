CREATE DATABASE Mecanica

GO
USE Mecanica

CREATE TABLE Cliente (
id int NOT NULL IDENTITY(3401,15),
nome varchar(100) NOT NULL,
logradouro varchar(200) NOT NULL,
numero int NOT NULL CHECK(numero >= 0),
cep char(8) NOT NULL CHECK(LEN(cep) = 8),
complemento varchar(255) NOT NULL
PRIMARY KEY(id)
)

CREATE TABLE TelefoneCliente (
clienteId int NOT NULL,
telefone varchar(11) NOT NULL CHECK(telefone = 10 OR telefone = 11) 
PRIMARY KEY(clienteId, telefone)
FOREIGN KEY(clienteId) REFERENCES Cliente(id)
)

CREATE TABLE Veiculo (
placa char(7) NOT NULL CHECK(placa = 7),
marca varchar(30) NOT NULL,
modelo varchar(30) NOT NULL,
cor varchar(15) NOT NULL,
anoFabricacao int NOT NULL CHECK(anoFabricacao > 1997),
anoModelo int NOT NULL,
dataAquisicao date NOT NULL,
clienteId int NOT NULL
PRIMARY KEY(placa)
FOREIGN KEY(clienteId) REFERENCES Cliente(id)
CONSTRAINT chkModeloFabricacao
CHECK ((anoModelo > 1997 AND anoModelo = anoFabricacao) OR (anoModelo > 1997 AND anoModelo - anoFabricacao = 1))
)

CREATE TABLE Peca (
id int NOT NULL IDENTITY(3411,7),
nome varchar(30) NOT NULL UNIQUE,
preco decimal(4,2) NOT NULL CHECK(preco >= 0.0),
estoque int NOT NULL CHECK(estoque >= 10)
PRIMARY KEY(id)
)

CREATE TABLE Categoria (
id int NOT NULL IDENTITY(1,1),
categoria varchar(10) NOT NULL,
valorHora decimal(4,2) NOT NULL
PRIMARY KEY(id)
CONSTRAINT chkCategoriaValorHora
CHECK(categoria = 'Estagiário' AND valorHora > 15.00 OR
	  categoria = 'Nível 1' AND valorHora > 25.00 OR 
	  categoria = 'Nível 2' AND valorHora > 35.00 OR
	  categoria = 'Nível 3' AND valorHora > 50.00)
)

CREATE TABLE Funcionario (
id int NOT NULL IDENTITY(101,1),
nome varchar(100) NOT NULL,
logradouro varchar(200) NOT NULL,
numero int NOT NULL CHECK(numero >= 0),
telefone char(11) NOT NULL CHECK(telefone = 10 OR telefone = 11),
categoriaHabilitacao varchar(2) NOT NULL CHECK(
UPPER(categoriaHabilitacao) = 'A' OR 
UPPER(categoriaHabilitacao) = 'B' OR 
UPPER(categoriaHabilitacao) = 'C' OR 
UPPER(categoriaHabilitacao) = 'D' OR
UPPER(categoriaHabilitacao) = 'E'),
categoriaId int NOT NULL
PRIMARY KEY(id)
FOREIGN KEY(categoriaId) REFERENCES Categoria(id)
)

CREATE TABLE Reparo (
veiculoPlaca char(7) NOT NULL,
funcionarioId int NOT NULL,
pecaId int NOT NULL,
data_ date DEFAULT GETDATE(),
custoTotal decimal(4,2) NOT NULL CHECK(custoTotal >= 0),
tempo int NOT NULL CHECK(tempo >= 0)
PRIMARY KEY(veiculoPlaca, funcionarioId, pecaId, data_)
FOREIGN KEY(veiculoPlaca) REFERENCES Veiculo(placa),
FOREIGN KEY(funcionarioId) REFERENCES Funcionario(id),
FOREIGN KEY(pecaId) REFERENCES Peca(id)
)