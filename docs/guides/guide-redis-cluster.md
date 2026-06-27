# Redis Cluster Docker 部署指南

## 📚 目录结构

```
docs/dev-ops/
├── docker-compose-redis-cluster.yml    # Docker Compose 配置文件
├── redis/
│   └── cluster/
│       ├── node1/redis.conf            # 节点 1 配置 (Master)
│       ├── node2/redis.conf            # 节点 2 配置 (Master)
│       ├── node3/redis.conf            # 节点 3 配置 (Master)
│       ├── node4/redis.conf            # 节点 4 配置 (Slave)
│       ├── node5/redis.conf            # 节点 5 配置 (Slave)
│       └── node6/redis.conf            # 节点 6 配置 (Slave)
└── script/
    └── deploy-redis-cluster.sh         # 一键部署脚本
```

## 🎯 架构设计

### 集群拓扑图

```
┌─────────────────────────────────────────────────────────┐
│                  Redis Cluster (6 Nodes)                 │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Master Nodes (主节点)        Slave Nodes (从节点)       │
│  ┌──────────────┐            ┌──────────────┐          │
│  │  Node-1      │◄───────────│  Node-4      │          │
│  │  172.25.0.11 │  Replicate │  172.25.0.14 │          │
│  │  :6379       │            │  :6379       │          │
│  └──────────────┘            └──────────────┘          │
│                                                          │
│  ┌──────────────┐            ┌──────────────┐          │
│  │  Node-2      │◄───────────│  Node-5      │          │
│  │  172.25.0.12 │  Replicate │  172.25.0.15 │          │
│  │  :6379       │            │  :6379       │          │
│  └──────────────┘            └──────────────┘          │
│                                                          │
│  ┌──────────────┐            ┌──────────────┐          │
│  │  Node-3      │◄───────────│  Node-6      │          │
│  │  172.25.0.13 │  Replicate │  172.25.0.16 │          │
│  │  :6379       │            │  :6379       │          │
│  └──────────────┘            └──────────────┘          │
│                                                          │
└─────────────────────────────────────────────────────────┘

端口映射:
Node-1: 16379 (Client), 116379 (Cluster Bus)
Node-2: 16380 (Client), 116380 (Cluster Bus)
Node-3: 16381 (Client), 116381 (Cluster Bus)
Node-4: 16382 (Client), 116382 (Cluster Bus)
Node-5: 16383 (Client), 116383 (Cluster Bus)
Node-6: 16384 (Client), 116384 (Cluster Bus)
```

### 为什么选择 3 主 3 从？

**思考题：** 为什么不使用 2 主 2 从或 4 主 4 从？

**答案：**
1. **容错性**：Redis 集群需要超过半数（N/2 + 1）的 master 存活才能工作
   - 3 主节点：可容忍 1 个节点故障
   - 2 主节点：可容忍 0 个节点故障（一个挂了就瘫痪）
   
2. **资源平衡**：
   - 本地实验环境资源有限
   - 6 个节点足够演示集群的所有特性

3. **生产建议**：生产环境通常 5 主 5 从或更多

## 🚀 快速开始

### 方式一：使用一键部署脚本（推荐）

```bash
# 进入脚本目录
cd docs/dev-ops/script

# 执行部署脚本
./deploy-redis-cluster.sh
```

脚本会自动完成以下操作：
1. ✅ 创建数据目录
2. ✅ 清理旧容器
3. ✅ 启动所有节点
4. ✅ 初始化集群
5. ✅ 显示访问信息

### 方式二：手动部署

```bash
# 1. 创建数据目录
mkdir -p redis/cluster/node{1..6}/data

# 2. 启动所有节点
cd docs/dev-ops
docker-compose -f docker-compose-redis-cluster.yml up -d

# 3. 等待节点就绪 (10 秒)
sleep 10

# 4. 初始化集群
docker exec redis-node-1 redis-cli --cluster create \
    172.25.0.11:6379 172.25.0.12:6379 172.25.0.13:6379 \
    172.25.0.14:6379 172.25.0.15:6379 172.25.0.16:6379 \
    --cluster-replicas 1 \
    --cluster-yes

# 5. 查看集群状态
docker exec redis-node-1 redis-cli -c cluster info
```

## 🔍 验证集群状态

### 1. 查看集群信息

```bash
docker exec redis-node-1 redis-cli -c cluster info
```

输出示例：
```
cluster_state:ok
cluster_slots_assigned:16384
cluster_slots_ok:16384
cluster_slots_pfail:0
cluster_slots_fail:0
cluster_known_nodes:6
cluster_size:3
...
```

### 2. 查看节点分布

```bash
docker exec redis-node-1 redis-cli -c cluster nodes
```

### 3. 测试数据分片

```bash
# 设置键值对（会自动分配到某个 master）
docker exec redis-node-1 redis-cli -c set foo bar

# 获取键值对（可能需要从其他节点重定向）
docker exec redis-node-2 redis-cli -c get foo
```

### 4. 访问管理界面

浏览器访问：**http://localhost:8081**
- 账号：`admin`
- 密码：`admin`

## 💡 核心概念解析

### Q1: 什么是 Slot（槽）？

**类比理解：**
想象一个图书馆有 16384 个书架（slots），书籍（keys）按照书名计算应该放在哪个书架。

```
KEY "user:1001" → CRC16 哈希 → 数字 → MOD 16384 → Slot 编号 (0-16383)
```

**为什么是 16384？**
- Redis 作者经过计算得出：2^14 = 16384
- 太少：分片不够均匀
- 太多：心跳包太大，浪费网络带宽

### Q2: 数据如何在集群中分布？

