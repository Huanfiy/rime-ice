# 新词典创建规范

本文档专门用于指导 AI 创建新的 Rime-Ice 词典文件。

## 文件格式模板

### 标准模板
```yaml
# Rime dictionary
# encoding: utf-8
#
#
# https://github.com/iDvel/rime-ice
# ------- [词典标题] -------
#
#
# 词库组成：
# - [词汇来源说明]
# - [处理方法说明]
#
# 按照「拼音顺序、权重逆序」排序

---
name: [词典名称]
version: "[YYYY-MM-DD]"
sort: by_weight
use_preset_vocabulary: false
...

[词条内容]
```

### 实际示例
```yaml
# Rime dictionary
# encoding: utf-8
#
#
# https://github.com/iDvel/rime-ice
# ------- 医学词汇词库 -------
#
#
# 词库组成：
# - 医学基础术语
# - 疾病诊断名词
# - 医疗器械名称
# - 药物名称
#
# 按照「拼音顺序、权重逆序」排序

---
name: medical
version: "2024-08-28"
sort: by_weight
use_preset_vocabulary: false
...

心电图	xin dian tu
核磁共振	he ci gong zhen
CT扫描	C T sao miao
```

## 词条格式要求

### 基本格式
```
词汇<TAB>拼音<TAB>权重(可选)
```
**重要**: 使用制表符（TAB），不是空格

### 拼音规则
1. **音节分隔**: 用空格分隔拼音音节
2. **英文字母**: 每个字母单独拼读
   - ARM → `A R M`
   - HTTP → `H T T P`
3. **数字**: 每个数字单独拼读
   - STM32 → `S T M 32`
4. **特殊规则**:
   - nüe/lüe → nve/lve
   - 句/去/需/与 → ju/qu/xu/yu

### 正确示例
```
物联网	wu lian wang
IoT	I o T
STM32	S T M 32
WiFi	W i F i
5G网络	5 G wang luo
TCP协议	T C P xie yi
```

### 错误示例
```
物联网 wu lian wang        # ❌ 使用了空格而不是TAB
IoT	IoT                    # ❌ 英文没有拆分
STM32	S T M san shi er   # ❌ 数字用了中文
WiFi	WiFi               # ❌ 英文没有拆分
```

## 文件命名规则

- 格式: `[领域名].dict.yaml`
- 示例: `medical.dict.yaml`, `finance.dict.yaml`, `programming.dict.yaml`
- 使用英文名称，简洁明了

## 词汇数量建议

- **初始创建**: 50-100个核心词汇
- **完整词库**: 100-200个词汇
- **大型词库**: 200-500个词汇

## 词汇选择原则

### 优先级顺序
1. **核心基础词汇** - 该领域最常用的术语
2. **专业术语** - 领域特有的专业词汇
3. **缩写和全称** - 常见的缩写词
4. **复合词汇** - 由基础词组成的复合概念

### 词汇分类建议
```yaml
# 基础概念
基础词1	pinyin1
基础词2	pinyin2

# 专业术语
专业词1	pinyin3
专业词2	pinyin4

# 缩写词汇
ABC	A B C
XYZ	X Y Z

# 复合词汇
复合词1	pinyin5
复合词2	pinyin6
```

## 集成到主词典

创建词典后，需要在 `../rime_ice.dict.yaml` 中添加引用：

```yaml
import_tables:
  - cn_dicts/8105
  - cn_dicts/base
  - cn_dicts/mydict
  - cn_dicts/ext
  - cn_dicts/[新词典名]  # 在这里添加
  - cn_dicts/tencent
  - cn_dicts/others
```

## AI 创建新词典的步骤

### 1. 确定词典信息
- 词典名称（英文）
- 词典标题（中文）
- 目标词汇数量
- 词汇领域范围

### 2. 创建文件头部
- 使用标准模板
- 填写词典名称和当前日期
- 说明词库组成

### 3. 收集词汇
- 按分类组织词汇
- 确保拼音正确
- 遵循命名规则

### 4. 格式检查
- 确认使用TAB分隔
- 检查拼音格式
- 验证YAML语法

### 5. 集成测试
- 添加到主词典引用
- 确认可以正常加载

## 常见词典类型模板

### 科技类词典
```yaml
name: technology
version: "2024-08-28"
# 包含: 编程语言、软件工具、技术概念
```

### 医学类词典
```yaml
name: medical
version: "2024-08-28"
# 包含: 疾病名称、医疗器械、药物名称、解剖术语
```

### 法律类词典
```yaml
name: legal
version: "2024-08-28"
# 包含: 法律条文、司法程序、法律概念
```

### 金融类词典
```yaml
name: finance
version: "2024-08-28"
# 包含: 金融工具、投资术语、会计概念
```

## 质量检查清单

### 文件格式
- [ ] 文件编码为 UTF-8
- [ ] YAML 语法正确
- [ ] 文件名符合规范

### 词条格式
- [ ] 使用制表符分隔
- [ ] 拼音格式正确
- [ ] 英文字母正确拆分
- [ ] 数字正确处理

### 内容质量
- [ ] 词汇准确无误
- [ ] 拼音标注正确
- [ ] 无重复词条
- [ ] 词汇实用性高

### 集成测试
- [ ] 成功添加到主词典
- [ ] 词汇可以正常输入
- [ ] 无冲突和错误

---

遵循此规范可以确保新创建的词典与现有 Rime-Ice 词库完全兼容。