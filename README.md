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

