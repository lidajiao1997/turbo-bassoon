# 南昌大学本科生毕业设计（论文）LaTeX 模板

本模板依据南昌大学官方文件《本科生毕业设计、论文书写式样》（附件 7）编写，**仅面向本科（学士学位）论文**。
排版效果与官方 Word 式样逐条对应，可直接用于本科毕业设计（论文）的撰写与提交。

## 一、快速开始

模板目录中应包含以下文件：

| 文件 | 说明 |
| --- | --- |
| `ncubachelor.cls` | 文档类（模板核心） |
| `ncu-name.png` | 封面校名标识（1.88 cm × 6.59 cm） |
| `ncu-badge.jpg` | 封面校徽标识（3.33 cm × 3.33 cm） |
| `main.tex` | 示例文档，可直接改写为自己的论文 |
| `references.bib` | 参考文献库 |
| `README.md` | 本文件 |

**编译方式：XeLaTeX**（不支持 pdfLaTeX）。完整编译流程：

```
xelatex  main.tex
bibtex   main
xelatex  main.tex
xelatex  main.tex
```

在 TeXworks / TeXstudio / VS Code (LaTeX Workshop) 中，请把编译器选为 **XeLaTeX**，
并使用"XeLaTeX → BibTeX → XeLaTeX × 2"的编译链。

## 二、填写论文信息

论文的封面、摘要页信息集中在导言区的 `\ncusetup` 中填写：

```latex
\ncusetup{
  info = {
    secret-level     = {公开},              % 密级
    title            = {论文中文题目},
    title*           = {Thesis English Title},
    college          = {经管},              % 学院名（封面“学　　院：__经管__学院”的下划线部分）
    department       = {工商},              % 系名（封面“__工商__系”的下划线部分）
    major-class      = {物理学 2023 班},    % 专业班级
    major            = {物理学},            % 专业（摘要页）
    author           = {张三},              % 学生姓名
    studentid        = {402230220001},      % 学号
    supervisor       = {李四},              % 指导教师
    supervisor-title = {教授},              % 职称
    start-date       = {23},                % （20□□—20□□ 年）的起始年份后两位
    stop-date        = {27},                % 结束年份后两位
    start-stop-date  = {2023 年 9 月—2027 年 6 月}  % 起讫日期
  }
}
```

### 类选项

| 选项 | 说明 |
| --- | --- |
| `draft` / `final` | 草稿模式：图片只显示边框，可加快编译 |
| `fontset=windows` / `fontset=fandol` | 中文字体方案，默认自动（Windows 用中易宋体，其他平台用 Fandol） |
| `tocdots` | 目录加引导点线；**v1.1.5 起默认开启**（章/节/摘要各级条目均有点线；官方样张本无点线，如需还原设 `tocdots=false`） |
| `openright` | 每章从奇数页开始（默认单面 `openany`） |

### 样式键

`\ncusetup{style = {...}}` 可替换封面图片：

| 键 | 默认值 |
| --- | --- |
| `name-image` | `ncu-name.png` |
| `badge-image` | `ncu-badge.jpg` |

## 三、文档结构

模板的正文骨架如下，顺序不可打乱（页码切换依赖该顺序）：

```latex
\begin{document}
\maketitle                  % 封面（无页眉页脚）
\makedecaut                 % 原创性申明 + 版权使用授权书（无页眉页脚）
\frontmatter                % 页码切换为罗马数字 I, II, III …

\begin{abstract}  … \keywords{关键词1；关键词2} \end{abstract}   % 中文摘要（页眉“摘要”）
\begin{abstract*} … \keywords{kw1; kw2}        \end{abstract*}   % 英文摘要（页眉“Abstract”）
\tableofcontents            % 目录（页眉“目录”）

\mainmatter                 % 页码切换为阿拉伯数字 1, 2, 3 …

\chapter{引言}              % 正文，页眉为章标题
\section{…}
…

\appendix                   % 附录（编号 A、B …）
\chapter{附加材料}

\backmatter                 % 后置部分
\bibliography{references}   % 参考文献（页眉“参考文献”）
\begin{acknowledgements}    % 致谢（页眉“致谢”）
感谢……
\signoff{张三}{2027 年 6 月}
\end{acknowledgements}
\end{document}
```

## 四、命令与环境一览

