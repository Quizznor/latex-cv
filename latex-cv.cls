\ProvidesClass{latex-cv}[2021/04/14 LaTeX CV Class]
\NeedsTeXFormat{LaTeX2e}
\LoadClass{article}


%------------------------------------------------------------------------------
% PACKAGES
%------------------------------------------------------------------------------

\RequirePackage[T1]{fontenc}
\RequirePackage{tikz}
\RequirePackage{xcolor}
\RequirePackage{ragged2e}
\RequirePackage{etoolbox}
\RequirePackage{ifmtarg}
\RequirePackage{ifthen}
\RequirePackage{pgffor}
\RequirePackage{marvosym}
\RequirePackage{parskip}
\RequirePackage{tabularx}
\RequirePackage{hyperref}
\RequirePackage{fontawesome}
\RequirePackage[sfdefault]{ClearSans}
\RequirePackage[absolute,overlay]{textpos}
\RequirePackage[english,ngerman]{babel}
\RequirePackage[left=7.6cm,top=0.1cm,right=1cm,bottom=0.2cm,nohead,nofoot]{geometry}


%------------------------------------------------------------------------------
%	 LANGUAGE
%------------------------------------------------------------------------------

\newcommand{\SelectLanguage}[1]{%
	\selectlanguage{#1}

	% english language support
	\iflanguage{english}{%
	\newcommand{\SkillSectionName}{Skills}
	\newcommand{\LanguageSectionName}{Languages}
	\newcommand{\CEFRDisclaimer}{Proficiency levels conform to \textit{CEFR} standard}
	}{}

	% german language support
	\iflanguage{ngerman}{%
	\newcommand{\SkillSectionName}{Fähigkeiten}
	\newcommand{\LanguageSectionName}{Sprachen}
	\newcommand{\CEFRDisclaimer}{Sprachniveau orientiert sich am \textit{GER} Standard}
	}{}

	% Add your own language here, don't forget to load it with babel on line 25
	% \iflanguage{...}{%
	% ...
	% }{}
}


%------------------------------------------------------------------------------
%	 COLOURS
%------------------------------------------------------------------------------

\definecolor{SectionForeground}{RGB}{255,255,255}					% White for (sub-) section foreground
\definecolor{SidebarBackground}{RGB}{237, 237, 237}				% Light gray for sidebar background
\definecolor{AccentBlue}{RGB}{14, 84, 132}								% Blue for hard accents with sidebar etc.
\definecolor{AccentGray}{RGB}{186, 186, 186}							% Gray for soft accents with subsection etc.


%------------------------------------------------------------------------------
%	 GENERAL PDF LAYOUT
%------------------------------------------------------------------------------

\pagestyle{empty}																					% Disable headers and footers
\setlength{\parindent}{0pt} 															% Disable paragraph indentation

\setlength{\TPHorizModule}{1cm} 													% Left margin
\setlength{\TPVertModule}{1cm} 														% Top margin


%------------------------------------------------------------------------------
%	 SIDEBAR DEFINITIONS
%------------------------------------------------------------------------------

% Add horizontal line to profilesections
\newlength{\TotalSectionLength}
\newlength{\SectionTitleLength}
\newcommand{\profilesection}[1]{%
	\setlength\TotalSectionLength{\linewidth}
	\settowidth{\SectionTitleLength}{\huge #1 }
	\addtolength\TotalSectionLength{-\SectionTitleLength}
	{\vspace{-1pt}\huge #1 \rule[0.15\baselineskip]{\TotalSectionLength}{1pt}\vspace{7pt}}
}

% Slap an icon in front of general information
\newcommand{\icon}[1]{%
	\noindent\parbox[c]{\hsize}{%
		\textsc{\tikz[baseline=(char.base)]{%
			\node[shape=circle,draw,minimum size=17pt,inner sep=0pt,%
			fill=AccentBlue,AccentBlue,text=SectionForeground] (char) {#1};
			}
		}
	}
}

% Force elements in CV information into different lines
\newcounter{ListLength}
\newcommand{\listview}[1]{
	\setcounter{ListLength}{0}
	\foreach \item in #1{\addtocounter{ListLength}{1}}
	\foreach [count=\i] \item in #1{%
		\ifthenelse{\equal{\i}{\value{ListLength}}}%
		{\item}%
		{\item \par}
	}
}

% General information such as name, address, etc.
\newcommand{\cvpicture}[1]{\renewcommand{\cvpicture}{#1}}
\newcommand{\cvname}[1]{\renewcommand{\cvname}{#1}}
\newcommand{\cvtitle}[1]{\renewcommand{\cvtitle}{#1}}
\newcommand{\cvphone}[1]{\renewcommand{\cvphone}{#1}}
\newcommand{\cvaddress}[1]{\renewcommand{\cvaddress}{#1}}
\newcommand{\cvmail}[1]{\renewcommand{\cvmail}{#1}}
\newcommand{\cvwebsite}[1]{\renewcommand{\cvwebsite}{#1}}
\newcommand{\cvgithub}[1]{\renewcommand{\cvgithub}{#1}}
\newcommand{\cvlinkedin}[1]{\renewcommand{\cvlinkedin}{#1}}
\newcommand{\cvbirthday}[1]{\renewcommand{\cvbirthday}{#1}}

% Command for printing skill progress bars
\newcommand\skills[1]{\renewcommand{\skills}{
	\begin{tikzpicture}
		\foreach [count=\i] \x/\y in {#1}{
			\draw[fill=AccentGray,AccentGray,rounded corners] (0,-\i) rectangle (6,-\i+0.4);
			\draw[fill=SectionForeground,AccentBlue,rounded corners](0,-\i) rectangle (\y,-\i+0.4);
			\node [above right] at (0,-\i+0.4) {\x};
		}
	\end{tikzpicture}}
}

% Command for printing language skills
\newcommand\languages[1]{
	\newcounter{LanguageCounter}
	\newcommand{\levels}{A1,A2,B1,B2,C1,C2}
	\renewcommand{\languages}{
		\begin{tikzpicture}

			% Print language level indicator
			\foreach \thing [count=\i] in \levels{
				\node [above right] at (2.55 + 0.5*\i,0) {\thing};
			}

			% Print the language flag
			\foreach [count=\j] \x/\y in {#1}{%
				\addtocounter{LanguageCounter}{1}
				\node [below right] at (0,0.7-0.62*\j) {\includegraphics[height=10pt,width=16.67pt]{./flags/\x.png}\;\;\;\x};

				% Print language level indicators
				\foreach \k in {1,2,...,6}{
					\ifthenelse{\y<\k}{%
					\filldraw[fill=AccentGray,draw=AccentGray] (2.85 + 0.5*\k,0.29-0.62*\j) circle (5pt);}		% Gray circle
					{\filldraw[fill=AccentBlue,draw=AccentBlue] (2.85 + 0.5*\k,0.29-0.62*\j) circle (5pt);}		% Blue circle
				}
			}

		% Print CEFR disclaimer footnote
		\node [below right] at (0,-0.62*\value{LanguageCounter}-0.1) {\centering\footnotesize{\CEFRDisclaimer}};

		\end{tikzpicture}
	}
}

%------------------------------------------------------------------------------
%	 SIDEBAR LAYOUT
%------------------------------------------------------------------------------

\newcommand{\makeprofile}{
	\begin{tikzpicture}[remember picture,overlay]
  	\node [rectangle, fill=SidebarBackground, anchor=north,minimum width=9cm,%
		minimum height=\paperheight+1cm] (box) at (-5cm,0.5cm){};
	\end{tikzpicture}

	\begin{textblock}{6}(0.5, 0.2)

		% PROFILE PICTURE ---------------------------------------------------------

		\ifthenelse{\equal{\cvpicture}{}}{}{

			\newlength\imagewidth
			\newlength\imagescale
			\pgfmathsetlength{\imagewidth}{5cm}
			\pgfmathsetlength{\imagescale}{\imagewidth/600}

			\begin{flushleft}
				\begin{tikzpicture}[x=\imagescale,y=-\imagescale]
				\draw[clip] (0cm, 0cm)
					[rounded corners=5pt] -- (0cm, 4.9cm)
					[rounded corners=10pt] -- (5.5cm, 4.9cm)
					[rounded corners=0.5cm] -- (5.5cm, 0cm)
					[sharp corners] -- cycle;
					\node[anchor=south west,%
        inner sep=0,%
        outer sep=0pt] (image) at (-0.2cm, 0cm) {\includegraphics[width=6cm,height=5cm]{\cvpicture}};
				\end{tikzpicture}
			\end{flushleft}
			\vspace{-10pt}
		}

		% CV NAME AND TITLE -------------------------------------------------------

		\begin{flushleft}
		\Huge\color{AccentBlue}\cvname \\
		\color{black}\normalsize\;\cvtitle
		\end{flushleft}

		% CV CONTACT INFORMATION --------------------------------------------------

		\renewcommand{\tabcolsep}{0.25cm}
		\renewcommand{\arraystretch}{1}
		\begin{tabularx}{0.5\textwidth}{m{10pt} m{4cm}}
  		\ifthenelse{\equal{\cvaddress}{}}{}{\icon{\faEnvelopeO} & \listview{\cvaddress} \\}
			\ifthenelse{\equal{\cvphone}{}}{}{\icon{\faPhone} & \listview{\cvphone} \\}
			\ifthenelse{\equal{\cvmail}{}}{}{\icon{@} & \href{mailto:\cvmail}{\cvmail} \\}
			\ifthenelse{\equal{\cvwebsite}{}}{}{\icon{\faGlobe} & \href{\cvwebsite}{\cvwebsite} \\}
			\ifthenelse{\equal{\cvgithub}{}}{}{\icon{\faGithub} & \href{https://www.\cvgithub}{\cvgithub} \\}
			\ifthenelse{\equal{\cvlinkedin}{}}{}{\icon{\faLinkedin} & \href{https://www.\cvlinkedin}{\cvlinkedin} \\}
			\ifthenelse{\equal{\cvbirthday}{}}{}{\icon{\faBirthdayCake} & \cvbirthday \\}
		\end{tabularx}
		\vspace{-8pt}

		% PROFILE SECTIONS --------------------------------------------------------

		\profilesection{\SkillSectionName}
			\skills																							% Print skill bars
			\vspace{15pt}																				% Margin to next section

		\profilesection{\LanguageSectionName}
			\languages																					% Print languages
			\vspace{15pt}																				% Margin to next section

	\end{textblock}
}


%------------------------------------------------------------------------------
%	 MAIN CV
%------------------------------------------------------------------------------

% SECTIONS --------------------------------------------------------------------

% Color the background of sections and add horizontal line
\newcommand{\sectionbox}[2]{%
	\setlength\TotalSectionLength{\linewidth}
	\settowidth{\SectionTitleLength}{#1}
	\addtolength\TotalSectionLength{-\SectionTitleLength}
	\addtolength\TotalSectionLength{-0.2cm}
	{\color{black!80} \tikz[baseline=(char.base)]\node[anchor=north west,%
	draw,rectangle, rounded corners, inner sep=4pt, minimum size=5.5mm,%
	text height=3.6mm, fill=#2,#2,text=SectionForeground](char){\,#1\,};%
	\hspace{0.2cm} \rule[0.15\baselineskip]{\TotalSectionLength}{1pt}}
}

\renewcommand{\section}[1]{{\color{AccentGray}\Large\sectionbox{#1}{AccentBlue}}}
\renewcommand{\subsection}[1]{\par\vspace{.2\parskip}{\large\sectionbox{#1}{AccentGray}}}

% LIST & CV ITEMS -------------------------------------------------------------

% Environment for chronological lists
\newenvironment{cvlist}{%
	\begin{tabular*}{\textwidth}{@{\extracolsep{\fill}}ll}}{\end{tabular*}
}

% Long cv item {year}{title}{location}{description}
\newcommand{\cvlongitem}[4]{%
	\small#1&\parbox[t]{0.83\textwidth}{%
		\large\textbf{#2}%
		\hfill%
		{\vspace{3pt}\footnotesize#3}\\%
		\small{#4}\vspace{\parsep}%
	} \\
}

% Short cv item {year}{title}{location}
\newcommand{\cvshortitem}[3]{%
	\small#1&\parbox[t]{0.83\textwidth}{%
		#2%
		\hfill%
		{\vspace{3pt}\footnotesize#3}
		\vspace{4pt}
	} \\
}
