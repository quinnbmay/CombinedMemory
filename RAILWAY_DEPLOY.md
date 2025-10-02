# LibreChat Railway Deployment Guide

## Overview
This setup runs LibreChat locally via Docker and can also be deployed to Railway, using the same Railway backend services (MongoDB, Meilisearch, RAG API, VectorDB).

## Architecture

### Local (Docker)
- LibreChat API container runs locally
- Connects to Railway services via TCP proxy and HTTPS

### Railway (Optional)
- Can deploy the same setup to Railway
- Uses Railway internal networking for faster connections

## Setup

### 1. Local Docker Setup

```bash
# Copy environment template
cp .env.example .env

# Edit .env with your API keys and Railway URLs
# MongoDB: ballast.proxy.rlwy.net:43047
# Meilisearch: https://meilisearch-production-63b9.up.railway.app
# RAG API: https://rag-api-production-6340.up.railway.app

# Start containers
docker-compose up -d

# View logs
docker-compose logs -f api
```

### 2. Railway Deployment

```bash
# Install Railway CLI
npm i -g @railway/cli

# Login to Railway
railway login

# Link to your project
railway link

# Set environment variables in Railway dashboard
# Use internal URLs for better performance:
# MONGO_URI=mongodb://mongo:PASSWORD@mongodb.railway.internal:27017/
# MEILI_HOST=http://meilisearch.railway.internal:7700
# RAG_API_URL=http://rag-api.railway.internal:8000

# Deploy
railway up
```

## Configuration Files

- **docker-compose.yml** - Base LibreChat setup (from upstream)
- **docker-compose.override.yml** - Railway service connections
- **librechat.yaml** - Custom LibreChat configuration
- **.env** - Local secrets (not in git)
- **.env.railway** - Railway environment template

## Railway Services

Current Railway project: **Librechat, Rag API + Mellisearch**
- MongoDB: `ballast.proxy.rlwy.net:43047` (TCP proxy)
- Meilisearch: `meilisearch-production-63b9.up.railway.app`
- RAG API: `rag-api-production-6340.up.railway.app`
- VectorDB: Internal to RAG API

## Notes

- **Local**: Uses TCP proxy for MongoDB (slower but works from anywhere)
- **Railway**: Can use internal URLs (faster, only works within Railway network)
- **Config**: librechat.yaml is synced across both environments
- **Data**: Both environments share the same MongoDB database
