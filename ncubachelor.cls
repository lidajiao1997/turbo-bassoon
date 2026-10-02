%% =====================================================================
%% ncubachelor.cls
%% 南昌大学本科生毕业设计（论文）LaTeX 模板 —— 文档类
%%
%% 依据《南昌大学本科生毕业设计（论文）书写式样》（附件 7）编写，
%% 仅面向本科（学士学位）论文，不含研究生学位类型。
%%
%% 编译方式：XeLaTeX（xelatex -> bibtex -> xelatex -> xelatex）
%% 基础文类：ctexbook
%% ---------------------------------------------------------------------
%% 模板文件：
%%   ncubachelor.cls   本文件（文档类）
%%   ncu-name.png      封面校名标识（1.88cm x 6.59cm，居中）
%%   ncu-badge.jpg     封面校徽标识（3.33cm x 3.33cm，居中）
%%   main.tex          示例文档（可作论文骨架）
%%   references.bib    参考文献库
%% =====================================================================
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ncubachelor}
  [2026/10/02 v1.1.5 Nanchang University bachelor thesis template]

%% ---------------------------------------------------------------------
%% 0. 前置准备：expl3、引擎检查、字体方案探测、类选项
%% ---------------------------------------------------------------------
\RequirePackage{expl3}
\RequirePackage{l3keys2e}
\ExplSyntaxOn

\msg_new:nnn {ncubachelor} {unsupported-engine}
  {
    The~ncubachelor~class~requires~XeLaTeX.~
    Engine~"#1"~is~not~supported.~Please~compile~with~"xelatex".
  }
\sys_if_engine_xetex:F
  {
    \sys_if_engine_luatex:F
      { \msg_fatal:nnx {ncubachelor} {unsupported-engine} {\c_sys_engine_str} }
  }

%% 字体方案（LaTeX3 变量）：
%%   auto    —— 依次探测各平台系统字体，见 \__ncu_detect_fontset:
%%   windows —— 中易宋体等（Windows 自带）
%%   mac     —— 宋体-简/苹方等（macOS 自带）
%%   founder —— 方正字库
%%   adobe   —— 思源宋体/黑体
%%   fandol  —— Fandol 字库（TeX 发行版自带，兜底方案）
%%   none    —— 完全不设置（用户自行配置）
\str_new:N \g__ncu_fontset_str
\str_gset:Nn \g__ncu_fontset_str {auto}

%% 双面模式（twoside）：奇偶页眉与内外侧边距；默认单面
\bool_new:N \g__ncu_twoside_bool

%% 盲审模式：封面与摘要信息行的姓名/学号/导师自动遮蔽
\bool_new:N \g__ncu_blind_bool

%% 装订偏移：追踪用户是否显式给出 bindingoffset（决定 twoside 默认值）
\bool_new:N \g__ncu_binding_given_bool

%% 目录是否使用点线引导符。v1.1.5 起默认开启（用户要求）；
%% 官方样张目录无点线，如需还原可设 tocdots=false。
\bool_new:N \g__ncu_tocdots_bool
\bool_gset_true:N \g__ncu_tocdots_bool

\msg_new:nnn {ncubachelor} {unknown-option}
  { Unknown~class~option:~"\l_keys_key_str".~It~is~ignored. }
\msg_new:nnn {ncubachelor} {unknown-info}
  { Unknown~info~key:~"\l_keys_key_str".~It~is~ignored. }
\msg_new:nnn {ncubachelor} {unknown-style}
  { Unknown~style~key:~"\l_keys_key_str".~It~is~ignored. }
\msg_new:nnn {ncubachelor} {unknown-key}
  { Unknown~key:~"\l_keys_key_str".~It~is~ignored. }
