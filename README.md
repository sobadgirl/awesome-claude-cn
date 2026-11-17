# Awesome Claude CN

中文圈里关于 Claude 的可用资源，人工筛过一遍的。

不做搬运站，不做导航页。这里的每一条我都点开看过，失效了会删。

**收录标准**：现在还能打开、内容还成立、有具体信息量。纯引流页、要加群才给看的、标题党教程，不收。

[![Awesome](https://awesome.re/badge.svg)](https://awesome.re)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

系列仓库｜[教程](https://github.com/sobadgirl/use-claude-in-china) · [避坑](https://github.com/sobadgirl/claude-fangfen) · [合集](https://github.com/sobadgirl/awesome-claude-cn) · [服务](https://github.com/sobadgirl/get-claude-in-china)

## 目录

- [官方](#官方)
- [风控与账号安全](#风控与账号安全)
- [支付](#支付)
- [网络与 IP](#网络与-ip)
- [Claude Code](#claude-code)
- [中文实战记录](#中文实战记录)
- [账号环境体检表](#账号环境体检表)
- [待收录](#待收录)

## 官方

先看官方说什么，其他都只是二手解读。

- [Anthropic 消费者服务条款](https://www.anthropic.com/legal/consumer-terms)：账号共享、第三方接入、地区限制的原始依据都在这里
- [Claude 帮助中心](https://support.claude.com/)：封号、验证、订阅问题的官方口径
- [Claude 文档](https://docs.claude.com/)：Claude Code、API、模型能力
- [Anthropic 状态页](https://status.anthropic.com/)：先确认是不是它自己挂了，再怀疑自己的环境

有个习惯值得养成：遇到"账号不能用了"，先去状态页看一眼。服务故障和封号在页面上的表现经常一样。

## 风控与账号安全

- [Claude 防封号 & KYC 避坑完整指南（PANews）](https://www.panewslab.com/zh-hant/articles/019db34c-eb93-707b-9c25-dfe946dc11b1)。目前中文圈里最完整的一份，综合了多位被封过两位数账号的用户实测。环境、邮箱、IP、支付、KYC、申诉退款全流程都覆盖了。
- [Claude 账号风控完整指南：地区、登录、KYC、封禁申诉（ClaudeMax）](https://claudemax.shop/blog/claude-account-risk-control-kyc-appeal)。把"风控"拆成六种状态，这个拆法很实用，因为 Warning、KYC、地区限制、支付失败、账号停用的处理路径完全不同。
- [Claude Opus 在国内为什么越来越难用：KYC 验证与封号回顾（腾讯云社区）](https://cloud.tencent.com/developer/article/2708468)。三年封锁史的时间线整理，想搞清楚"为什么一年比一年难"看这篇。
- [Claude Account Banned: 9 Reasons Why & How to Appeal Each（UnBanAI）](https://unbanai.org/fr/blog/anthropic-claude-ban-reasons-2026)。英文。九类触发原因对应九条申诉路径，API 账号部分比中文资料细。

## 支付

- [Anthropic 注册及支付的实验结论（Echosec）](https://blog.echosec.top/p/claude-signup-payment/)。少见的长期记录型文章，把每个阶段的报错原文都贴出来了。结论是大部分人能过注册，死在支付。
- [Anthropic 再次大规模清退虚拟卡订阅 Claude Max（BlockBeats）](https://www.theblockbeats.info/flash/335788)。虚拟卡按 BIN 段批量清退的现场记录，解释了为什么"IP 干净也没用"。
- [Claude 支付失败？没有海外银行卡的解决方案（TeamoRouter）](https://teamorouter.com/zh/blogs/claude-payment-failed-no-overseas-card)。服务商写的，结论有商业倾向，但各种支付方式的原理和坑说得清楚，当资料看，别当推荐看。

## 网络与 IP

这块中文资料最少，也最容易被卖 IP 的人带偏。有用的判断只有一条：查 ASN。

- [IPinfo](https://ipinfo.io/)：输入 IP 看 ASN 和组织名。看到云厂商名字就是机房段，看到宽带运营商才是住宅。
- [IP 纯净度自测的思路](https://github.com/sobadgirl/claude-fangfen)：为什么"同一个 IP 别人能用你不能"，写在避坑手册的中风险一节。

## Claude Code

- [Claude Code 官方文档](https://docs.claude.com/en/docs/claude-code)：安装、配置、权限模型、MCP
- [Claude Code GitHub 仓库](https://github.com/anthropics/claude-code)：Issue 区是排错最快的地方，很多报错这里已经有人踩过

## 中文实战记录

真实时间线比结论有用。这一节收的是"我什么时候做了什么，然后发生了什么"。

- [claude-fangfen 的 Issue 区](https://github.com/sobadgirl/claude-fangfen/issues)：欢迎把被封的时间线贴上来，越具体越好
- 待收录。有好的复盘发 PR。

## 账号环境体检表

这份表是我自己用的，逐项过一遍，比看十篇教程有用。全部通过才建议开始注册或付费。

### 身份与环境

- [ ] 邮箱是自己注册的，不是买的
- [ ] 邮箱开了两步验证
- [ ] 手机号能长期收到短信，不是接码平台
- [ ] 注册用的姓名、支付账单上的姓名、证件上的姓名，三者一致

### 网络

- [ ] 查过当前 IP 的 ASN，不是云厂商段
- [ ] 这条线路接下来三个月不会换
- [ ] 同一台机器上只走这一条线路，没有分流规则漏出去
- [ ] DNS 没有泄漏，解析结果和出口 IP 在同一个国家
- [ ] WebRTC 没有暴露真实内网地址

### 一致性

- [ ] 系统时区和 IP 所在地一致
- [ ] 浏览器语言和时区匹配
- [ ] 账单地址所在州和 IP 所在州一致
- [ ] 同一个账号没有在多个设备上同时活跃

### 支付

- [ ] 支付方式不是虚拟卡 / U 卡
- [ ] 这张卡没有被多个 Claude 账号用过
- [ ] 这张卡没有在其他被封账号上出现过

### 行为

- [ ] 注册后不打算立刻跑批量任务
- [ ] 头三天计划每天用几次，不是几百次
- [ ] 没有把 OAuth 令牌接到第三方工具

十七条里挂三条以上，先别付款。

后面会补一份能一键跑的检测脚本（IP 段、DNS 泄漏、WebRTC、时区一致性）。写好了会放在这里。

## 待收录

想提 PR 的，按这个格式加一行：

```
- [标题](链接)。一句话说清这篇解决什么问题，以及它的局限。
```

拒收的几类，提前说清楚免得白写：需要关注公众号才能看全文的、纯导流的落地页、"XX 个技巧"但没有具体操作的、明显是 AI 批量生成的。

## License

MIT。本仓库与 Anthropic, PBC 无官方关联。

## Changelog

2026-11-17 · v1.0 首版：官方、风控、支付、网络、Claude Code、实战记录、环境体检表
