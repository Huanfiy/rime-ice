# Huan Rime 配置说明

## 本机设备身份

当前机器使用独立 Rime 同步身份：

```yaml
installation_id: huan_rime_01
```

`installation_id` 用于决定本机同步输出目录。当前机器点“同步”时，Rime 会写入：

```text
sync/huan_rime_01/
```

仓库中保留的 `sync/huan_rime/` 可作为已有同步快照或公共基线使用。本机不再使用 `huan_rime` 作为设备身份，避免多台机器写入同一个同步目录。

根目录 `./installation.yaml` 是本机状态文件，默认被 `.gitignore` 排除，不应提交到 Git。`sync/<installation_id>/installation.yaml` 是同步快照的一部分，如需把某台设备的同步快照纳入版本管理，可以随该设备目录一起提交。

## Rime 同步调用链

Fcitx5 右上角“同步”按钮不会直接解析 `sync/` 目录。它只调用 librime 的同步接口：

```cpp
RimeEngine::sync() -> api_->sync_user_data()
```

进入 librime 后，`RimeSyncUserData()` 会安排三个任务：

```text
installation_update
backup_config_files
user_dict_sync
```

其中：

- `installation_update` 读取 `installation.yaml`，得到 `installation_id` 和 `sync_dir`。
- `backup_config_files` 把当前用户目录下的 `.yaml` / `.txt` 配置备份到 `sync/<installation_id>/`。
- `user_dict_sync` 才处理用户词库同步。

用户词库同步的核心行为是：遍历 `sync_dir` 下所有一级子目录，寻找与当前用户词典同名的 `*.userdb.txt` 快照文件；找到后合并进当前本机 userdb，最后再把当前本机 userdb 导出到 `sync/<installation_id>/`。

因此，多设备同步应使用不同设备身份，例如：

```text
sync/huan_rime_01/
sync/huan_rime_laptop/
sync/huan_rime_work/
```

不要让多台设备共用同一个 `installation_id`。否则多台设备会写入同一个 `sync/<installation_id>/` 目录，用户词库快照会互相覆盖。

需要注意：Rime 自动合并的是用户词库快照 `*.userdb.txt`，不是自动合并其它设备目录里的 `default.yaml`、`*.schema.yaml` 或 `installation.yaml`。

## 输入切换约定

- 需要关闭 Fcitx5 中的 shift 输入法切换，完全由 Rime 接管输入。
