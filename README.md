# surge-rules

自用的 [Surge](https://nssurge.com/) 自定义规则集仓库。规则文件托管在 GitHub，通过 jsDelivr CDN 引用到 Surge 配置中，国内访问更稳定。

## 目录结构

```
rules/        RULE-SET 规则集（支持 DOMAIN / DOMAIN-SUFFIX / DOMAIN-KEYWORD / IP-CIDR 等）
  MyProxy.list    走代理
  MyDirect.list   直连
  MyReject.list   拦截
domain-set/   DOMAIN-SET 纯域名列表（匹配更快，只能写域名/后缀）
  MyDirect.txt
```

## 在 Surge 中使用

把下面的规则加到 Surge 配置文件的 `[Rule]` 段（注意顺序：越靠前优先级越高，REJECT/DIRECT 一般放前面）：

```ini
[Rule]
RULE-SET,https://cdn.jsdelivr.net/gh/snowsky2025/surge-rules@main/rules/MyReject.list,REJECT
RULE-SET,https://cdn.jsdelivr.net/gh/snowsky2025/surge-rules@main/rules/MyDirect.list,DIRECT
RULE-SET,https://cdn.jsdelivr.net/gh/snowsky2025/surge-rules@main/rules/MyProxy.list,PROXY
# DOMAIN-SET 用法：
DOMAIN-SET,https://cdn.jsdelivr.net/gh/snowsky2025/surge-rules@main/domain-set/MyDirect.txt,DIRECT
```

> 把 `PROXY` 换成你自己的策略组名称（如 `Proxy` / `节点选择`）。

## URL 说明

- **jsDelivr CDN（推荐）**：`https://cdn.jsdelivr.net/gh/snowsky2025/surge-rules@main/<路径>`
  - `@main` 也可换成具体 tag / commit 锁定版本；用 `@latest` 取最新。
  - CDN 有缓存（约 12h）。改完规则想立刻生效，可访问
    `https://purge.jsdelivr.net/gh/snowsky2025/surge-rules@main/<路径>` 刷新缓存。
- **GitHub raw（备用）**：`https://raw.githubusercontent.com/snowsky2025/surge-rules/main/<路径>`

## 让 Surge 拉取最新规则

改完规则并 `git push` 后，在 Surge 里执行 **「更新所有资源 / Refresh Resources」**（或重载配置）即可重新拉取。

## 维护

```bash
# 编辑规则后提交
git add .
git commit -m "update rules"
git push
```
