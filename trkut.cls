%%% Originally written by Sandra Schumann in 2012
%%% Modified by Kaarel Kivisalu in 2018
%%% kaarel.kivisalu@real.edu.ee (kaarel.kivisalu@gmail.com pärast 06.2020)
%%% Modified by Peeter Aleksander Randla in 2020

% XXX: PDF TOC contains garbage for appendices and doesn't have any numbers

% Mitu juhendajat
% Automaatne nummerdamine ilma käsuta
%------------------------------------------------------------------------
%   CLASS DEFINITION AND PARAMETERS
%------------------------------------------------------------------------

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{trkut}[2018-12-02 TRK UT class]

\LoadClass[oneside, 12pt, headings=small, numbers=endperiod]{scrreprt}% Numbrite vahel ja lõpus on punkt, chapter font large, 12pt.

\RequirePackage{etoolbox}% Scriptimismacrod
\RequirePackage{polyglossia}% Eesti keele tugi
\setdefaultlanguage{estonian}
\RequirePackage{csquotes}% Eesti jutumärgid käsuga \enquote{}
\RequirePackage{graphicx}% Joonised
\RequirePackage[colorlinks,citecolor=black,filecolor=black,linkcolor=black,urlcolor=black,bookmarksnumbered]{hyperref}% Sisukorras ja viidetel on lingid
\RequirePackage[fleqn]{amsmath}% Joondame valemid vasakule
\RequirePackage{siunitx}

%---------------------------------------------
%   ÄÄRISED
%---------------------------------------------

\RequirePackage[layout=a4paper, top=2.5cm, bottom=2.5cm, left=3cm, right=2cm, includeall=false]{geometry}
\geometry{%
    layout=a4paper,
    top=2.5cm,
    bottom=2.5cm,
    left=3cm,
    right=2cm,
    includeall=false
}

%----------------------------------------------------------------------------------------
%   PENALTIES
%----------------------------------------------------------------------------------------

\doublehyphendemerits=10000%    No consecutive line hyphens
\brokenpenalty=10000%           No broken words across columns/pages
\widowpenalty=9999%             Almost no widows at bottom of page
\clubpenalty=9999%              Almost no orphans at top of page
\interfootnotelinepenalty=9999% Almost never break footnotes

%---------------------------------------------
%   NUMMERDAMINE
%---------------------------------------------

%% Leheküljenumbrid algavad sisukorra teiselt leheküljelt
\renewcommand\thepage{}
\newtoggle{nummerdamelehti}
\togglefalse{nummerdamelehti}

% Käsk nummerdamise alustamiseks
\newcommand{\nummerdame}{%
    \iftoggle{nummerdamelehti}{}{%
        \renewcommand\thepage{\arabic{page}}%
        \toggletrue{nummerdamelehti}%
        \thispagestyle{empty}%
    }
}

%---------------------------------------------
%   SISUKORD
%---------------------------------------------

\KOMAoptions{toc=chapterentrydotfill}%      Peatükkide taga on punktiirjoon
\addtokomafont{chapterentry}{\mdseries}%    Peatükid ei ole boldis
%\renewcommand*{\@pnumwidth}{1em}%          Punktiirjoone ja leheküljenumbrite vahe
\setcounter{tocdepth}{99}%                  Näitame kõikide - ka väga madala taseme - jaotuste pealkirju
\setcounter{secnumdepth}{99}%               Numbreid ka neile

%---------------------------------------------
%   TABELID, JOONISED, VÕRRANDID
%---------------------------------------------

\RequirePackage{enumitem}
\setlist{nosep, before={\parskip=0pt}}

% Left-align all captions. Always.
\RequirePackage{caption}
\captionsetup{justification=justified,singlelinecheck=false}

% Joonis vahetult seda kirjeldava teksti juures ehk sama alapeatüki sees
\RequirePackage[section]{placeins}

