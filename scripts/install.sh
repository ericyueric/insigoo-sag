#!/bin/bash
# insigoo-sag 一键部署
# 用法: bash install.sh

echo "🧠 正在部署 insigoo SAG 语义检索引擎..."
echo ""

# 1. Docker
if ! docker info >/dev/null 2>&1; then
    echo "❌ 请先安装 Docker Desktop"
    exit 1
fi

# 2. Start DB
echo "📦 启动 PostgreSQL..."
docker-compose up -d

# 3. Wait for ready
echo "⏳ 等待数据库就绪..."
until docker exec sag_lite_postgres pg_isready -U sag_lite -d sag_lite 2>/dev/null; do
    sleep 1
done

# 4. Migrate
echo "📋 执行数据库迁移..."
for f in migrations/*.sql; do
    docker exec -i sag_lite_postgres psql -U sag_lite -d sag_lite < "$f"
done

# 5. Install deps
echo "📦 安装依赖..."
npm install --save pg knex dotenv 2>/dev/null

echo ""
echo "✅ insigoo SAG 部署完成！"
echo "   REST API: http://localhost:4173"
echo "   导入文档: node batch_ingest.cjs --dir /你的知识库"
echo ""
echo "   下一步: 配置你的 Agent MCP 连接到 localhost:4174"
