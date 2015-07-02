function html = html_R2014a(varargin)
%ML.Doc.html_R2014a Html doc generator for R2014a
%   ML.Doc.html_R2014a(SDOC) creates a html documentation.
%
%   See also .

% === Input variables =====================================================

in = ML.Input;
in.S = @isstruct;
in.title('') = @ischar;
in = +in;

% =========================================================================

% --- Preparation
Config = ML.config;

% --- Get css -------------------------------------------------------------

csspath = [Config.path 'Doc' filesep 'Styles' filesep 'R2014a' filesep 'Style.css'];

% --- Useful links --------------------------------------------------------

home = 'matlab:ML.doc;';
lnk = @(x) ['matlab:ML.doc(''' x ''');'];

% --- Get search field ----------------------------------------------------

hmain = ['<form><div id="search">' ...
         '<span><input type="text" id="searchfield"></input></span>' ...
         '<input type="button" id="searchbutton"></input>' ...
         '</div></form>'];

% --- Get breadcrumb -----------------------------------------------------

% Get path elements
P = strsplit(in.S.filename(numel(Config.path)+5:end), filesep);

hmain = [hmain '<div id="breadcrumb">' ...
		 '<ul class="crumbs">' ...
		 '<li class="first"><a href="' home '" style="z-index:' num2str(numel(P)+1) ';"><span></span><img src="/home/raphael/Science/MLab/Doc/Styles/R2014a/home_crumb.png"></a></li>'];
     
for i = 1:numel(P)
    
    % Description
    desc = regexprep(P{i}, '\.m$', '');
    
    % Target
    target = strjoin(P(1:i), filesep);
    
    hmain = [hmain '<li><a href="' lnk(target) '" style="z-index:' num2str(numel(P)+1-i) ';">' desc '</a></li>'];
end

hmain = [hmain '</ul></div>\n'];

% --- Get main body -------------------------------------------------------

if isfield(in.S, 'Doc')
    main = in.S.Doc;
else 
    main = '';
end

% --- Title
tmp = regexp(main,'<title>(.*)</title>','tokens');
if ~isempty(tmp)
    in.title = strtrim(tmp{1}{1});
    main = regexprep(main,'<title>(.*)</title>','');
end

% --- H1 line
main = regexprep(main, '<hline>', '<div id="hline">');
main = regexprep(main, '</hline>', '</div>');

% --- Syntax
main = regexprep(main, '<sx>', '<div class="syntax">');
main = regexprep(main, '</sx>', '</div>');

% --- MLab doc links
tmp = regexp(main,'<MLdoc target=([''"])(.*?)[''"]>(.*?)</MLdoc>','tokens');
for i = 1:numel(tmp)
    main = regexprep(main, ...
        ['<MLdoc target=' tmp{i}{1} tmp{i}{2} tmp{i}{1} '>' tmp{i}{3} '</MLdoc>'], ...
        ['<a href="matlab:ML.doc(''' strtrim(tmp{i}{2}) ''');">' tmp{i}{3} '</a>']);
end

% --- Matlab doc links
tmp = regexp(main,'<doc target=([''"])(.*?)[''"]>(.*?)</doc>','tokens');
for i = 1:numel(tmp)
    main = regexprep(main, ...
        ['<doc target=' tmp{i}{1} tmp{i}{2} tmp{i}{1} '>' tmp{i}{3} '</doc>'], ...
        ['<a href="matlab:doc(''' strtrim(tmp{i}{2}) ''');">' tmp{i}{3} '</a>']);
end

% --- Code
main = regexprep(main, '<c>', '<span class="minicode">');
main = regexprep(main, '</c>', '</span>');

% --- MLab logo
main = strrep(main, '</h1>', ['<a href="' home '" id="MLab_logo"></a></h1>']);

% --- Build html ----------------------------------------------------------
html = ['<!DOCTYPE HTML>\n' ...
    '<html xmlns="http://www.w3.org/1999/xhtml" itemscope itemtype="http://www.mathworks.com/help/schema/MathWorksDocPage">\n' ...
    '<head>\n' ...
    '<meta charset="utf-8">\n' ...
    '<title>' in.title '</title>\n' ...
    '<link rel="stylesheet" href="' csspath '" type="text/css">\n' ...
    '</head>\n' ...
    '<body>\n' ...
    '<div id=''main''>' hmain main '</div>\n' ...
    '</body>\n' ...
    '</html>'];

%! ------------------------------------------------------------------------
%! Author: Raphaël Candelier
%! Version: 1.0
%
%! Revisions
%   1.0:    Initial version.
%
%! To_do
%   help
%   doc
%
%! ------------------------------------------------------------------------
%! Doc
%   To do.