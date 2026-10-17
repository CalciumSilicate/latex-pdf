# latex-pdf

一个 Skill:按北京大学《高等数学习题课讲义》风格(楷体正文 / 黑体标题 / 中文定理环境),用 LaTeX 撰写中文数学讲义并用 `xelatex` 渲染成 PDF。

## 格式参考来源

本项目的排版格式参考了 [darkoxie 网站](https://darkoxie.github.io/)上的高等数学习题课讲义,包括楷体正文、黑体标题与中文定理环境。此处仅说明格式参考来源,原讲义的著作权归原作者所有。

## 安装

### Claude Code

克隆到 Claude Code 的 skills 目录:

```bash
git clone https://github.com/CalciumSilicate/latex-pdf.git ~/.claude/skills/latex-pdf
```

Windows(PowerShell):

```powershell
git clone https://github.com/CalciumSilicate/latex-pdf.git "$env:USERPROFILE\.claude\skills\latex-pdf"
```

### Codex CLI

克隆到 Codex 的 skills 目录:

```bash
git clone https://github.com/CalciumSilicate/latex-pdf.git ~/.codex/skills/latex-pdf
```

Windows(PowerShell):

```powershell
git clone https://github.com/CalciumSilicate/latex-pdf.git "$env:USERPROFILE\.codex\skills\latex-pdf"
```

装好后,直接让它「写一份 XXX 的数学讲义」即可自动触发。
