# Rime 个人配置 AGENTS 约定

本仓库是一套**全拼-only** 的个人 Rime 配置（雾凇拼音精简版），面向 **Fcitx5 / Linux**，
脱离 iDvel/rime-ice 上游，无构建工具链——所有文件直接编辑，由 Rime 部署时编译。

## 结构

- `default.yaml`：全局默认配置（仅启用 `rime_ice` 一个方案）。
- `rime_ice.schema.yaml`：全拼方案，定义引擎管线（processor/segmentor/translator/filter）。
- `rime_ice_huan.dict.yaml`：主词库入口，`import_tables` 引用 `cn_dicts/` 下各词库。
- `cn_dicts/`：中文词库。
  - `8105`：常用单字。`base`：两字词+常用词。`ext`：三字及以上、含多音字词。
  - `mydict`：用户自定义词（优先于 ext）。`embedded` / `embedded_huan`：嵌入式领域词。`others`：杂项。
- `en_dicts/`：英文与中英混输词库。`en` / `en_ext` 英文词；`cn_en.txt` 中英混合词（直接编辑）。
- `melt_eng.schema.yaml` / `melt_eng.dict.yaml`：英文次翻译器。
- `lua/`：librime-lua 脚本扩展（日期/农历/计算器/UUID/Unicode/纠错/置顶/降频/emoji 延后等）。
- `opencc/`：OpenCC 映射。`emoji.txt`（emoji 映射，直接编辑）、`emoji.json`、`others.txt`。
- `symbols_v.yaml`：`v` 引导的符号输入。
- `custom_phrase.txt`：全拼自定义短语。
- `sync/`：Rime 同步快照，仅跟踪 `*.userdb.txt`（学习词频）。

## 改词与生效

- 加中文词：写入 `cn_dicts/` 对应词库，格式 `词<Tab>拼音<Tab>词频`，词频默认 100，重码按使用习惯调权重。
- 加英文词：写入 `en_dicts/en.dict.yaml` 或 `en_ext.dict.yaml`。
- 加中英混合词：直接编辑 `en_dicts/cn_en.txt`。
- 加 emoji 映射：直接编辑 `opencc/emoji.txt`（格式 `词<Tab>emoji`）。
- `*.dict.yaml` 很大，优先读前 100 行 + 搜索定位，改用查找/替换/追加，避免整文件重写。
- **生效方式**：改完在 Fcitx5 里「重新部署」，或 `rime_deployer --build . /usr/share/rime-data build`。

## 提交规则

Conventional Commits，正文中文。常用：`feat`/`fix`/`refactor`/`chore`/`docs`，作用域如
`dict(cn)`/`dict(en)`/`config`/`lua`。破坏性更新加 `!`。提交前确认工作区只含本次相关文件。
