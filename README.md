# latex-pdf

一个 [Claude Code](https://claude.com/claude-code) Skill:按北京大学《高等数学习题课讲义》风格(楷体正文 / 黑体标题 / 中文定理环境),用 LaTeX 撰写中文数学讲义并用 `xelatex` 渲染成 PDF。

当你想生成、撰写、排版**数学讲义 / 课程笔记 / 习题讲解 / 定理证明文档 / lecture notes**,或把数学内容做成这种风格的 PDF 时使用。

## 内容

| 文件 | 说明 |
|---|---|
| `SKILL.md` | Skill 主文件:工作流程、排版约定、定理环境与数学宏说明。 |
| `template.tex` | 还原讲义风格的完整 LaTeX 模板(`ctexart` + 导言区 + 正文骨架)。替换 `% 正文从此开始` 到 `% 正文到此结束` 之间即可。 |
| `build.ps1` | 自愈式编译脚本:跑 `latexmk -xelatex`,缺宏包时自动用 `tlmgr` 定位并安装后重试(ASCII-only,兼容 Windows PowerShell 5.1)。 |

## 安装

把本仓库克隆(或作为子目录放)到 Claude Code 的 skills 目录下:

```bash
git clone https://github.com/CalciumSilicate/latex-pdf.git ~/.claude/skills/latex-pdf
```

之后在 Claude Code 里让它「写一份 XXX 的数学讲义」即可自动触发。

## 依赖环境

- **TeX 发行版**:TeX Live / TinyTeX 内核,引擎 `xelatex`。
- **中文字体**:KaiTi(楷体)、SimHei(黑体)、SimSun。
- **PDF 目检**(可选):Python + [PyMuPDF](https://pymupdf.readthedocs.io/)(`import fitz`)把 PDF 转 PNG 查看。

## 手动编译

```powershell
powershell -File build.ps1 <file>.tex
# 成功输出:BUILD OK -> ...pdf
```

> 注意:`SKILL.md` / `build.ps1` 中的路径 `C:\Users\89366\.claude\skills\latex-pdf\` 是原作者的本机路径,克隆到自己机器后按需替换。

## License

MIT
