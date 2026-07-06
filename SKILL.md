---
name: insigoo-sag
version: 1.0.0
description: 语义增强检索引擎 —— 一键部署 PostgreSQL/pgvector 向量数据库，Agent 可通过 MCP 协议语义搜索知识库。适用于已有本地文件知识的组织。
author: insigoo (因思阁)
license: MIT
tags: [search, vector, pgvector, mcp, knowledge-base, rag]
---

# insigoo SAG — 语义增强检索引擎

> 给你的 Agent 装上搜索引擎。不再靠文件名猜测，用自然语言直接找到你要的知识。

---

## 是什么

SAG (Semantic Augmented Gateway) 是一个基于 PostgreSQL + pgvector 的语义检索引擎。

你问 Agent "上次净滩活动的预算表在哪？"——Agent 不搜文件名，而是**搜内容语义**，从 120 份文档里精准定位到"2025年净滩项目预算执行.md"。

---

## 与 insigoo-memory 的关系

| | insigoo-memory | insigoo-sag |
|------|:---:|:---:|
| **用途** | 文件分类·诊断·看板 | 语义搜索·向量检索 |
| **什么时候用** | 文件刚进来，需要归档 | 想找某个内容但不知道文件名 |
| **安装** | `pip install` | `docker-compose up` |
| **依赖** | 零依赖 | Docker + PostgreSQL |

**建议搭配使用**：memory 管前端（分类+看板），SAG 管后端（搜索+召回）。

---

## 部署流程

### 1. 前置条件

- 安装了 Docker 和 Docker Compose
- 有一批 Markdown/文本文件需要被检索
- 本机有 Ollama（用于生成向量嵌入）

### 2. 一键部署

```bash
# 拉取镜像并启动
docker-compose up -d

# 初始化数据库
npm run migrate

# 导入你的文档（替换成实际路径）
node batch_ingest.cjs --dir /你的知识库路径
```

导入完成后，SAG 在 `http://localhost:4173` 提供服务。

### 3. 搜索

```bash
# REST API
curl -X POST http://localhost:4173/api/search \
  -H "Content-Type: application/json" \
  -d '{"query":"净滩活动预算","sourceIds":["your-source-id"],"topK":5}'

# MCP 协议（Agent 可用）
# 在 Agent 的 mcp.json 中配置：
# {"insigoo-sag": {"url": "http://localhost:4173/mcp"}}
```

---

## 技术栈

| 组件 | 说明 |
|------|------|
| 向量数据库 | PostgreSQL 16 + pgvector |
| 嵌入模型 | Ollama / nomic-embed-text (768维) |
| 服务端 | Node.js (TypeScript) |
| 接口 | REST API (:4173) + MCP (:4174) |
| 部署 | Docker Compose |

---

## 适用场景

- ✅ 你有 50+ 份文档，经常需要跨文件检索
- ✅ 给 Agent 装上"搜索能力"，让它能回答"XX在哪"
- ✅ 配合 insigoo-memory：分类管"归属"，搜索管"找到"
- ❌ 只有 10 份以内文档（直接 grep 更简单）

---

*因思阁(insigoo)自主开发 · MIT 许可 · insigoo@insigoo.cn*