\msg_new:nnn {ncubachelor} {no-info}
  { No~#1~(#2)~given.~Please~set~it~with~\ncusetup. }
\msg_new:nnn {ncubachelor} {fontset-missing}
  {
    Font~definition~file~"ncu-font-#1.def"~not~found.~
    It~must~sit~next~to~ncubachelor.cls,~or~in~the~TeX~search~path.~
    Falling~back~to~Fandol.
  }

%% 类选项（l3keys + \ProcessKeysOptions，键名遵循 LaTeX3 规范）
\keys_define:nn {ncu/option}
  {
    draft .code:n =
      {
        \PassOptionsToClass {draft} {ctexbook}
        \PassOptionsToPackage {draft} {graphicx}
      },
    final .code:n = {},
    draft .value_forbidden:n = true,
    final .value_forbidden:n = true,
    fontset .choices:nn =
      { auto, windows, mac, founder, adobe, fandol, none }
      { \str_gset:Nn \g__ncu_fontset_str {\l_keys_choice_tl} },
    fontset .value_required:n = true,
    tocdots .choice:,
    tocdots/true  .code:n = { \bool_gset_true:N  \g__ncu_tocdots_bool },
    tocdots/false .code:n = { \bool_gset_false:N \g__ncu_tocdots_bool },
    tocdots .default:n = true,
    twoside .code:n =
      {
        \bool_gset_true:N \g__ncu_twoside_bool
        \PassOptionsToClass {twoside} {ctexbook}
      },
    twoside .value_forbidden:n = true,
    oneside .code:n =
      { \bool_gset_false:N \g__ncu_twoside_bool },
    oneside .value_forbidden:n = true,
    bindingoffset .code:n =
      {
        \bool_gset_true:N \g__ncu_binding_given_bool
        \PassOptionsToPackage {bindingoffset=#1} {geometry}
      },
    bindingoffset .value_required:n = true,
    blindreview .code:n =
      { \bool_gset_true:N \g__ncu_blind_bool },
    blindreview .value_forbidden:n = true,
    openright .code:n = { \PassOptionsToClass {openright} {ctexbook} },
    openright .value_forbidden:n = true,
    unknown .code:n =
      { \msg_warning:nnx {ncubachelor} {unknown-option} {\l_keys_key_str} }
  }
\ProcessKeysOptions {ncu/option}

%% 本模板自行管理中文字体，故 ctexbook 恒用 fontset=none
\PassOptionsToClass {fontset=none} {ctexbook}
\ExplSyntaxOff

%% 装订偏移（复旦 fduthesis 思路：双面模式版心左右对称，
%% 装订偏移作为独立维度交给 geometry 的 bindingoffset 处理，
%% 偶数页自动交替到纸张右侧——即装订内侧）。
%% 用户未显式给出 bindingoffset 且选用 twoside 时，默认 5mm
%% （A4 胶装通用值；可写 bindingoffset=0mm 关闭，oneside 下亦可显式设置）。
\ExplSyntaxOn
\bool_if:NT \g__ncu_twoside_bool
  {
    \bool_if:NF \g__ncu_binding_given_bool
      { \PassOptionsToPackage {bindingoffset=5mm} {geometry} }
  }
\ExplSyntaxOff

%% ---------------------------------------------------------------------
%% 1. 基础文类：ctexbook
%%    zihao=-4        正文小四号（12bp）
%%    linespread=1.56 —— 官方样张实测中文行距 8.0mm/行
%%    （Word 的“1.35 倍行距”对 12pt 宋体的实际渲染值；LaTeX 的 1.35 仅得 6.9mm）
%%    oneside/openany 单面印刷，章起新页但不强求奇数页
%% ---------------------------------------------------------------------
\LoadClass [
  a4paper,
  zihao      = -4,
  linespread = 1.56,   % 8.0mm 基线距，见上注
  oneside,
  onecolumn,
  openany,
  punct      = quanjiao,
  fontset    = none
] {ctexbook}

%% ---------------------------------------------------------------------
%% 2. 宏包
%% ---------------------------------------------------------------------
\RequirePackage{geometry}
\RequirePackage{graphicx}
\RequirePackage{fancyhdr}
\RequirePackage{tocloft}
\RequirePackage[nottoc,notlof,notlot]{tocbibind}
\RequirePackage{enumitem}
\RequirePackage{caption}
\RequirePackage{subcaption}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{mathtools}
\RequirePackage{bm}
\RequirePackage{booktabs}
\RequirePackage{array}
\RequirePackage{multirow}
\RequirePackage{longtable}
\RequirePackage{tabularx}
\RequirePackage[sort&compress]{gbt7714}
\bibliographystyle{gbt7714-numerical}
\RequirePackage{comment}  %% 盲审模式下排除致谢页用

%% ---------------------------------------------------------------------
%% 3. 字体（具体定义外置于 ncu-font-*.def，同济 TongjiThesis 风格）
%%    fontset=auto 时按系统探测：Windows → macOS → 方正 → 思源 → Fandol
%%    探测用 fontspec 的 \IfFontExistsTF（ctex fontset=none 下 fontspec 已加载）
%% ---------------------------------------------------------------------
\ExplSyntaxOn
%% 两个字体都存在才成立（\IfFontExistsTF 不可展开，不能用 bool 谓词组合）
\cs_new_protected:Npn \__ncu_font_all_exists:nnTF #1#2#3#4
  { \IfFontExistsTF {#1} { \IfFontExistsTF {#2} {#3} {#4} } {#4} }

\cs_new_protected:Npn \__ncu_detect_fontset:
  {
    \__ncu_font_all_exists:nnTF {SimSun} {SimHei}
      { \str_gset:Nn \g__ncu_fontset_str {windows} }
      {
        \__ncu_font_all_exists:nnTF {Songti~SC} {Kaiti~SC}
          { \str_gset:Nn \g__ncu_fontset_str {mac} }
          {
            \IfFontExistsTF {FZShuSong-Z01}
              { \str_gset:Nn \g__ncu_fontset_str {founder} }
              {
                \IfFontExistsTF {Source~Han~Serif~SC}
                  { \str_gset:Nn \g__ncu_fontset_str {adobe} }
                  { \str_gset:Nn \g__ncu_fontset_str {fandol} }
              }
          }
      }
  }

%% 西文 Times：有 Times New Roman 用之，否则 TeX Gyre Termes（Times 同族）
\cs_new_protected:Npn \ncu@settimes
  {
    \IfFontExistsTF {Times~New~Roman}
      { \setmainfont {Times~New~Roman} }
      { \setmainfont {TeX~Gyre~Termes} }
  }

%% 加载字体定义文件；none 表示用户自行配置
\cs_new_protected:Npn \__ncu_load_fontset:
  {
    \str_if_eq:VnF \g__ncu_fontset_str {none}
      {
        \file_if_exist:nTF {ncu-font-\g__ncu_fontset_str.def}
          { \file_input:n {ncu-font-\g__ncu_fontset_str.def} }
          {
            \msg_warning:nnx {ncubachelor} {fontset-missing}
              {\g__ncu_fontset_str}
            \file_input:n {ncu-font-fandol.def}
          }
      }
  }
\str_if_eq:VnT \g__ncu_fontset_str {auto}
  { \__ncu_detect_fontset: }
\__ncu_load_fontset:
\ExplSyntaxOff

%% ---------------------------------------------------------------------
%% 3.1 语义化字号宏（同济 TongjiThesis 思路：版式字号只在此处定义一次，
%%     正文各处引用语义名；用户可 \renewcommand 整体调整）
%% ---------------------------------------------------------------------
\newcommand{\ncufontcover}{\zihao{4}}    %% 封面信息栏：四号
\newcommand{\ncufonttitle}{\zihao{3}}    %% 封面题目：三号
\newcommand{\ncufontchapter}{\zihao{4}}  %% 章/节标题：四号
\newcommand{\ncufontbody}{\zihao{-4}}    %% 正文：小四
\newcommand{\ncufontheader}{\songti\zihao{5}}  %% 页眉页脚：五号宋体
\newcommand{\ncufontcaption}{\songti\zihao{5}} %% 图表标题：五号
\newcommand{\ncufontabstracttitle}{\zihao{-2}} %% 摘要标题：小二
\newcommand{\ncufonttoctitle}{\songti\bfseries\zihao{-3}}  %% 目录标题：小三

%% ---------------------------------------------------------------------
%% 4. 页面设置（书写式样·第一条）
%%    上 2.54cm 下 2.54cm 左 3.67cm 右 2.67cm 页眉 1.5cm 页脚 1.75cm
%%    geometry 的 top 为纸边到正文顶的距离，页眉位于其上：
%%    页眉顶 = top - headsep - headheight = 25.4 - 5.11 - 5.29 ≈ 15mm
%%    footskip 取 7mm，使页脚数字底边落在距纸底约 17.5mm 处（页脚 1.75cm）
%% ---------------------------------------------------------------------
\geometry{
  paper      = a4paper,
  top        = 25.4mm,
  bottom     = 25.4mm,
  left       = 36.7mm,
  right      = 26.7mm,
  headheight = 15pt,
  headsep    = 14.5pt,
  footskip   = 7mm
}
\raggedbottom

%% ---------------------------------------------------------------------
%% 5. 章节标题（书写式样·第五条）
%%    章标题：中文宋体、英文 Times New Roman，四号，居中，编号“第一章”
%%    节标题：中文宋体、英文 Times New Roman，四号，居左，编号 1.1
%%    （官方样张中章、节标题均不加粗；节编号用阿拉伯数字章号）
%% ---------------------------------------------------------------------
\ctexset{
  chapter = {
    name        = {第,章},
    number      = \chinese{chapter},
    format      = \songti\ncufontchapter\centering,
    aftername   = \hspace{1em},
    beforeskip  = 12bp plus 3bp minus 4bp,
    afterskip   = 18bp plus 2bp minus 2bp,
    fixskip     = true,
    tocline     = \CTEXifname{\CTEXthechapter\hspace{1em}}{}#2
  },
  section = {
    format     = \songti\ncufontchapter,
    aftername  = \hspace{0.5em},
    beforeskip = 13bp plus 3bp minus 3bp,
    afterskip  = 8bp plus 2bp minus 1bp,
    tocline    = \CTEXthesection\hspace{1em}#2
  },
  subsection = {
    format     = \songti\bfseries\zihao{-4},
    aftername  = \hspace{0.5em},
    beforeskip = 10bp plus 2bp minus 2bp,
    afterskip  = 6bp plus 1bp minus 1bp,
    tocline    = \CTEXthesubsection\hspace{1em}#2
  },
  subsubsection = {
    format     = \songti\bfseries\zihao{-4},
    aftername  = \hspace{0.5em},
    beforeskip = 10bp plus 2bp minus 2bp,
    afterskip  = 6bp plus 1bp minus 1bp,
    tocline    = \CTEXthesubsubsection\hspace{1em}#2
  }
}
%% 小节编号使用阿拉伯数字章号：1.1 而非 一.1（与官方目录样张一致）
\renewcommand{\thesection}{\arabic{chapter}.\arabic{section}}
\renewcommand{\thesubsection}{\thesection.\arabic{subsection}}
\renewcommand{\thesubsubsection}{\thesubsection.\arabic{subsubsection}}
\ctexset{secnumdepth=3, tocdepth=2}

%% ---------------------------------------------------------------------
%% 6. 页眉页脚（书写式样·第三条）
%%    页眉自中文摘要开始，内容为相应部分的标题，五号宋体，带横线
%%    单面（默认，与官方样张一致）：章名居中
%%    双面（twoside，复旦 fduthesis 思路）：偶数页章名靠左（外侧）、
%%    奇数页章名靠右（外侧）；页码均居中（NCU 官方页码居中）
%% ---------------------------------------------------------------------
\renewcommand{\chaptermark}[1]{%
  \markboth{\CTEXifname{\CTEXthechapter\hspace{1em}}{}#1}{}}
\renewcommand{\sectionmark}[1]{}

%% 页眉样式（复旦思路：按单双面在类加载时选定页眉布局，
%% 存入 \ncu@headsetup 供 pagestyle 调用）
\newcommand{\ncu@fancyhead}[1]{\fancyhead[#1]{\ncufontheader\leftmark}}
\ExplSyntaxOn
\bool_if:NTF \g__ncu_twoside_bool
  { \cs_gset_protected:Npn \ncu@headsetup
      { \ncu@fancyhead {EL} \ncu@fancyhead {OR} } }
  { \cs_gset_protected:Npn \ncu@headsetup
      { \ncu@fancyhead {C} } }
\ExplSyntaxOff
\fancypagestyle{ncu@body}{%
  \fancyhf{}%
  \ncu@headsetup
  \fancyfoot[C]{\ncufontheader\thepage}%
  \renewcommand{\headrulewidth}{0.5pt}%
  \renewcommand{\footrulewidth}{0pt}%
}
\fancypagestyle{plain}{%
  \fancyhf{}%
  \ncu@headsetup
  \fancyfoot[C]{\ncufontheader\thepage}%
  \renewcommand{\headrulewidth}{0.5pt}%
  \renewcommand{\footrulewidth}{0pt}%
}
\pagestyle{ncu@body}

%% 双面模式下章起新页：空白偶数页不显示页眉页脚（复旦 fduthesis 做法）
%% （l3 辅助经 \cs_new_eq:NN 转为 2e 名，避免参数体中 ExplSyntax 失效）
\ExplSyntaxOn
\cs_new_protected:Npn \__ncu_cleardoublepage:
  {
    \clearpage
    \bool_if:NT \g__ncu_twoside_bool
      { \int_if_odd:nF \c@page { \hbox:n{} \thispagestyle{empty} \newpage } }
  }
\cs_new_eq:NN \ncu@cleardoublepage \__ncu_cleardoublepage:
\ExplSyntaxOff
\RenewDocumentCommand{\cleardoublepage}{}{\ncu@cleardoublepage}

%% 双面模式下正文区内外侧边距：geometry 的 left 在 twoside 下自动成为
%% 内侧（装订侧），right 成为外侧；装订偏移经 bindingoffset 实现
%% （twoside 默认 5mm，见类选项区），偶数页自动交替到纸张右侧

%% ---------------------------------------------------------------------
%% 7. 目录（书写式样·第二条）
%%    “目录”两字小三号宋体加粗居中；目录内容小四号宋体；页码数字对齐；
%%    小节标题左侧缩进 1 字符
%% ---------------------------------------------------------------------
\renewcommand{\contentsname}{目\hspace{0.5em}录}
\renewcommand{\cfttoctitlefont}{\hfill\ncufonttoctitle}
\renewcommand{\cftaftertoctitle}{\hfill}
\setlength{\cftbeforetoctitleskip}{4bp}
\setlength{\cftaftertoctitleskip}{14bp}

\renewcommand{\cftchapfont}{\songti\zihao{-4}}
\renewcommand{\cftchappagefont}{\zihao{-4}}
\setlength{\cftbeforechapskip}{6bp plus 2bp minus 1bp}
\setlength{\cftchapindent}{0em}
\setlength{\cftchapnumwidth}{0em}

\renewcommand{\cftsecfont}{\songti\zihao{-4}}
\renewcommand{\cftsecpagefont}{\zihao{-4}}
\setlength{\cftsecindent}{1em}
\setlength{\cftsecnumwidth}{2em}
\setlength{\cftbeforesecskip}{2bp plus 1bp}

\renewcommand{\cftsubsecfont}{\songti\zihao{-4}}
\renewcommand{\cftsubsecpagefont}{\zihao{-4}}
\setlength{\cftsubsecindent}{2em}
\setlength{\cftsubsecnumwidth}{2.5em}
\setlength{\cftbeforesubsecskip}{2bp plus 1bp}

\renewcommand{\cftsubsubsecfont}{\songti\zihao{-4}}
\renewcommand{\cftsubsubsecpagefont}{\zihao{-4}}
\setlength{\cftsubsubsecindent}{3em}
\setlength{\cftsubsubsecnumwidth}{3.2em}
\setlength{\cftbeforesubsubsecskip}{2bp plus 1bp}

%% 目录点线开关（v1.1.5 起默认开启；官方样张无点线，如需还原设 tocdots=false）。
%% 开启时章级条目也加引导点：tocloft 默认 \cftchapleader 无点线，
%% 且点号用 \normalfont（不随章标题加粗），与节级点线粗细一致。
\ExplSyntaxOn
\bool_if:NTF \g__ncu_tocdots_bool
  { \renewcommand{\cftdotsep}{4.5}%
    \renewcommand{\cftchapleader}{\normalfont\cftdotfill{\cftdotsep}} }
  { \renewcommand{\cftdotsep}{10000} }
\ExplSyntaxOff

%% 自定义 \tableofcontents：目录标题用小三号宋体加粗，页眉为“目录”
\renewcommand{\tableofcontents}{%
  \clearpage
  \markboth{\contentsname}{}%
  \vspace*{-4bp}%
  {\centering\ncufonttoctitle\contentsname\par}%
  \vspace{12bp}%
  \@starttoc{toc}%
  \clearpage
}

%% ---------------------------------------------------------------------
%% 8. 前置、正文、后置
%% ---------------------------------------------------------------------
\renewcommand{\frontmatter}{%
  \clearpage
  \@mainmatterfalse
  \pagenumbering{Roman}%
}
\renewcommand{\mainmatter}{%
  \clearpage
  \@mainmattertrue
  \pagenumbering{arabic}%
}
\renewcommand{\backmatter}{%
  \clearpage
  \@mainmatterfalse
}

%% ---------------------------------------------------------------------
%% 9. 元信息与 \ncusetup
%% ---------------------------------------------------------------------
%% 封面用下划线字段：#1 最小宽度，#2 内容
%% 内容宽于 #1 时线自动加长（自适应），不溢出；否则按 #1 定宽居中
\newcommand{\ncufield}[2]{%
  \begingroup
    \setbox0=\hbox{#2}%
    \ifdim\wd0>#1\relax
      \makebox[0pt][l]{\rule[-0.25em]{\wd0}{0.4pt}}%
      \makebox[\wd0][c]{#2}%
    \else
      \makebox[0pt][l]{\rule[-0.25em]{#1}{0.4pt}}%
      \makebox[#1][c]{#2}%
    \fi
  \endgroup}
%% 题目用的整块下划线
\newcommand{\ncu@ulineblock}[2]{%
  \makebox[0pt][l]{\rule[-0.25em]{#1}{0.4pt}}%
  \parbox[c]{#1}{\centering #2}}

%% 元信息（@ 在 .cls 中为字母，ExplSyntax 内外均可使用）
\gdef\ncu@secretlevel{}
\gdef\ncu@title{}
\gdef\ncu@entitle{}
\gdef\ncu@college{}
\gdef\ncu@department{}
\gdef\ncu@majorclass{}
\gdef\ncu@major{}
\gdef\ncu@author{}
\gdef\ncu@studentid{}
\gdef\ncu@supervisor{}
\gdef\ncu@supervisortitle{}
\gdef\ncu@startdate{}
\gdef\ncu@stopdate{}
\gdef\ncu@startstopdate{}
\gdef\ncu@nameimage{ncu-name.png}
\gdef\ncu@badgeimage{ncu-badge.jpg}

\ExplSyntaxOn
\keys_define:nn {ncu/info}
  {
    secret-level     .code:n = { \xdef\ncu@secretlevel{#1} },
    title            .code:n = { \xdef\ncu@title{#1} },
    title*           .code:n = { \xdef\ncu@entitle{#1} },
    college          .code:n = { \xdef\ncu@college{#1} },
    department       .code:n = { \xdef\ncu@department{#1} },
    major-class      .code:n = { \xdef\ncu@majorclass{#1} },
    major            .code:n = { \xdef\ncu@major{#1} },
    author           .code:n = { \xdef\ncu@author{#1} },
    studentid        .code:n = { \xdef\ncu@studentid{#1} },
    supervisor       .code:n = { \xdef\ncu@supervisor{#1} },
    supervisor-title .code:n = { \xdef\ncu@supervisortitle{#1} },
    start-date       .code:n = { \xdef\ncu@startdate{#1} },
    stop-date        .code:n = { \xdef\ncu@stopdate{#1} },
    start-stop-date  .code:n = { \xdef\ncu@startstopdate{#1} },
    unknown .code:n =
      { \msg_warning:nnx {ncubachelor} {unknown-info} {\l_keys_key_str} }
  }
\keys_define:nn {ncu/style}
  {
    name-image  .code:n = { \xdef\ncu@nameimage{#1} },
    badge-image .code:n = { \xdef\ncu@badgeimage{#1} },
    unknown .code:n =
      { \msg_warning:nnx {ncubachelor} {unknown-style} {\l_keys_key_str} }
  }
%% 盲审配置：\ncusetup{blind={text={***}, hide-acknowledgement=true}}
\bool_new:N \g__ncu_blind_hideack_bool
\gdef\ncu@blindtext{***}
\keys_define:nn {ncu/blind}
  {
    text .code:n = { \xdef\ncu@blindtext{#1} },
    hide-acknowledgement .choice:,
    hide-acknowledgement/true  .code:n =
      { \bool_gset_true:N \g__ncu_blind_hideack_bool },
    hide-acknowledgement/false .code:n =
      { \bool_gset_false:N \g__ncu_blind_hideack_bool },
    hide-acknowledgement .default:n = true,
    unknown .code:n =
      { \msg_warning:nnx {ncubachelor} {unknown-style} {\l_keys_key_str} }
  }
\keys_define:nn {ncu}
  {
    info  .meta:nn = {ncu/info}  {#1},
    style .meta:nn = {ncu/style} {#1},
    blind .meta:nn = {ncu/blind} {#1},
    unknown .code:n =
      { \msg_warning:nnx {ncubachelor} {unknown-key} {\l_keys_key_str} }
  }
\NewDocumentCommand \ncusetup {m} { \keys_set:nn {ncu} {#1} }
\ExplSyntaxOff

%% ---------------------------------------------------------------------
%% 9.1 语义化信息命令：正文/封面/摘要统一从这里取元信息。
%%     盲审模式下，姓名、学号、导师、职称自动替换为 \ncu@blindtext，
%%     源信息（\ncusetup 所设）保持不变，正式版与盲审版一键切换。
%% ---------------------------------------------------------------------
\ExplSyntaxOn
\NewDocumentCommand \ncu@blindify {m}
  { \bool_if:NTF \g__ncu_blind_bool { \ncu@blindtext } {#1} }
\ExplSyntaxOff
\newcommand{\thesistitle}{\ncu@title}
\newcommand{\thesisentitle}{\ncu@entitle}
\newcommand{\thesiscollege}{\ncu@college}
\newcommand{\thesisdepartment}{\ncu@department}
\newcommand{\thesismajorclass}{\ncu@majorclass}
\newcommand{\thesismajor}{\ncu@major}
\newcommand{\thesisauthor}{\ncu@blindify{\ncu@author}}
\newcommand{\thesisstudentid}{\ncu@blindify{\ncu@studentid}}
\newcommand{\thesissupervisor}{\ncu@blindify{\ncu@supervisor}}
\newcommand{\thesissupervisortitle}{\ncu@blindify{\ncu@supervisortitle}}
\newcommand{\thesisdates}{\ncu@startstopdate}
%% 盲审模式的 PDF 元数据在 hyperref 加载后处理（见第 20 节）

%% ---------------------------------------------------------------------
%% 10. 封面（v1.1.1 依官方样张 page-2 像素级校准，150dpi 行投影测量）
%%     密级：宋体四号，标签右端距右边距约 35mm，值带下划线字段；
%%     校名标识 1.88x6.59cm 居中（y 38.8-56.0mm）；
%%     校名外文（大写）Times New Roman 四号居中（y 58.4mm）；
%%     “学士学位论文”宋体 30 磅居中（y 69.4mm）；
%%     “THESIS OF BACHELOR”Times New Roman 四号居中（y 83.8mm）；
%%     年份行四号居中（y 93.3mm）；校徽 3.33x3.33cm 居中（y ~110mm）；
%%     题目宋体三号居中（y 178.1mm）；信息栏宋体四号左缩进 11.5mm，
%%     五行网格对齐（v1.1.4）：标签列恒宽 5\ccwd、每行总宽恒 22\ccwd，
%%     首字/冒号/下划线左右端全部上下对齐；行距 14mm 使五行同页
%%     （官方 15mm 行距会让"起讫日期"溢出页底）
%% ---------------------------------------------------------------------
\renewcommand{\maketitle}{%
  \begin{titlepage}
    \parindent 0pt
    \songti\zihao{4}%
    \vspace*{-6.5mm}%
    %% 密级：宋体四号，值带下划线；零宽右对齐盒 + 盒内右空 5.7mm，
    %% 使标签落在 x133.2-148.0、下划线 x148.0-177.6（与样张标签位置一致）
    {\hfill\makebox[0pt][r]{密级：\ncufield{6\ccwd}{\ncu@secretlevel}\hspace*{5.7mm}}\par}
    \vspace{-0.4mm}
    \begin{center}
      %% 校名标识：1.88cm x 6.59cm，居中
      \includegraphics[width=6.59cm,height=1.88cm]{\ncu@nameimage}\\[-4.2mm]
      %% 校名外文（大写）：Times New Roman，四号，居中
      {\bfseries\zihao{4}NANCHANG\hspace{1em}UNIVERSITY}\\[7.1mm]
      %% 学士学位论文：宋体 30 磅，居中
      {\bfseries\fontsize{30bp}{40bp}\selectfont
        学\hspace{0.45em}士\hspace{0.45em}学\hspace{0.45em}位\hspace{0.45em}论\hspace{0.45em}文}\\[0mm]
      %% THESIS OF BACHELOR：Times New Roman，四号，居中
      {\bfseries\zihao{4}THESIS\hspace{1em}OF\hspace{1em}BACHELOR}\\[0.8mm]
      %% （20XX —20XX 年）：中文宋体、数字 Times New Roman，四号，居中
      {\zihao{4}（20\ncu@startdate\hspace{0.3em}—20\ncu@stopdate\hspace{0.3em}年）}\\[9mm]
      %% 校徽标识：3.33cm x 3.33cm，居中
      \includegraphics[width=3.33cm,height=3.33cm]{\ncu@badgeimage}
    \end{center}
    \vspace{26.6mm}
    %% 题目：宋体三号，居中
    {\ncufonttitle%
      \makebox[3\ccwd][l]{题\hfill 目}\hspace{0.5em}%
      \ncu@ulineblock{.76\textwidth}{\thesistitle}\par}
    \vspace{20.4mm}
    %% 信息栏：宋体四号。网格对齐（照 NCUBachelorThesis 参考模板做法）：
    %%   标签列恒宽 5\ccwd 且左对齐 —— 五行首字、冒号全部上下对齐；
    %%   每行总宽恒为 22\ccwd       —— 下划线右端全部上下对齐。
    %% 行宽构成：
    %%   学院    5 + 8(线) + 1(系) + 8(线)                  = 22
    %%   专业班级 5 + 17(线)                                = 22
    %%   学生姓名 5 + 7.5(线) + 3(学号：) + 6.5(线)          = 22
    %%   指导教师 5 + 7.5(线) + 3(职称：) + 6.5(线)          = 22
    %%   起讫日期 5 + 17(线)                                = 22
    %% 行距压缩至 14mm（官方 15mm 会使第 5 行溢出页底——官方样张本身
    %% 就把"起讫日期"挤到了次页），五行同页。
    {\ncufontcover
      \hspace*{11.5mm}%
      %% 学院行：学　院：+ 8\ccwd 线 + 系（固定字）+ 8\ccwd 线
      \makebox[5\ccwd][l]{学\hfill 院：}%
      \ncufield{8\ccwd}{\thesiscollege}%
      \makebox[\ccwd][c]{系}%
      \ncufield{8\ccwd}{\thesisdepartment}\\[4.75mm]
      \hspace*{11.5mm}%
      \makebox[5\ccwd][l]{专业班级：}\ncufield{17\ccwd}{\thesismajorclass}\\[4.75mm]
      \hspace*{11.5mm}%
      \makebox[5\ccwd][l]{学生姓名：}\ncufield{7.5\ccwd}{\thesisauthor}%
      \makebox[3\ccwd][l]{学号：}\ncufield{6.5\ccwd}{\thesisstudentid}\\[4.75mm]
      \hspace*{11.5mm}%
      \makebox[5\ccwd][l]{指导教师：}\ncufield{7.5\ccwd}{\thesissupervisor}%
      \makebox[3\ccwd][l]{职称：}\ncufield{6.5\ccwd}{\thesissupervisortitle}\\[4.75mm]
      \hspace*{11.5mm}%
      \makebox[5\ccwd][l]{起讫日期：}\ncufield{17\ccwd}{\thesisdates}%
    \par}
  \end{titlepage}}

%% ---------------------------------------------------------------------
%% 11. 原创性申明与授权书（一页，官方样张注明“此页可直接下载”）
%% ---------------------------------------------------------------------
\newcommand{\ncu@square}{%
  \begingroup
    \setlength{\fboxrule}{0.4pt}\setlength{\fboxsep}{0pt}%
    \framebox[1.4ex][c]{\rule{0pt}{1.4ex}}%
  \endgroup}

\newcommand{\makedecaut}{%
  \thispagestyle{empty}%
  \songti\zihao{-4}%
  \linespread{1.76}\selectfont   % 本页官方样张实测行距 9.0mm
  \parindent 2\ccwd
  \vspace*{-7.2mm}
  \begin{center}
    {\bfseries\zihao{3}南\hspace{0.5em}昌\hspace{0.5em}大\hspace{0.5em}学}\\[1.2mm]
    {\bfseries\zihao{3}学士学位论文原创性申明}
  \end{center}
  \vspace{-3.1mm}
  \noindent\hspace{2\ccwd}\ignorespaces 本人郑重申明：所呈交的论文是本人在导师的指导下独立进行研究所取得的
  研究成果。除了文中特别加以标注引用的内容外，本论文不包含任何其他个
  人或集体已经发表或撰写的成果。对本文的研究作出重要贡献的个人和集体，
  均已在文中以明确方式表明。本人完全意识到本申明的法律后果由本人承担。
  \par\vspace{6.5mm}
  \indent 作者签名：\hspace{11.6\ccwd}日期：
  \par\vspace{32.0mm}
  \begin{center}
    {\bfseries\zihao{3}学位论文版权使用授权书}
  \end{center}
  \vspace{-3.2mm}
  \noindent\hspace{2\ccwd}\ignorespaces 本学位论文作者完全了解学校有关保留、使用学位论文的规定，同意学校保
  留并向国家有关部门或机构送交论文的复印件和电子版，允许论文被查阅和
  借阅。本人授权南昌大学可以将本论文的全部或部分内容编入有关数据库进
  行检索，可以采用影印、缩印或扫描等复制手段保存和汇编本学位论文。
  \par
  \noindent\hspace{12\ccwd}保密\ncu@square，在\hspace{2\ccwd}年解密后适用本授权书。
  \par\indent 本学位论文属于
  \par\noindent\hspace{12\ccwd}不保密\ncu@square。
  \par\noindent\hspace{2\ccwd}（请在以上相应方框内打“\checkmark”）
  \par
  \indent 作者签名：\hspace{11.6\ccwd}日期：
  \par\vspace{7.2mm}
  \indent 导师签名：\hspace{11.6\ccwd}日期：
  \clearpage
  \linespread{1.56}\selectfont
}

%% ---------------------------------------------------------------------
%% 12. 中英文摘要（书写式样·第四条）
%%     中文摘要：标题小二号宋体加粗；“专业、学号、姓名、指导教师”五号宋体；
%%     “摘要”两字四号宋体；内容小四号宋体；“关键词”三字小四号宋体加粗
%%     英文摘要：标题小二号 Times New Roman 加粗；“Abstract”四号；
%%     内容小四号 Times New Roman；“Keyword”小四号加粗
%% ---------------------------------------------------------------------
\newenvironment{abstract}{%
  \def\keywords##1{\gdef\ncu@cnkws{##1}}%
  \gdef\ncu@cnkws{}%
  \markboth{摘要}{}%
  \addcontentsline{toc}{chapter}{摘要}%
  \begin{center}
    {\bfseries\ncufontabstracttitle\thesistitle\par}
    \vspace{4mm}
    {\songti\zihao{5}\begin{tabular}{r@{\makebox[1\ccwd][l]{：}}l
                                  @{\hspace{4\ccwd}}
                                  r@{\makebox[1\ccwd][l]{：}}l}
      专\hfill 业 & \thesismajor & 学\hfill 号 & \thesisstudentid \\
      学生姓名     & \thesisauthor & 指导教师   & \thesissupervisor
    \end{tabular}\par}
    \vspace{5mm}
    {\songti\zihao{4}摘\hspace{1em}要\par}
  \end{center}
  \vspace{2mm}\noindent\hspace{2\ccwd}\ignorespaces%
}{%
  \par\vspace{4mm}%
  \noindent{\bfseries\songti\zihao{-4}关键词：}\ncu@cnkws
  \clearpage
}

\newenvironment{abstract*}{%
  \def\keywords##1{\gdef\ncu@enkws{##1}}%
  \gdef\ncu@enkws{}%
  \markboth{Abstract}{}%
  \addcontentsline{toc}{chapter}{Abstract}%
  \begin{center}
    {\bfseries\ncufontabstracttitle\thesisentitle\par}
    \vspace{5mm}
    {\zihao{4}Abstract\par}
  \end{center}
  \linespread{1.29}\selectfont   % 英文页官方样张实测行距 6.6mm（Times 字体）
  \vspace{2mm}\noindent\hspace{2\ccwd}\ignorespaces%
}{%
  \par\vspace{4mm}%
  \noindent{\bfseries\zihao{-4}Keyword:}\ \ncu@enkws
  \clearpage
  \linespread{1.56}\selectfont
}

%% ---------------------------------------------------------------------
%% 13. 图表（书写式样·第六条）
%%     图表内容五号宋体；图表标题五号宋体加粗居中，表标题置上、图标题置下；
%%     图序与图名之间空一个汉字宽度；编号“图1-1”“表1-1”
%% ---------------------------------------------------------------------
\renewcommand{\thetable}{\arabic{chapter}-\arabic{table}}
\renewcommand{\thefigure}{\arabic{chapter}-\arabic{figure}}
\renewcommand{\theequation}{\arabic{chapter}-\arabic{equation}}
\renewcommand{\thesubfigure}{(\alph{subfigure})}
\renewcommand{\thesubtable}{(\alph{subtable})}

\DeclareCaptionFont{ncu@wuhao}{\ncufontcaption}
\DeclareCaptionLabelSeparator{ncu@ccwd}{\hspace{1\ccwd}}
\captionsetup{
  font            = {ncu@wuhao,bf},
  labelfont       = {ncu@wuhao,bf},
  labelsep        = ncu@ccwd,
  justification   = centering,
  singlelinecheck = true
}
\captionsetup[table]{position=above, skip=6bp}
\captionsetup[figure]{position=below, skip=6bp}
\captionsetup[sub]{font={ncu@wuhao,bf}, labelfont={ncu@wuhao,bf}}

%% 浮动体内容五号宋体
\g@addto@macro\@floatboxreset{\songti\zihao{5}}

%% ---------------------------------------------------------------------
%% 14. 列表
%% ---------------------------------------------------------------------
\setlist{
  topsep      = 2bp plus 1bp minus 1bp,
  parsep      = 1bp,
  partopsep   = 0bp,
  itemsep     = 1bp,
  leftmargin  = 2\ccwd,
  rightmargin = 0pt
}
\setlist[itemize,1]{label=\textbullet}
\setlist[itemize,2]{label=\normalfont\bfseries\textendash}
\setlist[enumerate,1]{label=\arabic*.\kern-0.1em}
\setlist[enumerate,2]{label=(\arabic*)}

%% ---------------------------------------------------------------------
%% 15. 脚注（小五号宋体）
%% ---------------------------------------------------------------------
\renewcommand{\footnotesize}{\@setfontsize\footnotesize{9bp}{11bp}}
\setlength{\footnotesep}{9bp}
\setlength{\skip\footins}{12bp plus 3bp minus 3bp}
\renewcommand{\footnoterule}{%
  \kern-1bp\hrule height 0.4pt width 0.25\columnwidth\kern 3bp}
\long\def\@makefntext#1{%
  \parindent 1em\noindent
  \hb@xt@ 1.8em{\hss\@textsuperscript{\normalfont\@thefnmark}\hspace{0.3em}}#1}

%% ---------------------------------------------------------------------
%% 16. 无编号章（结论、参考文献、致谢等）
%% ---------------------------------------------------------------------
\newcommand{\unnumberedchapter}[1]{%
  \clearpage
  \markboth{#1}{}%
  \addcontentsline{toc}{chapter}{#1}%
  \chapter*{#1}%
}

%% 参考文献标题“参考文献”（四号宋体居中），并进目录
\renewcommand{\bibname}{参考文献}
%% 参考文献条目小四号宋体
\renewcommand{\bibfont}{\songti\zihao{-4}}
\setlength{\bibsep}{2bp plus 1bp}

%% ---------------------------------------------------------------------
%% 17. 致谢（书写式样·第八条：标题四号宋体居中，内容小四号宋体）
%%     盲审模式可经 \ncusetup{blind={hide-acknowledgement=true}} 排除整页
%% ---------------------------------------------------------------------
\newenvironment{acknowledgements}{%
  \unnumberedchapter{致谢}%
  \def\signoff##1##2{\par\vspace{8mm}\noindent\hfill ##1\par\noindent\hfill ##2\par}%
}{\clearpage}
\ExplSyntaxOn
\ctex_at_end_preamble:n
  {
    \bool_if:NT \g__ncu_blind_hideack_bool
      { \excludecomment{acknowledgements} }
  }
\ExplSyntaxOff

%% ---------------------------------------------------------------------
%% 18. 附加实用命令
%% ---------------------------------------------------------------------
%% 三线表的粗横线
\newcommand{\thickhline}{%
  \noalign{\ifnum0=`}\fi
  \hrule \@height 1.2pt
  \futurelet\@let@token\@xhline}

%% 证明结束符号（文字模式与数学模式均可）
\newcommand{\freeze}{%
  \ifmmode
    \tag*{$\blacksquare$}%
  \else
    \unskip\nobreak\hfill\penalty50\hskip 1em
    \hbox{}\nobreak\hfill$\blacksquare$
    \par\penalty 10001
  \fi}

%% 正文第一页的无编号脚注（标注项目来源等）
\newcommand{\blfootnote}[1]{%
  \begingroup
    \renewcommand{\thefootnote}{}\footnote{#1}%
    \addtocounter{footnote}{-1}%
  \endgroup}

%% ---------------------------------------------------------------------
%% 19. 定理类环境（LaTeX3 配置接口）
%%     官方未规定样式，取通行约定：编号“章.序”，头部宋体加粗
%%     可配置项（导言区 \ncusetup{...}）：
%%       theorem/header-font = <命令序列>   头部字体，默认 \songti\bfseries
%%       theorem/within      = chapter|section|none  编号锚点，默认 chapter
%%       proof/qed           = <符号>       证明结束符，默认 $\blacksquare$
%% ---------------------------------------------------------------------
\ExplSyntaxOn
\tl_new:N \l__ncu_thm_headerfont_tl
\tl_new:N \l__ncu_thm_number_tl
\tl_new:N \l__ncu_proof_qed_tl
\keys_define:nn {ncu/theorem}
  {
    header-font .code:n = { \tl_set:Nn \l__ncu_thm_headerfont_tl {#1} },
    within .choice:,
    within/chapter .code:n =
      { \tl_set:Nn \l__ncu_thm_number_tl {\arabic{chapter}.} },
    within/section .code:n =
      { \tl_set:Nn \l__ncu_thm_number_tl {\thesection.} },
    within/none    .code:n =
      { \tl_set:Nn \l__ncu_thm_number_tl {} },
    within .default:n = chapter,
  }
\keys_define:nn {ncu/proof}
  {
    qed .code:n = { \tl_set:Nn \l__ncu_proof_qed_tl {#1} },
  }
\keys_set:nn {ncu/theorem}
  { header-font = \songti\bfseries, within = chapter }
\keys_set:nn {ncu/proof}
  { qed = $\blacksquare$ }
\keys_define:nn {ncu}
  {
    theorem .meta:nn = {ncu/theorem} {#1},
    proof   .meta:nn = {ncu/proof}   {#1},
  }
%% 转为 2e 名，供 ExplSyntaxOff 区域使用
\cs_new_eq:NN \ncu@thmheaderfont \l__ncu_thm_headerfont_tl
\cs_new_eq:NN \ncu@thmnumber     \l__ncu_thm_number_tl
\cs_new_eq:NN \ncu@proofqed      \l__ncu_proof_qed_tl
\ExplSyntaxOff

\newcommand{\ncu@newthm}[2]{%
  \newcounter{ncu@#1}[chapter]%
  \expandafter\def\csname thencu@#1\endcsname{\ncu@thmnumber\arabic{ncu@#1}}%
  \newenvironment{#1}[1][]{%
    \par\vspace{4bp plus 1bp}%
    \refstepcounter{ncu@#1}%
    \noindent{\ncu@thmheaderfont
      \csname thencu@#1\endcsname\ #2}%
    \ifx\relax##1\relax\else（##1）\fi\hspace{0.5em}\ignorespaces
  }{\par\vspace{4bp plus 1bp}}}
\ncu@newthm{theorem}{定理}
\ncu@newthm{law}{定律}
\ncu@newthm{principle}{原理}
\ncu@newthm{axiom}{公理}
\ncu@newthm{lemma}{引理}
\ncu@newthm{inference}{推论}
\ncu@newthm{conclusion}{结论}
\ncu@newthm{proposition}{命题}
\ncu@newthm{definition}{定义}
\ncu@newthm{assumption}{假设}
\ncu@newthm{property}{性质}
\ncu@newthm{remark}{注解}
\ncu@newthm{condition}{条件}
\ncu@newthm{example}{例}
\newenvironment{proof}[1][证明]{%
  \par\vspace{4bp plus 1bp}%
  \noindent{\ncu@thmheaderfont #1}\hspace{0.5em}\ignorespaces
}{\hfill\ncu@proofqed\par\vspace{4bp plus 1bp}}

%% ---------------------------------------------------------------------
%% 20. 超链接（最后加载）
%% ---------------------------------------------------------------------
\RequirePackage[
  hidelinks,
  bookmarksnumbered=true,
  bookmarksopen=true,
  pdfstartview=FitH
]{hyperref}
%% 盲审模式：清除 PDF 元数据中的作者痕迹（ExplSyntaxOff 处借助分支）
\ExplSyntaxOn
\bool_if:NT \g__ncu_blind_bool
  { \hypersetup { pdfauthor={} , pdfcreator={LaTeX~with~ncubachelor} } }
\ExplSyntaxOff
\pdfstringdefDisableCommands{\def\quad{}\def\qquad{}\def\hspace#1{}}

\endinput
%% ncubachelor.cls 结束
