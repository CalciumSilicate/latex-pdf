---
name: latex-pdf
description: >-
  按北京大学《高等数学习题课讲义》风格(楷体正文 / 黑体标题 / 中文定理环境),
  用 LaTeX 撰写中文数学讲义并用 xelatex 渲染成 PDF。当用户想生成、撰写、排版
  数学讲义 / 讲义 / 课程笔记 / 习题讲解 / 定理证明文档 / lecture notes,
  或把数学内容做成这种风格的 PDF 时使用。
---

# 数学讲义(LaTeX → PDF)

把用户给的数学内容,按北大《高等数学习题课讲义》的版式写成 LaTeX 并编译成 PDF。

格式参考来源:[darkoxie 网站](https://darkoxie.github.io/)上的高等数学习题课讲义。仅参考排版格式,原讲义的著作权归原作者所有。

## 环境要求

- TeX 发行版:建议使用 **TinyTeX**(TeX Live 内核),确保 **xelatex**、**latexmk** 和 **tlmgr** 可用。
- 字体:需安装 **KaiTi(楷体)**、**SimHei(黑体)**、SimSun;正文楷体、标题黑体由模板配置好。
- 渲染查看 PDF:可用 **Python + PyMuPDF**(`import fitz`)把 PDF 转成 PNG 再用图片查看工具检查;使用前确认依赖可用。

## 本 skill 的文件

- `template.tex` — 还原讲义风格的完整模板(导言区 + 正文骨架)。**正文从 `% 正文从此开始` 到 `% 正文到此结束` 之间**,替换这段即可。
- `build.ps1` — 自愈式编译脚本:跑 `latexmk -xelatex`,若缺宏包会自动 `tlmgr` 定位并安装后重试。

> 以下 `<skill目录>` 指本 `SKILL.md` 所在目录,请替换为实际安装路径,不要假定用户名或客户端的 skills 目录。

## 工作流程

1. **确认主题与内容**。若用户只给了主题(如“写一份导数的讲义”),先快速理出小节结构(知识点 / 定理 / 例题 / 注),需要时再追问范围。

2. **生成 .tex**。把 `template.tex` 复制到工作目录(默认当前目录,或用户指定路径),命名如 `<主题>.tex`,然后:
   - 改 `\title`(格式:`北京大学高等数学B习题课讲义:XXX`)、`\author`、`\date`;
   - 把正文骨架替换成实际内容,使用下面的环境与宏。

3. **编译**:
   ```powershell
   powershell -File "<skill目录>\build.ps1" "<工作目录>\<文件>.tex"
   ```
   成功输出 `BUILD OK -> ...pdf`。脚本会自动补装缺失的宏包,无需手动 `tlmgr install`。

4. **目检**:用 PyMuPDF 把生成的 PDF 渲染成 PNG,Read 查看,确认无溢出/乱码/编译报错,再交付:
   ```python
   import fitz
   doc = fitz.open(r"<文件>.pdf")
   for i, p in enumerate(doc):
       p.get_pixmap(dpi=130).save(f"_check-{i+1}.png")
   ```

5. **交付**:告诉用户 PDF 路径。临时图片(`_check-*.png`)清掉。

## 排版约定(模板已内置)

**定理类环境**(中文,带自动编号;证明结尾自带 □):
| 环境 | 显示 | | 环境 | 显示 |
|---|---|---|---|---|
| `theorem` | 定理 | | `definition` | 定义 |
| `proposition` | 命题 | | `example` | 例(连续编号) |
| `lemma` | 引理 | | `exercise` | 习题 |
| `corollary` | 推论 | | `remark` | 注(无编号) |
| `proof` | 证明 … □ | | | |

带名字的定理写 `\begin{theorem}[算术—几何平均不等式] ... \end{theorem}`。

**无编号小标题**(参考件里“有理数和无理数”这类黑体行)用 `\subsubsection*{...}`。

**数学宏**(模板已定义):`\R \N \Z \Q`(数集)、`\dd`(微分 d)、`\eps`(ε)、`\sgn`。公式用 `equation` / `align` 自动编号。

**作图**:用 TikZ / pgfplots(模板已 `\usepackage`)。函数图像示例:
```latex
\begin{center}
\begin{tikzpicture}
  \begin{axis}[axis lines=middle, xlabel=$x$, ylabel=$y$, samples=100]
    \addplot[blue, domain=-3:3]{x^2};
  \end{axis}
\end{tikzpicture}
\end{center}
```

## 注意

- 编译引擎必须是 **xelatex**(中文字体);别用 pdflatex。`build.ps1` 已固定用 xelatex。
- 文件存 **UTF-8**。`.tex` 里中文没问题;但**不要**把中文写进会被 PowerShell 5.1 执行的 `.ps1`(GBK 环境下会解析错乱)。
- 若 `build.ps1` 报“not a missing-package error”,打开同名 `.log` 看真正的报错(多半是 LaTeX 语法或数学环境写错),修了再编。
