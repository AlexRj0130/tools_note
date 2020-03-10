[TOC]

# Extensions

## Todo_Tree

- 搜索并展示文件中的 `TODO` 和 `FIXME` 注释（可以自定义其它关键字）
  - 结果展示在 Exploer 面板中
  - 点击对应结果可快速跳转

### 使用方法

> 在 Side Bar 中点击 Todo Tree 图标打开对应的面板，然后使用即可
> 没有（也无需）快捷键

### 配置方法

- 配置示例（参见插件首页）：
  ```json
  "todo-tree.highlights.defaultHighlight": {
      "icon": "alert",
      "type": "text",
      "foreground": "red",
      "background": "white",
      "opacity": 50,
      "iconColour": "blue"
  },
  "todo-tree.highlights.customHighlight": {
      "TODO": {
          "icon": "check",
          "type": "line"
      },
      "FIXME": {
          "foreground": "black",
          "iconColour": "yellow",
          "gutterIcon": true
      }
  }
  ```
- 附：[常用 RGB 颜色对照表](https://tool.oschina.net/commons?type=3)