| 命令 / 环境 | 用途 |
| --- | --- |
| `\maketitle` | 生成封面 |
| `\makedecaut` | 生成原创性申明与版权使用授权书（一页） |
| `abstract` / `abstract*` | 中 / 英文摘要，内部用 `\keywords{…}` 填关键词 |
| `\tableofcontents` | 生成目录 |
| `\frontmatter` / `\mainmatter` / `\backmatter` | 前置 / 正文 / 后置切换，并切换页码格式 |
| `\chapter{…}` `\section{…}` … | 章（第一章）、节（1.1）、小节（1.1.1） |
| `\unnumberedchapter{结论}` | 无编号章：进目录、进页眉，但不参与章编号（用于"结论"等） |
| `figure` / `table` | 插图 / 表格；标题自动为"图1-1 / 表1-1"，表题在上、图题在下 |
| `\thickhline` | 三线表的粗横线（配合 `\hline`） |
| `theorem` `definition` `lemma` … | 定理类环境（定理/定律/原理/公理/引理/推论/结论/命题/定义/假设/性质/注解/条件/例），可选参数为名称，如 `\begin{theorem}[可编译性]`；编号"章.序"可配置，见下节 |
| `proof` | 证明环境，末尾自动加黑方块（可配置） |
| `\footnote{…}` | 脚注（小五号宋体） |
| `\blfootnote{…}` | 无编号脚注，用于正文第一页标注项目来源 |
| `\freeze` | 手动插入证明结束符号（含数学模式） |
| `acknowledgements` | 致谢环境，内部 `\signoff{姓名}{日期}` 右对齐署名 |

## 五、类选项与高级配置

### 5.1 类选项

| 选项 | 说明 |
| --- | --- |
| `fontset=auto`（默认） | **自动探测平台字体**：Windows（中易宋体/黑体）→ macOS（宋体-简/苹方/楷体-简）→ 方正字库 → 思源宋体 → Fandol（TeX 发行版自带，兜底）。探测用 fontspec 的 `\IfFontExistsTF`，逐字体验证 |
| `fontset=windows/mac/founder/adobe/fandol/none` | 强制指定字体方案；字体定义外置于 `ncu-font-*.def` 文件（TongjiThesis 风格），可仿写扩展自己的方案 |
| `twoside` | 双面打印（复旦 fduthesis 思路）：页眉章名在**奇数页靠右、偶数页靠左**（外侧）；`\cleardoublepage` 生成的空白偶数页不显示页眉页脚。默认 `oneside`（页眉居中，与官方样张一致） |
| `bindingoffset=⟨长度⟩` | **装订偏移**（v1.1.1 新增，需 geometry）：版心整体让出⟨长度⟩给装订侧，双面下偶数页自动交替到纸张右侧（内侧）。选用 `twoside` 且未显式给出时**默认 5mm**（A4 胶装通用值）；写 `bindingoffset=0mm` 可关闭；`oneside` 下也可显式设置（恒在左侧） |
| `blindreview` | **盲审模式**：封面与摘要信息行中的学生姓名、学号、指导教师、职称自动替换为占位文本（默认 `***`），并清除 PDF 元数据中的作者信息。源信息保持不变，正式版去掉该选项即可 |
| `openright` | 每章从奇数页开始（配合 `twoside` 用于双面印刷） |
| `tocdots` | 目录显示点线（v1.1.5 起默认开启；`tocdots=false` 还原官方样张的无点线样式） |
| `draft` / `final` | 草稿 / 最终模式 |

### 5.2 `\ncusetup` 高级键

```latex
\ncusetup{
  %% 盲审细节（配合 blindreview 类选项）
  blind = {
    text = {***},                  %% 遮蔽占位文本
    hide-acknowledgement = true,   %% 同时省略致谢页（连同目录条目）
  },
  %% 定理环境样式
  theorem = {
    header-font = \songti\bfseries,  %% 头部字体
    within      = chapter,           %% 编号锚点：chapter / section / none
  },
  proof = { qed = $\blacksquare$ },  %% 证明结束符
}
```

### 5.3 语义化命令

版式字号与论文信息不直接写在正文里，而是通过语义命令引用，
改一处即可全局调整（TongjiThesis 思路）：