```
┌──────────────────────────────────────────────┐
│  Slot 分配示例                                │
├──────────────────────────────────────────────┤
│  Master-1 (Node-1):  Slot 0 ~ 5460          │
│  Master-2 (Node-2):  Slot 5461 ~ 10922      │
│  Master-3 (Node-3):  Slot 10923 ~ 16383     │
└──────────────────────────────────────────────┘

当你写入 key 时:
set user:1001 value → 计算 hash → 落到 Slot 1234 → 路由到 Master-1
set user:2001 value → 计算 hash → 落到 Slot 7890 → 路由到 Master-2
```

### Q3: 主从复制是如何工作的？

**异步复制流程：**

```
Master (Node-1)              Slave (Node-4)
     │                            │
     │─── 1. Write Command ──────►│
     │    (set foo bar)           │
     │                            │
     │─── 2. ACK (异步确认) ◄─────│
     │                            │
     │─── 3. 定期同步全量数据 ────►│ (如果差异太大)
```

**故障转移过程：**

```
1. Master-1 宕机
         ↓
2. Slave-4 检测到超时 (cluster-node-timeout: 5000ms)
         ↓
3. Slave-4 发起选举投票
         ↓
4. 获得多数票 (> N/2)
         ↓
5. Slave-4 晋升为新的 Master-4
         ↓
6. 集群恢复正常，继续服务
```

## 🔧 常用运维命令

### 停止/启动集群

```bash
# 停止所有节点
docker-compose -f docker-compose-redis-cluster.yml down

# 重启所有节点
docker-compose -f docker-compose-redis-cluster.yml restart

# 重启单个节点
docker restart redis-node-1
```

### 查看日志

```bash
# 查看指定节点日志
docker logs -f redis-node-1

# 查看最近 100 行
docker logs --tail 100 redis-node-1
```

### 进入 Redis CLI

```bash
# 连接模式（-c 表示 cluster mode）
docker exec -it redis-node-1 redis-cli -c

# 在集群内部操作
127.0.0.1:6379> cluster info
127.0.0.1:6379> cluster nodes
127.0.0.1:6379> keys *
```

### 扩容/缩容实验

```bash
# 添加新节点（需要先修改 docker-compose 文件）
docker-compose up -d redis-node-7

# 重新分片
docker exec redis-node-1 redis-cli --cluster reshard \
    172.25.0.11:6379 \
    --cluster-from <source-node-id> \
    --cluster-to <target-node-id> \
    --cluster-slots <number-of-slots>
```

## 📝 项目集成配置

### Spring Boot + Redisson 配置

修改你的 `application-dev.yml`：

```yaml
redis:
  sdk:
    config:
      # 集群模式下可以配置多个 seed nodes
      host: 127.0.0.1
      port: 16379
      # 如果需要完整集群配置，需要修改 RedisClientConfig.java
      # 使用 Config.useClusterServers() 而不是 Config.useSingleServer()
```

### Redisson 集群模式配置示例

```java
@Configuration
public class RedisClusterConfig {
    
    @Bean
    public RedissonClient redissonClient() {
        Config config = new Config();
        // 使用集群模式
        config.useClusterServers()
            .addNodeAddress("redis://127.0.0.1:16379",
                           "redis://127.0.0.1:16380",
                           "redis://127.0.0.1:16381")
            .setPassword(null); // 如果有密码，在这里设置
        return Redisson.create(config);
    }
}
```

## 🎓 实验场景建议

### 场景 1: 故障转移测试

```bash
# 1. 查看当前主从关系
docker exec redis-node-1 redis-cli -c cluster nodes

# 2. 模拟 Master-1 宕机
docker stop redis-node-1

# 3. 观察 Slave-4 是否晋升为 Master
docker exec redis-node-2 redis-cli -c cluster nodes

# 4. 恢复节点
docker start redis-node-1

# 5. 观察原 Master 变为 Slave
```

### 场景 2: 数据分片验证

```bash
# 批量写入数据
for i in {1..100}; do
    docker exec redis-node-1 redis-cli -c set "user:$i" "value:$i"
done

# 查看每个节点的 key 数量
docker exec redis-node-1 redis-cli -c dbsize
docker exec redis-node-2 redis-cli -c dbsize
docker exec redis-node-3 redis-cli -c dbsize
```

### 场景 3: 性能对比实验

```bash
# 单机模式 vs 集群模式
# 使用 redis-benchmark 进行压测

# 测试单节点 QPS
docker exec redis-node-1 redis-benchmark -q -n 10000

# 测试集群整体 QPS（需要在客户端开启集群模式）
```

## ⚠️ 注意事项

1. **数据持久化**
   - 数据存储在 `redis/cluster/nodeX/data/` 目录
   - 删除容器不会丢失数据（AOF 持久化已开启）
   - 如需完全清理：`rm -rf redis/cluster/node*/data`

2. **内存限制**
   - 每个节点限制 256MB 内存
   - 总共约 1.5GB（6 个节点）
   - 可根据实际情况调整 `maxmemory` 参数

3. **网络配置**
   - 确保 16379-16384 和 116379-116384 端口未被占用
   - 如有冲突，修改 docker-compose 文件中的端口映射

4. **集群重建**
   - 如需重置集群，先执行 `down` 再清理数据目录
   - 重新运行部署脚本即可

## 📖 参考资源

- [Redis 官方文档 - Cluster](https://redis.io/topics/cluster-tutorial)
- [Redisson GitHub](https://github.com/redisson/redisson)
- [Docker Compose 官方文档](https://docs.docker.com/compose/)

---

**💭 思考题：**

1. 如果同时有两个 Master 节点宕机，集群会怎样？
2. 如何在不中断服务的情况下进行集群扩容？
3. Redis 集群的读写性能与单机版有什么差异？为什么？

带着这些问题去实验，你会理解得更深刻！🚀
