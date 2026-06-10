# custom_rules

自用的代理规则集仓库，按客户端分目录存放。规则文件托管在 GitHub，通过 jsDelivr CDN 引用，国内访问更稳定。

## 目录结构

```
surge/    Surge 规则集（RULE-SET，.list）
  OpenAI.list      OpenAI / ChatGPT（源：blackmatrix7）
  Anthropic.list   Claude / Claude Code（源：xiaolai）
clash/    Clash 规则集（rule-provider，.yaml）
  OpenAI.yaml      OpenAI / ChatGPT（源：blackmatrix7）
  Anthropic.yaml   Claude / Claude Code（源：xiaolai）
```

> 规则较少时一个文件即可（如 OpenAI 35 条、Anthropic 13 条），直接放在对应客户端目录下。
> 若某类规则将来拆得很细、文件较多，再在该客户端目录下建子文件夹（如 `surge/openai/`）。

## CDN 基础地址

```
https://cdn.jsdelivr.net/gh/snowsky2025/custom_rules@main/<路径>
```

## Surge 用法

在 `Surge.conf` 的 `[Rule]` 段引用（`🍟 OpenAI` / `🖥️ ClaudeCode` 换成你自己的策略组名）：

```ini
[Rule]
RULE-SET,https://cdn.jsdelivr.net/gh/snowsky2025/custom_rules@main/surge/OpenAI.list,🍟 OpenAI
RULE-SET,https://cdn.jsdelivr.net/gh/snowsky2025/custom_rules@main/surge/Anthropic.list,🖥️ ClaudeCode
```

## Clash 用法

在 `rule-providers` 里声明，再到 `rules` 引用：

```yaml
rule-providers:
  openai:
    type: http
    behavior: classical
    url: https://cdn.jsdelivr.net/gh/snowsky2025/custom_rules@main/clash/OpenAI.yaml
    path: ./ruleset/openai.yaml
    interval: 86400
  anthropic:
    type: http
    behavior: classical
    url: https://cdn.jsdelivr.net/gh/snowsky2025/custom_rules@main/clash/Anthropic.yaml
    path: ./ruleset/anthropic.yaml
    interval: 86400

rules:
  - RULE-SET,openai,🍟 OpenAI
  - RULE-SET,anthropic,🖥️ ClaudeCode
```

> 注意 `behavior` 要和文件内容匹配：含 `DOMAIN-SUFFIX/IP-CIDR` 等多类型用 `classical`；纯 `+.domain` 列表（`payload:` 下）用 `domain`。Anthropic.yaml 为纯域名 `payload` 列表，可用 `domain`。

## URL / 缓存说明

- `@main` 可换成具体 tag / commit 锁定版本。
- jsDelivr 有约 12h 缓存。改完想立即生效，访问一次
  `https://purge.jsdelivr.net/gh/snowsky2025/custom_rules@main/<路径>` 刷新缓存。
- 备用 raw 直链（国内可能不稳）：
  `https://raw.githubusercontent.com/snowsky2025/custom_rules/main/<路径>`

## 维护

```bash
git add .
git commit -m "update rules"
git push
```

改完 push 后，在 Surge / Clash 客户端里「更新资源 / 刷新规则」即可重新拉取。

## 来源致谢

- [blackmatrix7/ios_rule_script](https://github.com/blackmatrix7/ios_rule_script) — OpenAI
- [xiaolai/anthropic-claude-surge-rules-set](https://github.com/xiaolai/anthropic-claude-surge-rules-set) — Anthropic / Claude
