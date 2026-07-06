# homebrew-dc

Tap privado de dc-tools

## RAG System CLI

La Formula `rag-system-cli` depende de `python@3.12` y usa un virtualenv gestionado por Homebrew. No incluye Python ni binarios standalone dentro del tap.

Antes de instalar, publica el source distribution como asset del release:

```text
https://github.com/greenlsi/s3-rag/releases/download/v1.0.0/rag_system_cli-1.0.0.tar.gz
```

El SHA256 esperado por la Formula actual es:

```text
41b1c33f9abaabf2ee35cc17d588fc9caba42f7b82e1f23d983618a9f83bff28
```

Instalacion:

```bash
brew tap greenlsi/dc-tools git@github.com:greenlsi/homebrew-dc.git
brew install rag-system-cli
```

Actualizacion:

```bash
brew update
brew upgrade rag-system-cli
```

## Minions CLI

La Formula `minions` depende de `python@3.13` y `rust` (build-time, requerido para compilar `cryptography`/`pydantic-core` desde su sdist). Usa un virtualenv gestionado por Homebrew. No incluye Python ni binarios standalone dentro del tap.

Antes de instalar, publica el source distribution como asset del release:

```text
https://github.com/greenlsi/minions/releases/download/v0.1.0/minions-0.1.0.tar.gz
```

El SHA256 esperado por la Formula actual es:

```text
0f85a7930714eb1a5b2a1eca18f0192b2ad1a26265fe5c23212a2cd0319f101c
```

Instalacion:

```bash
brew tap greenlsi/dc-tools git@github.com:greenlsi/homebrew-dc.git
brew install minions
```

Actualizacion:

```bash
brew update
brew upgrade minions
```