| 字号语义 | 默认 | 信息语义 | 来源 |
| --- | --- | --- | --- |
| `\ncufontcover` | 四号 | `\thesistitle` / `\thesisentitle` | `info = { title / title* }` |
| `\ncufonttitle` | 三号 | `\thesiscollege` `\thesisdepartment` | `info = { college / department }` |
| `\ncufontchapter` | 四号 | `\thesismajorclass` `\thesismajor` | `info = { major-class / major }` |
| `\ncufontbody` | 小四 | `\thesisauthor` `\thesisstudentid` | 盲审时自动遮蔽 |
| `\ncufontheader` | 五号宋体 | `\thesissupervisor` `\thesissupervisortitle` | 盲审时自动遮蔽 |
| `\ncufontcaption` | 五号 | `\thesisdates` | `info = { start-stop-date }` |
| `\ncufontabstracttitle` | 小二 | | |
| `\ncufonttoctitle` | 小三加粗 | | |

### 5.4 LaTeX3 规范

类选项经 `\ProcessKeysOptions`（l3keys2e）处理；`\ncusetup`
基于 `\keys_define:nn` 分组为 `ncu/info`、`ncu/style`、`ncu/blind`、
`ncu/theorem`、`ncu/proof`；内部变量遵循 l3 命名（`\g__ncu_…`），
消息用 `\msg_new:nnn`，文件加载用 `\file_input:n`，引擎检查用
`\sys_if_engine_xetex:F`。字体探测等少量与 2e 宏交互的部分
（`\IfFontExistsTF`、fancyhdr、`\excludecomment`）经 `\cs_new_eq:NN`
或包装宏桥接。

## 六、与官方《书写式样》的对应关系

| 官方要求 | 模板实现 |
| --- | --- |
| 页面：上 2.54、下 2.54、左 3.67、右 2.67 cm；页眉 1.5、页脚 1.75 cm；行距 1.35 倍 | `geometry` 精确设置；实测页眉文字顶 15.9 mm、页眉线 20.3 mm、正文顶 28.6 mm、页码底边距纸底 18.7 mm，与官方样张（14.6 / 20.7 / 27.8 / 18.4 mm）一致。行距按官方样张实测校准：中文 8.0 mm/行（`linespread=1.56`，即 Word“1.35 倍”对 12pt 宋体的实际渲染值；LaTeX 直接写 1.35 只有 6.9 mm）、申明/授权书页 9.0 mm、英文摘要页 6.6 mm |
| 目录："目录"两字小三号宋体加粗；内容小四号宋体；页码数字对齐 | 目录标题小三号加粗居中；条目小四号宋体；页码右对齐；小节左缩进 1 字符；引导点线 v1.1.5 起默认开启（章级条目用 \normalfont 点号，不随标题加粗；`tocdots=false` 可还原样张的无点线样式） |
| 页眉页码：从中文摘要开始；页眉为相应内容标题；摘要—目录用罗马数字，正文第一章起用阿拉伯数字 | `abstract` / `abstract*` / `\tableofcontents` 各自设置页眉与 `\markboth`；`\frontmatter` 切罗马数字，`\mainmatter` 切阿拉伯数字；封面与申明页无页眉页脚 |
| 中文摘要：标题小二号宋体加粗；专业、学号、姓名、指导教师五号宋体；"摘要"四号宋体；内容小四号宋体；"关键词"小四号宋体加粗 | `abstract` 环境按此排版 |
| 英文摘要：标题小二号 Times New Roman 加粗；"Abstract" 四号；内容小四号；"Keyword" 小四号加粗 | `abstract*` 环境按此排版 |
| 正文：标题四号宋体；内容小四号宋体 | 章（居中）、节（居左）均为四号宋体（样张不加粗）；正文小四号宋体、首行缩进 2 字符、两端对齐 |
| 图表：内容五号宋体；表题在上方、图题在下方，五号宋体加粗居中，图序与图名间空一个汉字宽度 | `caption` 设置为五号加粗居中，`labelsep` 为一个汉字宽度；编号"图1-1""表1-1"；浮动体内容统一五号宋体 |
| 参考文献："参考文献"四号宋体；内容小四号宋体，英文小四号 Times New Roman | `gbt7714`（GB/T 7714—2015 顺序编码制），标题四号宋体居中并进目录，条目小四号宋体 |
| 致谢："致谢"四号宋体；内容小四号宋体 | `acknowledgements` 环境 |

封面各要素（密级、校名标识 1.88×6.59 cm、校名外文四号、"学士学位论文"宋体 30 磅、"THESIS OF BACHELOR"四号、年份、校徽 3.33×3.33 cm、"题目"三号、信息栏四号）均按官方批注实现。