% Captions to "Caption" style instead of "Source".
\newcommand{\trkcaptionsetup}{\captionsetup{labelformat=simple, labelsep=period, labelfont=normalfont, font=normalfont}}
\trkcaptionsetup % And this is also the default
% Captions to "Source" mode. Only used internally by \allikas
\newcommand{\captionstosource}{\captionsetup{labelformat=simple, labelsep=period, font=normalfont}}
% Add source to a figure or table.
\newcommand{\allikas}[1]{\vspace{-1em}\captionstosource\caption*{Allikas: #1}\trkcaptionsetup}

% Töö kõik tabelid tuleb nummerdada läbiva numeratsiooniga (ja kui juba tabelid, siis muu ka vist)
\RequirePackage{chngcntr}
\counterwithout{figure}{chapter}
\counterwithout{table}{chapter}
\counterwithout{equation}{chapter}
\counterwithout{footnote}{chapter}

%---------------------------------------------
%   PAIGUTUS JA FORMAAT
%---------------------------------------------

\RequirePackage{microtype}% Teeb paigutuse paremaks

% Lisade pealkirjad stiilis "Lisa 2 Teise lisa pealkiri"
% Vaata https://tex.stackexchange.com/questions/163890
\let\oldaddchap\addchap
\g@addto@macro\appendix{%
    \renewcommand*{\thechapter}{%
        {\arabic{chapter}}%
    }
    \renewcommand*{\chapterformat}{%
        {\chapapp\nobreakspace\thechapter\enskip}%
    }
    \renewcommand*{\chaptermarkformat}{%
        {\chapapp\nobreakspace\thechapter\enskip}%
    }
    \let\oldaddcontentsline\addcontentsline
    % \addcontentsline is used by \chapter to write a line to the tocfile.
    % we override it to first write "appendix", then set \autodot to an
    % empty string to not add a dot after the appendix number, then reset
    % \autodot to its original value (which generally depends on which
    % options you pass to scrreprt but we can hardcode it here as we include
    % scrreprt in the same file)
    \newcommand\hackedaddcontentsline[3]{\oldaddcontentsline{#1}{#2}{%
        \chapapp\nobreakspace%
        % this is needed because the autodot commands don't work in PDF TOC
        % (it's not necessary in PDF TOC because apparently that one ignores
        % autodot anyways)
        \texorpdfstring{%
            \string\def\string\autodot{}%
            #3%
            \string\def\string\autodot{.}%
        }{#3}%
        }}
    \let\oldchapter\chapter
    \renewcommand*\chapter[1]{%
        \let\addcontentsline\hackedaddcontentsline%
        \oldchapter{#1}%
        \let\addcontentsline\oldaddcontentsline%
    }
}

% doesn't actually reverse all effects of \appendix,
% just barely enough to be able to use \addchap
\newcommand*{\appendixend}{
    \let\chapter\oldchapter
    \renewcommand*{\chapterformat}{}
}

% Font size
% \tiny         6pt
% \scriptsize   8pt
% \footnotesize 10pt
% \small        11pt
% \normalsize   12pt
% \large        14pt
% \Large        17pt
% \LARGE        20pt
% \huge         25pt
% \Huge         25pt

% faili alguses scrreprt'i option headings=small annab:
% \chapter kasutab \Large (17pt)
% \section kasutab \large (14pt)
% \subsection etc kasutab \normalsize (12pt)
% Juhendis on määratud ainult see, et \chapter peaks 16pt olema, aga täpselt
% 16pt ei ole võimalik scrreprt'iga saada, ja 17pt on piisavalt lähedal

\renewcommand{\baselinestretch}{1.5}%   Reavahe on 1,5
\setlength{\parindent}{0pt}%            Taandridasid pole
\setlength{\parskip}{12pt}%             Lõiguvahe on 12 pt
\setlength{\topskip}{0pt}%              Ülaääre ja teksti vahel pole vaba ruumi

% Pealkirjade vahed
\RedeclareSectionCommand[%
beforeskip=2.5cm,
tocbeforeskip=0pt]{chapter}
\renewcommand*{\chapterheadendvskip}{\vspace{0em}}
\RedeclareSectionCommand[
beforeskip=1pt,
afterskip=0pt,
runin=off,
tocindent=2em]{section}
\RedeclareSectionCommand[
beforeskip=1pt,
afterskip=0pt,
runin=off,
tocindent=4em]{subsection}
\RedeclareSectionCommand[
beforeskip=1pt,
afterskip=0pt,
runin=off,
tocindent=6em]{subsubsection}
\RedeclareSectionCommand[
beforeskip=1pt,
afterskip=0pt,
runin=off,
tocindent=8em]{paragraph}
\RedeclareSectionCommand[
beforeskip=1pt,
afterskip=0pt,
runin=off,
indent=0pt, % kõigil teistel heading'utel on indent 0 by default, aga subparagraph'il mitte
tocindent=10em]{subparagraph}

% Pealkirjad boldis ja tekstiga sama fondiga
\setkomafont{disposition}{\rmfamily\bfseries}

%---------------------------------------------
%   TIITELLEHT
%---------------------------------------------
\newtoggle{mitujuhendajat}
\togglefalse{mitujuhendajat}

\RequirePackage{xparse}
\NewDocumentCommand{\autor}{m}{\newcommand{\@autor}{#1}\renewcommand{\@author}{#1}}
\NewDocumentCommand{\pealkiri}{m}{\newcommand{\@pealkiri}{#1}\renewcommand{\@title}{#1}}
\NewDocumentCommand{\juhendaja}{m}{\newcommand{\@juhendaja}{#1}}
\NewDocumentCommand{\klass}{m}{\newcommand{\@klass}{#1}}
\NewDocumentCommand{\koht}{m}{\newcommand{\@koht}{#1}}
\NewDocumentCommand{\asutus}{m}{\newcommand{\@asutus}{#1}}
\NewDocumentCommand{\paber}{m}{\newcommand{\@paber}{#1}}

% Vaikeväärtused
\paber{Uurimist\"o\"o}
\asutus{Tallinna Reaalkool}
\koht{Tallinn}

% Tiitellehe genereerimine
\renewcommand{\maketitle}{%
    \newpage
    \thispagestyle{empty}
    \large
    \begin{center}
        \@asutus
    \end{center}
    \vspace{8cm}
    \begin{center}
        {\LARGE\textbf{\@title}}

        \@paber
    \end{center}
    \vspace{2cm}
    \begin{flushright}
        \@author \\
        \@klass \\
        \iftoggle{mitujuhendajat}{%
            Juhendajad: \@juhendaja
        }{%
            Juhendaja: \@juhendaja
        }
    \end{flushright}
    \vfill
    \centerline{\@koht{} \the\year}
    \clearpage
    \normalsize
}

%--------------------------------------------------
%   KINNITUSLEHT
%--------------------------------------------------

\newcommand{\kinnitusleht}{%
    \addchap{Kinnitusleht}

    Kinnitan, et
    \begin{itemize}
        \item koostasin uurimistöö iseseisvalt. Kõigile töös kasutatud teiste autorite töödele ja
        andme\-allikatele on viidatud;
        \item olen teadlik, et uurimistööd ei edastata teistele tulu teenimise eesmärgil ega jagata
        tead\-likult plagieerimiseks.
    \end{itemize}

    \vspace{1em}
    \dotfill

    kuupäev / nimi / allkiri

    \vspace{1.5cm}
    \noindent Tunnistan uurimistöö kaitsmisvalmiks.

    \iftoggle{mitujuhendajat}{%
        Juhendajad

        \vspace{1em}
        \dotfill

        kuupäev / nimi / allkiri

        \dotfill

        kuupäev / nimi / allkiri
    }{%
        Juhendaja

        \vspace{1em}
        \dotfill

        kuupäev / nimi / allkiri
    }
    \vfill
    %\setlength{\topskip}{0 cm}
    % i'm not sure why this was even here, especially what with this being the last page of the document, but it somehow causes a blank page to be added to the end when using packages like tikz, so i'm removing it
}

%---------------------------------------------
%
%---------------------------------------------