**v1.1.1 封面像素级校准**（对官方样张 page-2 以 150 dpi 行投影逐元素测量，偏差 ≤0.4 mm）：

| 元素 | 官方样张实测 y (mm) | 说明 |
| --- | --- | --- |
| 密级行 | 28.0 | 标签右端距右边距约 35 mm，无下划线字段 |
| 校名标识 | 38.8–56.0 | |
| NANCHANG UNIVERSITY | 58.4 | |
| 学士学位论文 | 69.4 | |
| THESIS OF BACHELOR | 83.8 | |
| 年份行 | 93.3 | |
| 校徽 | ≈110 | |
| 题目行 | 178.1 | |
| 信息栏（5 行，v1.1.4） | 207.9 / 222.0 / 236.1 / 249.9 / 264.0 | **网格对齐**（照 NCUBachelorThesis 参考模板做法）：标签列恒宽 5ccwd 且左对齐——五行首字、冒号全部上下对齐；每行总宽恒为 22ccwd——下划线左端（x72.8）与右端（x156.8）全部上下对齐。行宽构成：学院 5+8+1(系)+8；专业班级 5+17；学生姓名 5+7.5+3(学号：)+6.5；指导教师 5+7.5+3(职称：)+6.5；起讫日期 5+17。行距压缩至 14mm 使五行同页（官方 15mm 会让"起讫日期"溢出页底——官方样张本身即如此）；`college`/`department` 两键填学院名与系名，学院行为"学院名线＋固定字"系"＋系名线"结构 |

**v1.1.4 修正**：信息栏改为网格对齐（照 NCUBachelorThesis 参考模板做法）——标签列恒宽 5\ccwd、每行总宽恒为 22\ccwd，五行首字、冒号、下划线左右端全部上下对齐（实测线左端 x72.8、右端 x156.8）；学号/职称字段 7→6.5\ccwd、标签改紧排"学号：""职称："（3\ccwd）；行距压缩至 14mm，**"起讫日期"行回到第一页**（官方 15mm 行距下第五行溢出页底——官方样张本身即把该行挤到了次页）。

**v1.1.3 修正**：学院行由单段 8ccwd 下划线改为"学院名＋学院＋系名＋系"结构（`college`=经管、`department`=工商 → "学　院：__经管__学院 __工商__系"），"经管""工商"带下划线、"学院""系"为固定文字；`\ncufield` 改为自适应宽度（内容长于线宽时线自动加长，不溢出）。

**v1.1.2 修正**：v1.1.1 曾依据样张渲染的空白状态误删学号、职称、密级处的下划线——官方格式实为所有字段值带下划线（Word 中尾部空格的下划线在空值时不显示），已全部恢复；同时按样张实测修正学院线（6→8ccwd）、姓名/导师线（5→7.5ccwd），密级行定位改用零宽右对齐盒（标签 x133–148、下划线 x148–177.6，与样张标签位置一致）。

与旧版的结构差异：信息栏由居中改为左缩进（对齐样张字段名起点）；"起讫日期"行保留（v1.1.2 曾误删，v1.1.4 起在封面第五行显示）；密级行"密级："标签定位与样张一致（右端距右边距约 35mm），密级值带下划线字段（`info/secret-level` 的值显示在线上）。

**官方未明确、模板取通行约定的两处**（如学院另有规定，可在 `ncubachelor.cls` 中直接修改）：

1. 小节（1.1.1）及其后各级标题：小四号宋体加粗；
2. 定理类环境：编号"章.序"，头部宋体加粗。

## 七、常见问题

- **报错 "requires XeLaTeX"**：编译器选成了 pdfLaTeX，请改为 XeLaTeX。
- **中文加粗无效或字体报错**：Windows 请保持默认 `fontset=windows`；Linux/macOS 会自动回落到 Fandol（开源思源字体族），粗体为算法加粗。
- **交叉引用/文献编号显示为问号**：没有跑满编译链，请执行完整的"xelatex → bibtex → xelatex → xelatex"。
- **图片不显示**：可能处于 `draft` 模式，把类选项改为 `final` 或去掉 `draft`。
- **章节起页**：默认每章起新页但不强求奇数页；如需奇数页起章，加类选项 `openright`。

## 八、许可

本模板遵循 [LaTeX Project Public License](http://www.latex-project.org/lppl.txt)（1.3c 或更高版本）。
封面使用的校名标识与校徽标识版权归南昌大学所有，仅限本校学生撰写毕业论文使用。
